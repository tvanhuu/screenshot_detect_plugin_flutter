import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screenshot_detect_plugin_flutter/screenshot_detect_plugin_flutter_method_channel.dart';

void main() {
  MethodChannelScreenshotDetectPluginFlutter platform =
      MethodChannelScreenshotDetectPluginFlutter();
  const MethodChannel channel =
      MethodChannel('screenshot_detect_plugin_flutter');

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
    expect(await platform.getPlatformVersion(), '42');
  });

  test("getStreamScreenshot", () {
    expect(platform.screenShotStream(), const Stream.empty());
  });

  test("checkPermission", () {
    expect(platform.checkPermission(), true);
  });

  test("getPlatformVersion", () {
    expect(platform.getPlatformVersion(), 'Request success');
  });
}
