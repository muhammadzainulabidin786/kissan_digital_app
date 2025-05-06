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

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool isLoading = false;
  String selectedProvince = 'Sindh';
  String? selectedDistrict;
  String? selectedRole;

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

  Future<void> _registerWithEmail() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      try {
        // 1. Create user with email/password
        final credential = await _auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text,
        );

        // 2. Send verification email
        await credential.user?.sendEmailVerification();

        // 3. Save user data (emailVerified will be false initially)
        await FirebaseFirestore.instance
            .collection('users')
            .doc(credential.user!.uid)
            .set({
              'uid': credential.user!.uid,
              'name': nameController.text.trim(),
              'email': emailController.text.trim(),
              'phone': phoneController.text.trim(),
              'address': addressController.text.trim(),
              'province': selectedProvince,
              'district': selectedDistrict,
              'role': selectedRole,
              'emailVerified': false,
              'createdAt': FieldValue.serverTimestamp(),
            });

        // Stop loading
        setState(() => isLoading = false);

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Signup successful! Please check your email to verify your account.',
            ),
          ),
        );

        // Navigate to the login screen after a short delay
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/login');
          }
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signup failed: ${e.toString()}')),
        );
        setState(() => isLoading = false); // Ensure loading stops on error
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
                _buildTextField(
                  'Phone Number',
                  phoneController,
                  keyboardType: TextInputType.phone,
                  hintText: '3001234567',
                  prefixText: '+92 ',
                  validator: (value) {
                    if (value!.isEmpty) return 'Phone number required';
                    final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
                    if (!RegExp(r'^0?3\d{9}$').hasMatch(cleaned)) {
                      return 'Invalid Pakistani number format';
                    }
                    return null;
                  },
                ),
                _buildEmailField(),
                _buildPasswordRow(),
                _buildAddressField(),
                const SizedBox(height: 15),
                _buildLocationRow(),
                const SizedBox(height: 20),

                // Signup Button
                ElevatedButton(
                  onPressed: isLoading ? null : _registerWithEmail,
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
                          : const Text(
                            'Signup',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  child: const Text(
                    'Already have an account? Login',
                    style: TextStyle(
                      color: Color(0xFF0ED23B),
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

  Widget _buildTextField(
    String hint,
    TextEditingController controller, {
    TextInputType? keyboardType,
    String? hintText,
    String? prefixText,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: _inputDecoration(
          hint,
        ).copyWith(hintText: hintText, prefixText: prefixText),
        validator:
            validator ??
            (value) => value!.isEmpty ? 'Please enter $hint' : null,
      ),
    );
  }

  Widget _buildEmailField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: _inputDecoration('Email'),
        validator: (value) {
          if (value!.isEmpty) return 'Email is required';
          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
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

/*
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

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool isLoading = false;
  String selectedProvince = 'Sindh';
  String? selectedDistrict;
  String? selectedRole;

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

  Future<void> _registerWithEmail() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      try {
        // 1. Create user with email/password
        final credential = await _auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text,
        );

        // 2. Send verification email
        await credential.user?.sendEmailVerification();

        // 3. Save user data (emailVerified will be false initially)
        await FirebaseFirestore.instance
            .collection('users')
            .doc(credential.user!.uid)
            .set({
              'uid': credential.user!.uid,
              'name': nameController.text.trim(),
              'email': emailController.text.trim(),
              'phone': phoneController.text.trim(),
              'address': addressController.text.trim(),
              'province': selectedProvince,
              'district': selectedDistrict,
              'role': selectedRole,
              'emailVerified': false,
              'createdAt': FieldValue.serverTimestamp(),
            });

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Signup successful! Please check your email to verify your account.',
            ),
          ),
        );

        // Optionally, navigate back to the login screen
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signup failed: ${e.toString()}')),
        );
      } finally {
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
                _buildTextField(
                  'Phone Number',
                  phoneController,
                  keyboardType: TextInputType.phone,
                  hintText: '3001234567',
                  prefixText: '+92 ',
                  validator: (value) {
                    if (value!.isEmpty) return 'Phone number required';
                    final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
                    if (!RegExp(r'^0?3\d{9}$').hasMatch(cleaned)) {
                      return 'Invalid Pakistani number format';
                    }
                    return null;
                  },
                ),
                _buildEmailField(),
                _buildPasswordRow(),
                _buildAddressField(),
                const SizedBox(height: 15),
                _buildLocationRow(),
                const SizedBox(height: 20),

                // Signup Button
                ElevatedButton(
                  onPressed: isLoading ? null : _registerWithEmail,
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
                          : const Text(
                            'Signup',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  child: const Text(
                    'Already have an account? Login',
                    style: TextStyle(
                      color: Color(0xFF0ED23B),
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

  Widget _buildTextField(
    String hint,
    TextEditingController controller, {
    TextInputType? keyboardType,
    String? hintText,
    String? prefixText,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: _inputDecoration(
          hint,
        ).copyWith(hintText: hintText, prefixText: prefixText),
        validator:
            validator ??
            (value) => value!.isEmpty ? 'Please enter $hint' : null,
      ),
    );
  }

  Widget _buildEmailField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: _inputDecoration('Email'),
        validator: (value) {
          if (value!.isEmpty) return 'Email is required';
          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
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
*/
