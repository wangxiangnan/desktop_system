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
}
