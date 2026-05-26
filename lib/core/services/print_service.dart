import 'dart:io';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:desktop_system/core/di/setup_dependencies.dart';
import 'package:desktop_system/core/models/print_content.dart';
import 'package:desktop_system/core/models/print_settings.dart';
import 'package:desktop_system/core/network/dio_client.dart';
import 'package:desktop_system/core/services/print_settings_service.dart';
import 'package:desktop_system/routing/routes.dart';

class PrintService {
  static pw.Font? _cachedCjkFont;

  static Future<pw.Font> loadCjkFont() async {
    if (_cachedCjkFont != null) return _cachedCjkFont!;

    final paths = switch (defaultTargetPlatform) {
      TargetPlatform.windows => [
        r'C:\Windows\Fonts\NotoSansSC-VF.ttf',
        r'C:\Windows\Fonts\simhei.ttf',
        r'C:\Windows\Fonts\msyh.ttc',
      ],
      TargetPlatform.macOS => [
        '/System/Library/Fonts/PingFang.ttc',
        '/System/Library/Fonts/STHeiti Light.ttc',
        '/System/Library/Fonts/Hiragino Sans GB.ttc',
      ],
      TargetPlatform.linux => [
        '/usr/share/fonts/opentype/noto/NotoSansCJK-Regular.ttc',
        '/usr/share/fonts/truetype/noto/NotoSansCJK-Regular.ttc',
        '/usr/share/fonts/noto-cjk/NotoSansCJK-Regular.ttc',
      ],
      _ => <String>[],
    };

    for (final path in paths) {
      final file = File(path);
      if (file.existsSync()) {
        final bytes = await file.readAsBytes();
        _cachedCjkFont = pw.Font.ttf(bytes.buffer.asByteData());
        return _cachedCjkFont!;
      }
    }
    return pw.Font.courier();
  }

  Future<Uint8List> generatePdf(PrintContent content, {PrintSettings? settings}) async {
    if (content is PdfContent) {
      return content.builder();
    }
    final effectiveSettings = settings ?? getIt<PrintSettingsService>().loadSettings();
    final imageBytes = await _contentToImageBytes(content);
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: effectiveSettings.pageFormat,
        build: (ctx) =>
            pw.Center(child: pw.Image(pw.MemoryImage(imageBytes), fit: pw.BoxFit.contain)),
      ),
    );
    return doc.save();
  }

  void navigateToPreview(BuildContext context, PrintContent content) {
    context.push(Routes.printPreview, extra: content);
  }

  Future<void> printDirectly(PrintContent content, {PrintSettings? settings}) async {
    final effectiveSettings = settings ?? getIt<PrintSettingsService>().loadSettings();
    final pdfBytes = await generatePdf(content, settings: effectiveSettings);

    if (effectiveSettings.directPrint && effectiveSettings.hasPrinterSelected) {
      await Printing.directPrintPdf(
        printer: Printer(
          url: effectiveSettings.selectedPrinterUrl!,
          name: effectiveSettings.selectedPrinterName!,
        ),
        onLayout: (format) => pdfBytes,
        name: effectiveSettings.jobName,
      );
    } else {
      await Printing.layoutPdf(
        onLayout: (format) => pdfBytes,
        name: effectiveSettings.jobName,
      );
    }
  }

  Future<Uint8List> _contentToImageBytes(PrintContent content) {
    return switch (content) {
      ImageFileContent(:final filePath) => File(filePath).readAsBytes(),
      ImageUrlContent(:final url) => _downloadImage(url),
      ImageBytesContent(:final bytes) => Future.value(bytes),
      SvgContent(:final svgString) => _renderSvgToPng(svgString),
      PdfContent(:final builder) => builder(),
    };
  }

  Future<Uint8List> _downloadImage(String url) async {
    final dio = getIt<DioClient>().dio;
    final response = await dio.get<List<int>>(
      url,
      options: Options(responseType: ResponseType.bytes),
    );
    return Uint8List.fromList(response.data!);
  }

  Future<Uint8List> _renderSvgToPng(String svgString) async {
    final loader = SvgStringLoader(svgString);
    final pictureInfo = await vg.loadPicture(loader, null);
    final picture = pictureInfo.picture;
    final width = pictureInfo.size.width.ceil();
    final height = pictureInfo.size.height.ceil();
    if (width <= 0 || height <= 0) {
      throw Exception('SVG has invalid dimensions ($width x $height)');
    }
    final image = await picture.toImage(width, height);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    return byteData!.buffer.asUint8List();
  }
}
