import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:odo/core/constants/app_durations.dart';
import 'package:odo/core/constants/app_spacing.dart';
import 'package:odo/core/constants/app_typography.dart';
import 'package:odo/core/types/result.dart';
import 'package:odo/features/practice/presentation/practice_providers.dart';

class LogSessionSheet extends ConsumerStatefulWidget {
  const LogSessionSheet({super.key, required this.skillId});

  final int skillId;

  @override
  ConsumerState<LogSessionSheet> createState() => _LogSessionSheetState();
}

class _LogSessionSheetState extends ConsumerState<LogSessionSheet>
    with SingleTickerProviderStateMixin {
  static const _presets = [15, 25, 45, 60];

  int? _durationMinutes;
  bool _customSelected = false;
  final _customController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _startedAt = DateTime.now();
  bool _isSaving = false;
  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: AppDurations.durationSlow,
    );
    _customController.addListener(_onCustomChanged);
  }

  void _onCustomChanged() {
    final v = int.tryParse(_customController.text.trim());
    setState(() => _durationMinutes = (v != null && v > 0) ? v : null);
  }

  @override
  void dispose() {
    _animController.dispose();
    _customController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  bool get _canSave =>
      !_isSaving && _durationMinutes != null && _durationMinutes! > 0;

  Future<void> _save() async {
    final duration = _durationMinutes;
    if (duration == null || duration <= 0) return;
    setState(() => _isSaving = true);

    final result = await ref.read(practiceNotifierProvider.notifier).logSession(
          skillId: widget.skillId,
          durationMinutes: duration,
          startedAt: _startedAt,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        );

    if (!mounted) return;

    switch (result) {
      case Success<int>():
        await _animController.forward();
        if (mounted) Navigator.of(context).pop();
      case Failure<int>(:final error):
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message),
            behavior: SnackBarBehavior.floating,
          ),
        );
    }
  }

  Future<void> _editTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_startedAt),
    );
    if (picked != null && mounted) {
      setState(() {
        _startedAt = DateTime(
          _startedAt.year,
          _startedAt.month,
          _startedAt.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final skill = ref.watch(skillByIdProvider(widget.skillId));

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.sp24,
        AppSpacing.sp24,
        AppSpacing.sp24,
        AppSpacing.sp24 + bottomInset,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sp24),
          Text(
            skill?.name ?? '…',
            style: AppTypography.textTitle.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.sp20),
          Text(
            'Durée',
            style: AppTypography.textCaption.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sp8),
          Wrap(
            spacing: AppSpacing.sp8,
            runSpacing: AppSpacing.sp8,
            children: [
              ..._presets.map(
                (min) => ChoiceChip(
                  label: Text('$min min'),
                  selected: !_customSelected && _durationMinutes == min,
                  onSelected: (_) => setState(() {
                    _customSelected = false;
                    _durationMinutes = min;
                  }),
                ),
              ),
              ChoiceChip(
                label: const Text('Autre'),
                selected: _customSelected,
                onSelected: (_) => setState(() {
                  _customSelected = true;
                  _durationMinutes = null;
                }),
              ),
            ],
          ),
          if (_customSelected) ...[
            const SizedBox(height: AppSpacing.sp8),
            TextField(
              controller: _customController,
              autofocus: true,
              keyboardType: TextInputType.number,
              style: AppTypography.textBody.copyWith(
                color: colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: 'Durée en minutes',
                hintStyle: AppTypography.textBody.copyWith(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                ),
                suffixText: 'min',
                filled: true,
                fillColor:
                    colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sp16,
                  vertical: AppSpacing.sp12,
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.sp16),
          Text(
            'Heure de début',
            style: AppTypography.textCaption.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sp4),
          InkWell(
            onTap: _editTime,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sp16,
                vertical: AppSpacing.sp12,
              ),
              child: Row(
                children: [
                  Text(
                    TimeOfDay.fromDateTime(_startedAt).format(context),
                    style: AppTypography.textBody.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sp16),
          Text(
            'Notes (optionnel)',
            style: AppTypography.textCaption.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sp8),
          TextField(
            controller: _notesController,
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            style: AppTypography.textBody.copyWith(
              color: colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              hintText: "Comment ça s'est passé ?",
              hintStyle: AppTypography.textBody.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              ),
              filled: true,
              fillColor:
                  colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sp16,
                vertical: AppSpacing.sp12,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sp20),
          FilledButton(
            onPressed: _canSave ? _save : null,
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Enregistrer'),
          ),
        ],
      ),
    )
        .animate(controller: _animController)
        .fadeOut(duration: AppDurations.durationSlow)
        .scaleXY(end: 0.9, duration: AppDurations.durationSlow);
  }
}
