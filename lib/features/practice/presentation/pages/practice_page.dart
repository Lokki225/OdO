import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:odo/core/constants/app_spacing.dart';
import 'package:odo/core/constants/app_typography.dart';
import 'package:odo/features/practice/domain/entities/skill.dart';
import 'package:odo/features/practice/presentation/pages/first_launch_sheet.dart';
import 'package:odo/features/practice/presentation/practice_providers.dart';

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
      final async = ref.read(allSkillsProvider);
      async.whenData((skills) {
        if (skills.isEmpty && !_hasShownFirstLaunch) {
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
    final skillsAsync = ref.watch(allSkillsProvider);
    final colorScheme = Theme.of(context).colorScheme;

    ref.listen<AsyncValue<List<Skill>>>(allSkillsProvider, (_, next) {
      if (!_hasShownFirstLaunch &&
          next is AsyncData<List<Skill>> &&
          next.value.isEmpty) {
        _hasShownFirstLaunch = true;
        _showFirstLaunchSheet();
      }
    });

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
      body: skillsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: Text(
            'Erreur de chargement',
            style: AppTypography.textBody.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        data: (skills) {
          if (skills.isEmpty) {
            return _EmptyState(onAdd: _showFirstLaunchSheet);
          }
          return _SkillList(skills: skills);
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
  const _SkillList({required this.skills});

  final List<Skill> skills;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.sp16),
      itemCount: skills.length,
      separatorBuilder: (_, __) =>
          const SizedBox(height: AppSpacing.sp8),
      itemBuilder: (context, index) {
        final skill = skills[index];
        return Card(
          child: ListTile(
            title: Text(
              skill.name,
              style: AppTypography.textBody.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              skill.type.value,
              style: AppTypography.textCaption.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () =>
                context.push('/home/practice/skill/${skill.id}'),
          ),
        );
      },
    );
  }
}
