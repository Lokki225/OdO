import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:odo/core/constants/app_durations.dart';
import 'package:odo/features/agenda/domain/entities/event.dart';
import 'package:odo/features/agenda/presentation/pages/add_event_sheet.dart';
import 'package:odo/features/agenda/presentation/pages/agenda_page.dart';
import 'package:odo/features/agenda/presentation/pages/calendar_page.dart';
import 'package:odo/features/agenda/presentation/pages/event_detail_page.dart';
import 'package:odo/features/home/presentation/home_screen.dart';
import 'package:odo/features/home/presentation/placeholder_screen.dart';
import 'package:odo/features/home/presentation/scaffold_with_nav_bar.dart';
import 'package:odo/features/practice/presentation/pages/first_launch_sheet.dart';
import 'package:odo/features/practice/presentation/pages/log_session_sheet.dart';
import 'package:odo/features/practice/presentation/pages/practice_page.dart';

final routerProvider = Provider<GoRouter>((ref) => router);

final router = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/glance',
      builder: (_, __) => const PlaceholderScreen(title: 'Glance'),
    ),
    GoRoute(
      path: '/evening',
      builder: (_, __) => const PlaceholderScreen(title: 'Evening'),
    ),
    GoRoute(
      path: '/settings',
      builder: (_, __) => const PlaceholderScreen(title: 'Settings'),
      routes: [
        GoRoute(
          path: 'themes',
          builder: (_, __) => const PlaceholderScreen(title: 'Themes'),
        ),
      ],
    ),
    GoRoute(
      path: '/confirm-suggestion/:id',
      pageBuilder: (context, state) => _slideUpSheet(
        state,
        PlaceholderScreen(
            title: 'Confirm Suggestion ${state.pathParameters['id']}'),
      ),
    ),
    ShellRoute(
      builder: (context, state, child) => ScaffoldWithNavBar(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (_, __) => const HomeScreen(),
          routes: [
            GoRoute(
              path: 'agenda',
              builder: (_, __) => const AgendaPage(),
              routes: [
                GoRoute(
                  path: 'event/:id',
                  builder: (context, state) {
                    final id = int.parse(state.pathParameters['id']!);
                    return EventDetailPage(eventId: id);
                  },
                ),
                GoRoute(
                  path: 'calendar',
                  builder: (_, __) => const CalendarPage(),
                ),
                GoRoute(
                  path: 'add-event',
                  pageBuilder: (context, state) {
                    final extra = state.extra as Map<String, dynamic>?;
                    return _slideUpSheet(
                      state,
                      AddEventSheet(
                        prefillEvent: extra?['event'] as Event?,
                        prefillStartTime: extra?['startTime'] as DateTime?,
                      ),
                    );
                  },
                ),
              ],
            ),
            GoRoute(
              path: 'practice',
              builder: (_, __) => const PracticePage(),
              routes: [
                GoRoute(
                  path: 'skill/:id',
                  builder: (context, state) => PlaceholderScreen(
                    title: 'Skill ${state.pathParameters['id']}',
                  ),
                ),
                GoRoute(
                  path: 'add-skill',
                  pageBuilder: (context, state) => _slideUpSheet(
                    state,
                    const FirstLaunchSheet(),
                  ),
                ),
                GoRoute(
                  path: 'log-session/:id',
                  pageBuilder: (context, state) {
                    final id = int.parse(state.pathParameters['id']!);
                    return _slideUpSheet(
                      state,
                      LogSessionSheet(skillId: id),
                    );
                  },
                ),
              ],
            ),
            GoRoute(
              path: 'insights',
              builder: (_, __) =>
                  const PlaceholderScreen(title: 'Insights'),
            ),
            GoRoute(
              path: 'profile',
              builder: (_, __) =>
                  const PlaceholderScreen(title: 'Profile'),
            ),
          ],
        ),
      ],
    ),
  ],
);

CustomTransitionPage<void> _slideUpSheet(
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: AppDurations.durationDefault,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    ),
  );
}
