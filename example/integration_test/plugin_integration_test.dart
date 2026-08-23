// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://flutter.dev/to/integration-testing

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:v_thumbnail/v_thumbnail.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('generateThumbnail on a missing file fails gracefully',
      (tester) async {
    final result = await VThumbnail.generateThumbnail(
      videoPath: '/no/such/video.mp4',
      width: 100,
      height: 100,
    );

    expect(result, isNull);
  });

  testWidgets(
      'generateMultipleThumbnails with numberOfThumbnails=0 returns an empty list',
      (tester) async {
    final results = await VThumbnail.generateMultipleThumbnails(
      videoPath: '/no/such/video.mp4',
      numberOfThumbnails: 0,
    );

    expect(results, isEmpty);
  });
}
