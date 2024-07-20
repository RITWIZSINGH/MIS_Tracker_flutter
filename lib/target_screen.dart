// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, must_be_immutable, unused_element, avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mis_tracker/target_data.dart';
import 'package:mis_tracker/add_target_screen.dart';
import 'package:mis_tracker/calendar_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class TargetScreen extends StatefulWidget {

  @override
  State<TargetScreen> createState() => _TargetScreenState();
}

  class _TargetScreenState extends State<TargetScreen> {
  String currentDay = getcurrentDay();
  final _formKey = GlobalKey<FormState>();

  /// Controllers
  TextEditingController dateController = TextEditingController();
  TextEditingController employeeNameController = TextEditingController();
  TextEditingController targetNamesController = TextEditingController();
  TextEditingController progressController = TextEditingController();
  TextEditingController totalController = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      const String scriptURL =
          'https://script.google.com/macros/s/AKfycbyNGGiTDchb2LxuyF0ryMgrJhndIZa3wkMNlIikXiNCLnSjY78J/exec';

      String tempdate = currentDay;
      String tempemployeeName = employeeNameController.text;
      String temptargetNames = targetNamesController.text;
      String tempprogress = progressController.text;
      String temptotal = totalController.text;

      String queryString = "?date=$tempdate&employeeName=$tempemployeeName&targetNames=$temptargetNames&progress=$tempprogress&total=$temptotal";

      var finalURI = Uri.parse(scriptURL + queryString);
      var response = await http.get(finalURI);
      //print(finalURI);

      if (response.statusCode == 200) {
        var bodyR = convert.jsonDecode(response.body);
        print(bodyR);
      }
    }
  }


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
          'Target Tracker ($currentDay)',
          style: TextStyle(
            color: Colors.white,
            fontFamily: "NexaBold",
          ),
        ),
        backgroundColor: primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
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
              _submitForm();
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

void submitData() {

}
