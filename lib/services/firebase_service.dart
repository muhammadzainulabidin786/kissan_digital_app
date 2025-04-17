import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Fixed synchronous access
  User? getCurrentUser() => _auth.currentUser;

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String district,
    required String role,
  }) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'name': name,
        'email': email,
        'phone': phone,
        'district': district,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    } catch (e) {
      throw FirebaseAuthException(
          code: 'operation-failed', message: 'Signup failed: ${e.toString()}');
    }
  }

  Future<String> uploadCottonImage(File image, String userId) async {
    try {
      final Reference storageRef = _storage.ref().child(
          'cotton_images/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg');

      await storageRef.putFile(image);
      return await storageRef.getDownloadURL();
    } catch (e) {
      throw Exception('Image upload failed: $e');
    }
  }

  Stream<DocumentSnapshot> getFarmerData(String uid) {
    return _firestore.collection('users').doc(uid).snapshots();
  }

  Stream<QuerySnapshot> getDistrictAggregations() {
    return _firestore
        .collection('district_aggregations')
        .orderBy('average_quality', descending: true)
        .snapshots();
  }
}
