import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_social_button/flutter_social_button.dart';

import 'package:grad_project/models/elevatedButton.dart';
import 'package:grad_project/screens/signinOptions/signupPage.dart';
import 'package:grad_project/widgets/tabs.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();

    void _login() async {
      String emailValue = email.text;
      String passwordValue = password.text;

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailValue,
          password: passwordValue,
        );
        Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => Tabs()));
      } on FirebaseAuthException catch (error) {
        if (error.code == 'user-not-found') {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.message ?? 'User not found.')),
          );
        } else if (error.code == 'wrong-password') {}
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message ?? 'Wrong password.')),
        );
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Login'),
      ),
      body: SafeArea(
        top: true,
        child: Stack(
          children: [
            Opacity(
              opacity: 0.3,
              child: Align(
                alignment: AlignmentDirectional(0, -1.98),
                child: Icon(
                  Icons.sports_soccer,
                  color: Color(0xFF363272),
                  size: 500,
                ),
              ),
            ),
            Column(
              children: [
                Image.asset(
                  'assets/images/logo1.png',
                  height: 159.5,
                  width: 112.7,
                ),
                Text(
                  'Sign Into your account',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Form(
                  key: _formKey,
                  child: Text(
                    'Email Address: ',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Example@gmail.com',
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 15,
                      ),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      prefixIcon: Icon(Icons.email),
                    ),
                    controller: email,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value)) {
                        return null;
                      }
                      return 'Please enter a valid email';
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Text('Password', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: '*********',
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 15,
                      ),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      prefixIcon: Icon(Icons.key),
                    ),
                    controller: password,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else if (RegExp(
                        r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$',
                      ).hasMatch(value)) {
                        return null;
                      }
                      return 'Please enter a valid Password';
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: AlignmentDirectional(0.84, 0.04),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {},
                    child: Text(
                      'Forgot your password?',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                CustomElevatedButton(title: 'Log In', onPressed: _login),
                const SizedBox(height: 10),
                Text(
                  '________________________ OR ________________________',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 10),

                Text(
                  'Log In with...',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: FlutterSocialButton(
                        onTap: () {},
                        buttonType: ButtonType.facebook,
                        mini: true,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FlutterSocialButton(
                        onTap: () {},
                        buttonType: ButtonType.google,
                        mini: true,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FlutterSocialButton(
                        onTap: () {},
                        buttonType: ButtonType.twitter,
                        mini: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SocialButton(
                  onTap: () {},
                  icon: Icon(Icons.apple),
                  buttonColor: Theme.of(context).colorScheme.secondary,
                  label: 'Sign in with apple',
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (ctx) => SignupPage()));
                  },
                  child: Center(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: "Don't Have An Account ? "),
                          TextSpan(
                            text: "Signup",
                            style: TextStyle(
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Opacity(
              opacity: 0.3,
              child: Align(
                alignment: AlignmentDirectional(10, 3),
                child: Icon(
                  Icons.sports_soccer,
                  color: Color(0xFF363272),
                  size: 500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
