import 'package:flutter/material.dart';
import 'package:ironbook/core/global_widgets/bottom_nav_bar.dart';
import 'package:ironbook/features/chat/presentation/screens/chat_screen.dart';
import 'package:ironbook/features/member/presentation/screens/join_gym_screen.dart';
import 'package:ironbook/features/member/presentation/screens/member_home_screen.dart';

class MemberShellScreen extends StatefulWidget {
  const new({super.key});
  @override
  State<MemberShellScreen> createState() => _MemberShellScreenState();
}

enum MemberShellPage { home, join, chat }

class _MemberShellScreenState extends State<MemberShellScreen> {
  late final PageController _pageController;
  late ValueNotifier<MemberShellPage> _selectedPage;

  @override
  void initState() {
    super.initState();
    _selectedPage = ValueNotifier<MemberShellPage>(MemberShellPage.home);
    _pageController = PageController(initialPage: _selectedPage.value.index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showPage(MemberShellPage page) {
    _pageController.animateToPage(
      page.index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      MemberHomeScreen(
        onOpenJoinToGym: () {
          _selectedPage.value = MemberShellPage.join;
        },
      ),
      const JoinGymScreen(),
      const ChatScreen(),
    ];
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          _selectedPage.value = MemberShellPage.values[index];
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
          return AppBottomNavigationBar(
            items: [
              AppNavigationItem(
                page: MemberShellPage.home,
                label: 'Home',
                icon: Icons.home,
              ),
              AppNavigationItem(
                page: MemberShellPage.join,
                label: 'Join',
                icon: Icons.search,
              ),
              AppNavigationItem(
                page: MemberShellPage.chat,
                label: 'Chat',
                icon: Icons.chat_bubble_outline_rounded,
              ),
            ],
            selectedPage: value,
            onSelect: _showPage,
          );
        },
      ),
    );
  }
}
