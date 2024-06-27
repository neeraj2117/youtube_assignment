import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? email;
  String? username;
  String? profilePicUrl;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (snapshot.exists) {
        String? fetchedEmail = user.email;
        String? fetchedUsername = snapshot.data()?['username'];

        // Handle profile image URL retrieval
        dynamic profileImageField = snapshot.data()?['profileImage'];
        String? fetchedProfilePicUrl;
        if (profileImageField is String) {
          fetchedProfilePicUrl = profileImageField;
        } else {
          fetchedProfilePicUrl = null; // or set a default profile pic URL
        }

        setState(() {
          email = fetchedEmail;
          username = fetchedUsername ?? 'Username not available';
          profilePicUrl = fetchedProfilePicUrl;
        });
      } else {
        setState(() {
          email = user.email;
          username = 'Username not available';
          profilePicUrl = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 100,
                backgroundImage:
                    profilePicUrl != null ? NetworkImage(profilePicUrl!) : null,
                backgroundColor: Colors.grey[300],
                child: profilePicUrl == null
                    ? const Icon(
                        Icons.account_circle,
                        size: 100,
                        color: Colors.grey,
                      )
                    : null,
              ),
              const SizedBox(height: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    email ?? 'Loading...',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Username',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    username ?? 'Loading...',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 100),
              ElevatedButton(
                onPressed: () {
                  // Implement sign out logic here
                  // FirebaseAuth.instance.signOut();
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Colors.red,
                ),
                child: const Text(
                  'Sign Out',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
