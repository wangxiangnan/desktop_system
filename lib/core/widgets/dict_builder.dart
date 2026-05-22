import 'package:flutter/material.dart';
import 'package:desktop_system/core/services/dict_service.dart';
import 'package:desktop_system/core/di/setup_dependencies.dart';

class DictLoadState {
  final bool isLoading;
  final bool allLoaded;
  final bool hasError;
  final String? errorMessage;
  final Set<String> loadedDictIds;
  final Map<String, String?> dictErrors;

  const DictLoadState({
    this.isLoading = false,
    this.allLoaded = false,
    this.hasError = false,
    this.errorMessage,
    this.loadedDictIds = const {},
    this.dictErrors = const {},
  });
}

class DictBuilder extends StatefulWidget {
  final List<String> dictIds;
  final Widget Function(
    BuildContext context,
    Map<String, Map<String, String>> dicts,
    DictLoadState state,
  ) builder;
  final DictService? dictService;

  const DictBuilder({
    super.key,
    required this.dictIds,
    required this.builder,
    this.dictService,
  });

  @override
  State<DictBuilder> createState() => _DictBuilderState();
}

class _DictBuilderState extends State<DictBuilder> {
  Map<String, Map<String, String>> _dicts = {};
  DictLoadState _state = const DictLoadState(isLoading: true);
  int _generation = 0;

  DictService get _service => widget.dictService ?? getIt<DictService>();

  @override
  void initState() {
    super.initState();
    _service.addListener(_onDictServiceChanged);
    _load();
  }

  @override
  void didUpdateWidget(DictBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dictIds.length != widget.dictIds.length ||
        !oldWidget.dictIds.every(widget.dictIds.contains)) {
      _load();
    }
  }

  @override
  void dispose() {
    _service.removeListener(_onDictServiceChanged);
    super.dispose();
  }

  void _onDictServiceChanged() {
    if (!mounted) return;
    _syncFromCache();
  }

  void _syncFromCache() {
    final updated = <String, Map<String, String>>{};
    for (final id in widget.dictIds) {
      final cached = _service.getCachedDict(id);
      if (cached != null) {
        updated[id] = cached;
      }
    }
    setState(() {
      _dicts.addAll(updated);
      _state = DictLoadState(
        allLoaded: widget.dictIds.every((id) => _dicts.containsKey(id)),
        loadedDictIds: _dicts.keys.toSet(),
        hasError: _state.hasError,
        errorMessage: _state.errorMessage,
        dictErrors: _state.dictErrors,
      );
    });
  }

  Future<void> _load() async {
    _generation++;
    final gen = _generation;

    setState(() {
      _state = const DictLoadState(isLoading: true);
    });

    try {
      final results = await _service.getDicts(widget.dictIds);
      if (!mounted || gen != _generation) return;
      setState(() {
        _dicts = results;
        _state = DictLoadState(
          allLoaded: true,
          loadedDictIds: results.keys.toSet(),
        );
      });
    } catch (e) {
      if (!mounted || gen != _generation) return;
      final error = e.toString();
      setState(() {
        _state = DictLoadState(
          hasError: true,
          errorMessage: error,
          loadedDictIds: _dicts.keys.toSet(),
          dictErrors: {for (final id in widget.dictIds)
            if (!_dicts.containsKey(id)) id: error},
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _dicts, _state);
  }
}
