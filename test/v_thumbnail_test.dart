import 'package:flutter_test/flutter_test.dart';
import 'package:v_thumbnail/v_thumbnail.dart';
import 'package:v_thumbnail/v_thumbnail_platform_interface.dart';
import 'package:v_thumbnail/v_thumbnail_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockVThumbnailPlatform
    with MockPlatformInterfaceMixin
    implements VThumbnailPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final VThumbnailPlatform initialPlatform = VThumbnailPlatform.instance;

  test('$MethodChannelVThumbnail is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelVThumbnail>());
  });

  test('getPlatformVersion', () async {
    VThumbnail vThumbnailPlugin = VThumbnail();
    MockVThumbnailPlatform fakePlatform = MockVThumbnailPlatform();
    VThumbnailPlatform.instance = fakePlatform;

    expect(await vThumbnailPlugin.getPlatformVersion(), '42');
  });
}
