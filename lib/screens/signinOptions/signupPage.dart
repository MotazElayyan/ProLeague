import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:grad_project/models/elevatedButton.dart';
import 'package:grad_project/screens/signinOptions/loginPage.dart';
import 'package:grad_project/models/imageInput.dart';
import 'package:grad_project/screens/signinOptions/verifyEmailPage.dart';

final firebase = FirebaseAuth.instance;

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  File? _pickedImage;
  bool _isLoading = false;
  bool _showPassword1 = false;
  bool _showPassword2 = false;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  Future<void> _signup() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (!isValid || _pickedImage == null) {
      setState(() {
        _autovalidateMode = AutovalidateMode.onUserInteraction;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userCredential = await firebase.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      await userCredential.user!.sendEmailVerification();

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child('${userCredential.user!.uid}.jpg');

      await storageRef.putFile(_pickedImage!);
      final imageUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
            'username': username.text.trim(),
            'email': email.text.trim(),
            'image_url': imageUrl,
          });

      await userCredential.user!.updateDisplayName(username.text.trim());

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx) => const VerifyEmailPage()),
      );

    } on FirebaseAuthException catch (error) {
      String message = 'Authentication failed. Please try again.';
      if (error.code == 'email-already-in-use') {
        message = 'This email address is already in use.';
      } else if (error.code == 'weak-password') {
        message = 'The password is too weak.';
      } else if (error.code == 'invalid-email') {
        message = 'The email address is invalid.';
      }

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (error) {
      print('Signup error: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    username.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        title: const Text('Signup'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.3,
                child: Icon(
                  Icons.sports_soccer,
                  color: const Color(0xFF363272),
                  size: 500,
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  autovalidateMode: _autovalidateMode,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ImageInput(
                        onImagePick: (pickedImage) {
                          setState(() {
                            _pickedImage = pickedImage;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        controller: username,
                        hintText: 'Username',
                        label: 'Full Name',
                        prefixIcon: Icons.person_3_outlined,
                        validator: (value) {
                          if (value == null || value.trim().length < 4) {
                            return 'Please enter at least 4 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: email,
                        hintText: 'Example@gmail.com',
                        label: 'Email',
                        prefixIcon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          } else if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(value)) {
                            return 'Invalid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: password,
                        hintText: '********',
                        label: 'Password',
                        prefixIcon: Icons.lock,
                        obscureText: !_showPassword1,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPassword1
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _showPassword1 = !_showPassword1;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          } else if (!RegExp(
                            r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$',
                          ).hasMatch(value)) {
                            return 'Password must be at least 8 characters\nwith upper, lower case and a number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: confirmPassword,
                        hintText: '********',
                        label: 'Confirm Password',
                        prefixIcon: Icons.lock_outline,
                        obscureText: !_showPassword2,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPassword2
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _showPassword2 = !_showPassword2;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          } else if (value != password.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      if (_isLoading)
                        CircularProgressIndicator(
                          color: theme.colorScheme.secondary,
                        )
                      else
                        CustomElevatedButton(
                          title: 'Signup',
                          onPressed: _signup,
                        ),
                      const SizedBox(height: 16),
                      _buildLoginLink(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String label,
    required IconData prefixIcon,
    Widget? suffixIcon,
    required FormFieldValidator<String> validator,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 5),
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Theme.of(context).colorScheme.primaryContainer,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 2,
              horizontal: 15,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            prefixIcon: Icon(prefixIcon),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginLink() {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      },
      child: Text.rich(
        TextSpan(
          children: [
            const TextSpan(text: "Already have an account? "),
            TextSpan(
              text: "Login",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
