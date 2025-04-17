import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FarmerDashboardScreen extends StatefulWidget {
  const FarmerDashboardScreen({super.key});

  @override
  State<FarmerDashboardScreen> createState() => _FarmerDashboardScreenState();
}

class _FarmerDashboardScreenState extends State<FarmerDashboardScreen> {
  final _auth = FirebaseAuth.instance;
  String userName = '';
  String userEmail = '';
  String userPhone = '';
  String userDistrict = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final uid = _auth.currentUser!.uid;
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = doc.data()!;

    setState(() {
      userName = data['name'] ?? 'Farmer';
      userEmail = data['email'] ?? '';
      userPhone = data['phone'] ?? '';
      userDistrict = data['district'] ?? '';
      isLoading = false;
    });
  }

  Future<void> _logout() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmer Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, $userName 👨‍🌾',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildProfileCard(),
                    const SizedBox(height: 30),
                    const Text(
                      'Your Options:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      leading: const Icon(Icons.upload),
                      title: const Text('Upload Crops'),
                      onTap: () {
                        Navigator.pushNamed(context, '/upload');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('View Profile'),
                      onTap: () {
                        Navigator.pushNamed(context, '/farmerProfile');
                      },
                    ),
                    // Add more dashboard options here
                  ],
                ),
              ),
    );
  }

  Widget _buildProfileCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profile Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildProfileItem('Email', userEmail),
            _buildProfileItem('Phone', userPhone),
            _buildProfileItem('District', userDistrict),
            // Add more profile information here
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value),
        ],
      ),
    );
  }
}






/*
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FarmerDashboardScreen extends StatefulWidget {
  const FarmerDashboardScreen({super.key});

  @override
  State<FarmerDashboardScreen> createState() => _FarmerDashboardScreenState();
}

class _FarmerDashboardScreenState extends State<FarmerDashboardScreen> {
  final _auth = FirebaseAuth.instance;
  String userName = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final uid = _auth.currentUser!.uid;
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    setState(() {
      userName = doc.data()?['name'] ?? 'Farmer';
      isLoading = false;
    });
  }

  Future<void> _logout() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmer Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome, $userName 👨‍🌾',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),
                  const Text(
                    'Your Options:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    leading: const Icon(Icons.upload),
                    title: const Text('Upload Crops'),
                    onTap: () {
                      Navigator.pushNamed(context, '/upload');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('View Profile'),
                    onTap: () {
                      Navigator.pushNamed(context, '/farmerProfile');
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
*/