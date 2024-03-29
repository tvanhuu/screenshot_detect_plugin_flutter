# screenshot_detect_plugin_flutter

- A simple package to detect user screenshots and get path images for `Android` and `IOS`.
- You can share image to social...
- Hope to help you.

[Source](https://github.com/tvanhuu/screenshot_detect_plugin_flutter)
[Pub.dev](https://pub.dev/packages/screenshot_detect_plugin_flutter)

![2024-01-11 13 54 14](https://github.com/tvanhuu/screenshot_detect_plugin_flutter/assets/31562266/340b84a6-2b08-4969-81bb-ddeeccd3c8a1)

---

## Getting Started

`ANDROID`

- Required minSdkVersion >= 26, targetSdk 33
- Add to AndroidManifest user permission

```xml
  <!-- For sdk < 33 -->
  <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"
    android:maxSdkVersion="32" />
  <!-- For sdk >= 33 -->
  <uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
```

- For android 10 add requestLegacyExternalStorage to <activity />

```xml
  <activity
      ....
      android:requestLegacyExternalStorage="true">
  </activity>
```

---

`IOS`

- Required IOS > 14
- Add NSPhotoLibraryUsageDescription to Info.plits

```plist
    <key>NSPhotoLibraryUsageDescription</key>
    <string>This app requires access to the photo library.</string>
```

---

`USE`
You can to check and request permission `checkPermission`.

```dart
    Future<void> _checkPermission() async {
    _screenshotDetect.checkPermission().then((isGranted) {
      if (isGranted == null || !isGranted) {
        _screenshotDetect.requestPermission();
      }
    });
  }
```

---

Create Stream of `Screenshot stream` and listen call back path

```dart
    Future<void> _listenScreenShot() async {
    _stream = _screenshotDetect.screenShotStream();

    _stream.listen((String? path) {
      print("It's a screenshot of the path!\n $path");
    }).onError((error) {
      print("It's somethings wrong: \n $error");
    });
  }
```

`Full example`

```dart
import 'package:screenshot_detect_plugin_flutter/screenshot_detect.dart';

class _MyAppState extends State<MyApp> {
  final ScreenshotDetect _screenshotDetect = ScreenshotDetect();
  late Stream<String?> _stream;

  @override
  void initState() {
    super.initState();
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

...
```

## Author

- [tvanhuu](https://github.com/tvanhuu) • <ithuutran@gmail.com>

## License

MIT
