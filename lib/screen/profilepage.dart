import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _dobController = TextEditingController();
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Fetch current user information from Firestore
  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        setState(() {
          _nameController.text = doc['name'] ?? '';
          _emailController.text = user.email ?? '';  // Load email from FirebaseAuth
          _phoneController.text = doc['phone'] ?? ''; // Load phone from Firestore
          _addressController.text = doc['address'] ?? ''; // Load address from Firestore
          _dobController.text = doc['dob'] ?? ''; // Load date of birth from Firestore
        });
      }
    }
  }

  // Save updated user information to Firestore
  Future<void> _saveUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'name': _nameController.text,
        'phone': _phoneController.text,
        'address': _addressController.text,
        'dob': _dobController.text,
      });
      setState(() {
        isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          if (!isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  isEditing = true;
                });
              },
            ),
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveUserData,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Avatar
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Handle avatar change
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: FirebaseAuth.instance.currentUser?.photoURL != null
                        ? NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!)
                        : const AssetImage('assets/images/default_avatar.jpg') as ImageProvider,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
                enabled: isEditing,
              ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
                enabled: false, // Email should not be editable
              ),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
                enabled: isEditing,
              ),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
                enabled: isEditing,
              ),
              TextField(
                controller: _dobController,
                decoration: const InputDecoration(
                  labelText: 'Date of Birth',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
                enabled: isEditing,
              ),
              const SizedBox(height: 20),
              if (isEditing)
                ElevatedButton(
                  onPressed: _saveUserData,
                  child: const Text('Save'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}