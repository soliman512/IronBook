import 'package:flutter/material.dart';
import 'package:ironbook/core/constants/app_colors.dart';
import 'package:ironbook/core/extenstions/screen_size_extension.dart';
import 'package:ironbook/features/chat/presentation/screens/chat_screen.dart';
import 'package:ironbook/features/members/presentation/screens/members_screen.dart';
import 'package:ironbook/features/owner_shell/presentation/screens/owner_home_screen.dart';
import 'package:ironbook/features/plans/presentation/screens/subscription_plans_screen.dart';
import 'package:ironbook/theme/app_text_styles.dart';

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
    _pageController.animateToPage(
      page.index,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
    );
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
    bottomNavigationBar: _OwnerBottomNavigationBar(
      selectedPage: _selectedPage,
      onSelect: _showPage,
    ),
  );
}

class _OwnerBottomNavigationBar extends StatelessWidget {
  const _OwnerBottomNavigationBar({
    required this.selectedPage,
    required this.onSelect,
  });

  final OwnerShellPage selectedPage;
  final ValueChanged<OwnerShellPage> onSelect;

  static const List<(OwnerShellPage, String, IconData)> _items = [
    (OwnerShellPage.home, 'Home', Icons.home_outlined),
    (OwnerShellPage.plans, 'Plans', Icons.receipt_long_outlined),
    (OwnerShellPage.members, 'Members', Icons.groups_outlined),
    (OwnerShellPage.chat, 'Chat', Icons.chat_bubble_outline_rounded),
  ];

  @override
  Widget build(BuildContext context) => Container(
    height: context.screenHeight * .1,
    padding: const .all(8),
    decoration: BoxDecoration(
      color: AppColors.white,
      border: Border(top: BorderSide(color: AppColors.border)),
    ),
    child: Row(
      mainAxisAlignment: .spaceEvenly,
      children: [
        for (final (page, label, icon) in _items)
          _OwnerNavigationItem(
            label: label,
            icon: icon,
            selected: selectedPage == page,
            onTap: () => onSelect(page),
          ),
      ],
    ),
  );
}

class _OwnerNavigationItem extends StatelessWidget {
  const _OwnerNavigationItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: .symmetric(horizontal: 12, vertical: 6),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            size: 20,
            color: selected ? AppColors.primary : AppColors.secondary,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.monoLabel.copyWith(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? AppColors.primary : AppColors.secondary,
          ),
        ),
      ],
    ),
  );
}
