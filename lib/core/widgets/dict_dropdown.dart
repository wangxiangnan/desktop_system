import 'package:flutter/material.dart';
import 'package:desktop_system/core/services/dict_service.dart';
import 'package:desktop_system/core/di/setup_dependencies.dart';
import 'package:desktop_system/core/constants/app_colors.dart';

class DictDropdown extends StatefulWidget {
  final String dictId;
  final String? value;
  final ValueChanged<String?>? onChanged;
  final String? labelText;
  final String? hintText;
  final InputDecoration? decoration;
  final DictService? dictService;
  final bool isDense;
  final double? width;
  final EdgeInsetsGeometry? contentPadding;

  const DictDropdown({
    super.key,
    required this.dictId,
    this.value,
    this.onChanged,
    this.labelText,
    this.hintText,
    this.decoration,
    this.dictService,
    this.isDense = true,
    this.width,
    this.contentPadding,
  });

  @override
  State<DictDropdown> createState() => _DictDropdownState();
}

class _DictDropdownState extends State<DictDropdown> {
  Map<String, String> _options = <String, String>{};
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDict();
  }

  @override
  void didUpdateWidget(DictDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dictId != widget.dictId) {
      _loadDict();
    }
  }

  Future<void> _loadDict() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final service = widget.dictService ?? getIt<DictService>();
      final dict = await service.getDict(widget.dictId);
      if (!mounted) return;
      setState(() {
        _options = dict;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final child = _buildContent(context);

    if (widget.width != null) {
      return SizedBox(width: widget.width, child: child);
    }
    return child;
  }

  Widget _buildContent(BuildContext context) {
    if (_loading) {
      return _buildInput(
        child: const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (_error != null) {
      return _buildInput(
        child: InkWell(
          onTap: _loadDict,
          child: Row(
            children: [
              const Icon(Icons.error_outline, size: 16, color: AppColors.error),
              const SizedBox(width: 8),
              Text('加载失败，点击重试', style: TextStyle(color: AppColors.error, fontSize: 13)),
            ],
          ),
        ),
      );
    }

    final items = _options.entries.map((e) {
      return DropdownMenuItem<String>(
        value: e.key,
        child: Text(e.value),
      );
    }).toList()
      ..sort((a, b) => a.value.toString().compareTo(b.value.toString()));

    return _buildDropdown(items);
  }

  Widget _buildDropdown(List<DropdownMenuItem<String>> items) {
    return DropdownButtonFormField<String>(
      initialValue: widget.value,
      isDense: widget.isDense,
      decoration: widget.decoration ?? _defaultDecoration(),
      items: items,
      onChanged: widget.onChanged,
    );
  }

  Widget _buildInput({required Widget child}) {
    return InputDecorator(
      decoration: widget.decoration ?? _defaultDecoration(),
      child: Align(
        alignment: Alignment.centerLeft,
        child: child,
      ),
    );
  }

  InputDecoration _defaultDecoration() {
    return InputDecoration(
      labelText: widget.labelText,
      hintText: widget.hintText,
      contentPadding: widget.contentPadding,
      isDense: widget.isDense,
    );
  }
}
