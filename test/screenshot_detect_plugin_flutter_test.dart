import 'package:flutter_test/flutter_test.dart';
import 'package:screenshot_detect_plugin_flutter/screenshot_detect.dart';
import 'package:screenshot_detect_plugin_flutter/screenshot_detect_plugin_flutter_platform_interface.dart';
import 'package:screenshot_detect_plugin_flutter/screenshot_detect_plugin_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockScreenshotDetectPluginFlutterPlatform
    with MockPlatformInterfaceMixin
    implements ScreenshotDetectPluginFlutterPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Stream<String> screenShotStream() {
    return const Stream<String>.empty();
  }

  @override
  Future<bool?> checkPermission() {
    return Future.value(true);
  }

  @override
  Future<String?> requestPermission() {
    return Future.value('Request success');
  }
}

void main() {
  final ScreenshotDetectPluginFlutterPlatform initialPlatform =
      ScreenshotDetectPluginFlutterPlatform.instance;

  test('$MethodChannelScreenshotDetectPluginFlutter is the default instance',
      () {
    expect(initialPlatform,
        isInstanceOf<MethodChannelScreenshotDetectPluginFlutter>());
  });

  test('getPlatformVersion', () async {
    ScreenshotDetect screenshotDetect = ScreenshotDetect();
    MockScreenshotDetectPluginFlutterPlatform fakePlatform =
        MockScreenshotDetectPluginFlutterPlatform();
    ScreenshotDetectPluginFlutterPlatform.instance = fakePlatform;

    expect(await screenshotDetect.getPlatformVersion(), '42');
  });

  test('getStreamScreenshot', () async {
    ScreenshotDetect screenshotDetect = ScreenshotDetect();

    MockScreenshotDetectPluginFlutterPlatform fakePlatform =
        MockScreenshotDetectPluginFlutterPlatform();
    ScreenshotDetectPluginFlutterPlatform.instance = fakePlatform;

    expect(screenshotDetect.screenShotStream(), const Stream<String>.empty());
  });

  test('checkPermission', () async {
    ScreenshotDetect screenshotDetect = ScreenshotDetect();
    MockScreenshotDetectPluginFlutterPlatform fakePlatform =
        MockScreenshotDetectPluginFlutterPlatform();
    ScreenshotDetectPluginFlutterPlatform.instance = fakePlatform;

    expect(await screenshotDetect.checkPermission(), true);
  });

  test('getPlatformVersion', () async {
    ScreenshotDetect screenshotDetect = ScreenshotDetect();
    MockScreenshotDetectPluginFlutterPlatform fakePlatform =
        MockScreenshotDetectPluginFlutterPlatform();
    ScreenshotDetectPluginFlutterPlatform.instance = fakePlatform;

    expect(await screenshotDetect.getPlatformVersion(), 'Request success');
  });
}
