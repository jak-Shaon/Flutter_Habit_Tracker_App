
class Habit {
  final String id;
  final String title;
  final String category; // Health, Study, Fitness, Productivity, Mental Health, Others
  final String frequency; // Daily or Weekly
  final DateTime createdAt;
  final List<DateTime> completionHistory; // ISO dates
  final int streak;
  final String? notes;
  final DateTime? startDate;

  Habit({
    required this.id,
    required this.title,
    required this.category,
    required this.frequency,
    required this.createdAt,
    required this.completionHistory,
    required this.streak,
    this.notes,
    this.startDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      'frequency': frequency,
      'createdAt': createdAt.toIso8601String(),
      'completionHistory': completionHistory.map((d) => d.toIso8601String()).toList(),
      'streak': streak,
      'notes': notes,
      'startDate': startDate?.toIso8601String(),
    };
  }

  static Habit fromMap(String id, Map<String, dynamic> data) {
    List<DateTime> history = [];
    final raw = data['completionHistory'];
    if (raw is List) {
      history = raw.map((e) => DateTime.parse(e.toString())).toList();
    }
    return Habit(
      id: id,
      title: data['title']?.toString() ?? '',
      category: data['category']?.toString() ?? 'Others',
      frequency: data['frequency']?.toString() ?? 'Daily',
      createdAt: DateTime.parse(data['createdAt'] ?? DateTime.now().toIso8601String()),
      completionHistory: history,
      streak: (data['streak'] as num?)?.toInt() ?? 0,
      notes: data['notes']?.toString(),
      startDate: data['startDate'] != null ? DateTime.parse(data['startDate']) : null,
    );
  }
}
