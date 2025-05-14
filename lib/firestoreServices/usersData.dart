import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserSignupService {
  static Future<String?> signupUser({
    required String username,
    required String email,
    required String password,
    required File pickedImage,
  }) async {
    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      await userCredential.user!.sendEmailVerification();

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child('${userCredential.user!.uid}.jpg');
      await storageRef.putFile(pickedImage);

      final imageUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'username': username.trim(),
        'email': email.trim(),
        'image_url': imageUrl,
      });

      await userCredential.user!.updateDisplayName(username.trim());

      return null; // Success (no error message)
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        return 'This email address is already in use.';
      } else if (error.code == 'weak-password') {
        return 'The password is too weak.';
      } else if (error.code == 'invalid-email') {
        return 'The email address is invalid.';
      } else {
        return 'Authentication failed. Please try again.';
      }
    } catch (e) {
      print('Signup error: $e');
      return 'An unexpected error occurred. Please try again.';
    }
  }
}

class UserProfileService {
  static Future<Map<String, String?>> loadUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No authenticated user found.');
      return {'imageUrl': null, 'username': null};
    }

    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        return {
          'imageUrl': data?['image_url'],
          'username': data?['username'],
        };
      } else {
        print('User document not found for UID: ${user.uid}');
      }
    } catch (e) {
      print('Error loading user profile: $e');
    }

    return {'imageUrl': null, 'username': null};
  }
}
