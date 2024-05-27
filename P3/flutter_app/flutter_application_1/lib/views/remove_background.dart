import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_rembg/local_rembg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

enum ProcessStatus {
  loading,
  success,
  failure,
  none,
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Local Remove Background',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const RemoveBackground(title: 'Background Remover'),
    );
  }
}

class RemoveBackground extends StatefulWidget {
  const RemoveBackground({super.key, required this.title});

  final String title;

  @override
  State<RemoveBackground> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<RemoveBackground> {
  final ImagePicker picker = ImagePicker();
  ProcessStatus status = ProcessStatus.none;
  String? message;
  Uint8List? imageBytes;

  Future<void> _pickPhoto() async {
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        status = ProcessStatus.loading;
      });

      try {
        LocalRembgResultModel localRembgResultModel =
            await LocalRembg.removeBackground(
          imagePath: pickedFile.path,
        );

        if (localRembgResultModel.status == 1 && localRembgResultModel.imageBytes != null) {
          imageBytes = Uint8List.fromList(localRembgResultModel.imageBytes!);
          setState(() {
            status = ProcessStatus.success;
          });
        } else {
          message = localRembgResultModel.errorMessage ?? 'Failed to process image';
          setState(() {
            status = ProcessStatus.failure;
          });
        }
      } catch (e) {
        message = 'Exception: $e';
        setState(() {
          status = ProcessStatus.failure;
        });
      }
    }
  }

  Future<void> _saveImage() async {
    if (imageBytes == null) return;

    if (await Permission.storage.request().isGranted) {
      final directory = await getExternalStorageDirectory();
      if (directory != null) {
        final path = '${directory.path}/processed_image.png';
        final file = File(path);
        await file.writeAsBytes(imageBytes!);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image saved to $path')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Storage permission not granted')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (imageBytes != null && status == ProcessStatus.success)
              SizedBox(
                height: screenSize.width * 0.8,
                child: Image.memory(
                  imageBytes!,
                ),
              ),
            if (status == ProcessStatus.loading)
              const CupertinoActivityIndicator(
                color: Colors.black,
              ),
            if (status == ProcessStatus.failure)
              Text(
                message ?? 'Failed to process image',
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            if (status == ProcessStatus.none)
              const Text(
                'Select your image',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            const SizedBox(height: 20),
            if (imageBytes != null && status == ProcessStatus.success)
              ElevatedButton(
                onPressed: _saveImage,
                child: const Text('Save Image'),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickPhoto,
        child: const Icon(Icons.add_photo_alternate_outlined),
      ),
    );
  }
}
