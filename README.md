# screenshot_detect_plugin_flutter

A simple package to detect user screenshots and get path images.
You can from image link to social sharing.
Hope to help you.

[Source](https://stackoverflow.com/a/51118088)

---

## Getting Started

Android

- Add to AndroidManifest

```xml
  <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"
    android:maxSdkVersion="32" />
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

IOS

- Add NSPhotoLibraryUsageDescription to Info.plit

```plist
    <key>NSPhotoLibraryUsageDescription</key>
    <string>This app requires access to the photo library.</string>
```

You can to check and request permission

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

Create Instance of `Screenshot stream` and listen call back

```dart
    Future<void> _listenScreenShot() async {
    _stream = _screenshotDetect.screenShotStream();

    _stream.listen((String? path) {
      print("It is a path screenshot!\n $path");
    }).onError((error) {
      print("It is somethings wrong: \n $error");
    });
  }
```

Full example:

```dart
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

...
```
