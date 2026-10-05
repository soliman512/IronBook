import 'package:flutter/material.dart';
import 'package:ironbook/core/global_widgets/bottom_nav_bar.dart';
import 'package:ironbook/features/auth/models/user_model.dart';
import 'package:ironbook/features/auth/providers/auth_provider.dart';
import 'package:ironbook/features/chat/presentation/screens/chat_screen.dart';
import 'package:ironbook/features/owner/presentation/screens/members_screen.dart';
import 'package:ironbook/features/owner/presentation/screens/owner_home_screen.dart';
import 'package:ironbook/features/owner/presentation/screens/subscription_plans_screen.dart';
import 'package:provider/provider.dart';

enum OwnerShellPage { home, plans, members, chat }

class OwnerShellScreen extends StatefulWidget {
  const OwnerShellScreen({super.key});

  @override
  State<OwnerShellScreen> createState() => _OwnerShellScreenState();
}

class _OwnerShellScreenState extends State<OwnerShellScreen> {
  late final PageController _pageController;
  late ValueNotifier<OwnerShellPage> _selectedPage;

  @override
  void initState() {
    super.initState();
    _selectedPage = ValueNotifier<OwnerShellPage>(OwnerShellPage.home);
    _pageController = PageController(initialPage: _selectedPage.value.index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showPage(OwnerShellPage page) {
    _pageController.animateToPage(
      page.index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      OwnerHomeScreen(
        onOpenPlans: () => _showPage(OwnerShellPage.plans),
        onOpenMembers: () => _showPage(OwnerShellPage.members),
      ),
      const SubscriptionPlansScreen(),
      const MembersScreen(),
      const ChatScreen(),
    ];

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          _selectedPage.value = OwnerShellPage.values[index];
        },
        children: List.generate(
          pages.length,
          ((index) =>
              Padding(padding: .fromLTRB(24, 48, 24, 0), child: pages[index])),
        ),
      ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: _selectedPage,
        builder: (context, value, child) {
          return AppBottomNavigationBar<OwnerShellPage>(
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
            selectedPage: _selectedPage.value,
            onSelect: _showPage,
          );
        },
      ),
    );
  }
}
