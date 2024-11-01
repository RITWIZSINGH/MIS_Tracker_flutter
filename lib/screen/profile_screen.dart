// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'target_screen.dart';
import 'dart:io';
import 'package:flutter/foundation.dart'; // Import kIsWeb

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _employeeIdController = TextEditingController();

  void _navigateToTargetScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TargetScreen(
          employeeId: _employeeIdController.text,
          employeeName: _nameController.text,
        ),
      ),
    );
  }
  File? _imageFile;
  String? _storedImagePath;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final imagePath = pickedFile.path;
        if (await File(imagePath).exists()) {
          setState(() {
            _imageFile = File(imagePath);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Selected image does not exist.'),
          ));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to pick image: $e'),
      ));
    }
  }

  Future<void> _loadProfile() async {
    final String employeeId = _employeeIdController.text;

    if (employeeId.isEmpty) return;

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('profiles')
          .doc(employeeId)
          .get();

      if (snapshot.exists) {
        setState(() {
          _nameController.text = snapshot['name'];
          _employeeIdController.text = snapshot['employeeId'];
          _storedImagePath = snapshot['imagePath'];
          if (_storedImagePath != null && File(_storedImagePath!).existsSync()) {
            _imageFile = File(_storedImagePath!);
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to load profile: $e'),
      ));
    }
  }

  Future<void> _saveProfile() async {
    final String name = _nameController.text;
    final String employeeId = _employeeIdController.text;

    if (name.isNotEmpty && employeeId.isNotEmpty && _imageFile != null) {
      try {
        await FirebaseFirestore.instance
            .collection('profiles')
            .doc(employeeId)
            .set({
          'name': name,
          'employeeId': employeeId,
          'imagePath': _imageFile!.path,
        });

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Profile Saved'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 40.0,
                    backgroundImage: kIsWeb
                        ? NetworkImage(_imageFile!.path) // For web
                        : FileImage(_imageFile!) as ImageProvider, // For mobile
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Name: $name',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Employee ID: $employeeId',
                    style: TextStyle(
                        fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to save profile: $e'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please complete all fields and select an image.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SAVE YOUR PROFILE'),
        backgroundColor: Colors.red,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 90,
                  backgroundImage: _imageFile != null
                      ? (kIsWeb
                          ? NetworkImage(_imageFile!.path) // For web
                          : FileImage(_imageFile!)) // For mobile
                      : (_storedImagePath != null && File(_storedImagePath!).existsSync()
                          ? (kIsWeb
                              ? NetworkImage(_storedImagePath!)
                              : FileImage(File(_storedImagePath!)))
                          : null),
                  child: _imageFile == null && _storedImagePath == null
                      ? Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                      : null,
                ),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Name"),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: _employeeIdController,
                decoration: InputDecoration(labelText: "Employee ID"),
              ),
              SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: _saveProfile,
                child: Text('Save'),
              ),
              SizedBox(height: 30.0),
              ElevatedButton(
                onPressed: _navigateToTargetScreen,
                child: Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
