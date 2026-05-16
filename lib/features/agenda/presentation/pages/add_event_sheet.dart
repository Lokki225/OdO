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
        const SnackBar(
          content: Text("L'heure de fin doit être après l'heure de début"),
        ),
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) context.pop();
          },
        ),
        title: Text(
          widget.prefillEvent != null ? 'Modifier' : 'Nouvel événement',
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: AppSpacing.sp24,
          right: AppSpacing.sp24,
          top: AppSpacing.sp16,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.sp24,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              const _SectionLabel(label: 'TITRE'),
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(
                  hintText: "Nom de l'événement",
                ),
                textCapitalization: TextCapitalization.sentences,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Le titre est requis' : null,
              ),
              const SizedBox(height: AppSpacing.sp20),

              const _SectionLabel(label: 'DURÉE'),
              Row(
                children: [
                  Expanded(
                    child: _TimeTile(
                      label: 'DÉBUT',
                      time: _startTime,
                      onTap: () => _pickTime(isStart: true),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sp12),
                  Expanded(
                    child: _TimeTile(
                      label: 'FIN',
                      time: _endTime,
                      onTap: () => _pickTime(isStart: false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sp20),

              const _SectionLabel(label: 'CATÉGORIE'),
              _CategoryChips(
                selected: _category,
                onChanged: (c) => setState(() => _category = c),
              ),
              const SizedBox(height: AppSpacing.sp20),

              const _SectionLabel(label: 'NOTE (OPTIONNEL)'),
              TextFormField(
                controller: _notesCtrl,
                decoration: const InputDecoration(
                  hintText: 'Ajouter une note...',
                ),
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: AppSpacing.sp32),

              FilledButton(
                onPressed: _save,
                child: const Text('Enregistrer'),
              ),
              const SizedBox(height: AppSpacing.sp12),
              TextButton(
                onPressed: () {
                  if (context.canPop()) context.pop();
                },
                child: const Text('Annuler'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sp8),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              letterSpacing: 0.8,
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
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    letterSpacing: 0.5,
                  ),
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

class _CategoryChips extends StatelessWidget {
  const _CategoryChips({required this.selected, required this.onChanged});

  final EventCategory selected;
  final void Function(EventCategory) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < EventCategory.values.length; i++)
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: i < EventCategory.values.length - 1 ? AppSpacing.sp8 : 0,
              ),
              child: _buildChip(EventCategory.values[i], context),
            ),
          ),
      ],
    );
  }

  Widget _buildChip(EventCategory cat, BuildContext context) {
    final isSelected = cat == selected;
    final catColor = _categoryColor(cat);
    return GestureDetector(
      onTap: () => onChanged(cat),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sp8,
          vertical: AppSpacing.sp12,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color:
              isSelected ? catColor.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(
            color: isSelected
                ? catColor
                : Theme.of(context).colorScheme.outline,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: catColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppSpacing.sp4),
            Text(
              _categoryLabel(cat),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: isSelected
                        ? catColor
                        : Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  static Color _categoryColor(EventCategory cat) => switch (cat) {
        EventCategory.personal => AppColors.colorCategoryPersonal,
        EventCategory.work => AppColors.colorCategoryWork,
        EventCategory.practice => AppColors.colorCategoryPractice,
      };

  static String _categoryLabel(EventCategory cat) => switch (cat) {
        EventCategory.personal => 'Personnel',
        EventCategory.work => 'Travail',
        EventCategory.practice => 'Pratique',
      };
}
