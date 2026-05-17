import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:odo/core/constants/app_spacing.dart';
import 'package:odo/core/constants/app_typography.dart';
import 'package:odo/features/practice/domain/entities/skill_with_stats.dart';
import 'package:odo/features/practice/presentation/pages/first_launch_sheet.dart';
import 'package:odo/features/practice/presentation/practice_providers.dart';
import 'package:odo/features/practice/presentation/widgets/skill_card.dart';

class PracticePage extends ConsumerStatefulWidget {
  const PracticePage({super.key});

  @override
  ConsumerState<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends ConsumerState<PracticePage> {
  bool _hasShownFirstLaunch = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final async = ref.read(practiceNotifierProvider);
      async.whenData((stats) {
        if (stats.isEmpty && !_hasShownFirstLaunch) {
          _hasShownFirstLaunch = true;
          _showFirstLaunchSheet();
        }
      });
    });
  }

  void _showFirstLaunchSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const FirstLaunchSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statsAsync = ref.watch(practiceNotifierProvider);
    final colorScheme = Theme.of(context).colorScheme;

    ref.listen<AsyncValue<List<SkillWithStats>>>(
      practiceNotifierProvider,
      (_, next) {
        if (!_hasShownFirstLaunch &&
            next is AsyncData<List<SkillWithStats>> &&
            next.value.isEmpty) {
          _hasShownFirstLaunch = true;
          _showFirstLaunchSheet();
        }
      },
    );

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        title: Text(
          'Pratique',
          style: AppTypography.textTitle.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/home/practice/add-skill'),
        backgroundColor: colorScheme.primary,
        child: Icon(Icons.add, color: colorScheme.onPrimary),
      ),
      body: statsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: Text(
            'Erreur de chargement',
            style: AppTypography.textBody.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        data: (stats) {
          if (stats.isEmpty) {
            return _EmptyState(onAdd: _showFirstLaunchSheet);
          }
          return _SkillList(stats: stats);
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sp32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_awesome_outlined,
              size: 48,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppSpacing.sp16),
            Text(
              'Pas encore de compétences',
              style: AppTypography.textTitle.copyWith(
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sp8),
            Text(
              'Ajoute ta première compétence pour commencer.',
              style: AppTypography.textBodyMuted.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sp24),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('Ajouter une compétence'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkillList extends StatelessWidget {
  const _SkillList({required this.stats});

  final List<SkillWithStats> stats;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.sp16),
      itemCount: stats.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sp8),
      itemBuilder: (_, i) => SkillCard(stats: stats[i]),
    );
  }
}
