import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:grad_project/models/elevatedButton.dart';
import 'package:grad_project/models/textForm.dart';
import 'package:grad_project/screens/signinOptions/chooseFavTeam.dart';
import 'package:grad_project/screens/signinOptions/loginPage.dart';
import 'package:grad_project/widgets/imageInput.dart';

final firebase = FirebaseAuth.instance;

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  void _signup() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    String emailValue = email.text;
    String passwordValue = password.text;

    _formKey.currentState!.save();
    try {
      await firebase.createUserWithEmailAndPassword(
        email: emailValue,
        password: passwordValue,
      );
      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => ChooseFavTeam()));
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message ?? 'Authentication failed')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Signup'),
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
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(child: ImageInput()),
                        const SizedBox(height: 15),
                        Text(
                          'First Name',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 5),
                        CustomTextForm(
                          hintText: 'First Name',
                          myController: firstname,
                        ),
                        const SizedBox(height: 10),

                        Text(
                          'Last Name',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 5),
                        CustomTextForm(
                          hintText: 'Last Name',
                          myController: lastname,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Email',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 5),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            fillColor: Theme.of(context).colorScheme.primaryContainer,
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
                        const SizedBox(height: 10),
                        Text(
                          'Password',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                            fillColor: Theme.of(context).colorScheme.primaryContainer,
                            prefixIcon: Icon(Icons.key),
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
                        const SizedBox(height: 10),
                        Center(
                          child: CustomElevatedButton(
                            onPressed: _signup,
                            title: 'Signup',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                InkWell(
                  onTap: () {
                    Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (ctx) => LoginPage()));
                  },
                  child: Center(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: "Already Have An Account ? "),
                          TextSpan(
                            text: "Login",
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
