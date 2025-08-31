import 'package:flutter/material.dart';
import '../models/habit_model.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;
  final VoidCallback onTap;
  final VoidCallback onToggleToday;

  const HabitCard({
    super.key,
    required this.habit,
    required this.onTap,
    required this.onToggleToday,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Check if today is completed
    final today = DateTime.now();
    final isCompletedToday = habit.completionHistory.any(
          (d) => d.year == today.year && d.month == today.month && d.day == today.day,
    );

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: isCompletedToday ? Colors.green : Colors.blueAccent,
                child: Text(
                  habit.category.isNotEmpty ? habit.category[0] : '?',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.title,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${habit.category} • ${habit.frequency} • Streak ${habit.streak}",
                      style: theme.textTheme.bodySmall,
                    ),
                    if ((habit.notes ?? '').isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(habit.notes!, style: theme.textTheme.bodySmall),
                    ],
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: habit.streak > 0 ? (habit.streak / 30).clamp(0, 1) : 0,
                      backgroundColor: Colors.grey[300],
                      color: Colors.blueAccent,
                      minHeight: 4,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                tooltip: isCompletedToday ? "Completed Today" : "Mark today's completion",
                onPressed: onToggleToday,
                icon: Icon(
                  isCompletedToday ? Icons.check_circle : Icons.check_circle_outline,
                  color: isCompletedToday ? Colors.green : Colors.grey,
                  size: 28,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
