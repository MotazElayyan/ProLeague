import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_social_button/flutter_social_button.dart';

import 'package:grad_project/models/customTextField.dart';
import 'package:grad_project/models/CustomButtons.dart';
import 'package:grad_project/screens/signinOptions/forgotPassword.dart';
import 'package:grad_project/screens/signinOptions/signupPage.dart';
import 'package:grad_project/widgets/tabs.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _showPassword = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx) => Tabs()),
        (route) => false,
      );
    } on FirebaseAuthException catch (error) {
      String message = 'An error occurred. Please try again.';
      if (error.code == 'user-not-found') {
        message = 'User not found.';
      } else if (error.code == 'wrong-password') {
        message = 'Wrong password.';
      }

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        title: const Text('Login'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Opacity(
              opacity: 0.3,
              child: Align(
                alignment: AlignmentDirectional(0, -1.98),
                child: Icon(
                  Icons.sports_soccer,
                  color: const Color(0xFF363272),
                  size: 500,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Image.asset(
                      'assets/images/logo1.png',
                      height: 159.5,
                      width: 112.7,
                    ),
                    Text(
                      'Sign Into your account',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 20),

                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          CustomTextField(
                            controller: emailController,
                            hintText: 'Example@gmail.com',
                            label: 'Email Address',
                            prefixIcon: Icons.email,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              ).hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          CustomTextField(
                            controller: passwordController,
                            hintText: '*********',
                            label: 'Password',
                            prefixIcon: Icons.key,
                            obscureText: !_showPassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _showPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (!RegExp(
                                r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$',
                              ).hasMatch(value)) {
                                return 'Please enter a valid password';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => ForgotPassword(),
                            ),
                          );
                        },
                        child: Text(
                          'Forgot your password?',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    CustomElevatedButton(title: 'Log In', onPressed: _login),

                    const SizedBox(height: 15),
                    Text(
                      '________________________ OR ________________________',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 10),
                    Text('Log In with...', style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SocialButtonItem(
                          buttonType: ButtonType.facebook,
                          onTap: () {},
                        ),
                        SocialButtonItem(
                          buttonType: ButtonType.google,
                          onTap: () {},
                        ),
                        SocialButtonItem(
                          buttonType: ButtonType.twitter,
                          onTap: () {},
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),
                    SocialButton(
                      onTap: () {},
                      icon: const Icon(Icons.apple),
                      buttonColor: theme.colorScheme.primaryContainer,
                      label: 'Sign in with Apple',
                    ),

                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (ctx) => SignupPage()),
                        );
                      },
                      child: Center(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(text: "Don't Have An Account? "),
                              TextSpan(
                                text: "Signup",
                                style: TextStyle(
                                  color: theme.colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
