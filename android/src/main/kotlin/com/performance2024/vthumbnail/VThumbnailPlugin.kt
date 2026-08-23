package com.performance2024.vthumbnail

import android.content.Context
import android.graphics.Bitmap
import android.media.MediaMetadataRetriever
import android.os.Build
import android.os.Handler
import android.os.Looper
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File
import java.io.FileOutputStream
import java.util.UUID
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

class VThumbnailPlugin : FlutterPlugin, MethodCallHandler {
  private lateinit var channel: MethodChannel
  private lateinit var appContext: Context
  private val executor: ExecutorService = Executors.newFixedThreadPool(2)
  private val mainHandler = Handler(Looper.getMainLooper())

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "v_thumbnail")
    channel.setMethodCallHandler(this)
    appContext = flutterPluginBinding.applicationContext
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

        executor.execute {
          val retriever = MediaMetadataRetriever()
          try {
            retriever.setDataSource(videoPath)
            val path = extractFrame(retriever, timeMs, width, height)
            mainHandler.post {
              if (path != null) {
                result.success(path)
              } else {
                result.error("THUMBNAIL_ERROR", "Could not extract frame at ${timeMs}ms", null)
              }
            }
          } catch (e: Exception) {
            mainHandler.post { result.error("THUMBNAIL_ERROR", e.message, null) }
          } finally {
            retriever.release()
          }
        }
      }
      "generateMultipleThumbnails" -> {
        val videoPath = call.argument<String>("videoPath")
        val width = call.argument<Int>("width") ?: 100
        val height = call.argument<Int>("height") ?: 100
        val count = call.argument<Int>("numberOfThumbnails") ?: 5

        if (videoPath == null) {
          result.error("INVALID_ARGUMENT", "Video path is required", null)
          return
        }
        if (count <= 0) {
          result.success(emptyList<String>())
          return
        }

        executor.execute {
          val retriever = MediaMetadataRetriever()
          try {
            retriever.setDataSource(videoPath)
            val durationMs =
              retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION)
                ?.toLongOrNull() ?: 0L
            val paths = mutableListOf<String>()
            for (i in 0 until count) {
              val timeMs = if (count == 1) 0L else durationMs * i / count
              extractFrame(retriever, timeMs.toInt(), width, height)?.let { paths.add(it) }
            }
            mainHandler.post { result.success(paths) }
          } catch (e: Exception) {
            mainHandler.post { result.error("THUMBNAIL_ERROR", e.message, null) }
          } finally {
            retriever.release()
          }
        }
      }
      else -> result.notImplemented()
    }
  }

  /** Runs on a background thread. Reuses [retriever] so callers can extract several frames
   * from the same video without re-parsing it each time. */
  private fun extractFrame(
    retriever: MediaMetadataRetriever,
    timeMs: Int,
    width: Int,
    height: Int,
  ): String? {
    val timeUs = timeMs * 1000L
    val bitmap: Bitmap? =
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
        // Decodes straight to the target size instead of full resolution then scaling.
        retriever.getScaledFrameAtTime(
          timeUs,
          MediaMetadataRetriever.OPTION_CLOSEST_SYNC,
          width,
          height,
        )
      } else {
        val frame =
          retriever.getFrameAtTime(timeUs, MediaMetadataRetriever.OPTION_CLOSEST_SYNC)
            ?: return null
        Bitmap.createScaledBitmap(frame, width, height, true)
      }
    if (bitmap == null) return null

    // Cache dir is OS-managed (cleared under storage pressure), unlike a raw temp file.
    val cacheDir = File(appContext.cacheDir, "v_thumbnail").apply { mkdirs() }
    val thumbnailFile = File(cacheDir, "thumb_${UUID.randomUUID()}.jpg")
    FileOutputStream(thumbnailFile).use { out ->
      bitmap.compress(Bitmap.CompressFormat.JPEG, 90, out)
    }
    return thumbnailFile.absolutePath
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    executor.shutdown()
  }
}
