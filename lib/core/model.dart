import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppModel extends ChangeNotifier {
  AppModel(this.preferences) {
    try {
      final saved =
          jsonDecode(preferences.getString('momotaro.v1') ?? '{}')
              as Map<String, dynamic>;
      water = saved['water'] as int? ?? 750;
      weight = (saved['weight'] as num?)?.toDouble() ?? 58;
      name = saved['name'] as String? ?? 'Grace Saraswati';
      avatar = saved['avatar'] as String? ?? '';
      completed = saved['completed'] as bool? ?? false;
      notificationEnabled = saved['notificationEnabled'] as bool? ?? false;
      sleepTime = saved['sleepTime'] as String? ?? '22:30';
      reminderDays = Set<int>.from(saved['reminderDays'] as List? ?? [4, 5, 6]);
      interests = Set<String>.from(
        saved['interests'] as List? ?? ['Sports', 'Running', 'Vegan'],
      );
      goals = Set<String>.from(
        saved['goals'] as List? ?? ['Weight loss', 'Better sleeping habit'],
      );
      bookmarks = Set<String>.from(saved['bookmarks'] as List? ?? []);
      posts = List<String>.from(saved['posts'] as List? ?? []);
      meals = List<String>.from(saved['meals'] as List? ?? []);
      weightHistory = List<double>.from(
        (saved['weightHistory'] as List? ?? [58, 58.4, 59.1]).map(
          (n) => (n as num).toDouble(),
        ),
      );
      vote = saved['vote'] as int?;
      joinedEvent = saved['joinedEvent'] as bool? ?? false;
      gender = saved['gender'] as String? ?? 'Male';
      fitness = saved['fitness'] as String? ?? 'Moderate Intensity';
    } on FormatException {
      /* Invalid saved JSON falls back to the sample profile. */
    }
  }

  final SharedPreferences preferences;
  int water = 750;
  double weight = 58;
  String name = 'Grace Saraswati', avatar = '', sleepTime = '22:30';
  String gender = 'Male', fitness = 'Moderate Intensity';
  bool completed = false, notificationEnabled = false, joinedEvent = false;
  Set<int> reminderDays = {4, 5, 6};
  Set<String> interests = {'Sports', 'Running', 'Vegan'},
      goals = {'Weight loss', 'Better sleeping habit'},
      bookmarks = {};
  List<String> posts = [], meals = [];
  List<double> weightHistory = [58, 58.4, 59.1];
  int? vote;
  Future<void> save() async {
    notifyListeners();
    await preferences.setString(
      'momotaro.v1',
      jsonEncode({
        'water': water,
        'weight': weight,
        'name': name,
        'avatar': avatar,
        'completed': completed,
        'notificationEnabled': notificationEnabled,
        'sleepTime': sleepTime,
        'reminderDays': reminderDays.toList(),
        'interests': interests.toList(),
        'goals': goals.toList(),
        'bookmarks': bookmarks.toList(),
        'posts': posts,
        'meals': meals,
        'weightHistory': weightHistory,
        'vote': vote,
        'joinedEvent': joinedEvent,
        'gender': gender,
        'fitness': fitness,
      }),
    );
  }

  Future<void> addWater(int amount) async {
    if (amount <= 0 || amount > 2000) return;
    water += amount;
    await save();
  }

  Future<bool> updateWeight(double value) async {
    if (!value.isFinite || value < 20 || value > 350) return false;
    weight = value;
    weightHistory.insert(0, value);
    if (weightHistory.length > 30) weightHistory.removeLast();
    await save();
    return true;
  }

  Future<void> toggleBookmark(String id) async {
    if (!bookmarks.add(id)) bookmarks.remove(id);
    await save();
  }

  int get calories => 500 + meals.length * 345;
}
