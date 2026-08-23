package com.performance2024.vthumbnail

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlin.test.Test
import org.mockito.ArgumentMatchers.anyString
import org.mockito.Mockito
import org.mockito.Mockito.timeout
import org.mockito.Mockito.verify

internal class VThumbnailPluginTest {
  @Test
  fun onMethodCall_generateThumbnail_missingVideoPath_returnsError() {
    val plugin = VThumbnailPlugin()

    val call = MethodCall("generateThumbnail", emptyMap<String, Any>())
    val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
    plugin.onMethodCall(call, mockResult)

    verify(mockResult).error("INVALID_ARGUMENT", "Video path is required", null)
  }

  @Test
  fun onMethodCall_generateMultipleThumbnails_zeroCount_returnsEmptyList() {
    val plugin = VThumbnailPlugin()

    val call =
      MethodCall(
        "generateMultipleThumbnails",
        mapOf("videoPath" to "/tmp/video.mp4", "numberOfThumbnails" to 0),
      )
    val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
    plugin.onMethodCall(call, mockResult)

    verify(mockResult).success(emptyList<String>())
  }

  @Test
  fun onMethodCall_unknownMethod_notImplemented() {
    val plugin = VThumbnailPlugin()

    val call = MethodCall("someUnknownMethod", null)
    val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
    plugin.onMethodCall(call, mockResult)

    verify(mockResult).notImplemented()
  }
}
