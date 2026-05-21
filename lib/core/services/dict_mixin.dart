import 'package:flutter/widgets.dart';
import 'package:desktop_system/core/services/dict_service.dart';

mixin DictMixin<T extends StatefulWidget> on State<T> {
  DictService get dictService;

  final Map<String, Map<String, String>> _dicts = {};
  bool _dictsLoaded = false;
  bool _dictLoading = false;
  String? _dictError;

  List<String> get dictIds => [];

  Map<String, Map<String, String>> get dicts => _dicts;
  bool get dictsLoaded => _dictsLoaded;
  bool get dictLoading => _dictLoading;
  String? get dictError => _dictError;

  @override
  void initState() {
    super.initState();
    if (dictIds.isNotEmpty) _loadDicts();
  }

  Future<void> _loadDicts() async {
    _dictLoading = true;
    _dictError = null;
    if (!mounted) return;
    setState(() {});

    try {
      final results = await dictService.getDicts(dictIds);
      if (!mounted) return;
      setState(() {
        _dicts.addAll(results);
        _dictsLoaded = true;
        _dictLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _dictLoading = false;
        _dictError = e.toString();
      });
    }
  }

  String dictLabel(String dictId, String value) {
    return _dicts[dictId]?[value] ?? value;
  }
}
