//
//  Created by Hữu Trần on 10/01/2024.
//

import Flutter
import UIKit

@available(iOS 14.0, *)
public class ScreenshotDetectPluginFlutterPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    private var TAG: String = "ScreenshotDetectPluginFlutterPlugin"
    private var eventChanel = "screenshot_detect_plugin_flutter/event"
    private var methodChanel = "screenshot_detect_plugin_flutter/method"
    
    private var screenshotDetector: ScreenshotDetector = ScreenshotDetector()
    private var eventSink: FlutterEventSink?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = ScreenshotDetectPluginFlutterPlugin()
        instance.setupChannels(registrar.messenger(), instance)
    }
    
    private func setupChannels(_ messenger: FlutterBinaryMessenger, _ instance: ScreenshotDetectPluginFlutterPlugin) {
        let methodChannel = FlutterMethodChannel(
            name: instance.methodChanel, binaryMessenger: messenger)
        methodChannel.setMethodCallHandler(methodCallHandler)
        
        let eventChannel = FlutterEventChannel(name: instance.eventChanel, binaryMessenger: messenger)
        eventChannel.setStreamHandler(instance as FlutterStreamHandler & NSObjectProtocol)
        
        let notificationCenter = NotificationCenter.default
         notificationCenter.addObserver(instance,
                                        selector: #selector(didEnterBackground),
                                        name: UIApplication.didEnterBackgroundNotification,
                                        object: nil)
         
         notificationCenter.addObserver(instance,
                                        selector: #selector(willEnterForeground),
                                        name: UIApplication.willEnterForegroundNotification,
                                        object: nil)
    }
    
    private func methodCallHandler(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
            case "getPlatformVersion":
                result("iOS " + UIDevice.current.systemVersion)
            case "checkPermission":
                result(screenshotDetector.checkPhotoLibraryPermission())
            case "requestPermission":
                screenshotDetector.requestPermission()
                result("Okay, coming soon..")
            default:
                result(nil)
        }
    }
    
    public func onListen(withArguments arguments: Any?,eventSink: @escaping FlutterEventSink) -> FlutterError? {
        print(TAG + " onListen")
        self.eventSink = eventSink
        self.screenshotDetector.setSink(eventSink: eventSink)
        self.screenshotDetector.startDetectingScreenshots()
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        print(TAG + " onCancel")
        eventSink = nil
        return nil
    }

    @objc func didEnterBackground() {
        print(TAG + " didEnterBackground")
        self.screenshotDetector.stopDetectingScreenshots()
    }

    @objc func willEnterForeground() {
        print(TAG + " willEnterForeground")
        self.screenshotDetector.startDetectingScreenshots()
    }
}
