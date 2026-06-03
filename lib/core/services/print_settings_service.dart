import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:desktop_system/core/models/print_settings.dart';

class PrintSettingsService {
  static const _keyPageFormat = 'print_page_format';
  static const _keyOrientation = 'print_orientation';
  static const _keyMarginLeft = 'print_margin_left';
  static const _keyMarginTop = 'print_margin_top';
  static const _keyMarginRight = 'print_margin_right';
  static const _keyMarginBottom = 'print_margin_bottom';
  static const _keyJobName = 'print_job_name';
  static const _keyDirectPrint = 'print_direct_print';
  static const _keyPrinterUrl = 'print_printer_url';
  static const _keyPrinterName = 'print_printer_name';

  final SharedPreferences _prefs;

  PrintSettingsService(this._prefs);

  PrintSettings loadSettings() {
    return PrintSettings(
      pageFormatName: _prefs.getString(_keyPageFormat) ?? 'a4',
      isLandscape:
          (_prefs.getString(_keyOrientation) ?? 'portrait') == 'landscape',
      marginLeft: _prefs.getDouble(_keyMarginLeft) ?? 10.0,
      marginTop: _prefs.getDouble(_keyMarginTop) ?? 10.0,
      marginRight: _prefs.getDouble(_keyMarginRight) ?? 10.0,
      marginBottom: _prefs.getDouble(_keyMarginBottom) ?? 10.0,
      jobName: _prefs.getString(_keyJobName) ?? 'Print Job',
      directPrint: _prefs.getBool(_keyDirectPrint) ?? false,
      selectedPrinterUrl: _prefs.getString(_keyPrinterUrl),
      selectedPrinterName: _prefs.getString(_keyPrinterName),
    );
  }

  Future<void> saveSettings(PrintSettings settings) async {
    await _prefs.setString(_keyPageFormat, settings.pageFormatName);
    await _prefs.setString(_keyOrientation, settings.orientationKey);
    await _prefs.setDouble(_keyMarginLeft, settings.marginLeft);
    await _prefs.setDouble(_keyMarginTop, settings.marginTop);
    await _prefs.setDouble(_keyMarginRight, settings.marginRight);
    await _prefs.setDouble(_keyMarginBottom, settings.marginBottom);
    await _prefs.setString(_keyJobName, settings.jobName);
    await _prefs.setBool(_keyDirectPrint, settings.directPrint);
    if (settings.selectedPrinterUrl != null) {
      await _prefs.setString(_keyPrinterUrl, settings.selectedPrinterUrl!);
      await _prefs.setString(
          _keyPrinterName, settings.selectedPrinterName ?? '');
    } else {
      await _prefs.remove(_keyPrinterUrl);
      await _prefs.remove(_keyPrinterName);
    }
  }

  Future<List<Printer>> getPrinters() => Printing.listPrinters();
}
