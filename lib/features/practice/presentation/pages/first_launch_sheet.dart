import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:odo/core/constants/app_spacing.dart';
import 'package:odo/core/constants/app_typography.dart';
import 'package:odo/features/practice/domain/entities/skill.dart';
import 'package:odo/features/practice/domain/usecases/skill_type_detector.dart';
import 'package:odo/features/practice/presentation/practice_providers.dart';

class FirstLaunchSheet extends ConsumerStatefulWidget {
  const FirstLaunchSheet({super.key});

  @override
  ConsumerState<FirstLaunchSheet> createState() => _FirstLaunchSheetState();
}

class _FirstLaunchSheetState extends ConsumerState<FirstLaunchSheet> {
  final _controller = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _controller.text.trim();
    if (name.isEmpty) return;

    setState(() => _isLoading = true);

    final type = SkillTypeDetector.detect(name);
    final skill = Skill(
      name: name,
      type: type,
      sessionssSinceLevelUpdate: 0,
      createdAt: DateTime.now().toUtc(),
      isArchived: false,
    );

    final repo = ref.read(practiceRepositoryProvider);
    final result = await repo.addSkill(skill);

    if (!mounted) return;

    result.when(
      success: (_) {
        Navigator.of(context).pop();
      },
      failure: (error) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

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
            'Quelle compétence travailles-tu en ce moment ?',
            style: AppTypography.textTitle.copyWith(
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.sp20),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (context, value, child) {
              return TextField(
                controller: _controller,
                autofocus: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
                style: AppTypography.textBody.copyWith(
                  color: colorScheme.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: 'ex : japonais, échecs, course à pied…',
                  hintStyle: AppTypography.textBody.copyWith(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                  ),
                  filled: true,
                  fillColor:
                      colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusMd),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sp16,
                    vertical: AppSpacing.sp16,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.sp20),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (context, value, child) {
              final canSubmit = value.text.trim().isNotEmpty && !_isLoading;
              return FilledButton(
                onPressed: canSubmit ? _submit : null,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Commencer'),
              );
            },
          ),
        ],
      ),
    );
  }
}
