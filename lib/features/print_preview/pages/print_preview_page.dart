import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import 'package:desktop_system/core/di/setup_dependencies.dart';
import 'package:desktop_system/core/models/print_content.dart';
import 'package:desktop_system/core/models/print_settings.dart';
import 'package:desktop_system/core/services/print_service.dart';
import 'package:desktop_system/core/services/print_settings_service.dart';
import 'package:desktop_system/routing/routes.dart';

class PrintPreviewPage extends StatefulWidget {
  final PrintContent content;

  const PrintPreviewPage({super.key, required this.content});

  @override
  State<PrintPreviewPage> createState() => _PrintPreviewPageState();
}

class _PrintPreviewPageState extends State<PrintPreviewPage> {
  late PrintSettings _settings;
  bool _isPrinting = false;
  int _previewKey = 0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    setState(() {
      _settings = getIt<PrintSettingsService>().loadSettings();
      _previewKey++;
    });
  }

  Future<void> _navigateToSettings() async {
    await context.push(Routes.printSettings);
    if (!mounted) return;
    _loadSettings();
  }

  Future<void> _doDirectPrint(
    BuildContext actionContext,
    LayoutCallback build,
    PdfPageFormat pageFormat,
  ) async {
    if (_isPrinting) return;
    setState(() => _isPrinting = true);

    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('打印中...'),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    bool success = false;
    try {
      final pdfBytes = await build(pageFormat);
      success = await Printing.directPrintPdf(
        printer: Printer(
          url: _settings.selectedPrinterUrl!,
          name: _settings.selectedPrinterName!,
        ),
        onLayout: (format) => pdfBytes,
        name: _settings.jobName,
      );
    } catch (_) {
      success = false;
    }

    if (!mounted) return;
    setState(() => _isPrinting = false);
    Navigator.of(context, rootNavigator: true).pop(); // close loading dialog

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('打印成功'), duration: Duration(seconds: 2)),
      );
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) context.pop();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('打印失败，请检查打印机是否可用'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  List<Widget> _buildActions() {
    return [
      PdfPreviewAction(
        icon: const Icon(Icons.print),
        onPressed: _doDirectPrint,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.content.title ?? '打印预览'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: '打印设置',
            onPressed: _navigateToSettings,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSettingsBar(),
          Expanded(
            child: PdfPreview(
              key: ValueKey(_previewKey),
              build: (format) =>
                  getIt<PrintService>().generatePdf(
                    widget.content,
                    settings: _settings,
                  ),
              initialPageFormat: _settings.pageFormat,
              canChangeOrientation: false,
              canChangePageFormat: false,
              allowPrinting: false,
              allowSharing: true,
              pdfFileName: _settings.jobName,
              actions: _buildActions(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _settings.hasPrinterSelected ? Colors.green.shade50 : Colors.grey.shade100,
        border: Border(
          bottom: BorderSide(
            color: _settings.hasPrinterSelected ? Colors.green.shade300 : Colors.grey,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.tune, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _buildSettingsSummary(),
              style: const TextStyle(fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton.icon(
            icon: const Icon(Icons.edit, size: 16),
            label: const Text('修改设置', style: TextStyle(fontSize: 13)),
            onPressed: _navigateToSettings,
          ),
        ],
      ),
    );
  }

  String _buildSettingsSummary() {
    final parts = [
      _settings.pageFormatLabel,
      _settings.orientationLabel,
      '边距${_settings.marginLeft.toStringAsFixed(0)}mm',
    ];
    if (_settings.hasPrinterSelected) {
      parts.add('直接打印至: ${_settings.selectedPrinterName}');
    }
    return parts.join(' · ');
  }
}
