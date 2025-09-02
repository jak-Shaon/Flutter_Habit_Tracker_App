
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/habit_model.dart';
import '../../providers/habit_provider.dart';
import '../../widgets/progress_chart.dart';

class HabitDetailScreen extends StatefulWidget {
  final Habit habit;
  const HabitDetailScreen({super.key, required this.habit});

  @override
  State<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends State<HabitDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final hp = context.watch<HabitProvider>();
    // Get the current habit from the provider to ensure we have the latest data
    final habit = hp.habits.firstWhere(
      (h) => h.id == widget.habit.id,
      orElse: () => widget.habit,
    );
    final data = hp.last7Days(habit);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Details'),
        actions: [
          IconButton(
            onPressed: () async {
              await hp.deleteHabit(habit.id);
              if (context.mounted) Navigator.pop(context);
            },
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(habit.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 6),
          Text("${habit.category} • ${habit.frequency}"),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Last 7 Days Progress'),
                  const SizedBox(height: 8),
                  ProgressChart(data: data),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          if ((habit.notes ?? '').isNotEmpty)
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(habit.notes!),
              ),
            ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () async {
              await hp.toggleToday(habit);
            },
            icon: const Icon(Icons.check_circle_outline),
            label: const Text("Mark today's completion"),
          ),
        ],
      ),
    );
  }
}
