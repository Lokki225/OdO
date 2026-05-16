import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:odo/core/constants/app_colors.dart';
import 'package:odo/core/constants/app_spacing.dart';
import 'package:odo/features/agenda/domain/entities/event.dart';
import 'package:odo/features/agenda/presentation/agenda_providers.dart';

class AddEventSheet extends ConsumerStatefulWidget {
  const AddEventSheet({super.key, this.prefillEvent, this.prefillStartTime});

  final Event? prefillEvent;
  final DateTime? prefillStartTime;

  @override
  ConsumerState<AddEventSheet> createState() => _AddEventSheetState();
}

class _AddEventSheetState extends ConsumerState<AddEventSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _notesCtrl;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late EventCategory _category;

  @override
  void initState() {
    super.initState();
    final pre = widget.prefillEvent;
    _titleCtrl = TextEditingController(text: pre?.title ?? '');
    _notesCtrl = TextEditingController(text: pre?.notes ?? '');

    final now = DateTime.now();
    final preStart = pre?.startTime.toLocal() ??
        widget.prefillStartTime?.toLocal() ??
        now;
    final preEnd = pre?.endTime.toLocal() ??
        preStart.add(const Duration(hours: 1));

    _startTime = TimeOfDay(hour: preStart.hour, minute: preStart.minute);
    _endTime = TimeOfDay(hour: preEnd.hour, minute: preEnd.minute);
    _category = pre?.category ?? EventCategory.personal;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickTime({required bool isStart}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
      builder: (context, child) => Directionality(
        textDirection: TextDirection.ltr,
        child: child!,
      ),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _startTime = picked;
      } else {
        _endTime = picked;
      }
    });
  }

  bool _endAfterStart() {
    final s = _startTime.hour * 60 + _startTime.minute;
    final e = _endTime.hour * 60 + _endTime.minute;
    return e > s;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_endAfterStart()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End time must be after start time')),
      );
      return;
    }

    final now = DateTime.now();
    final base = DateTime(now.year, now.month, now.day);
    final startDt = base
        .add(Duration(hours: _startTime.hour, minutes: _startTime.minute))
        .toUtc();
    final endDt = base
        .add(Duration(hours: _endTime.hour, minutes: _endTime.minute))
        .toUtc();

    final notifier = ref.read(agendaNotifierProvider.notifier);

    if (widget.prefillEvent?.id != null) {
      final updated = widget.prefillEvent!.copyWith(
        title: _titleCtrl.text.trim(),
        startTime: startDt,
        endTime: endDt,
        category: _category,
        notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      );
      await notifier.updateEvent(updated);
    } else {
      final event = Event(
        title: _titleCtrl.text.trim(),
        startTime: startDt,
        endTime: endDt,
        category: _category,
        notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      );
      await notifier.addEvent(event);
    }

    if (mounted && context.canPop()) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.sp24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppSpacing.sp20),
                  decoration: BoxDecoration(
                    color: colorScheme.outline,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                ),
              ),

              Text(
                widget.prefillEvent != null ? 'Edit Event' : 'New Event',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.sp20),

              // Title
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: 'Title'),
                textCapitalization: TextCapitalization.sentences,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Title is required' : null,
              ),
              const SizedBox(height: AppSpacing.sp16),

              // Times
              Row(
                children: [
                  Expanded(
                    child: _TimeTile(
                      label: 'Start',
                      time: _startTime,
                      onTap: () => _pickTime(isStart: true),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sp12),
                  Expanded(
                    child: _TimeTile(
                      label: 'End',
                      time: _endTime,
                      onTap: () => _pickTime(isStart: false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sp16),

              // Category
              Text(
                'Category',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              _CategorySelector(
                selected: _category,
                onChanged: (c) => setState(() => _category = c),
              ),
              const SizedBox(height: AppSpacing.sp16),

              // Notes
              TextFormField(
                controller: _notesCtrl,
                decoration: const InputDecoration(labelText: 'Notes (optional)'),
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: AppSpacing.sp24),

              // Save button
              FilledButton(
                onPressed: _save,
                child: const Text('Save'),
              ),
              const SizedBox(height: AppSpacing.sp12),
              OutlinedButton(
                onPressed: () => context.pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimeTile extends StatelessWidget {
  const _TimeTile({
    required this.label,
    required this.time,
    required this.onTap,
  });

  final String label;
  final TimeOfDay time;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final formatted =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sp12,
          vertical: AppSpacing.sp12,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: Theme.of(context).colorScheme.outline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            Text(
              formatted,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class _CategorySelector extends StatelessWidget {
  const _CategorySelector({required this.selected, required this.onChanged});

  final EventCategory selected;
  final void Function(EventCategory) onChanged;

  @override
  Widget build(BuildContext context) {
    return RadioGroup<EventCategory>(
      groupValue: selected,
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
      child: Column(
        children: EventCategory.values.map((cat) {
          return RadioListTile<EventCategory>(
            value: cat,
            title: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.only(right: AppSpacing.sp8),
                  decoration: BoxDecoration(
                    color: _categoryColor(cat),
                    shape: BoxShape.circle,
                  ),
                ),
                Text(_categoryLabel(cat)),
              ],
            ),
            dense: true,
            contentPadding: EdgeInsets.zero,
          );
        }).toList(),
      ),
    );
  }

  static Color _categoryColor(EventCategory cat) => switch (cat) {
        EventCategory.personal => AppColors.colorCategoryPersonal,
        EventCategory.work => AppColors.colorCategoryWork,
        EventCategory.practice => AppColors.colorCategoryPractice,
      };

  static String _categoryLabel(EventCategory cat) => switch (cat) {
        EventCategory.personal => 'Personal',
        EventCategory.work => 'Work',
        EventCategory.practice => 'Practice',
      };
}
