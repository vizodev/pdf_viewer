import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';

void main() {
  const MethodChannel channel = MethodChannel('easy_pdf_viewer');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    // expect(await EasyPdfViewer.platformVersion, '42');
  });
}
