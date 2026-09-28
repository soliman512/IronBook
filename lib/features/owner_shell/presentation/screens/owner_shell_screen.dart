import 'package:flutter/material.dart';

import 'package:ironbook/core/widgets/bottom_nav_bar.dart';
import 'package:ironbook/features/chat/presentation/screens/chat_screen.dart';
import 'package:ironbook/features/members/presentation/screens/members_screen.dart';
import 'package:ironbook/features/owner_shell/presentation/screens/owner_home_screen.dart';
import 'package:ironbook/features/plans/presentation/screens/subscription_plans_screen.dart';

enum OwnerShellPage { home, plans, members, chat }

class OwnerShellScreen extends StatefulWidget {
  const OwnerShellScreen({super.key});

  @override
  State<OwnerShellScreen> createState() => _OwnerShellScreenState();
}

class _OwnerShellScreenState extends State<OwnerShellScreen> {
  late final PageController _pageController;
  late OwnerShellPage _selectedPage;

  @override
  void initState() {
    super.initState();
    _selectedPage = OwnerShellPage.home;
    _pageController = PageController(initialPage: _selectedPage.index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showPage(OwnerShellPage page) {
    _pageController.jumpToPage(page.index);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          _selectedPage = OwnerShellPage.values[index];
          setState(() {});
        },
        children: [
          OwnerHomeScreen(
            onOpenPlans: () => _showPage(OwnerShellPage.plans),
            onOpenMembers: () => _showPage(OwnerShellPage.members),
          ),
          const SubscriptionPlansScreen(),
          const MembersScreen(),
          const ChatScreen(),
        ],
      ),
    ),
    bottomNavigationBar: AppBottomNavigationBar<OwnerShellPage>(
      items: const [
        AppNavigationItem(
          page: OwnerShellPage.home,
          label: 'Home',
          icon: Icons.home_outlined,
        ),
        AppNavigationItem(
          page: OwnerShellPage.plans,
          label: 'Plans',
          icon: Icons.receipt_long_outlined,
        ),
        AppNavigationItem(
          page: OwnerShellPage.members,
          label: 'Members',
          icon: Icons.groups_outlined,
        ),
        AppNavigationItem(
          page: OwnerShellPage.chat,
          label: 'Chat',
          icon: Icons.chat_bubble_outline_rounded,
        ),
      ],
      selectedPage: _selectedPage,
      onSelect: _showPage,
    ),
  );
}
