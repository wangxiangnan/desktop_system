import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:desktop_system/core/models/print_settings.dart';

class PrintSettingsService {
  final SharedPreferences _prefs;

  PrintSettingsService(this._prefs);

  PrintSettings loadSettings() => PrintSettings.fromPrefs(_prefs);

  Future<void> saveSettings(PrintSettings settings) => settings.saveToPrefs(_prefs);

  Future<List<Printer>> getPrinters() => Printing.listPrinters();
}
