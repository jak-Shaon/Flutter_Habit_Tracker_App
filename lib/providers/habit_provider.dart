
import 'package:flutter/material.dart';
import '../models/habit_model.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';

class HabitProvider with ChangeNotifier {
  final AppUser? user;
  final _service = FirestoreService();

  List<Habit> _habits = [];
  bool _loading = false;
  String _filterCategory = 'All';

  HabitProvider(this.user) {
    if (user != null) {
      _service.watchHabits(user!.uid).listen((list) {
        _habits = list;
        notifyListeners();
      });
    }
  }

  List<Habit> get habits {
    if (_filterCategory == 'All') return _habits;
    return _habits.where((h) => h.category == _filterCategory).toList();
  }

  bool get loading => _loading;
  String get filterCategory => _filterCategory;

  set filterCategory(String c) {
    _filterCategory = c;
    notifyListeners();
  }

  List<String> get categories => const ['All','Health','Study','Fitness','Productivity','Mental Health','Others'];

  Future<void> addHabit(Habit h) async {
    if (user == null) return;
    _loading = true; notifyListeners();
    await _service.createHabit(user!.uid, h);
    _loading = false; notifyListeners();
  }

  Future<void> updateHabit(Habit h) async {
    if (user == null) return;
    await _service.updateHabit(user!.uid, h);
  }

  Future<void> deleteHabit(String id) async {
    if (user == null) return;
    await _service.deleteHabit(user!.uid, id);
  }

  Future<void> toggleToday(Habit h) async {
    if (user == null) return;
    await _service.toggleCompletion(uid: user!.uid, habit: h, date: DateTime.now());
  }

  // For charts: last 7 days counts for a specific habit
  List<int> last7Days(Habit h) {
    final now = DateTime.now();
    List<int> data = [];
    for (int i = 6; i >= 0; i--) {
      final day = DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
      final done = h.completionHistory.any((d) => d.year == day.year && d.month == day.month && d.day == day.day);
      data.add(done ? 1 : 0);
    }
    return data;
  }
}
