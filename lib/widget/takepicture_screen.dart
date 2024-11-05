import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart'; // Import for path provider
import 'package:path/path.dart'; // Import for path joining
import 'dart:io'; // Import for File class
import 'displaypicture_screen.dart';

class TakepictureScreen extends StatefulWidget {
  const TakepictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakepictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();

            // Get the directory to save the image
            final directory = await getApplicationDocumentsDirectory();
            final captureDirectory =
                Directory('${directory.path}/CapturedImages');

            // Create the directory if it doesn't exist
            if (!await captureDirectory.exists()) {
              await captureDirectory.create(recursive: true);
              print('Created directory: ${captureDirectory.path}');
            } else {
              print('Directory already exists: ${captureDirectory.path}');
            }

            // Define the path to save the image
            final imagePath =
                '${captureDirectory.path}/${basename(image.path)}';

            // Save the image file to the specified directory
            final File savedImage = File(imagePath);
            await savedImage.writeAsBytes(await File(image.path).readAsBytes());
            print('Image saved at: $imagePath'); // Debug statement

            if (!mounted) return;

            // Navigate to the DisplayPictureScreen to show the captured image.
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    DisplaypictureScreen(imagePath: imagePath),
              ),
            );
          } catch (e) {
            print('Error: $e');
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
