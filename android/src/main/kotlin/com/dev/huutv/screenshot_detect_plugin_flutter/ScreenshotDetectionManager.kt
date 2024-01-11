package com.dev.huutv.screenshot_detect_plugin_flutter

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import android.database.ContentObserver
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.provider.MediaStore
import android.util.Log
import io.flutter.plugin.common.PluginRegistry
import java.util.Locale

interface ScreenshotDetectionListener {
    fun onScreenCaptured(path: String?)
    fun onScreenCapturedWithDeniedPermission()
}

class ScreenshotDetectionManager(private val listener: ScreenshotDetectionListener?, private val permissionsController: PermissionsController) : PluginRegistry.RequestPermissionsResultListener,
    ScreenshotDetectionListener {
    private val TAG: String = "ScreenshotDetectPluginFlutterPlugin-ScreenshotDetectionManager"
    private val REQUEST_CODE_READ_EXTERNAL_STORAGE_PERMISSION = 1993

    private var activity: Activity? = null

    private val contentObserver: ContentObserver = object : ContentObserver(Handler()) {
        override fun onChange(selfChange: Boolean, uri: Uri?) {
            super.onChange(selfChange, uri)

            if (permissionsController.hasRequiredPermissions(getPermissionNeedRequest())) {
                val path = getFilePathFromContentResolver(activity!!.baseContext, uri)
                if (isScreenshotPath(path)) {
                    onScreenCaptured(path)
                }
            } else {
                onScreenCapturedWithDeniedPermission()
            }
        }
    }

    fun setActivity(activity: Activity?) {
        this.activity = activity
    }

    private fun getPermissionNeedRequest(): List<String> {
        // For sdk < 33
        var permission = listOf<String>(Manifest.permission.READ_EXTERNAL_STORAGE)

        // SDK >= 33
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            permission = listOf<String>(Manifest.permission.READ_MEDIA_IMAGES)
        }
        return permission
    }

    fun checkReadExternalStoragePermission(): Boolean {
        return !permissionsController.hasRequiredPermissions(getPermissionNeedRequest())
    }

    fun requestReadExternalStoragePerPermission() {
        permissionsController.requestPermissions(activity!!, getPermissionNeedRequest(), REQUEST_CODE_READ_EXTERNAL_STORAGE_PERMISSION)
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<String?>,
        grantResults: IntArray
    ): Boolean {
        if (grantResults.isEmpty()) {
            return false
        }

        when (requestCode) {
            REQUEST_CODE_READ_EXTERNAL_STORAGE_PERMISSION -> if (grantResults[0] == PackageManager.PERMISSION_DENIED) {
                showReadExternalStoragePermissionDeniedMessage()
            }
            else -> return false
        }

        return true
    }

    private fun showReadExternalStoragePermissionDeniedMessage() {
        listener?.onScreenCapturedWithDeniedPermission()
    }

    fun startScreenshotDetection() {
        Log.d(TAG, "startScreenshotDetection")
        activity!!.baseContext
            .contentResolver
            ?.registerContentObserver(
                MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
                true,
                contentObserver
            )
    }

    fun stopScreenshotDetection() {
        Log.d(TAG, "stopScreenshotDetection")
        activity!!.baseContext.contentResolver?.unregisterContentObserver(contentObserver)
    }

    private fun isScreenshotPath(path: String?): Boolean {
        return path != null && (path.lowercase(Locale.getDefault()).contains("screenshots") && !path.lowercase(Locale.getDefault()).contains(".pending"))
    }

    private fun getFilePathFromContentResolver(context: Context, uri: Uri?): String? {
        try {
            val cursor = context.contentResolver.query(
                uri!!, arrayOf(
                    MediaStore.Images.Media.DISPLAY_NAME,
                    MediaStore.Images.Media.DATA
                ), null, null, null
            )
            if (cursor != null && cursor.moveToFirst()) {
                val path =
                    cursor.getString(cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA))
                cursor.close()

                return path
            }
        } catch (ignored: IllegalStateException) {
            return null
        }
        return null
    }

    override fun onScreenCaptured(path: String?) {
        listener?.onScreenCaptured(path)
    }

    override fun onScreenCapturedWithDeniedPermission() {
        listener?.onScreenCapturedWithDeniedPermission()
    }
}

