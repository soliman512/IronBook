import 'package:flutter/material.dart';
import 'package:ironbook/core/constants/app_colors.dart';
import 'package:ironbook/core/global_widgets/bottom_nav_bar.dart';
import 'package:ironbook/features/auth/providers/gym_provider.dart';
import 'package:ironbook/features/chat/presentation/screens/chat_screen.dart';
import 'package:ironbook/features/member/models/member_ship_model.dart';
import 'package:ironbook/features/member/services/member_ship_services.dart';
import 'package:ironbook/features/owner/models/plan_model.dart';
import 'package:ironbook/features/owner/models/services/plan_services.dart';
import 'package:ironbook/features/owner/presentation/screens/members_screen.dart';
import 'package:ironbook/features/owner/presentation/screens/owner_home_screen.dart';
import 'package:ironbook/features/owner/presentation/screens/subscription_plans_screen.dart';
import 'package:provider/provider.dart';

enum OwnerShellPage { home, plans, members /*,chat*/ }

class OwnerShellScreen extends StatefulWidget {
  const OwnerShellScreen({super.key});

  @override
  State<OwnerShellScreen> createState() => _OwnerShellScreenState();
}

class _OwnerShellScreenState extends State<OwnerShellScreen> {
  late final PageController _pageController;
  late ValueNotifier<OwnerShellPage> _selectedPage;

  List<SubscriptionPlan> _plans = [];
  Future<void> _loadPlans() async {
    try {
      final plans = await PlanServices.getPlans(
        context.read<GymProvider>().getGym!.id,
      );

      if (!mounted) return;

      setState(() {
        _plans = plans;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Problem when fetching plans, try again later.'),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  int _activeMembersCount = 0;
  int _pendingRequestsCount = 0;
  Future<void> _loadMemberCounts() async {
    final gym = context.read<GymProvider>().getGym;
    if (gym == null) return;

    final members = await MembershipServices.getMembers(gym.id);
    final requests = await MembershipServices.getMembershipRequests(gym.id);

    if (!mounted) return;

    final activeMembersCount = members
        .where((member) => member.status == MembershipStatus.active)
        .length;

    setState(() {
      _activeMembersCount = activeMembersCount;
      _pendingRequestsCount = requests.length;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPlans();
      _loadMemberCounts();
    });
    _selectedPage = ValueNotifier<OwnerShellPage>(OwnerShellPage.home);
    _pageController = PageController(initialPage: _selectedPage.value.index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _showPage(
    OwnerShellPage page, {
    int? plansCount,
    int? activeMembersCount,
    int? pendingRequestsCount,
  }) {
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
        plansCount: _plans.length,
        activeMembersCount: _activeMembersCount,
        pendingRequestsCount: _pendingRequestsCount,
      ),
      SubscriptionPlansScreen(plans: _plans, onPlansChanged: _loadPlans),
      MembersScreen(),
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
              // AppNavigationItem(
              //   page: OwnerShellPage.chat,
              //   label: 'Chat',
              //   icon: Icons.chat_bubble_outline_rounded,
              // ),
            ],
            selectedPage: _selectedPage.value,
            onSelect: _showPage,
          );
        },
      ),
    );
  }
}
