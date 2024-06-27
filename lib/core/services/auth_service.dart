import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:youtube/app/credentials/supabase_cred.dart';
import 'package:youtube/core/services/storage_service.dart';
import 'package:youtube/utilities/keys.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> signup({
    required String email,
    required String password,
  }) async {
    try {
      final response = await SupabaseCred.supabaseClient.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        // Handle successful sign-up
        print('User signed up: ${response.user!.email}');
      } else {
        // Handle unknown error
        print('Sign up failed: Unknown error');
      }
    } catch (e) {
      // Handle exceptions
      print('Sign up error: $e');
    }
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      final response =
          await SupabaseCred.supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        // Handle successful sign-up
        print('User logged in: ${response.user!.email}');
      } else {
        // Handle unknown error
        print('Log in failed: Unknown error');
      }
    } catch (e) {
      // Handle exceptions
      print('Log in error: $e');
    }
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required Uint8List file,
    required BuildContext context,
  }) async {
    String res = "some error occurred";

    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          file.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String photoUrl =
            await StorageService().uploadImageToStorage('profilePics', file);

        await _firestore.collection('users').doc(cred.user!.uid).set({
          'username': username,
          'uid': cred.user!.uid,
          'email': email,
          'profileImage': photoUrl,
        });

        res = "success";
      } else {
        res = "Please fill all fields";
      }
    } catch (e) {
      res = e.toString();
      showSnackBar(res, context);
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    String res = "Some error occurred";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
