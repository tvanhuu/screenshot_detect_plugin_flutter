import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'screenshot_detect_plugin_flutter_method_channel.dart';

abstract class ScreenshotDetectPluginFlutterPlatform extends PlatformInterface {
  /// Constructs a ScreenshotDetectPluginFlutterPlatform.
  ScreenshotDetectPluginFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static ScreenshotDetectPluginFlutterPlatform _instance =
      MethodChannelScreenshotDetectPluginFlutter();

  /// The default instance of [ScreenshotDetectPluginFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelScreenshotDetectPluginFlutter].
  static ScreenshotDetectPluginFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ScreenshotDetectPluginFlutterPlatform] when
  /// they register themselves.
  static set instance(ScreenshotDetectPluginFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Retrieves the platform version using the `ScreenshotDetectPluginFlutterPlatform`.
  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  /// Creates a stream to listen for screenshot events using the `ScreenshotDetectPluginFlutterPlatform`.
  Stream<String?> screenShotStream() {
    throw UnimplementedError('screenShotStream() has not been implemented.');
  }

  /// Check permission READ_EXTERNAL_STORAGE, NSPhotoLibrary using the `ScreenshotDetectPluginFlutterPlatform`.
  Future<bool?> checkPermission() {
    throw UnimplementedError('checkPermission() has not been implemented.');
  }

  /// Request permission READ_EXTERNAL_STORAGE, NSPhotoLibrary using the `ScreenshotDetectPluginFlutterPlatform`.
  Future<String?> requestPermission() {
    throw UnimplementedError('requestPermission() has not been implemented.');
  }
}
