import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/pdf.dart';

class PrintSettings {
  final String pageFormatName;
  final bool isLandscape;
  final double marginLeft;
  final double marginTop;
  final double marginRight;
  final double marginBottom;
  final String jobName;
  final bool directPrint;
  final String? selectedPrinterUrl;
  final String? selectedPrinterName;

  static const Map<String, PdfPageFormat> _pageFormats = {
    'a4': PdfPageFormat.a4,
    'a3': PdfPageFormat.a3,
    'letter': PdfPageFormat.letter,
    'legal': PdfPageFormat.legal,
  };

  static const Map<String, String> formatLabels = {
    'a4': 'A4',
    'a3': 'A3',
    'letter': 'Letter',
    'legal': 'Legal',
  };

  static const Map<String, String> orientationLabels = {
    'portrait': '纵向',
    'landscape': '横向',
  };

  static const List<String> formatKeys = ['a4', 'a3', 'letter', 'legal'];
  static const List<String> orientationKeys = ['portrait', 'landscape'];

  const PrintSettings({
    this.pageFormatName = 'a4',
    this.isLandscape = false,
    this.marginLeft = 10.0,
    this.marginTop = 10.0,
    this.marginRight = 10.0,
    this.marginBottom = 10.0,
    this.jobName = 'Print Job',
    this.directPrint = false,
    this.selectedPrinterUrl,
    this.selectedPrinterName,
  });

  factory PrintSettings.defaults() => const PrintSettings();

  String get pageFormatLabel => formatLabels[pageFormatName] ?? 'A4';

  String get orientationKey => isLandscape ? 'landscape' : 'portrait';
  String get orientationLabel => orientationLabels[orientationKey]!;

  bool get hasPrinterSelected => selectedPrinterUrl != null;

  PdfPageFormat get pageFormat {
    final base = _pageFormats[pageFormatName] ?? PdfPageFormat.a4;
    final oriented = isLandscape ? base.landscape : base.portrait;
    return oriented.copyWith(
      marginLeft: marginLeft * PdfPageFormat.mm,
      marginTop: marginTop * PdfPageFormat.mm,
      marginRight: marginRight * PdfPageFormat.mm,
      marginBottom: marginBottom * PdfPageFormat.mm,
    );
  }

  String get marginsSummary =>
      '${marginLeft.toStringAsFixed(0)} / ${marginTop.toStringAsFixed(0)} / ${marginRight.toStringAsFixed(0)} / ${marginBottom.toStringAsFixed(0)} mm';

  PrintSettings copyWith({
    String? pageFormatName,
    bool? isLandscape,
    double? marginLeft,
    double? marginTop,
    double? marginRight,
    double? marginBottom,
    String? jobName,
    bool? directPrint,
    String? selectedPrinterUrl,
    String? selectedPrinterName,
    bool clearPrinter = false,
  }) {
    return PrintSettings(
      pageFormatName: pageFormatName ?? this.pageFormatName,
      isLandscape: isLandscape ?? this.isLandscape,
      marginLeft: marginLeft ?? this.marginLeft,
      marginTop: marginTop ?? this.marginTop,
      marginRight: marginRight ?? this.marginRight,
      marginBottom: marginBottom ?? this.marginBottom,
      jobName: jobName ?? this.jobName,
      directPrint: directPrint ?? this.directPrint,
      selectedPrinterUrl:
          clearPrinter ? null : selectedPrinterUrl ?? this.selectedPrinterUrl,
      selectedPrinterName:
          clearPrinter ? null : selectedPrinterName ?? this.selectedPrinterName,
    );
  }

  // SharedPreferences serialization
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

  factory PrintSettings.fromPrefs(SharedPreferences prefs) {
    return PrintSettings(
      pageFormatName: prefs.getString(_keyPageFormat) ?? 'a4',
      isLandscape: (prefs.getString(_keyOrientation) ?? 'portrait') == 'landscape',
      marginLeft: prefs.getDouble(_keyMarginLeft) ?? 10.0,
      marginTop: prefs.getDouble(_keyMarginTop) ?? 10.0,
      marginRight: prefs.getDouble(_keyMarginRight) ?? 10.0,
      marginBottom: prefs.getDouble(_keyMarginBottom) ?? 10.0,
      jobName: prefs.getString(_keyJobName) ?? 'Print Job',
      directPrint: prefs.getBool(_keyDirectPrint) ?? false,
      selectedPrinterUrl: prefs.getString(_keyPrinterUrl),
      selectedPrinterName: prefs.getString(_keyPrinterName),
    );
  }

  Future<void> saveToPrefs(SharedPreferences prefs) async {
    await prefs.setString(_keyPageFormat, pageFormatName);
    await prefs.setString(_keyOrientation, orientationKey);
    await prefs.setDouble(_keyMarginLeft, marginLeft);
    await prefs.setDouble(_keyMarginTop, marginTop);
    await prefs.setDouble(_keyMarginRight, marginRight);
    await prefs.setDouble(_keyMarginBottom, marginBottom);
    await prefs.setString(_keyJobName, jobName);
    await prefs.setBool(_keyDirectPrint, directPrint);
    if (selectedPrinterUrl != null) {
      await prefs.setString(_keyPrinterUrl, selectedPrinterUrl!);
      await prefs.setString(_keyPrinterName, selectedPrinterName ?? '');
    } else {
      await prefs.remove(_keyPrinterUrl);
      await prefs.remove(_keyPrinterName);
    }
  }
}
