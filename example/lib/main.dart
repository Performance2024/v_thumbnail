import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
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
      print("path ${_thumbnailPath}");
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
