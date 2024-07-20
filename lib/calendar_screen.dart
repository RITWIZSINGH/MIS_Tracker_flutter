// ignore_for_file: prefer_const_constructors, unnecessary_import, unused_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

String getcurrentDay() {
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd').format(now);
  return formattedDate;
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  
  DateTime today = DateTime.now();
  void _onDaySelected(DateTime day,DateTime focusedDay){
    setState(() {
      today = day;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 239, 48, 48),
        title: Text(
          'Calendar',
          style: TextStyle(
            fontFamily: "NexaBold",
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 40, 0, 10),
        child: TableCalendar(
          headerStyle: HeaderStyle(
            titleTextStyle: TextStyle(
              fontFamily: "NexaBold",
              fontSize: 18,
            ),
            formatButtonVisible: false,
            titleCentered: true,
          ),
          availableGestures: AvailableGestures.all,
          selectedDayPredicate: (day) => isSameDay(day, today),
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2050, 1, 1),
          focusedDay: DateTime.now(),
          onDaySelected: _onDaySelected,
        ),
      ),
    );
  }
}
