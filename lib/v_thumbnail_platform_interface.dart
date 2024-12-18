import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'v_thumbnail_method_channel.dart';

abstract class VThumbnailPlatform extends PlatformInterface {
  VThumbnailPlatform() : super(token: _token);

  static final Object _token = Object();
  static VThumbnailPlatform _instance = MethodChannelVThumbnail();
  static VThumbnailPlatform get instance => _instance;

  static set instance(VThumbnailPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> generateThumbnail({
    required String videoPath,
    int width = 100,
    int height = 100,
    int timeMs = 0,
  }) {
    throw UnimplementedError('generateThumbnail() has not been implemented.');
  }

  Future<List<String>> generateMultipleThumbnails({
    required String videoPath,
    int width = 100,
    int height = 100,
    int numberOfThumbnails = 5,
  }) {
    throw UnimplementedError(
        'generateMultipleThumbnails() has not been implemented.');
  }
}
