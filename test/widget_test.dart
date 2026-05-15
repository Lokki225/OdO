import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:odo/app/app.dart';
import 'package:odo/core/services/shared_preferences_provider.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  Future<ProviderScope> buildApp(WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    return ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const OdoApp(),
    );
  }

  testWidgets('OdoApp renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(await buildApp(tester));
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('OdoApp applies OLED dark background', (WidgetTester tester) async {
    await tester.pumpWidget(await buildApp(tester));
    final MaterialApp app = tester.widget(find.byType(MaterialApp));
    expect(
      app.theme?.scaffoldBackgroundColor,
      equals(const Color(0xFF0D0D0F)),
    );
  });
}
