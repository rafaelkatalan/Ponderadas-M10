import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

enum ProcessStatus {
  loading,
  success,
  failure,
  none,
}

class RemoveBackground extends StatefulWidget {
  const RemoveBackground({Key? key, required this.userId}) : super(key: key);
  final int? userId;

  @override
  State<RemoveBackground> createState() => _ImageToBase64State();
}

class _ImageToBase64State extends State<RemoveBackground> {
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
        final bytes = await pickedFile.readAsBytes();
        imageBytes = bytes;
        setState(() {
          status = ProcessStatus.success;
        });
      } catch (e) {
        message = 'Exception: $e';
        setState(() {
          status = ProcessStatus.failure;
        });
      }
    }
  }

  Future<void> _sendImageToServer() async {
    if (imageBytes == null) return;

    final base64Image = base64Encode(imageBytes!);
    print("Base64 Image: $base64Image"); // Debugging: Print base64 string

    final response = await http.post(
      Uri.parse('http://localhost:8002/upload_image'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'Image': base64Image, 'userId': widget.userId}),
    );

    print("Response status: ${response.statusCode}"); // Debugging: Print response status
    print("Response body: ${response.body}"); // Debugging: Print response body

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Success"),
            content: const Text("Image sent successfully!"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/local_notifications', arguments: {'userId':widget.userId}); // Go back to the previous page
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send image to server')),
      );
    }
  }

  Future<void> _saveImage() async {
    if (imageBytes == null) return;

    if (await Permission.storage.request().isGranted) {
      final directory = await getExternalStorageDirectory();
      if (directory != null) {
        final path = '${directory.path}/selected_image.png';
        final file = File(path);
        await file.writeAsBytes(imageBytes!);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image saved to $path')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Storage permission not granted')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          'Remove Background',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),)
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
              Column(
                children: [
                  ElevatedButton(
                    onPressed: _saveImage,
                    child: const Text('Save Image'),
                  ),
                  ElevatedButton(
                    onPressed: _sendImageToServer,
                    child: const Text('Send Image to Server'),
                  ),
                ],
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
