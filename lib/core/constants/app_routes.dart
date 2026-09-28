import 'package:flutter/material.dart';

import 'package:ironbook/features/auth/presentation/screens/auth_screen.dart';
import 'package:ironbook/features/join_gym/presentation/screens/join_gym_screen.dart';
import 'package:ironbook/features/member/presentation/screens/member_home_screen.dart';
import 'package:ironbook/features/owner_shell/presentation/screens/owner_shell_screen.dart';
import 'package:ironbook/features/role_selection/presentation/screens/role_selection_screen.dart';

abstract final class AppRoutes {
  static const String roleSelection = '/';
  static const String auth = '/auth';
  static const String ownerShell = '/owner-shell';
  static const String subscriptionPlans = '/plans';
  static const String members = '/members';
  static const String joinGym = '/join-gym';
  static const String memberHome = '/member';
  static const String chat = '/chat';

  static final Map<String, WidgetBuilder> routes = {
    roleSelection: (_) => const RoleSelectionScreen(),
    auth: (_) => const AuthScreen(),
    ownerShell: (_) => const OwnerShellScreen(),
    subscriptionPlans: (_) =>
        const OwnerShellScreen(initialPage: OwnerShellPage.plans),
    members: (_) => const OwnerShellScreen(initialPage: OwnerShellPage.members),
    joinGym: (_) => const JoinGymScreen(),
    memberHome: (_) => const MemberHomeScreen(),
    chat: (_) => const OwnerShellScreen(initialPage: OwnerShellPage.chat),
  };
}
