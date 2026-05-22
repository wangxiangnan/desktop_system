import 'package:flutter_test/flutter_test.dart';
import 'package:desktop_system/core/services/dict_service.dart';
import 'package:desktop_system/data/models/dict_data.dart';
import 'package:desktop_system/domain/repositories/dict_repository.dart';

class _MockDictRepository extends DictRepository {
  final Map<String, List<DictData>> _data = {};
  int fetchCount = 0;
  Duration delay = Duration.zero;
  bool shouldThrow = false;

  void addDict(String dictId, List<DictData> items) {
    _data[dictId] = items;
  }

  @override
  Future<List<DictData>> getDict(String dictId) async {
    if (shouldThrow) throw Exception('network error');
    fetchCount++;
    if (delay > Duration.zero) await Future.delayed(delay);
    return _data[dictId] ?? [];
  }
}

void main() {
  late _MockDictRepository mockRepo;
  late DictService service;

  setUp(() {
    mockRepo = _MockDictRepository();
    service = DictService(mockRepo);
  });

  group('getDict', () {
    test('fetches and caches dict', () async {
      mockRepo.addDict('payment', [
        DictData(dictLabel: '支付宝', dictValue: 'alipay'),
        DictData(dictLabel: '微信支付', dictValue: 'wechat'),
      ]);

      final result = await service.getDict('payment');

      expect(result, {
        'alipay': '支付宝',
        'wechat': '微信支付',
      });
      expect(mockRepo.fetchCount, 1);
    });

    test('returns cached data on second call', () async {
      mockRepo.addDict('payment', [
        DictData(dictLabel: '支付宝', dictValue: 'alipay'),
      ]);

      await service.getDict('payment');
      await service.getDict('payment');

      expect(mockRepo.fetchCount, 1);
    });

    test('deduplicates concurrent requests', () async {
      mockRepo.addDict('test', [DictData(dictLabel: '值', dictValue: 'v')]);

      final results = await Future.wait([
        service.getDict('test'),
        service.getDict('test'),
        service.getDict('test'),
      ]);

      expect(mockRepo.fetchCount, 1);
      for (final result in results) {
        expect(result, {'v': '值'});
      }
    });

    test('stale-while-revalidate: returns stale data then refreshes in background', () async {
      final shortTtl = DictService(mockRepo, defaultTtl: Duration(milliseconds: 50));
      mockRepo.addDict('test', [DictData(dictLabel: '旧值', dictValue: 'v')]);

      await shortTtl.getDict('test');
      expect(mockRepo.fetchCount, 1);

      await Future.delayed(const Duration(milliseconds: 60));

      mockRepo.addDict('test', [DictData(dictLabel: '新值', dictValue: 'v')]);

      final stale = await shortTtl.getDict('test');
      expect(stale, {'v': '旧值'});

      await Future.delayed(Duration.zero);

      final fresh = await shortTtl.getDict('test');
      expect(fresh, {'v': '新值'});
      expect(mockRepo.fetchCount, 2);
    });
  });

  group('getLabel', () {
    test('returns label for known value', () async {
      mockRepo.addDict('type', [
        DictData(dictLabel: '个人', dictValue: 'personal'),
      ]);

      final label = await service.getLabel('type', 'personal');

      expect(label, '个人');
    });

    test('returns value itself for unknown value', () async {
      mockRepo.addDict('type', [
        DictData(dictLabel: '个人', dictValue: 'personal'),
      ]);

      final label = await service.getLabel('type', 'unknown');

      expect(label, 'unknown');
    });
  });

  group('getDicts', () {
    test('fetches multiple dicts in parallel', () async {
      mockRepo.addDict('a', [DictData(dictLabel: 'A', dictValue: 'a')]);
      mockRepo.addDict('b', [DictData(dictLabel: 'B', dictValue: 'b')]);

      final results = await service.getDicts(['a', 'b']);

      expect(results.keys, ['a', 'b']);
      expect(results['a'], {'a': 'A'});
      expect(results['b'], {'b': 'B'});
      expect(mockRepo.fetchCount, 2);
    });
  });

  group('error handling', () {
    test('rethrows when no cache exists and network fails', () async {
      mockRepo.shouldThrow = true;

      expect(
        () => service.getDict('nonexistent'),
        throwsA(isA<Exception>()),
      );
    });

    test('returns stale cache when network fails and cache exists', () async {
      final shortTtl = DictService(mockRepo, defaultTtl: Duration(milliseconds: 50));
      mockRepo.addDict('test', [DictData(dictLabel: '旧值', dictValue: 'v')]);

      await shortTtl.getDict('test');

      await Future.delayed(const Duration(milliseconds: 60));

      mockRepo.shouldThrow = true;

      final result = await shortTtl.getDict('test');
      expect(result, {'v': '旧值'});
    });
  });

  group('clearCache / clearDict', () {
    test('clearCache forces a refetch', () async {
      mockRepo.addDict('x', [DictData(dictLabel: 'X', dictValue: 'x')]);
      await service.getDict('x');
      service.clearCache();
      await service.getDict('x');

      expect(mockRepo.fetchCount, 2);
    });

    test('clearDict forces a refetch for specific dict only', () async {
      mockRepo.addDict('a', [DictData(dictLabel: 'A', dictValue: 'a')]);
      mockRepo.addDict('b', [DictData(dictLabel: 'B', dictValue: 'b')]);
      await service.getDict('a');
      await service.getDict('b');
      service.clearDict('a');
      await service.getDict('a');
      await service.getDict('b');

      expect(mockRepo.fetchCount, 3);
    });
  });

  group('refreshDict / refreshAll', () {
    test('refreshDict forces a single dict refetch', () async {
      mockRepo.addDict('x', [DictData(dictLabel: 'X', dictValue: 'x')]);
      await service.getDict('x');
      await service.refreshDict('x');

      expect(mockRepo.fetchCount, 2);
    });

    test('refreshAll refetches all cached dicts', () async {
      mockRepo.addDict('a', [DictData(dictLabel: 'A', dictValue: 'a')]);
      mockRepo.addDict('b', [DictData(dictLabel: 'B', dictValue: 'b')]);
      await service.getDict('a');
      await service.getDict('b');
      await service.refreshAll();

      expect(mockRepo.fetchCount, 4);
    });
  });

  group('sync cache access', () {
    test('getCachedLabel returns null when not cached', () {
      expect(service.getCachedLabel('x', 'v'), isNull);
    });

    test('getCachedLabel returns label when cached', () async {
      mockRepo.addDict('x', [DictData(dictLabel: '标签', dictValue: 'v')]);
      await service.getDict('x');

      expect(service.getCachedLabel('x', 'v'), '标签');
      expect(service.getCachedLabel('x', 'unknown'), isNull);
    });

    test('getCachedDict returns null when not cached', () {
      expect(service.getCachedDict('x'), isNull);
    });

    test('getCachedDict returns map when cached', () async {
      mockRepo.addDict('x', [DictData(dictLabel: '标签', dictValue: 'v')]);
      await service.getDict('x');

      expect(service.getCachedDict('x'), {'v': '标签'});
    });
  });

  group('setDictTtl', () {
    test('per-dict TTL overrides default', () async {
      mockRepo.addDict('a', [DictData(dictLabel: 'A', dictValue: 'a')]);
      service.setDictTtl('a', Duration(hours: 24));

      // Cache should persist longer than default 10min
      await service.getDict('a');
      expect(mockRepo.fetchCount, 1);
    });
  });
}
