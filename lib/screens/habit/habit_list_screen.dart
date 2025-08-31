import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/habit_provider.dart';
import '../../widgets/habit_card.dart';
import 'habit_form_screen.dart';
import 'habit_detail_screen.dart';

class HabitListScreen extends StatelessWidget {
  const HabitListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hp = context.watch<HabitProvider>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 300));
        },
        child: Column(
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: hp.filterCategory,
                      items: hp.categories
                          .map((c) => DropdownMenuItem(
                        value: c,
                        child: Text(c),
                      ))
                          .toList(),
                      onChanged: (v) => hp.filterCategory = v ?? 'All',
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.filter_alt),
                        labelText: 'Filter by category',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: hp.habits.isEmpty
                  ? const Center(
                child: Text(
                  'No habits found. Tap "New Habit" to add one!',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: hp.habits.length,
                itemBuilder: (context, i) {
                  final h = hp.habits[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: HabitCard(
                      habit: h,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => HabitDetailScreen(habit: h)),
                        );
                      },
                      onToggleToday: () => hp.toggleToday(h),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const HabitFormScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('New Habit'),
      ),
    );
  }
}
