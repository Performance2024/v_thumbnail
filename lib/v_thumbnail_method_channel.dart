import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'v_thumbnail_platform_interface.dart';

class MethodChannelVThumbnail extends VThumbnailPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('v_thumbnail');
  @override
  Future<String?> generateThumbnail({
    required String videoPath,
    int width = 100,
    int height = 100,
    int timeMs = 0,
  }) async {
    try {
      final result =
          await methodChannel.invokeMethod<String>('generateThumbnail', {
        'videoPath': videoPath,
        'width': width,
        'height': height,
        'timeMs': timeMs,
      });
      return result;
    } on PlatformException catch (e) {
      debugPrint('Erreur lors de la génération de la miniature: ${e.message}');
      return null;
    }
  }

  @override
  Future<List<String>> generateMultipleThumbnails({
    required String videoPath,
    int width = 100,
    int height = 100,
    int numberOfThumbnails = 5,
  }) async {
    try {
      final result =
          await methodChannel.invokeMethod<List>('generateMultipleThumbnails', {
        'videoPath': videoPath,
        'width': width,
        'height': height,
        'numberOfThumbnails': numberOfThumbnails,
      });
      return result?.cast<String>() ?? [];
    } on PlatformException catch (e) {
      debugPrint('Erreur lors de la génération des miniatures: ${e.message}');
      return [];
    }
  }
}
