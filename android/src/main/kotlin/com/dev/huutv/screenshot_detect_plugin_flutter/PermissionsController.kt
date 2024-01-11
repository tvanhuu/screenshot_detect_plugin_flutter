package com.dev.huutv.screenshot_detect_plugin_flutter

import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager

class PermissionsController (private val context: Context) {
    fun hasRequiredPermissions(permissions: List<String>): Boolean {
        var hasPermissions = true
        for (permission in permissions) {
            hasPermissions = hasPermissions && checkPermissionPermissionGranted(permission)
        }
        return hasPermissions
    }

    private fun checkPermissionPermissionGranted(permission: String): Boolean {
        return context.checkSelfPermission(permission) == PackageManager.PERMISSION_GRANTED
    }

    fun requestPermissions(activity: Activity, permissions: List<String>, requestCode: Int) {
        activity.requestPermissions(permissions.toTypedArray(), requestCode)
    }
}