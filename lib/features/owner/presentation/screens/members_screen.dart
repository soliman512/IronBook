import 'package:flutter/material.dart';
import 'package:ironbook/core/constants/app_colors.dart';
import 'package:ironbook/core/constants/app_radius.dart';
import 'package:ironbook/core/global_widgets/app_switcher.dart';
import 'package:ironbook/features/auth/models/user_model.dart';
import 'package:ironbook/features/auth/providers/gym_provider.dart';
import 'package:ironbook/features/auth/services/auth_services.dart';
import 'package:ironbook/features/loading/providers/loading_provider.dart';
import 'package:ironbook/features/member/models/member_ship_model.dart';
import 'package:ironbook/features/member/services/member_ship_services.dart';
import 'package:ironbook/features/owner/models/plan_model.dart';
import 'package:ironbook/features/owner/models/services/plan_services.dart';
import 'package:provider/provider.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  int selectedIndex = 0;
  List<MembershipModel> _requests = [];
  List<MembershipModel> _members = [];

  Future<void> _loadMembers() async {
    final gym = context.read<GymProvider>().getGym;
    if (gym == null) return;

    final members = await MembershipServices.getMembers(gym.id);

    if (!mounted) return;

    setState(() {
      _members = members;
    });
  }

  Future<void> _loadRequests() async {
    final gym = context.read<GymProvider>().getGym;
    if (gym == null) return;

    final requests = await MembershipServices.getMembershipRequests(gym.id);

    if (!mounted) return;

    setState(() {
      _requests = requests;
    });
  }

  Color _getStatusColor(MembershipStatus status) {
    switch (status) {
      case MembershipStatus.active:
        return AppColors.success;

      case MembershipStatus.cancelled:
        return AppColors.warning;

      case MembershipStatus.rejected:
        return AppColors.danger;
      case MembershipStatus.pending:
        return AppColors.secondary;
    }
  }

  Future<(UserModel?, SubscriptionPlan?)> getMemberData(
    MembershipModel member,
  ) async {
    final user = await AuthServices.getUserData(member.userId);
    final plan = await PlanServices.getPlan(member.planId);

    return (user, plan);
  }

  Future<(UserModel?, SubscriptionPlan?)> getRequestData(
    MembershipModel request,
  ) async {
    final user = await AuthServices.getUserData(request.userId);
    final plan = await PlanServices.getPlan(request.planId);

    return (user, plan);
  }

  @override
  void initState() {
    super.initState();
    _loadMembers();
    _loadRequests();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: [
        Text('Members', style: TextTheme.of(context).titleLarge!),
        const SizedBox(height: 18),
        AppSwitcher(
          selectedIndex: selectedIndex,
          onSelected: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          children: [
            Text(
              'Members · ${_members.length}',
              style: TextTheme.of(context).bodyMedium,
            ),
            Row(
              mainAxisAlignment: .center,
              spacing: 6,
              children: [
                Text("Requests", style: TextTheme.of(context).bodyMedium),
                CircleAvatar(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.accent,
                  radius: 10,
                  child: Text(
                    "${_requests.length}",
                    style: TextTheme.of(context).bodyMedium!
                        .copyWith(color: AppColors.accent, fontSize: 10),
                  ),
                ),
              ],
            ),
          ],
        ),
        Flexible(
          child: selectedIndex == 0
              ? Container(
                  margin: .symmetric(vertical: 20),
                  padding: .symmetric(horizontal: 16),
                  clipBehavior: .antiAlias,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(color: AppColors.border, width: 1),
                    borderRadius: .circular(20),
                  ),
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: _members.length,
                    separatorBuilder: (context, index) =>
                        Divider(color: AppColors.border),
                    itemBuilder: (context, index) {
                      final member = _members[index];

                      return FutureBuilder(
                        future: getMemberData(member),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.all(20),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          if (snapshot.hasError) {
                            return const Text('Failed to load member.');
                          }

                          final (user, plan) = snapshot.data!;

                          if (user == null || plan == null) {
                            return const Text('Failed to load member.');
                          }

                          return Material(
                            color: Colors.transparent,
                            child: ListTile(
                              contentPadding: .zero,
                              leading: CircleAvatar(
                                backgroundColor: AppColors.neutral2,
                                child: Text(
                                  user.fullName
                                      .split(' ')
                                      .map((element) => element[0])
                                      .join(''),
                                  style: TextTheme.of(context).bodyMedium!
                                      .copyWith(fontWeight: FontWeight.w700),
                                ),
                              ),
                              title: Text(
                                user.fullName,
                                style: TextTheme.of(context).bodyMedium!
                                    .copyWith(fontWeight: FontWeight.w700),
                              ),
                              subtitle: Text(
                                plan.name,
                                style: TextTheme.of(context).bodyMedium!
                                    .copyWith(
                                      color: AppColors.textMuted,
                                      fontSize: 10,
                                    ),
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(member.status)
                                      .withValues(alpha: .2),
                                  borderRadius: BorderRadius.circular(10000),
                                ),
                                child: Text(
                                  member.status.name,
                                  style: TextTheme.of(context).labelSmall!
                                      .copyWith(
                                        color: _getStatusColor(member.status),
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                )
              : ListView.builder(
                  itemCount: _requests.length,
                  itemBuilder: (context, index) {
                    final request = _requests[index];

                    return FutureBuilder(
                      future: getRequestData(request),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.all(20),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        if (snapshot.hasError) {
                          return const Text('Failed to load request.');
                        }

                        final (user, plan) = snapshot.data!;
                        if (user == null || plan == null) {
                          return const Text('Failed to load request.');
                        }
                        return Padding(
                          padding: .only(top: 6),
                          child: Container(
                            padding: const .all(16),
                            margin: .symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              border: Border.all(color: AppColors.border),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              spacing: 14,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 42,
                                      height: 42,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: AppColors.neutral2,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        user.fullName
                                            .split(' ')
                                            .map((element) => element[0])
                                            .join(''),
                                        style: TextTheme.of(context).bodySmall!,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            user.fullName,
                                            style: TextTheme.of(context)
                                                .bodySmall!,
                                          ),
                                          Text(
                                            plan.type ==
                                                    SubscriptionPlanType
                                                        .sessionBased
                                                ? 'session-based'
                                                : 'time-based',
                                            style: TextTheme.of(context)
                                                .bodySmall!
                                                .copyWith(
                                                  fontSize: 12,
                                                  color: AppColors.secondary,
                                                  fontWeight: FontWeight.w400,
                                                  overflow: .ellipsis,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    //status
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.neutral,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'Pending',
                                        style: TextTheme.of(context).bodySmall!
                                            .copyWith(
                                              fontSize: 12,
                                              color: AppColors.warning,
                                              fontWeight: FontWeight.w400,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const .all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.neutral2,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          plan.name,
                                          style: TextTheme.of(context)
                                              .bodySmall!
                                              .copyWith(
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.secondary,
                                              ),
                                        ),
                                      ),
                                      Text(
                                        '${plan.price.toString()} EGP',
                                        style: TextTheme.of(context).bodySmall!
                                            .copyWith(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          context
                                              .read<LoadingProvider>()
                                              .show();
                                          if (request.id == null) {
                                            context
                                                .read<LoadingProvider>()
                                                .hide();
                                            return;
                                          }
                                          await MembershipServices.rejectMembership(
                                            request.id!,
                                          );
                                          if (!context.mounted) {
                                            return;
                                          }
                                          _loadRequests();
                                          context
                                              .read<LoadingProvider>()
                                              .hide();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.neutral,
                                          foregroundColor: AppColors.danger,
                                          padding: .symmetric(vertical: 12),
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          'Reject',
                                          style: TextTheme.of(context)
                                              .bodySmall!
                                              .copyWith(
                                                color: AppColors.danger,
                                              ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      flex: 6,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          context
                                              .read<LoadingProvider>()
                                              .show();
                                          if (request.id == null) {
                                            context
                                                .read<LoadingProvider>()
                                                .hide();
                                            return;
                                          }
                                          await MembershipServices.approveMembership(
                                            request.id!,
                                          );
                                          if (!context.mounted) {
                                            return;
                                          }
                                          _loadRequests();
                                          context
                                              .read<LoadingProvider>()
                                              .hide();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary,
                                          foregroundColor: AppColors.white,
                                          padding: .symmetric(vertical: 12),
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          'Approve',
                                          style: TextTheme.of(context)
                                              .bodySmall!
                                              .copyWith(color: AppColors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );

                    //  MemberRequestCard(request: _requests[index]);
                  },
                ),
        ),
      ],
    ),
  );
}
