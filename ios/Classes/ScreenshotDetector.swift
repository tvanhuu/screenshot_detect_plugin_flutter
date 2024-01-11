//
//  ScreenshotDetector.swift
//  screenshot_detect_plugin_flutter
//
//  Created by Hữu Trần on 10/01/2024.
//
import Foundation
import Photos
import UIKit
import Flutter

@available(iOS 14.0, *)
class ScreenshotDetector: NSObject, ObservableObject, PHPhotoLibraryChangeObserver {
    private var TAG: String = "ScreenshotDetectPluginFlutterPlugin"
    private var fetchResult: PHFetchResult<PHAsset>?
    private var eventSink: FlutterEventSink?
    
    func setSink(eventSink: @escaping FlutterEventSink) {
        print(TAG + " setSink")
        self.eventSink = eventSink
    }
    
    func sinkScreenShootPath(path: String?) {
        if(eventSink != nil) {
            eventSink!(path)
        }
    }
        
    func startDetectingScreenshots() {
        print(TAG + " startDetectingScreenshots")
        if checkPhotoLibraryPermission() {
            PHPhotoLibrary.shared().register(self)
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            fetchOptions.predicate = NSPredicate(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
            self.fetchResult = PHAsset.fetchAssets(with: fetchOptions)
        } else {
            // TODO: If not authorization
        }
    }
    
    func stopDetectingScreenshots() {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
        
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        print(self.TAG + " photoLibraryDidChange")
        
        guard let fetchResult = fetchResult,
              let changes = changeInstance.changeDetails(for: fetchResult) else {
            return
        }

        DispatchQueue.main.async {
            self.fetchResult = changes.fetchResultAfterChanges

            changes.insertedObjects.forEach { asset in
                // Check if the inserted asset is a screenshot
                if self.isScreenshot(asset: asset) {
                    // Get the path of the screenshot image
                    self.retrievePath(for: asset)
                }
            }
        }
    }

    private func isScreenshot(asset: PHAsset) -> Bool {
        return asset.creationDate != nil &&
            asset.mediaSubtypes.contains(.photoScreenshot)
    }

    private func retrievePath(for asset: PHAsset) {
        let options = PHContentEditingInputRequestOptions()
        options.canHandleAdjustmentData = { _ in return true }

        asset.requestContentEditingInput(with: options) { contentEditingInput, _ in
            guard let url = contentEditingInput?.fullSizeImageURL else {
                return
            }
            
            let imagePath = self.saveImageToDocumentDirectory(urlImage: url, fileName: "sreenshot_huutv_\(NSUUID().uuidString)")
            
            if (self.eventSink != nil) {
                self.eventSink!(imagePath)
            }
        }
    }
    
    func saveImageToDocumentDirectory(urlImage: URL, fileName: String) -> String {

        let data = try? Data(contentsOf: urlImage)
        
        let directoryPath =  NSHomeDirectory().appending("/Documents/")

        if !FileManager.default.fileExists(atPath: directoryPath) {
            do {
                try FileManager.default.createDirectory(at: NSURL.fileURL(withPath: directoryPath), withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }

        let filepath = directoryPath.appending(fileName.appending(".jpg"))
        let url = NSURL.fileURL(withPath: filepath)
        
        do {
            try data?.write(to: url, options: .atomic)
            print("\(self.TAG) retrievePath \(url.path)")
            return url.path
        } catch {
            print(error)
            print("file cant not be save at path \(filepath), with error : \(error)");
            return urlImage.absoluteString
        }
    }
    
    func checkPhotoLibraryPermission() -> Bool {
        return PHPhotoLibrary.authorizationStatus() == .authorized
//            let status = PHPhotoLibrary.authorizationStatus()
//            print(TAG + " checkPhotoLibraryPermission \(status)")
//            switch status {
//                case .authorized:
//                    return true
//                case .denied, .restricted, .notDetermined, .limited :
//                    return false
//                default:
//                    return false
//            }
    }
    
    func requestPermission() {
        // ask for permissions
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
                case .authorized: break
                // as above
                case .denied, .restricted: break
                // as above
                case .notDetermined: break
                // won't happen but still
                case .limited: break
                default: break
            }
        }
    }
}
