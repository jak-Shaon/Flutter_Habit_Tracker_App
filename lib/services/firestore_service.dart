
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/habit_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  FirestoreService() {
    // Enable offline persistence (usually on by default for Flutter web off).
    _db.settings = const Settings(persistenceEnabled: true);
  }

  CollectionReference<Map<String, dynamic>> habitsRef(String uid) =>
      _db.collection('users').doc(uid).collection('habits');

  Future<List<Habit>> fetchHabits(String uid) async {
    final q = await habitsRef(uid).orderBy('createdAt', descending: true).get();
    return q.docs.map((d) => Habit.fromMap(d.id, d.data())).toList();
    }

  Stream<List<Habit>> watchHabits(String uid) {
    return habitsRef(uid).orderBy('createdAt', descending: true).snapshots().map(
      (snap) => snap.docs.map((d) => Habit.fromMap(d.id, d.data())).toList(),
    );
  }

  Future<String> createHabit(String uid, Habit habit) async {
    final ref = await habitsRef(uid).add(habit.toMap());
    return ref.id;
  }

  Future<void> updateHabit(String uid, Habit habit) async {
    await habitsRef(uid).doc(habit.id).set(habit.toMap(), SetOptions(merge: true));
  }

  Future<void> deleteHabit(String uid, String habitId) async {
    await habitsRef(uid).doc(habitId).delete();
  }

  // Completion logic: allow only valid dates
  Future<Habit> toggleCompletion({
    required String uid,
    required Habit habit,
    required DateTime date,
  }) async {
    final isDaily = habit.frequency.toLowerCase() == 'daily';
    final isWeekly = habit.frequency.toLowerCase() == 'weekly';

    bool canMark = false;
    final now = DateTime.now();
    if (isDaily) {
      canMark = date.year == now.year && date.month == now.month && date.day == now.day;
    } else if (isWeekly) {
      // Same calendar week/year
      final weekStart = now.subtract(Duration(days: now.weekday % 7));
      final weekEnd = weekStart.add(const Duration(days: 6));
      canMark = date.isAfter(weekStart.subtract(const Duration(seconds: 1))) &&
          date.isBefore(weekEnd.add(const Duration(days: 1)));
    }

    if (!canMark) return habit;

    final newHistory = [...habit.completionHistory];
    final exists = newHistory.any((d) => d.year == date.year && d.month == date.month && d.day == date.day);
    if (exists) {
      // uncheck
      newHistory.removeWhere((d) => d.year == date.year && d.month == date.month && d.day == date.day);
    } else {
      newHistory.add(date);
    }

    // Recalculate streak (continuous last days/weeks)
    int streak = 0;
    if (isDaily) {
      DateTime cursor = DateTime(now.year, now.month, now.day);
      while (newHistory.any((d) => d.year == cursor.year && d.month == cursor.month && d.day == cursor.day)) {
        streak += 1;
        cursor = cursor.subtract(const Duration(days: 1));
      }
    } else if (isWeekly) {
      DateTime cursor = DateTime(now.year, now.month, now.day);
      // Jump week-by-week
      DateTime weekStart(DateTime dt) => dt.subtract(Duration(days: dt.weekday % 7));
      Set<String> doneWeeks = newHistory.map((d) {
        final ws = weekStart(d);
        return "${ws.year}-${ws.month}-${ws.day}";
      }).toSet();
      DateTime currentWeekStart = weekStart(cursor);
      while (doneWeeks.contains("${currentWeekStart.year}-${currentWeekStart.month}-${currentWeekStart.day}")) {
        streak += 1;
        currentWeekStart = currentWeekStart.subtract(const Duration(days: 7));
      }
    }

    final updated = Habit(
      id: habit.id,
      title: habit.title,
      category: habit.category,
      frequency: habit.frequency,
      createdAt: habit.createdAt,
      completionHistory: newHistory,
      streak: streak,
      notes: habit.notes,
      startDate: habit.startDate,
    );

    await updateHabit(uid, updated);
    return updated;
  }
}
