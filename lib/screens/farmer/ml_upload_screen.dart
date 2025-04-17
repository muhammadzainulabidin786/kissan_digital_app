// 📁 lib/screens/farmer/ml_upload_screen.dart
// ✅ Purpose: Pick a crop image and show ML-based simulated result (Disease detection)

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MLUploadScreen extends StatefulWidget {
  const MLUploadScreen({super.key});

  @override
  State<MLUploadScreen> createState() => _MLUploadScreenState();
}

class _MLUploadScreenState extends State<MLUploadScreen> {
  File? _image;
  String? _result;
  bool isLoading = false;

  final picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _result = null;
      });
    }
  }

  Future<void> analyzeImage() async {
    if (_image == null) return;

    setState(() {
      isLoading = true;
    });

    // 🔮 Simulated ML result (to be replaced with Firebase ML)
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _result = "Healthy Cotton 🌱";
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cotton Disease Detector')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (_image != null)
              Image.file(_image!, height: 200)
            else
              const Placeholder(fallbackHeight: 200),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () => pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                ),
                ElevatedButton.icon(
                  onPressed: () => pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Gallery'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: analyzeImage,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.green,
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Analyze',
                      style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            if (_result != null)
              Text(
                _result!,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
