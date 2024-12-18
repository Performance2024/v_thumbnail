// android/src/main/kotlin/com/example/v_thumbnail/VThumbnailPlugin.kt
package com.example.v_thumbnail

import android.graphics.Bitmap
import android.media.MediaMetadataRetriever
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File
import java.io.FileOutputStream

class VThumbnailPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "v_thumbnail")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "generateThumbnail" -> {
        val videoPath = call.argument<String>("videoPath")
        val width = call.argument<Int>("width") ?: 100
        val height = call.argument<Int>("height") ?: 100
        val timeMs = call.argument<Int>("timeMs") ?: 0

        if (videoPath == null) {
          result.error("INVALID_ARGUMENT", "Video path is required", null)
          return
        }

        try {
          val retriever = MediaMetadataRetriever()
          retriever.setDataSource(videoPath)
          
          val bitmap = retriever.getFrameAtTime(timeMs * 1000L)
          val scaledBitmap = Bitmap.createScaledBitmap(bitmap!!, width, height, true)
          
          val thumbnailFile = File.createTempFile("thumbnail_", ".jpg")
          val outputStream = FileOutputStream(thumbnailFile)
          scaledBitmap.compress(Bitmap.CompressFormat.JPEG, 90, outputStream)
          
          outputStream.close()
          retriever.release()
          
          result.success(thumbnailFile.absolutePath)
        } catch (e: Exception) {
          result.error("THUMBNAIL_ERROR", e.message, null)
        }
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}