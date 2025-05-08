import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'ml_upload_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  User? _user;
  Map<String, dynamic> _userData = {};
  File? _profileImage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(_user?.uid).get();
      if (doc.exists) {
        setState(() {
          _userData = doc.data() as Map<String, dynamic>;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading user data: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateProfileImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _profileImage = File(pickedFile.path));

      try {
        Reference storageRef = _storage.ref().child(
          'profile_images/${_user?.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg',
        );

        await storageRef.putFile(_profileImage!);
        String downloadURL = await storageRef.getDownloadURL();

        await _firestore.collection('users').doc(_user?.uid).update({
          'profileUrl': downloadURL,
        });

        setState(() => _userData['profileUrl'] = downloadURL);
      } catch (e) {
        print("Error uploading image: $e");
      }
    }
  }

  Future<void> _updateQuantity(String newQuantity) async {
    try {
      await _firestore.collection('users').doc(_user?.uid).update({
        'quantity': newQuantity,
      });
      setState(() => _userData['quantity'] = newQuantity);
    } catch (e) {
      print("Error updating quantity: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      backgroundColor: const Color(0xFFCFFFDC), // Main background color
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.green.shade700, // AppBar background color
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            GestureDetector(
              onTap: _updateProfileImage,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey.shade200,
                child:
                    _profileImage != null || _userData['profileUrl'] != null
                        ? ClipOval(
                          child: Image(
                            image:
                                _profileImage != null
                                    ? FileImage(_profileImage!)
                                    : NetworkImage(_userData['profileUrl'])
                                        as ImageProvider,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        )
                        : Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.grey.shade600,
                        ),
              ),

              /*
               CircleAvatar(
                radius: 60,
                backgroundImage:
                    _profileImage != null
                        ? FileImage(_profileImage!)
                        : (_userData['profileUrl'] != null
                                ? NetworkImage(_userData['profileUrl'])
                                : const AssetImage(
                                  'assets/images/default_profile.png',
                                ))
                            as ImageProvider,
              ),
              */
            ),
            const SizedBox(height: 10),
            Text(
              _userData['name'] ?? 'Farmer',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              _userData['role'] ?? 'Role',
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            Text(
              '${_userData['district'] ?? 'District'}, ${_userData['province'] ?? 'Sindh'}',
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            Text(
              _userData['address'] ?? 'Address',
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMetricCard(
                    value: _userData['quantity']?.toString() ?? '0',
                    label: 'Quantity',
                  ),
                  _buildMetricCard(
                    value: '${_userData['quality']?.toString() ?? '0'}%',
                    label: 'Quality',
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MLUploadScreen(),
                        ),
                      ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Upload Quality',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _showAddQuantityDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Add Quantity',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
              child: Text(
                'Photos',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    _firestore
                        .collection('uploads')
                        .where('userId', isEqualTo: _user?.uid)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var doc = snapshot.data!.docs[index];
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(doc['imageUrl']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({required String value, required String label}) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.black54)),
      ],
    );
  }

  void _showAddQuantityDialog(BuildContext context) {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add Quantity'),
            content: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter quantity (kg)',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    _updateQuantity(controller.text);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }
}

/*
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'ml_upload_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  User? _user;
  Map<String, dynamic> _userData = {};
  File? _profileImage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(_user?.uid).get();
      if (doc.exists) {
        setState(() {
          _userData = doc.data() as Map<String, dynamic>;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading user data: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateProfileImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _profileImage = File(pickedFile.path));

      // Upload to Firebase Storage
      try {
        Reference storageRef = _storage.ref().child(
          'profile_images/${_user?.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg',
        );

        await storageRef.putFile(_profileImage!);
        String downloadURL = await storageRef.getDownloadURL();

        // Update Firestore
        await _firestore.collection('users').doc(_user?.uid).update({
          'profileUrl': downloadURL,
        });

        setState(() => _userData['profileUrl'] = downloadURL);
      } catch (e) {
        print("Error uploading image: $e");
      }
    }
  }

  Future<void> _updateQuantity(String newQuantity) async {
    try {
      await _firestore.collection('users').doc(_user?.uid).update({
        'quantity': newQuantity,
      });
      setState(() => _userData['quantity'] = newQuantity);
    } catch (e) {
      print("Error updating quantity: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
            children: [
              const Text('9:41', style: TextStyle(color: Colors.black)),
              const Spacer(),
              const Icon(Icons.signal_cellular_alt, color: Colors.black),
              const SizedBox(width: 5),
              const Icon(Icons.battery_full, color: Colors.black),
            ],
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(_userData['backgroundUrl'] ?? ''),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: _updateProfileImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage:
                        _profileImage != null
                            ? FileImage(_profileImage!)
                            : (_userData['profileUrl'] != null
                                    ? NetworkImage(_userData['profileUrl'])
                                    : const AssetImage(
                                      'assets/default_profile.png',
                                    ))
                                as ImageProvider,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _userData['name'] ?? 'Farmer',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  _userData['role'] ?? 'Role',
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
                Text(
                  '${_userData['district'] ?? 'District'}, ${_userData['province'] ?? 'Sindh'}',
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
                Text(
                  _userData['address'] ?? 'Address',
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMetricCard(
                        value: _userData['quantity']?.toString() ?? '0',
                        label: 'Quantity',
                      ),
                      _buildMetricCard(
                        value: '${_userData['quality']?.toString() ?? '0'}%',
                        label: 'Quality',
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MLUploadScreen(),
                            ),
                          ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Upload Quality',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _showAddQuantityDialog(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Add Quantity',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                  child: Text(
                    'Photos',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream:
                        _firestore
                            .collection('uploads')
                            .where('userId', isEqualTo: _user?.uid)
                            .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return const Center(child: CircularProgressIndicator());

                      return GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var doc = snapshot.data!.docs[index];
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(doc['imageUrl']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({required String value, required String label}) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.black54)),
      ],
    );
  }

  void _showAddQuantityDialog(BuildContext context) {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add Quantity'),
            content: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter quantity (kg)',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    _updateQuantity(controller.text);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }
}

*/
