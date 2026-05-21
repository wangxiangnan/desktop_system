import 'package:flutter_test/flutter_test.dart';
import 'package:desktop_system/core/services/dict_service.dart';
import 'package:desktop_system/data/models/dict_data.dart';
import 'package:desktop_system/domain/repositories/dict_repository.dart';

class _MockDictRepository extends DictRepository {
  final Map<String, List<DictData>> _data = {};
  int fetchCount = 0;

  void addDict(String dictId, List<DictData> items) {
    _data[dictId] = items;
  }

  @override
  Future<List<DictData>> getDict(String dictId) async {
    fetchCount++;
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

      expect(mockRepo.fetchCount, 3); // a x2, b x1
    });
  });
}
