import 'package:desktop_system/domain/repositories/dict_repository.dart';

class _CacheEntry {
  final Map<String, String> data;
  final DateTime timestamp;

  _CacheEntry(this.data, this.timestamp);
}

class DictService {
  final DictRepository _dictRepository;
  final _cache = <String, _CacheEntry>{};
  static const _defaultTtl = Duration(minutes: 10);

  DictService(this._dictRepository);

  Duration get ttl => _defaultTtl;

  Future<String> getLabel(String dictId, String value) async {
    final dict = await _getDict(dictId);
    return dict[value] ?? value;
  }

  Future<Map<String, String>> getDict(String dictId) async {
    return _getDict(dictId);
  }

  Future<Map<String, Map<String, String>>> getDicts(List<String> dictIds) async {
    final results = await Future.wait(dictIds.map(_getDict));
    return Map.fromIterables(dictIds, results);
  }

  Future<Map<String, String>> _getDict(String dictId) async {
    final entry = _cache[dictId];
    if (entry != null && DateTime.now().difference(entry.timestamp) < ttl) {
      return entry.data;
    }

    final list = await _dictRepository.getDict(dictId);
    final map = {for (final item in list) item.dictValue: item.dictLabel};
    _cache[dictId] = _CacheEntry(map, DateTime.now());
    return map;
  }

  void clearCache() => _cache.clear();

  void clearDict(String dictId) => _cache.remove(dictId);
}
