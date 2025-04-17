import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool isLoading = false;
  bool otpSent = false;
  String selectedProvince = 'Sindh';
  String? selectedDistrict;
  String? selectedRole;
  String? _verificationId;

  final List<String> sindhDistricts = [
    'Badin',
    'Dadu',
    'Ghotki',
    'Hyderabad',
    'Jacobabad',
    'Jamshoro',
    'Karachi Central',
    'Kashmore',
    'Khairpur',
    'Larkana',
    'Matiari',
    'Mirpur Khas',
    'Nawabshah',
    'Naushahro Feroze',
    'Qambar Shahdadkot',
    'Sanghar',
    'Shaheed Benazirabad',
    'Shikarpur',
    'Sukkur',
    'Sujawal',
    'Tando Adam',
    'Tando Allahyar',
    'Tando Muhammad Khan',
    'Thatta',
    'Tharparkar',
    'Umerkot',
    'Keamari',
    'Karachi East',
    'Karachi West',
  ];

  final List<String> roles = ['Farmer', 'Buyer'];

  Future<void> _verifyPhoneNumber() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      try {
        await _auth.verifyPhoneNumber(
          phoneNumber: '+92${phoneController.text}',
          verificationCompleted: (PhoneAuthCredential credential) async {
            await _signInWithCredential(credential);
          },
          verificationFailed: (FirebaseAuthException e) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${e.message}')));
            setState(() => isLoading = false);
          },
          codeSent: (String verificationId, int? resendToken) {
            setState(() {
              _verificationId = verificationId;
              otpSent = true;
              isLoading = false;
            });
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _signInWithCredential(PhoneAuthCredential credential) async {
    try {
      // Verify OTP first
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      // Process phone number
      String phone = phoneController.text;
      if (phone.startsWith('0')) {
        phone = phone.substring(1); // Remove leading 0
      }

      // Create email/password account
      final fakeEmail = '$phone@kissan.fake';
      await _auth.createUserWithEmailAndPassword(
        email: fakeEmail,
        password: passwordController.text,
      );

      // Store user data
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
            'uid': userCredential.user!.uid,
            'phone': '+92$phone', // Store with country code
            'name': nameController.text,
            'email': emailController.text.isEmpty ? null : emailController.text,
            'address': addressController.text,
            'province': selectedProvince,
            'district': selectedDistrict,
            'role': selectedRole,
            'createdAt': FieldValue.serverTimestamp(),
          });

      // Redirect based on role
      Navigator.pushReplacementNamed(
        context,
        selectedRole == 'Farmer' ? '/farmerDashboard' : '/buyerDashboard',
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      try {
        final credential = PhoneAuthProvider.credential(
          verificationId: _verificationId!,
          smsCode: otpController.text,
        );

        await _signInWithCredential(credential);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
        setState(() => isLoading = false);
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
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF0ED23B),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Signup',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                _buildTextField('Full Name', nameController),
                _buildPhoneField(),
                _buildEmailField(),
                _buildPasswordRow(),
                _buildAddressField(),
                const SizedBox(height: 15),
                _buildLocationRow(),
                const SizedBox(height: 20),

                // OTP Input Field (Visible after sending OTP)
                if (otpSent)
                  TextFormField(
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration(
                      'Enter OTP',
                    ).copyWith(prefixIcon: const Icon(Icons.sms)),
                    validator: (value) {
                      if (value!.isEmpty) return 'Enter OTP';
                      if (value.length != 6) return 'Invalid OTP';
                      return null;
                    },
                  ),
                const SizedBox(height: 20),

                // Send OTP/Register Button
                ElevatedButton(
                  onPressed:
                      isLoading
                          ? null
                          : (otpSent ? _registerUser : _verifyPhoneNumber),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0ED23B),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child:
                      isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                            otpSent ? 'Complete Registration' : 'Send OTP',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  child: Text(
                    'Already have an account? Login',
                    style: TextStyle(
                      color: const Color(0xFF0ED23B),
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: _inputDecoration(hint),
        validator: (value) => value!.isEmpty ? 'Please enter $hint' : null,
      ),
    );
  }

  Widget _buildPhoneField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: phoneController,
        keyboardType: TextInputType.phone,
        decoration: _inputDecoration('Phone Number').copyWith(
          hintText: '3001234567',
          prefix: const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Text('+92 '),
          ),
        ),
        validator: (value) {
          if (value!.isEmpty) return 'Phone number required';
          final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
          if (!RegExp(r'^0?3\d{9}$').hasMatch(cleaned)) {
            return 'Invalid Pakistani number format';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildEmailField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: _inputDecoration('Email (optional)'),
        validator: (value) {
          if (value!.isNotEmpty &&
              !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
            return 'Invalid email format';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordRow() {
    return Row(
      children: [
        Expanded(
          child: _buildPasswordField(
            'Password',
            passwordController,
            _obscurePassword,
            () => setState(() => _obscurePassword = !_obscurePassword),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildPasswordField(
            'Confirm Password',
            confirmPasswordController,
            _obscureConfirmPassword,
            () => setState(
              () => _obscureConfirmPassword = !_obscureConfirmPassword,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(
    String hint,
    TextEditingController controller,
    bool obscure,
    VoidCallback onToggle,
  ) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      decoration: _inputDecoration(hint).copyWith(
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility : Icons.visibility_off),
          color: const Color(0xFF0ED23B),
          onPressed: onToggle,
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) return 'Please enter $hint';
        if (hint == 'Confirm Password' && value != passwordController.text) {
          return 'Passwords do not match';
        }
        if (value.length < 6) return 'Minimum 6 characters required';
        return null;
      },
    );
  }

  Widget _buildAddressField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: addressController,
        decoration: _inputDecoration('Address'),
        validator: (value) => value!.isEmpty ? 'Please enter address' : null,
      ),
    );
  }

  Widget _buildLocationRow() {
    return Row(
      children: [
        Expanded(
          child: _buildDropdown(
            'Province',
            ['Sindh'],
            selectedProvince,
            (value) {},
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildDropdown(
            'District',
            sindhDistricts,
            selectedDistrict,
            (value) => setState(() => selectedDistrict = value),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildDropdown(
            'Role',
            roles,
            selectedRole,
            (value) => setState(() => selectedRole = value),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(
    String hint,
    List<String> items,
    String? value,
    Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: _inputDecoration(hint),
      items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'Please select $hint' : null,
      isExpanded: true,
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
