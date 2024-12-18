import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'v_thumbnail_platform_interface.dart';

/// An implementation of [VThumbnailPlatform] that uses method channels.
class MethodChannelVThumbnail extends VThumbnailPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('v_thumbnail');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
