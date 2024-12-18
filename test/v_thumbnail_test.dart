import 'package:flutter_test/flutter_test.dart';
import 'package:v_thumbnail/v_thumbnail.dart';
import 'package:v_thumbnail/v_thumbnail_platform_interface.dart';
import 'package:v_thumbnail/v_thumbnail_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockVThumbnailPlatform
    with MockPlatformInterfaceMixin
    implements VThumbnailPlatform {
  @override
  Future<List<String>> generateMultipleThumbnails(
      {required String videoPath,
      int width = 100,
      int height = 100,
      int numberOfThumbnails = 5}) {
    // TODO: implement generateMultipleThumbnails
    throw UnimplementedError();
  }

  @override
  Future<String?> generateThumbnail(
      {required String videoPath,
      int width = 100,
      int height = 100,
      int timeMs = 0}) {
    // TODO: implement generateThumbnail
    throw UnimplementedError();
  }
}

void main() {
  final VThumbnailPlatform initialPlatform = VThumbnailPlatform.instance;

  test('$MethodChannelVThumbnail is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelVThumbnail>());
  });
}
