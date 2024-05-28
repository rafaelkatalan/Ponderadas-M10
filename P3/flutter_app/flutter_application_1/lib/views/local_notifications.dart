import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ImageListPage extends StatefulWidget {
  final int? userId;

  const ImageListPage({Key? key, required this.userId}) : super(key: key);

  @override
  _ImageListPageState createState() => _ImageListPageState();
}

class _ImageListPageState extends State<ImageListPage> {
  List<String> imageBase64List = [];

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  Future<void> _fetchImages() async {
    final response = await http.get(Uri.parse('http://localhost:8002/get_images/${widget.userId}'));

    if (response.statusCode == 200) {
      final List<String> data = List<String>.from(jsonDecode(response.body));
      if (data.isEmpty) {
        print('No images found');
        return;
      }
      print("Base64 images: $data"); // Debugging: Print base64 encoded images
      setState(() {
        imageBase64List = List<String>.from(data);
      });
    } else {
      // Handle error
      print('Failed to load images: ${response.reasonPhrase}');
    }
  }

  Uint8List? _decodeImage(String base64String) {
    try {
      return base64Decode(base64String);
    } catch (e) {
      print('Error decoding image: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Gallery'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Adjust the number of images per row as needed
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: imageBase64List.length,
        itemBuilder: (BuildContext context, int index) {
          final bytes = _decodeImage(imageBase64List[index]);
          if (bytes != null) {
            return Image.memory(
              bytes,
              fit: BoxFit.cover,
            );
          } else {
            return Container(
              child: Text('Error decoding image'),
            );
          }
        },
      ),
    );
  }
}
