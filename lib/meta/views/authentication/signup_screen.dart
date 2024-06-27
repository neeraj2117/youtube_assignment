import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:youtube/core/services/auth_service.dart';
import 'package:youtube/utilities/keys.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  File? _profileImage;
  final _picker = ImagePicker();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    email = TextEditingController();
    password = TextEditingController();
    username = TextEditingController();
    super.initState();
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<Uint8List> _fileToUint8List(File file) async {
    return await file.readAsBytes();
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    Uint8List profileImageBytes = await _fileToUint8List(_profileImage!);
    String res = await AuthService().signUpUser(
      email: email.text,
      password: password.text,
      username: username.text,
      file: profileImageBytes,
      context: context,
    );

    setState(() {
      _isLoading = false;
    });

    if (res == 'success') {
      showSnackBar('Signup successful!', context);
      await Future.delayed(Duration(seconds: 2));
      Navigator.of(context).pop(); // Navigate to login page
    } else {
      showSnackBar(res, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Create Account',
                  style: GoogleFonts.lobster(
                    textStyle: const TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white24,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : null,
                    child: _profileImage == null
                        ? const Icon(Icons.add_a_photo,
                            color: Colors.white, size: 50)
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField(Icons.person, 'Username', controller: username),
                const SizedBox(height: 20),
                _buildTextField(Icons.email, 'Email', controller: email),
                const SizedBox(height: 20),
                _buildTextField(Icons.lock, 'Password',
                    isPassword: true, controller: password),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Already have an account?',
                        style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Login',
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              fontSize: 16,
                              color: Colors.amber,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () async {
                    if (_profileImage != null) {
                      signUpUser();
                    } else {
                      showSnackBar("No profile image selected", context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Text('Signup'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(IconData icon, String hintText,
      {bool isPassword = false, required TextEditingController controller}) {
    return TextField(
      obscureText: isPassword,
      cursorColor: Colors.white,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Colors.white24,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
      ),
      controller: controller,
    );
  }
}

void showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}
