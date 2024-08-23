// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, duplicate_ignore, unused_import

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:mis_tracker/screen/home_screen.dart';
import 'package:mis_tracker/models/target_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "mis-tracker-85ebd" ,
    options: FirebaseOptions(
        apiKey: "AIzaSyDs3dMFKM-iIXYDutZ90gDiDzMNE7h0OdI",
        appId: "1:849335743106:web:3807e79a32ae360625ba9b",
        messagingSenderId: "849335743106",
        projectId: "mis-tracker-85ebd"),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: KeyboardVisibilityProvider(
        child: ChangeNotifierProvider(
          create: (BuildContext context) => TargetData(),
          // ignore: prefer_const_constructors
          child: MaterialApp(home: LandingScreen()),
        ),
      ),
    );
  }
}

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
 

  @override
  Widget build(BuildContext context) {
    return HomeScreen();
  }
}