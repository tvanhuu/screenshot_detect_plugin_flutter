package com.dev.huutv.screenshot_detect_plugin_flutter

import android.app.Activity
import android.content.Context
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleEventObserver

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.lifecycle.HiddenLifecycleReference
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** ScreenshotDetectPluginFlutterPlugin */
class ScreenshotDetectPluginFlutterPlugin: FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler, ActivityAware, ScreenshotDetectionListener {
  private val TAG: String = "ScreenshotDetectPluginFlutterPlugin"
  private val methodChannelName: String = "screenshot_detect_plugin_flutter/method"
  private val eventChannelName: String = "screenshot_detect_plugin_flutter/event"

  private lateinit var activity: Activity
  private var eventSink: EventChannel.EventSink? = null

  private lateinit var methodChannel : MethodChannel
  private lateinit var eventChannel: EventChannel

  private lateinit var permissionsController: PermissionsController
  private  lateinit var screenshotDetectionManager : ScreenshotDetectionManager

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    setupPlugin(flutterPluginBinding.applicationContext,  flutterPluginBinding.binaryMessenger)
  }

  private fun setupPlugin(context: Context, messenger: BinaryMessenger) {
    methodChannel = MethodChannel(messenger, methodChannelName)
    methodChannel.setMethodCallHandler(this)

    eventChannel = EventChannel(messenger, eventChannelName)
    eventChannel.setStreamHandler(this)

    permissionsController = PermissionsController(context)
    screenshotDetectionManager = ScreenshotDetectionManager(this, permissionsController)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
      "checkPermission" -> result.success(screenshotDetectionManager.checkReadExternalStoragePermission())
      "requestPermission" -> {
        screenshotDetectionManager.requestReadExternalStoragePerPermission()
        result.success("Request permission success")
      }
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel.setMethodCallHandler(null)
    eventChannel.setStreamHandler(null)
    tearDown()
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity

    binding.addRequestPermissionsResultListener(screenshotDetectionManager)
    (binding.lifecycle as HiddenLifecycleReference)
      .lifecycle
      .addObserver(LifecycleEventObserver { _, event:  Lifecycle.Event ->
        if (event == Lifecycle.Event.ON_STOP){
          tearDown()
        } else if (event == Lifecycle.Event.ON_RESUME){
          screenshotDetectionManager.setActivity(binding.activity)
          screenshotDetectionManager.startScreenshotDetection()
        }
      })
  }

  override fun onDetachedFromActivityForConfigChanges() {
    tearDown()
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
  }

  override fun onDetachedFromActivity() {
    tearDown()
  }

  private fun tearDown() {
    screenshotDetectionManager.stopScreenshotDetection()
    screenshotDetectionManager.setActivity(null)
  }

  override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
    events?.let {
      eventSink = events
    }
  }

  override fun onCancel(arguments: Any?) {
    eventSink = null
    tearDown()
  }

  override fun onScreenCaptured(path: String?) {
    eventSink?.success(path)
  }

  override fun onScreenCapturedWithDeniedPermission() {
    // Do something when screen was captured but read external storage permission has denied
    eventSink?.error("-999","Please grant read external storage permission for screenshot detection","Please grant read external storage permission for screenshot detection")
  }
}
