// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:ironbook/core/constants/app_colors.dart';
import 'package:ironbook/core/constants/app_routes.dart';
import 'package:ironbook/core/constants/app_strings.dart';
import 'package:ironbook/core/providers/auth_provider.dart';
import 'package:ironbook/main.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('named routes open their corresponding screens', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AuthProvider(),
        child: const IronbookApp(),
      ),
    );
    expect(find.text(AppStrings.roleSelection), findsOneWidget);
    expect(
      Theme.of(tester.element(find.text(AppStrings.roleSelection)))
          .scaffoldBackgroundColor,
      AppColors.background,
    );

    final destinations = <(String, String)>[
      (AppRoutes.auth, AppStrings.auth),
      // (AppRoutes.ownerHome, AppStrings.ownerGymName),
      (AppRoutes.subscriptionPlans, AppStrings.subscriptionPlans),
      (AppRoutes.joinGym, AppStrings.joinGym),
      (AppRoutes.memberHome, AppStrings.memberHome),
      (AppRoutes.chat, AppStrings.chat),
    ];

    for (final (route, title) in destinations) {
      tester.state<NavigatorState>(find.byType(Navigator)).pushNamed(route);
      await tester.pumpAndSettle();
      expect(find.text(title), findsOneWidget);
    }
  });

  testWidgets('owner registration shows gym name and operating hours', (
    WidgetTester tester,
  ) async {
    final authProvider = AuthProvider()..setUserGymMode = UserGymMode.owner;

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: authProvider,
        child: const IronbookApp(),
      ),
    );
    tester
        .state<NavigatorState>(find.byType(Navigator))
        .pushNamed(AppRoutes.auth);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();

    expect(find.text('Gym name'), findsOneWidget);
    expect(find.text('From'), findsOneWidget);
    expect(find.text('To'), findsOneWidget);
  });

  testWidgets('member registration omits owner gym setup fields', (
    WidgetTester tester,
  ) async {
    final authProvider = AuthProvider()..setUserGymMode = UserGymMode.member;

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: authProvider,
        child: const IronbookApp(),
      ),
    );
    tester
        .state<NavigatorState>(find.byType(Navigator))
        .pushNamed(AppRoutes.auth);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle();

    expect(find.text('Gym name'), findsNothing);
    expect(find.text('From'), findsNothing);
    expect(find.text('To'), findsNothing);
  });
}
