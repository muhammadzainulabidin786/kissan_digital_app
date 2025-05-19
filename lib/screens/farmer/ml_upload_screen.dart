// 📁 lib/screens/farmer/ml_upload_screen.dart
// ✅ Purpose: Pick a crop image and show ML-based simulated result (Disease detection)
// 📁 ml_upload_screen.dart (updated)
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../services/ml_service.dart';
//import 'ml_service.dart';

class MLUploadScreen extends StatefulWidget {
  const MLUploadScreen({super.key});

  @override
  State<MLUploadScreen> createState() => _MLUploadScreenState();
}

class _MLUploadScreenState extends State<MLUploadScreen> {
  File? _image;
  Map<String, dynamic>? _analysisResult;
  bool _isLoading = false;
  final _picker = ImagePicker();
  final _mlService = MLService();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _analysisResult = null;
      });
    }
  }

  Future<void> _analyzeAndUpload() async {
    if (_image == null) return;

    setState(() => _isLoading = true);

    try {
      // 1. Analyze image with ML API
      final result = await _mlService.analyzeCottonQuality(_image!);

      // 2. Upload image to Firebase Storage
      final storageRef = _storage.ref().child(
        'cotton_quality/${_auth.currentUser!.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await storageRef.putFile(_image!);
      final imageUrl = await storageRef.getDownloadURL();

      // 3. Save results to Firestore
      await _firestore.collection('uploads').add({
        'userId': _auth.currentUser!.uid,
        'imageUrl': imageUrl,
        'quality': result['quality'],
        'qualityScore': result['quality_score'],
        'confidence': result['confidence'],
        'timestamp': FieldValue.serverTimestamp(),
      });

      // 4. Update user's quality data
      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        'quality': result['quality_score'],
      });

      setState(() {
        _analysisResult = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cotton Quality Analysis')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildImagePreview(),
            const SizedBox(height: 20),
            _buildImageSourceButtons(),
            const SizedBox(height: 20),
            _buildAnalyzeButton(),
            if (_analysisResult != null) _buildResultDisplay(),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child:
          _image != null
              ? Image.file(_image!, fit: BoxFit.cover)
              : const Center(child: Text('Select an image')),
    );
  }

  Widget _buildImageSourceButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.camera_alt),
          label: const Text('Camera'),
          onPressed: () => _pickImage(ImageSource.camera),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.photo_library),
          label: const Text('Gallery'),
          onPressed: () => _pickImage(ImageSource.gallery),
        ),
      ],
    );
  }

  Widget _buildAnalyzeButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _analyzeAndUpload,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        minimumSize: const Size(double.infinity, 50),
      ),
      child:
          _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                'Analyze Quality',
                style: TextStyle(color: Colors.white),
              ),
    );
  }

  Widget _buildResultDisplay() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Text(
            'Quality: ${_analysisResult!['quality']}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            'Score: ${_analysisResult!['quality_score']}/100',
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            'Confidence: ${_analysisResult!['confidence']}',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}



/*
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
              child:
                  isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                        'Analyze',
                        style: TextStyle(color: Colors.white),
                      ),
            ),
            const SizedBox(height: 20),
            if (_result != null)
              Text(
                _result!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
*/