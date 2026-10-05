import 'package:flutter/material.dart';
import 'package:ironbook/features/auth/presentation/screens/auth_screen.dart';
import 'package:ironbook/features/member/presentation/screens/member_shell_screen.dart';
import 'package:ironbook/features/owner/presentation/screens/owner_shell_screen.dart';
import 'package:ironbook/features/role_selection/presentation/screens/role_selection_screen.dart';
import 'package:ironbook/features/splash/presentation/screens/splash_screen.dart';

abstract final class AppRoutes {
  static const String roleSelection = '/';
  static const String auth = '/auth';
  static const String ownerShell = '/owner-shell';
  static const String subscriptionPlans = '/plans';
  static const String members = '/members';
  static const String joinGym = '/join-gym';
  static const String memberHome = '/member';
  static const String memberShell= '/member-shell';
  static const String chat = '/chat';
  static const String splash = '/splash';

  static final Map<String, WidgetBuilder> routes = {
    roleSelection: (_) => const RoleSelectionScreen(),
    auth: (_) => const AuthScreen(),
    ownerShell: (_) => const OwnerShellScreen(),
    memberShell: (_) => const MemberShellScreen(),
    splash: (_) => const SplashScreen(),
  };
}
