// You have generated a new plugin project without specifying the `--platforms`
// flag. A plugin project with no platform support was generated. To add a
// platform, run `flutter create -t plugin --platforms <platforms> .` under the
// same directory. You can also find a detailed instruction on how to add
// platforms in the `pubspec.yaml` at
// https://flutter.dev/to/pubspec-plugin-platforms.

import 'v_thumbnail_platform_interface.dart';

class VThumbnail {

  static Future<String?> generateThumbnail({
    required String videoPath,
    int width = 100,
    int height = 100,
    int timeMs = 0,
  }) async {
    return await VThumbnailPlatform.instance.generateThumbnail(
      videoPath: videoPath,
      width: width,
      height: height,
      timeMs: timeMs,
    );
  }

  /// Génère plusieurs miniatures
  static Future<List<String>> generateMultipleThumbnails({
    required String videoPath,
    int width = 100,
    int height = 100,
    int numberOfThumbnails = 5,
  }) async {
    return await VThumbnailPlatform.instance.generateMultipleThumbnails(
      videoPath: videoPath,
      width: width,
      height: height,
      numberOfThumbnails: numberOfThumbnails,
    );
  }
}
