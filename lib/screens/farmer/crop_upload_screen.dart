// 📁 lib/screens/farmer/crop_upload_screen.dart
// ✅ Purpose: For farmers to upload crop info (crop name, quantity, price) to Firestore

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CropUploadScreen extends StatefulWidget {
  const CropUploadScreen({super.key});

  @override
  State<CropUploadScreen> createState() => _CropUploadScreenState();
}

class _CropUploadScreenState extends State<CropUploadScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController cropController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  bool isUploading = false;

  Future<void> _uploadCrop() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isUploading = true);

      try {
        final user = FirebaseAuth.instance.currentUser;
        final cropData = {
          'uid': user!.uid,
          'crop': cropController.text,
          'quantity': quantityController.text,
          'price': priceController.text,
          'timestamp': FieldValue.serverTimestamp(),
        };

        await FirebaseFirestore.instance.collection('crops').add(cropData);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Crop uploaded successfully!')),
        );

        cropController.clear();
        quantityController.clear();
        priceController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: $e')),
        );
      } finally {
        setState(() => isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sell Your Crop')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: cropController,
                decoration: const InputDecoration(labelText: 'Crop Name'),
                validator: (value) => value!.isEmpty ? 'Enter crop name' : null,
              ),
              TextFormField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: 'Quantity (e.g., kg)'),
                validator: (value) => value!.isEmpty ? 'Enter quantity' : null,
              ),
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Price per unit'),
                validator: (value) => value!.isEmpty ? 'Enter price' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isUploading ? null : _uploadCrop,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: isUploading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Upload',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
