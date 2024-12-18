# v_thumbnail Flutter Plugin

`v_thumbnail` is a Flutter plugin that allows you to generate video thumbnails from videos on Android and iOS devices. This plugin provides easy methods to generate single or multiple thumbnails from videos, making it ideal for applications that need to display video previews.

## Features

- Pick a video from the gallery.
- Generate a thumbnail from a video file.
- Support for multiple thumbnails generation.
- Cross-platform support (Android & iOS).

## Installation

To use `v_thumbnail` in your Flutter project, add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  v_thumbnail: ^0.0.1
Then, run the following command in your terminal:

bash
Copy code
flutter pub get
Usage
Here's how you can use the v_thumbnail plugin in your Flutter app:

Example Code:
dart
Copy code
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:v_thumbnail/v_thumbnail.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _thumbnailPath;
  String? _videoPath;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _pickVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      setState(() {
        _videoPath = video.path;
        _thumbnailPath = null;
      });
    }
  }

  Future<void> _generateThumbnail() async {
    if (_videoPath == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final thumbnail = await VThumbnail.generateThumbnail(
        videoPath: _videoPath!,
        width: 300,
        height: 300,
        timeMs: 0, // Prend la première frame
      );
      setState(() {
        _thumbnailPath = thumbnail;
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Test Plugin Miniature Vidéo'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_videoPath != null) ...[
                const Text('Vidéo sélectionnée:'),
                Text(_videoPath!, style: const TextStyle(fontSize: 12)),
                const SizedBox(height: 20),
              ],
              if (_thumbnailPath != null) ...[
                const Text('Miniature générée:'),
                Image.file(
                  File(_thumbnailPath!),
                  width: 300,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ],
              const SizedBox(height: 20),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: _pickVideo,
                      child: const Text('Sélectionner une video'),
                    ),
                    if (_videoPath != null)
                      ElevatedButton(
                        onPressed: _generateThumbnail,
                        child: const Text('Générer la miniature'),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
How It Works
Select a Video: The user picks a video from their gallery using the ImagePicker package.
Generate a Thumbnail: The VThumbnail.generateThumbnail() method is called to generate a thumbnail from the selected video. You can customize the size and the frame (in milliseconds) from which the thumbnail is generated.
Display Thumbnail: Once the thumbnail is generated, it is displayed on the screen.
Methods
VThumbnail.generateThumbnail()
Generates a thumbnail from a video file.

dart
Copy code
static Future<String?> generateThumbnail({
  required String videoPath,
  int width = 100,
  int height = 100,
  int timeMs = 0,
});
videoPath: Path to the video file.
width: Width of the thumbnail.
height: Height of the thumbnail.
timeMs: The time (in milliseconds) from the video at which the thumbnail will be generated (default is 0, which generates from the first frame).
VThumbnail.generateMultipleThumbnails()
Generates multiple thumbnails from a video file.

dart
Copy code
static Future<List<String>> generateMultipleThumbnails({
  required String videoPath,
  int width = 100,
  int height = 100,
  int numberOfThumbnails = 5,
});
videoPath: Path to the video file.
width: Width of the thumbnail.
height: Height of the thumbnail.
numberOfThumbnails: The number of thumbnails to generate.
Platforms Supported
Android
iOS
Troubleshooting
Make sure you have the correct permissions in AndroidManifest.xml (for Android) and Info.plist (for iOS) to access the gallery and files.
Ensure that the video path you provide is correct and accessible.
Contributing
If you'd like to contribute to the development of this plugin, please fork the repository and submit a pull request with your proposed changes. Make sure to write tests for any new functionality.

License
This plugin is licensed under the MIT License. See the LICENSE file for more details.