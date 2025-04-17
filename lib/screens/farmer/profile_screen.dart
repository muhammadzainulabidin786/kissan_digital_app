// lib/screens/farmer/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FarmerProfileScreen extends StatefulWidget {
  const FarmerProfileScreen({super.key});

  @override
  State<FarmerProfileScreen> createState() => _FarmerProfileScreenState();
}

class _FarmerProfileScreenState extends State<FarmerProfileScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;

  Future<void> fetchUserData() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      userData = doc.data();
      setState(() => isLoading = false);
    } catch (e) {
      debugPrint('Error fetching user data: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Farmer Profile')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userData == null
              ? const Center(child: Text('No data found.'))
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage(
                              'assets/images/profile.png'), // Use a local placeholder image
                        ),
                      ),
                      const SizedBox(height: 20),
                      profileField('Name', userData!['name']),
                      profileField('Phone', userData!['phone']),
                      profileField(
                          'Email', userData!['email'] ?? 'Not provided'),
                      profileField('Province', userData!['province']),
                      profileField('District', userData!['district']),
                      profileField('Role', userData!['role']),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // We will handle update later
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content:
                                  Text('Edit profile feature coming soon!'),
                            ));
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit Profile'),
                        ),
                      )
                    ],
                  ),
                ),
    );
  }

  Widget profileField(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text('$title: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
