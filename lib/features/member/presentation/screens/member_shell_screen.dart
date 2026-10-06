import 'package:flutter/material.dart';
import 'package:ironbook/core/global_widgets/bottom_nav_bar.dart';
import 'package:ironbook/features/auth/models/gym_model.dart';
import 'package:ironbook/features/auth/models/user_model.dart';
import 'package:ironbook/features/auth/providers/auth_provider.dart';
import 'package:ironbook/features/auth/services/gym_services.dart';
import 'package:ironbook/features/chat/presentation/screens/chat_screen.dart';
import 'package:ironbook/features/member/presentation/screens/join_gym_screen.dart';
import 'package:ironbook/features/member/presentation/screens/member_home_screen.dart';
import 'package:ironbook/features/member/providers/member_ship_provider.dart';
import 'package:ironbook/features/member/services/member_ship_services.dart';
import 'package:provider/provider.dart';
import 'package:ironbook/features/owner/models/plan_model.dart';
import 'package:ironbook/features/owner/models/services/plan_services.dart';

class MemberShellScreen extends StatefulWidget {
  const new({super.key});
  @override
  State<MemberShellScreen> createState() => _MemberShellScreenState();
}

enum MemberShellPage { home, join /*,chat*/ }

class _MemberShellScreenState extends State<MemberShellScreen> {
  late final PageController _pageController;
  late ValueNotifier<MemberShellPage> _selectedPage;
  SubscriptionPlan? _plan;
  GymModel? gymModel;

  Future<void> loadMembership() async {
    final user = context.read<AuthProvider>().getUser;

    if (user == null) return;

    final membership = await MembershipServices.getMembership(user.id);

    if (!mounted) return;

    context.read<MembershipProvider>().setMembership(membership);

    if (membership == null) {
      setState(() {
        _plan = null;
      });
      return;
    }

    final plan = await PlanServices.getPlan(membership.planId);

    if (!mounted) return;

    gymModel = await GymServices.getGymById(plan.gymId);

    setState(() {
      _plan = plan;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedPage = ValueNotifier<MemberShellPage>(MemberShellPage.home);
    _pageController = PageController(initialPage: _selectedPage.value.index);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadMembership();
    });
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
    final UserModel? user = context.watch<AuthProvider>().getUser;
    final String userFullName = user != null ? user.fullName : 'unkoun';
    final List<Widget> pages = [
      MemberHomeScreen(
        userFullName: userFullName,
        loadMembership: loadMembership,
        plan: _plan,
        gymName: "${gymModel?.name} | ${gymModel?.id}",
        onOpenJoinToGym: () {
          _showPage(MemberShellPage.join);
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
              // AppNavigationItem(
              //   page: MemberShellPage.chat,
              //   label: 'Chat',
              //   icon: Icons.chat_bubble_outline_rounded,
              // ),
            ],
            selectedPage: value,
            onSelect: _showPage,
          );
        },
      ),
    );
  }
}
