// ignore_for_file: use_full_hex_values_for_flutter_colors, sized_box_for_whitespace, prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, file_names, unnecessary_import, unused_import, unused_local_variable, avoid_print, use_build_context_synchronously, empty_catches, unnecessary_null_comparison
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:mis_tracker/screen/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController idController = TextEditingController();
  TextEditingController passController = TextEditingController();
  double screenHeight = 0;
  double screenWidth = 0;

  Color primary = Color.fromARGB(255, 239, 48, 48);

  late SharedPreferences sharedPreferences;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance.collection('Employee_Credentials');

  @override
  void dispose() {
    idController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardVisible =
        KeyboardVisibilityProvider.isKeyboardVisible(context);
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          isKeyboardVisible
              ? SizedBox(height: screenHeight / 16,)
              : Container(
                  height: screenHeight / 2.5,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(70),
                    ),
                    color: primary,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: screenWidth / 5,
                    ),
                  ),
                ),

          Container(
            margin: EdgeInsets.only(
              top: screenHeight / 15,
              bottom: screenHeight / 20,
            ),
            child: Text(
              'Login',
              style: TextStyle(
                fontSize: screenWidth / 18,
                fontFamily: "NexaBold",
              ),
            ),
          ),

          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.symmetric(
              horizontal: screenWidth / 12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                fieldTitle('Username'),
                customField('Enter your Username', idController, false),
                fieldTitle('Password'),
                customField('Enter your Password', passController, true),
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      String id = idController.text.trim();
                      String pass = passController.text.trim();

                      if (id.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Username is still empty!")),
                        );
                      } else if (pass.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Password is still empty!")),
                        );
                      } else {
                        try {
                          QuerySnapshot snap = await _firestore.where('id', isEqualTo: id).get();

                          if (snap.docs.isEmpty) {
                            try {
                              print("Attempting to create user with email: $id");
                              UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: id, password: pass);
                              print("User created successfully in Firebase Auth");

                              try {
                                await _firestore.add({
                                  'id': id,
                                  'pass': pass,
                                });
                                print("User data added to Firestore successfully");

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Registration successful!")),
                                );

                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(employeeId: id,)));
                              } catch (firestoreError) {
                                print("Firestore error: $firestoreError");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Error saving user data: ${firestoreError.toString()}")),
                                );
                              }
                            } catch (e) {
                              print("Detailed error: $e");
                              if (e is FirebaseAuthException) {
                                print("Firebase Auth Error Code: ${e.code}");
                                print("Firebase Auth Error Message: ${e.message}");
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Registration failed: ${e.toString()}")),
                              );
                            }
                          } else {
                            if (pass == snap.docs[0]['pass']) {
                              sharedPreferences = await SharedPreferences.getInstance();
                              sharedPreferences.setString('employeeId', id).then((_) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => HomeScreen(employeeId: id,),
                                ));
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Incorrect password!")),
                              );
                            }
                          }
                        } catch (e) {
                          print("General error: $e");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("An error occurred: ${e.toString()}")),
                          );
                        }
                      }
                    },
                    child: Container(
                      height: 60,
                      margin: EdgeInsets.only(top: screenWidth / 40),
                      width: screenWidth / 2,
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: Center(
                        child: Text(
                          'LOGIN/REGISTER',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "NexaBold",
                            fontSize: screenWidth / 26,
                            letterSpacing: 2.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget fieldTitle(String title) {
    return Container(
      padding: EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: screenWidth / 26,
          fontFamily: "NexaBold",
        ),
      ),
    );
  }

  Widget customField(String hint, TextEditingController controller, bool obscure) {
    return Container(
      width: screenWidth,
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(2, 2),
            )
          ]),
      child: Row(
        children: [
          Container(
            width: screenWidth / 6,
            child: Icon(
              Icons.person,
              color: primary,
              size: screenWidth / 15,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: screenWidth / 12),
              child: TextFormField(
                controller: controller,
                keyboardType: TextInputType.emailAddress,
                obscureText: obscure,
                autocorrect: false,
                enableSuggestions: false,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: screenHeight / 35,
                  ),
                  border: InputBorder.none,
                  hintText: hint,
                ),
                maxLines: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}