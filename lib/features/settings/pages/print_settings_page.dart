import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';

import 'package:desktop_system/core/constants/app_colors.dart';
import 'package:desktop_system/core/di/setup_dependencies.dart';
import 'package:desktop_system/core/models/print_settings.dart';
import 'package:desktop_system/core/services/print_settings_service.dart';

class PrintSettingsPage extends StatefulWidget {
  const PrintSettingsPage({super.key});

  @override
  State<PrintSettingsPage> createState() => _PrintSettingsPageState();
}

class _PrintSettingsPageState extends State<PrintSettingsPage> {
  late PrintSettings _settings;
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _marginLeftCtrl;
  late final TextEditingController _marginTopCtrl;
  late final TextEditingController _marginRightCtrl;
  late final TextEditingController _marginBottomCtrl;
  late final TextEditingController _jobNameCtrl;
  List<Printer> _printers = [];
  bool _loadingPrinters = true;

  @override
  void initState() {
    super.initState();
    _settings = getIt<PrintSettingsService>().loadSettings();
    _marginLeftCtrl =
        TextEditingController(text: _settings.marginLeft.toStringAsFixed(0));
    _marginTopCtrl =
        TextEditingController(text: _settings.marginTop.toStringAsFixed(0));
    _marginRightCtrl =
        TextEditingController(text: _settings.marginRight.toStringAsFixed(0));
    _marginBottomCtrl =
        TextEditingController(text: _settings.marginBottom.toStringAsFixed(0));
    _jobNameCtrl = TextEditingController(text: _settings.jobName);
    _loadPrinters();
  }

  @override
  void dispose() {
    _marginLeftCtrl.dispose();
    _marginTopCtrl.dispose();
    _marginRightCtrl.dispose();
    _marginBottomCtrl.dispose();
    _jobNameCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadPrinters() async {
    setState(() => _loadingPrinters = true);
    try {
      final printers = await getIt<PrintSettingsService>().getPrinters();
      if (!mounted) return;
      setState(() {
        _printers = printers.where((p) => p.isAvailable).toList();
        _loadingPrinters = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingPrinters = false);
    }
  }

  void _updateField(String field, String value) {
    final parsed = double.tryParse(value);
    setState(() {
      _settings = switch (field) {
        'marginLeft' => _settings.copyWith(
            marginLeft: parsed ?? _settings.marginLeft),
        'marginTop' => _settings.copyWith(
            marginTop: parsed ?? _settings.marginTop),
        'marginRight' => _settings.copyWith(
            marginRight: parsed ?? _settings.marginRight),
        'marginBottom' => _settings.copyWith(
            marginBottom: parsed ?? _settings.marginBottom),
        _ => _settings,
      };
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    _settings = _settings.copyWith(jobName: _jobNameCtrl.text);
    await getIt<PrintSettingsService>().saveSettings(_settings);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('打印设置已保存'), duration: Duration(seconds: 2)),
    );
  }

  void _reset() {
    setState(() {
      _settings = PrintSettings.defaults();
      _marginLeftCtrl.text = '10';
      _marginTopCtrl.text = '10';
      _marginRightCtrl.text = '10';
      _marginBottomCtrl.text = '10';
      _jobNameCtrl.text = 'Print Job';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('打印设置')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPrinterSection(),
              const SizedBox(height: 24),
              _buildPageFormatSection(),
              const SizedBox(height: 24),
              _buildOrientationSection(),
              const SizedBox(height: 24),
              _buildMarginsSection(),
              const SizedBox(height: 24),
              _buildJobNameSection(),
              const SizedBox(height: 40),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrinterSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text('打印机',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, size: 20),
                  tooltip: '刷新打印机列表',
                  onPressed: _loadPrinters,
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_loadingPrinters)
              const Center(child: CircularProgressIndicator())
            else if (_printers.isEmpty)
              const Text('未找到可用打印机',
                  style: TextStyle(color: Colors.grey))
            else
              DropdownButtonFormField<String>(
                initialValue: _settings.selectedPrinterUrl,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  hintText: '选择打印机',
                ),
                isExpanded: true,
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text('使用系统默认打印机', style: TextStyle(color: Colors.grey)),
                  ),
                  ..._printers.map((printer) {
                    return DropdownMenuItem<String>(
                      value: printer.url,
                      child: Text(
                        printer.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }),
                ],
                onChanged: (value) {
                  setState(() {
                    if (value == null) {
                      _settings = _settings.copyWith(clearPrinter: true);
                    } else {
                      final printer = _printers.firstWhere((p) => p.url == value);
                      _settings = _settings.copyWith(
                        selectedPrinterUrl: printer.url,
                        selectedPrinterName: printer.name,
                      );
                    }
                  });
                },
              ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('直接打印到选中打印机'),
              subtitle: const Text('跳过系统打印弹窗，直接将文档发送到打印机'),
              value: _settings.directPrint,
              contentPadding: EdgeInsets.zero,
              onChanged: (value) {
                setState(() {
                  _settings = _settings.copyWith(directPrint: value);
                });
              },
            ),
            if (_settings.directPrint && _settings.selectedPrinterUrl == null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '请先在上方选择一台打印机',
                  style: TextStyle(color: Colors.orange.shade700, fontSize: 13),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageFormatSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('页面尺寸',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _settings.pageFormatName,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: PrintSettings.formatKeys.map((key) {
                return DropdownMenuItem(
                  value: key,
                  child: Text(PrintSettings.formatLabels[key]!),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() =>
                      _settings = _settings.copyWith(pageFormatName: value));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrientationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('纸张方向',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SegmentedButton<String>(
              segments: PrintSettings.orientationKeys.map((key) {
                return ButtonSegment<String>(
                  value: key,
                  label: Text(PrintSettings.orientationLabels[key]!),
                  icon: Icon(key == 'portrait'
                      ? Icons.stay_current_portrait
                      : Icons.stay_current_landscape),
                );
              }).toList(),
              selected: {_settings.orientationKey},
              onSelectionChanged: (selected) {
                setState(() {
                  _settings = _settings.copyWith(
                    isLandscape: selected.first == 'landscape',
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarginsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('页边距 (mm)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                    child: _marginField('左', _marginLeftCtrl, 'marginLeft')),
                const SizedBox(width: 12),
                Expanded(
                    child: _marginField('上', _marginTopCtrl, 'marginTop')),
                const SizedBox(width: 12),
                Expanded(
                    child: _marginField('右', _marginRightCtrl, 'marginRight')),
                const SizedBox(width: 12),
                Expanded(
                    child:
                        _marginField('下', _marginBottomCtrl, 'marginBottom')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _marginField(
    String label,
    TextEditingController controller,
    String field,
  ) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: (value) => _updateField(field, value),
      validator: (value) {
        if (value == null || value.isEmpty) return '必填';
        final n = double.tryParse(value);
        if (n == null || n < 0) return '≥ 0';
        return null;
      },
    );
  }

  Widget _buildJobNameSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('打印任务名称',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('显示在系统打印对话框中的任务名称',
                style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 12),
            TextFormField(
              controller: _jobNameCtrl,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '输入打印任务名称',
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _reset,
            child: const Text('恢复默认'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _save,
            child: const Text('保存设置'),
          ),
        ),
      ],
    );
  }
}
