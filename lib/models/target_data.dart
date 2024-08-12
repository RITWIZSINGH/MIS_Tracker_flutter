import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:collection';

class TargetData extends ChangeNotifier {
  final List<String> _targetNames = [];
  final Map<int, double> _targetProgress = {};

  UnmodifiableListView<String> get targetNames => UnmodifiableListView(_targetNames);

  void addTarget(String name) {
    _targetNames.add(name);
    notifyListeners();
  }

  double getTargetProgress(int index) {
    return _targetProgress[index] ?? 0.0; 
  }

  Future<void> saveTargetProgress(int index, double progress) async {
    _targetProgress[index] = progress;
    notifyListeners();

    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setDouble('target_$index', progress);
  }
}