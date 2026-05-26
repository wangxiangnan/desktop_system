import 'dart:typed_data';

sealed class PrintContent {
  const PrintContent._();

  String? get title;
  String? get fileNameHint;

  const factory PrintContent.imageFile(
    String filePath, {
    String? title,
    String? fileNameHint,
  }) = ImageFileContent;

  const factory PrintContent.imageUrl(
    String url, {
    String? title,
    String? fileNameHint,
  }) = ImageUrlContent;

  const factory PrintContent.imageBytes(
    Uint8List bytes, {
    String? title,
    String? fileNameHint,
  }) = ImageBytesContent;

  const factory PrintContent.svg(
    String svgString, {
    String? title,
    String? fileNameHint,
  }) = SvgContent;

  const factory PrintContent.pdf({
    required Future<Uint8List> Function() builder,
    String? title,
    String? fileNameHint,
  }) = PdfContent;
}

class ImageFileContent extends PrintContent {
  final String filePath;
  @override
  final String? title;
  @override
  final String? fileNameHint;

  const ImageFileContent(this.filePath, {this.title, this.fileNameHint})
      : super._();
}

class ImageUrlContent extends PrintContent {
  final String url;
  @override
  final String? title;
  @override
  final String? fileNameHint;

  const ImageUrlContent(this.url, {this.title, this.fileNameHint}) : super._();
}

class ImageBytesContent extends PrintContent {
  final Uint8List bytes;
  @override
  final String? title;
  @override
  final String? fileNameHint;

  const ImageBytesContent(this.bytes, {this.title, this.fileNameHint}) : super._();
}

class SvgContent extends PrintContent {
  final String svgString;
  @override
  final String? title;
  @override
  final String? fileNameHint;

  const SvgContent(this.svgString, {this.title, this.fileNameHint}) : super._();
}

class PdfContent extends PrintContent {
  final Future<Uint8List> Function() builder;
  @override
  final String? title;
  @override
  final String? fileNameHint;

  const PdfContent({required this.builder, this.title, this.fileNameHint}) : super._();
}
