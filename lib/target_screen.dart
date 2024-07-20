// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mis_tracker/target_data.dart';
import 'package:mis_tracker/add_target_screen.dart';

class TargetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final targetData = Provider.of<TargetData>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final primary = Color.fromARGB(255, 239, 48, 48);

    return Scaffold(
      appBar: AppBar(
        elevation: 20.0,
        shadowColor: Colors.black54,
        title: Text(
          'Target Tracker',
          style: TextStyle(
            color: Colors.white,
            fontFamily: "NexaBold",
          ),
        ),
        backgroundColor: primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: targetData.targetNames.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      targetData.targetNames[index],
                      style: TextStyle(
                        fontSize: screenWidth / 20,
                        fontFamily: "NexaBold",
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '${targetData.getTargetProgress(index) * 100}%',
                      style: TextStyle(
                        fontSize: screenWidth / 18,
                        fontFamily: "NexaBold",
                        color: primary,
                      ),
                    ),
                    Slider(
                      value: targetData.getTargetProgress(index),
                      min: 0,
                      max: 1,
                      divisions: 100,
                      activeColor: primary,
                      inactiveColor: Colors.grey,
                      onChanged: (value) {
                        targetData.saveTargetProgress(index, value);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'addTargetFab',
            onPressed: () async {
              final newTargetName = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddTargetScreen()),
              );
              if (newTargetName != null && newTargetName.isNotEmpty) {
                targetData.addTarget(newTargetName);
              }
            },
            backgroundColor: primary,
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'sendDataFab',
            onPressed: () {
              // Existing function for sending data (optional)
            },
            backgroundColor: primary,
            child: Icon(
              Icons.send,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
