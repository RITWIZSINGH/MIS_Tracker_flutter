import 'package:flutter/foundation.dart';
import 'dart:collection';
import 'package:shared_preferences/shared_preferences.dart';

class TargetData extends ChangeNotifier {
  final List<String> _targetNames = [
   
  ];

  UnmodifiableListView<String> get targetNames => UnmodifiableListView(_targetNames);

  void addTarget(String name) {
    _targetNames.add(name);
    notifyListeners(); // Notify listeners about the change
  }

 void saveTargetProgress(int index, double progress) async {
    // Implement your logic to save progress here
    // This could involve storing data in a local database, cloud storage, etc.
    // For example, using SharedPreferences for local storage:

    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setDouble('target_$index', progress);

    // ignore: avoid_print
    print('Target $index progress saved: $progress'); // Placeholder for now
    notifyListeners(); // Notify listeners about the change (optional)
  }
}
