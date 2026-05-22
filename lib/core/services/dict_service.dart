import 'package:flutter/foundation.dart';
import 'package:desktop_system/domain/repositories/dict_repository.dart';

class _CacheEntry {
  final Map<String, String> data;
  final DateTime timestamp;

  _CacheEntry(this.data, this.timestamp);

  bool isExpired(Duration ttl) =>
      DateTime.now().difference(timestamp) > ttl;
}

class DictService extends ChangeNotifier {
  final DictRepository _dictRepository;
  final Duration defaultTtl;
  final _cache = <String, _CacheEntry>{};
  final _pendingFutures = <String, Future<Map<String, String>>>{};
  final _dictTtls = <String, Duration>{};

  static const _kDefaultTtl = Duration(minutes: 10);

  DictService(this._dictRepository, {this.defaultTtl = _kDefaultTtl});

  void setDictTtl(String dictId, Duration ttl) {
    _dictTtls[dictId] = ttl;
  }

  Map<String, String>? getCachedDict(String dictId) {
    return _cache[dictId]?.data;
  }

  String? getCachedLabel(String dictId, String value) {
    return _cache[dictId]?.data[value];
  }

  Duration _ttlFor(String dictId) => _dictTtls[dictId] ?? defaultTtl;

  Future<String> getLabel(String dictId, String value) async {
    final dict = await getDict(dictId);
    return dict[value] ?? value;
  }

  Future<Map<String, String>> getDict(String dictId) async {
    if (_pendingFutures.containsKey(dictId)) {
      return _pendingFutures[dictId]!;
    }

    final entry = _cache[dictId];
    final ttl = _ttlFor(dictId);

    if (entry != null && !entry.isExpired(ttl)) {
      return entry.data;
    }

    if (entry != null && entry.isExpired(ttl)) {
      _backgroundRefresh(dictId);
      return entry.data;
    }

    return _fetchDict(dictId);
  }

  Future<Map<String, Map<String, String>>> getDicts(List<String> dictIds) async {
    final results = await Future.wait(dictIds.map(getDict));
    return Map.fromIterables(dictIds, results);
  }

  Future<void> refreshDict(String dictId) async {
    _cache.remove(dictId);
    await _fetchDict(dictId);
  }

  Future<void> refreshAll() async {
    final ids = <String>{..._cache.keys, ..._pendingFutures.keys};
    _cache.clear();
    _pendingFutures.clear();
    await Future.wait(ids.map(_fetchDict));
  }

  Future<Map<String, String>> _fetchDict(String dictId) async {
    if (_pendingFutures.containsKey(dictId)) {
      return _pendingFutures[dictId]!;
    }
    final future = _doFetch(dictId);
    _pendingFutures[dictId] = future;
    try {
      return await future;
    } finally {
      _pendingFutures.remove(dictId);
    }
  }

  Future<Map<String, String>> _doFetch(String dictId) async {
    try {
      final list = await _dictRepository.getDict(dictId);
      final map = {for (final item in list) item.dictValue: item.dictLabel};
      _cache[dictId] = _CacheEntry(map, DateTime.now());
      notifyListeners();
      return map;
    } catch (e) {
      final entry = _cache[dictId];
      if (entry != null) return entry.data;
      rethrow;
    }
  }

  void _backgroundRefresh(String dictId) {
    _fetchDict(dictId).then((_) {}, onError: (_) {});
  }

  void clearCache() {
    _cache.clear();
    _pendingFutures.clear();
    notifyListeners();
  }

  void clearDict(String dictId) {
    _cache.remove(dictId);
    _pendingFutures.remove(dictId);
    notifyListeners();
  }
}
