import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'v_thumbnail_method_channel.dart';

abstract class VThumbnailPlatform extends PlatformInterface {
  /// Constructs a VThumbnailPlatform.
  VThumbnailPlatform() : super(token: _token);

  static final Object _token = Object();

  static VThumbnailPlatform _instance = MethodChannelVThumbnail();

  /// The default instance of [VThumbnailPlatform] to use.
  ///
  /// Defaults to [MethodChannelVThumbnail].
  static VThumbnailPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [VThumbnailPlatform] when
  /// they register themselves.
  static set instance(VThumbnailPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
