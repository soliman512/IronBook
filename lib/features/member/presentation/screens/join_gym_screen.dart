import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ironbook/core/constants/app_colors.dart';
import 'package:ironbook/core/constants/app_routes.dart';
import 'package:ironbook/core/global_widgets/app_text_form_field.dart';
import 'package:ironbook/core/global_widgets/main_button.dart';
import 'package:ironbook/features/auth/models/gym_model.dart';
import 'package:ironbook/features/auth/providers/auth_provider.dart';
import 'package:ironbook/features/member/models/member_ship_model.dart';
import 'package:ironbook/features/member/providers/member_ship_provider.dart';
import 'package:ironbook/features/member/services/member_ship_services.dart';
import 'package:ironbook/features/owner/models/plan_model.dart';
import 'package:ironbook/features/owner/models/services/plan_services.dart';
import 'package:provider/provider.dart';

class ShowPlanWidget extends StatelessWidget {
  const ShowPlanWidget({
    super.key,
    required this.plan,
    required this.isSelected,
  });

  final SubscriptionPlan plan;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final String subtitle = plan.type == SubscriptionPlanType.timeBased
        ? '${plan.durationInDays} days • Unlimited sessions'
        : '${plan.sessionCount} sessions • Valid ${plan.validityInDays} days';

    return ListTile(
      tileColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.border,
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.secondary,
            width: 2,
          ),
        ),
        child: isSelected
            ? Center(
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              )
            : null,
      ),
      title: Text(
        plan.name,
        style: Theme.of(context).textTheme.titleMedium!
            .copyWith(fontWeight: FontWeight.w700, color: AppColors.primary),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodyMedium!
            .copyWith(color: AppColors.secondary, fontSize: 12),
      ),
      trailing: Text(
        '${plan.price} EGP',
        style: Theme.of(context).textTheme.titleMedium!
            .copyWith(fontWeight: FontWeight.w700, color: AppColors.primary),
      ),
    );
  }
}

class JoinGymScreen extends StatefulWidget {
  const JoinGymScreen({super.key});

  @override
  State<JoinGymScreen> createState() => _JoinGymScreenState();
}

class _JoinGymScreenState extends State<JoinGymScreen> {
  TextEditingController searchController = TextEditingController();
  List<SubscriptionPlan> plans = [];
  GymModel? gym;
  SubscriptionPlan? selectedPlan;
  String? ownerName;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> searchAboutGym(String gymId) async {
    try {
      final gymData = await _firestore.collection('gyms').doc(gymId).get();

      if (!gymData.exists) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gym not found'),
            backgroundColor: AppColors.warning,
          ),
        );
        return;
      }

      final gymModel = GymModel.fromMap(gymData.data()!, gymData.id);

      final ownerData = await _firestore
          .collection('users')
          .doc(gymModel.ownerId)
          .get();

      final plans = await PlanServices.getPlans(gymModel.id);

      if (!mounted) return;

      if (plans.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No plans in this gym'),
            backgroundColor: AppColors.warning,
          ),
        );
        return;
      }

      setState(() {
        gym = gymModel;
        ownerName = ownerData.data()?['fullName'];
        this.plans = plans;
        selectedPlan = null;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Problem when searching for the gym'),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        spacing: 16,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Join a gym',
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                color: AppColors.primary,
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Ask the front desk for their Gym ID.',
              style: Theme.of(context).textTheme.bodyMedium!
                  .copyWith(color: AppColors.secondary),
            ),
          ),
          if (context.read<MembershipProvider>().membership != null) ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: AppColors.warning.withValues(alpha: 0.25),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.card_membership_rounded,
                          color: AppColors.warning,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Active Membership',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  Text(
                    'You already have an active membership',
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(height: 1.5),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'You can cancel your current membership if you want to choose a different plan.',
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: Colors.grey.shade600, height: 1.4),
                  ),

                  const SizedBox(height: 18),

                  MainButton(
                    onPressed: () async {
                      final membership = context
                          .read<MembershipProvider>()
                          .membership;

                      if (membership?.id == null) return;

                      final shouldDelete = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Cancel Membership?'),
                            content: const Text(
                              'Are you sure you want to cancel your current membership? '
                              'You will lose access to your current plan.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Keep Membership'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text(
                                  'Cancel Membership',
                                  style: TextStyle(
                                    color: AppColors.warning,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );

                      if (shouldDelete != true) return;

                      await MembershipServices.cancelMembership(
                        membership!.id!,
                      );

                      if (context.mounted) {
                        context.read<MembershipProvider>().clearMembership();
                        setState(() {});
                      }
                    },
                    title: 'Cancel Membership',
                    icon: Icons.delete_outline_rounded,
                    color: AppColors.warning,
                  ),
                ],
              ),
            ),
          ] else ...[
            Row(
              spacing: 10,
              mainAxisAlignment: .center,
              crossAxisAlignment: .center,
              children: [
                Expanded(
                  child: AppTextFormField(
                    controller: searchController,
                    hintText: 'EXP-0000',
                  ),
                ),
                FilledButton(
                  onPressed: () {
                    final gymId = searchController.text.trim().toUpperCase();

                    if (gymId.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Enter gym ID first'),
                          backgroundColor: AppColors.warning,
                        ),
                      );
                      return;
                    }

                    searchAboutGym(gymId);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Find'),
                ),
              ],
            ),

            Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: gym == null
                  ? Padding(
                      padding: .all(12),
                      child: Text(
                        'enter gym id first to show details and options',
                        style: TextTheme.of(context).labelSmall!
                            .copyWith(color: AppColors.accent, fontSize: 14),
                        textAlign: .center,
                      ),
                    )
                  : ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'I',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        gym!.name,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: AppColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        'Owner • $ownerName',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.secondary,
                          fontSize: 12.5,
                        ),
                      ),
                      trailing: Text(
                        gym!.id,
                        style: Theme.of(context).textTheme.titleMedium!
                            .copyWith(
                              color: AppColors.accent,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
            ),

            if (plans.isNotEmpty) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'CHOOSE A PLAN',
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (plans.isEmpty)
                const SizedBox.shrink()
              else
                ...plans.map((plan) {
                  bool isSelected = plan == selectedPlan;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedPlan = plan;
                      });
                    },
                    child: ShowPlanWidget(plan: plan, isSelected: isSelected),
                  );
                }),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await MembershipServices.createMembership(
                      MembershipModel(
                        gymId: gym!.id,
                        userId: context.read<AuthProvider>().getUser!.id,
                        planId: selectedPlan!.id!,
                        status: MembershipStatus.pending,
                      ),
                    );
                    searchController.clear();
                    if(!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('request sent successfully'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.memberShell,
                    );
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    padding: .symmetric(vertical: 14),
                    textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  child: Text('Request Membership'),
                ),
              ),
            ] else
              Text("search with gym id"),
          ],
        ],
      ),
    );
  }
}
