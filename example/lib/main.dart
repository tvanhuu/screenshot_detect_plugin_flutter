import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:screenshot_detect_plugin_flutter/screenshot_detect.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final ScreenshotDetect _screenshotDetect = ScreenshotDetect();
  late Stream<String?> _stream;

  @override
  void initState() {
    super.initState();
    _initPlatformState();
    _checkPermission();
    _listenScreenShot();
  }

  Future<void> _checkPermission() async {
    _screenshotDetect.checkPermission().then((isGranted) {
      if (isGranted == null || !isGranted) {
        _screenshotDetect.requestPermission();
      }
    });
  }

  Future<void> _listenScreenShot() async {
    _stream = _screenshotDetect.screenShotStream();

    _stream.listen((String? path) {
      print("It is a path screenshot!\n $path");
    }).onError((error) {
      print("It is somethings wrong: \n $error");
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> _initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _screenshotDetect.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Screenshot example app'),
        ),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Running on: $_platformVersion\n'),
              StreamBuilder<String?>(
                stream: _stream,
                builder: (_, AsyncSnapshot<String?> snapshoot) {
                  if (snapshoot.data == null) {
                    return const Text('Let\'s take screenShot now!');
                  }
                  return SizedBox(
                      width: 200,
                      height: 200,
                      child: Image.file(File(snapshoot.data!)));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
