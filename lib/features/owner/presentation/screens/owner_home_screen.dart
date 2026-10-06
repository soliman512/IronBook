import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ironbook/core/constants/app_colors.dart';
import 'package:ironbook/core/constants/app_images.dart';
import 'package:ironbook/core/constants/app_radius.dart';
import 'package:ironbook/core/constants/app_spacing.dart';
import 'package:ironbook/core/constants/app_strings.dart';
import 'package:ironbook/core/constants/app_text_styles.dart';
import 'package:ironbook/core/global_widgets/logout_button.dart';
import 'package:ironbook/features/auth/models/gym_model.dart';
import 'package:ironbook/features/auth/models/user_model.dart';
import 'package:ironbook/features/auth/providers/auth_provider.dart';
import 'package:ironbook/features/auth/providers/gym_provider.dart';
import 'package:provider/provider.dart';

class OwnerHomeScreen extends StatelessWidget {
  const OwnerHomeScreen({
    super.key,
    required this.onOpenPlans,
    required this.onOpenMembers,
    this.activeMembersCount = 0,
    this.pendingRequestsCount = 0,
    this.plansCount = 0,
  });

  final VoidCallback onOpenPlans;
  final int? plansCount;
  final int? activeMembersCount;
  final int? pendingRequestsCount;
  final VoidCallback onOpenMembers;

  @override
  Widget build(BuildContext context) {
    final UserModel? user = context.watch<AuthProvider>().getUser;
    final GymModel? gym = context.watch<GymProvider>().getGym;

    return Stack(
      children: [
        Positioned(
          bottom: -80,
          right: 24,
          left: 24,
          child: Opacity(
            opacity: .1,
            child: Image.asset(AppImages.backgroundShape2),
          ),
        ),
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //top section (hi + close app)
              Row(
                crossAxisAlignment: .center,
                mainAxisAlignment: .spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi, ${user != null ? user.fullName.split(' ').first : 'unkoun'}',
                          style: TextTheme.of(context).bodyMedium!.copyWith(
                            color: AppColors.secondary,
                            fontWeight: .w300,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          gym != null ? gym.name : 'not found',
                          style: TextTheme.of(context).titleLarge!,
                        ),
                      ],
                    ),
                  ),
                  LogoutButton(),
                ],
              ),
              const SizedBox(height: 16),
              //gym id
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 12),
                      blurRadius: 28,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 14),
                    Text(
                      'GYM ID',
                      style: TextTheme.of(context).labelSmall!
                          .copyWith(color: AppColors.secondary, fontSize: 11),
                    ),
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      crossAxisAlignment: .center,
                      children: [
                        Flexible(
                          child: Text(
                            gym != null ? gym.id : 'not found',
                            style: AppTextStyles.monoGymId.copyWith(
                              color: AppColors.accent,
                            ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            _copyGymId(
                              context,
                              gym != null ? gym.id : 'not found',
                            );
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.white,
                            backgroundColor: AppColors.white.withValues(
                              alpha: .12,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            textStyle: TextTheme.of(context).bodyMedium!
                                .copyWith(fontSize: 12.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.copy_rounded, size: 14),
                          label: const Text('Copy'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Share this code with members so they can find your gym and request a plan.',
                      style: TextTheme.of(context).bodyMedium!
                          .copyWith(color: AppColors.secondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _DashboardStat(
                      value: activeMembersCount.toString(),
                      label: 'Active members',
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _DashboardStat(
                      value: pendingRequestsCount.toString(),
                      label: 'Pending requests',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.black12,
                  //     offset: Offset(0, 4),
                  //     blurRadius: 12,
                  //   ),
                  // ],
                ),
                child: Column(
                  children: [
                    _DashboardAction(
                      icon: Icons.receipt_long_outlined,
                      title: AppStrings.subscriptionPlans,
                      detail: '$plansCount plans',
                      onTap: onOpenPlans,
                    ),
                    const Divider(height: 1, indent: 14, endIndent: 14),
                    _DashboardAction(
                      icon: Icons.groups_outlined,
                      title: 'Members & Requests',
                      detail:
                          '$activeMembersCount active · $pendingRequestsCount pending',
                      onTap: onOpenMembers,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _copyGymId(BuildContext context, String textToCopy) async {
    await Clipboard.setData(ClipboardData(text: textToCopy));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Gym ID copied')));
  }
}

class _DashboardStat extends StatelessWidget {
  const _DashboardStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 90),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.border),
      // boxShadow: [
      //   BoxShadow(color: Colors.black12, offset: Offset(0, 4), blurRadius: 12),
      // ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: TextTheme.of(context).titleMedium!.copyWith(fontSize: 34),
          textAlign: .center,
        ),
        Text(
          label,
          style: TextTheme.of(context).bodyMedium!
              .copyWith(color: AppColors.secondary, fontSize: 12),
        ),
      ],
    ),
  );
}

class _DashboardAction extends StatelessWidget {
  const _DashboardAction({
    required this.icon,
    required this.title,
    required this.detail,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String detail;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: ListTile(
      onTap: onTap,

      contentPadding: const .symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        width: 42,
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.neutral2,
          borderRadius: BorderRadius.circular(AppRadius.badge),
        ),
        child: Icon(icon, size: 16, color: AppColors.primary),
      ),

      title: Text(
        title,
        style: TextTheme.of(context).bodyMedium!.copyWith(fontWeight: .w600),
      ),

      subtitle: Text(
        detail,
        style: TextTheme.of(context).bodyMedium!
            .copyWith(color: AppColors.secondary, fontSize: 13),
      ),

      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.secondary,
        size: 28,
      ),
    ),
  );
}
