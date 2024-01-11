import 'screenshot_detect_plugin_flutter_platform_interface.dart';

/// `ScreenshotDetect` is a Dart class that provides methods to interact with the `ScreenshotDetectPluginFlutterPlatform`.
/// It allows you to retrieve the platform version and listen to a stream for screenshot events.
class ScreenshotDetect {
  /// Retrieves the platform version using the `ScreenshotDetectPluginFlutterPlatform`.
  Future<String?> getPlatformVersion() {
    return ScreenshotDetectPluginFlutterPlatform.instance.getPlatformVersion();
  }

  /// Creates a stream to listen for screenshot events using the `ScreenshotDetectPluginFlutterPlatform`.
  Stream<String?> screenShotStream() {
    return ScreenshotDetectPluginFlutterPlatform.instance.screenShotStream();
  }

  /// Check permission READ_EXTERNAL_STORAGE  using the `ScreenshotDetectPluginFlutterPlatform`.
  Future<bool?> checkPermission() {
    return ScreenshotDetectPluginFlutterPlatform.instance.checkPermission();
  }

  /// Request permission READ_EXTERNAL_STORAGE  using the `ScreenshotDetectPluginFlutterPlatform`.
  Future<String?> requestPermission() {
    return ScreenshotDetectPluginFlutterPlatform.instance.requestPermission();
  }
}
