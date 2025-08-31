
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/habit_model.dart';
import '../../providers/habit_provider.dart';

class HabitFormScreen extends StatefulWidget {
  const HabitFormScreen({super.key});

  @override
  State<HabitFormScreen> createState() => _HabitFormScreenState();
}

class _HabitFormScreenState extends State<HabitFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _notes = TextEditingController();
  String _category = 'Health';
  String _frequency = 'Daily';
  DateTime? _startDate;

  @override
  void dispose() {
    _title.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(context: context, firstDate: DateTime(now.year-2), lastDate: DateTime(now.year+2), initialDate: now);
    if (picked != null) setState(() => _startDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final hp = context.watch<HabitProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Create Habit')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _title,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _category,
                items: const [
                  DropdownMenuItem(value: 'Health', child: Text('Health')),
                  DropdownMenuItem(value: 'Study', child: Text('Study')),
                  DropdownMenuItem(value: 'Fitness', child: Text('Fitness')),
                  DropdownMenuItem(value: 'Productivity', child: Text('Productivity')),
                  DropdownMenuItem(value: 'Mental Health', child: Text('Mental Health')),
                  DropdownMenuItem(value: 'Others', child: Text('Others')),
                ],
                onChanged: (v) => setState(() => _category = v ?? 'Health'),
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _frequency,
                items: const [
                  DropdownMenuItem(value: 'Daily', child: Text('Daily')),
                  DropdownMenuItem(value: 'Weekly', child: Text('Weekly')),
                ],
                onChanged: (v) => setState(() => _frequency = v ?? 'Daily'),
                decoration: const InputDecoration(labelText: 'Frequency'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: Text(_startDate == null ? 'Start Date: (optional)' : 'Start Date: ${_startDate!.toLocal()}'.split(' ')[0])),
                  TextButton.icon(onPressed: _pickDate, icon: const Icon(Icons.date_range), label: const Text('Pick')),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notes,
                decoration: const InputDecoration(labelText: 'Notes (optional)'),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;
                    final habit = Habit(
                      id: '',
                      title: _title.text.trim(),
                      category: _category,
                      frequency: _frequency,
                      createdAt: DateTime.now(),
                      completionHistory: const [],
                      streak: 0,
                      notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
                      startDate: _startDate,
                    );
                    await hp.addHabit(habit);
                    if (context.mounted) Navigator.pop(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14.0),
                    child: Text('Create'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
