// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, await_only_futures

import 'package:flutter/material.dart';
import 'package:mis_tracker/models/target_data.dart';
import 'package:provider/provider.dart';


class AddTargetScreen extends StatefulWidget {
  @override
  _AddTargetScreenState createState() => _AddTargetScreenState();
}

class _AddTargetScreenState extends State<AddTargetScreen> {
  late String newTargetName ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Target'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "Target Name",
              ),
              onChanged: (value) {
                newTargetName = value;
              }
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: ()  {
                if (newTargetName.isNotEmpty) {
                  // Access TargetData using Provider
                  final targetData = Provider.of<TargetData>(context, listen: false);
                  targetData.addTarget(newTargetName);
                   Navigator.pop(context); // Close the screen
                }
              },
              child: Text("Add Target"),
            ),
          ],
        ),
      ),
    );
  }
}