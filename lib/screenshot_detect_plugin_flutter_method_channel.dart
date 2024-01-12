import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'screenshot_detect_plugin_flutter_platform_interface.dart';

/// An implementation of [ScreenshotDetectPluginFlutterPlatform] that uses method channels.
class MethodChannelScreenshotDetectPluginFlutter
    extends ScreenshotDetectPluginFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel =
      const MethodChannel('screenshot_detect_plugin_flutter/method');

  /// Event channel to communicate with the platform.
  final _eventChannel =
      const EventChannel('screenshot_detect_plugin_flutter/event');

  /// Retrieves the platform version using the `ScreenshotDetectPluginFlutterPlatform`.
  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  /// Creates a stream to listen for screenshot events using the `ScreenshotDetectPluginFlutterPlatform`.
  @override
  Stream<String?> screenShotStream() {
    return _eventChannel.receiveBroadcastStream().map((dynamic event) {
      return event;
    });
  }

  /// Check permission READ_EXTERNAL_STORAGE, NSPhotoLibrary using the `ScreenshotDetectPluginFlutterPlatform`.
  @override
  Future<bool?> checkPermission() async {
    final permissionGranted =
        await methodChannel.invokeMethod<bool>('checkPermission');
    return permissionGranted;
  }

  /// Request permission READ_EXTERNAL_STORAGE, NSPhotoLibrary using the `ScreenshotDetectPluginFlutterPlatform`.
  @override
  Future<String?> requestPermission() async {
    return await methodChannel.invokeMethod<String?>('requestPermission');
  }
}
