import 'package:flutter/material.dart';

import 'package:ironbook/features/auth/presentation/screens/auth_screen.dart';
import 'package:ironbook/features/chat/presentation/screens/chat_screen.dart';
import 'package:ironbook/features/join_gym/presentation/screens/join_gym_screen.dart';
import 'package:ironbook/features/member/presentation/screens/member_home_screen.dart';
import 'package:ironbook/features/members/presentation/screens/members_screen.dart';
import 'package:ironbook/features/owner/presentation/screens/owner_home_screen.dart';
import 'package:ironbook/features/plans/presentation/screens/subscription_plans_screen.dart';
import 'package:ironbook/features/role_selection/presentation/screens/role_selection_screen.dart';

abstract final class AppRoutes {
  static const String roleSelection = '/';
  static const String auth = '/auth';
  static const String ownerHome = '/owner';
  static const String subscriptionPlans = '/plans';
  static const String members = '/members';
  static const String joinGym = '/join-gym';
  static const String memberHome = '/member';
  static const String chat = '/chat';

  static final Map<String, WidgetBuilder> routes = {
    roleSelection: (_) => const RoleSelectionScreen(),
    auth: (_) => const AuthScreen(),
    ownerHome: (_) => const OwnerHomeScreen(),
    subscriptionPlans: (_) => const SubscriptionPlansScreen(),
    members: (_) => const MembersScreen(),
    joinGym: (_) => const JoinGymScreen(),
    memberHome: (_) => const MemberHomeScreen(),
    chat: (_) => const ChatScreen(),
  };
}
