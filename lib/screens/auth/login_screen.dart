import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _checkIfAlreadyLoggedIn();
  }

  Future<void> _checkIfAlreadyLoggedIn() async {
    final user = _auth.currentUser;
    if (user != null) {
      final uid = user.uid;
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final role = doc.data()?['role'];

      if (role == 'Farmer') {
        Navigator.pushReplacementNamed(context, '/farmerDashboard');
      } else if (role == 'Buyer') {
        Navigator.pushReplacementNamed(context, '/buyerDashboard');
      }
    }
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // Process phone number
        String phone = phoneController.text;
        if (phone.startsWith('0')) {
          phone = phone.substring(1); // Remove leading 0
        }
        final fakeEmail = '$phone@kissan.fake';

        // Authenticate with email/password
        await _auth.signInWithEmailAndPassword(
          email: fakeEmail,
          password: passwordController.text,
        );

        // Get user role
        final userDoc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(_auth.currentUser!.uid)
                .get();

        // Navigate to proper dashboard
        Navigator.pushReplacementNamed(
          context,
          userDoc['role'] == 'Farmer' ? '/farmerDashboard' : '/buyerDashboard',
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${e.toString()}')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCFFFDC),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Color(0xFF0ED23B)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Welcome back!',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                _buildPhoneField(),
                const SizedBox(height: 20),
                _buildPasswordField(),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Handle forgot password
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(color: Color(0xFF0ED23B), fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0ED23B),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child:
                      _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don’t have an account? ',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(50, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Signup',
                        style: TextStyle(
                          color: const Color(0xFF0ED23B),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: phoneController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        hintText: 'Enter Your Phone Number',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: (value) => value!.isEmpty ? 'Please enter phone number' : null,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        hintText: 'Enter Your Password',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility : Icons.visibility_off,
            color: Color(0xFF0ED23B),
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
      validator:
          (value) => value!.isEmpty ? 'Please enter your password' : null,
    );
  }
}
