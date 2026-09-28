import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ironbook/core/constants/app_colors.dart';
import 'package:ironbook/core/constants/app_radius.dart';
import 'package:ironbook/core/constants/app_spacing.dart';
import 'package:ironbook/core/constants/app_strings.dart';
import 'package:ironbook/core/constants/app_text_styles.dart';

class OwnerHomeScreen extends StatelessWidget {
  const OwnerHomeScreen({
    super.key,
    required this.onOpenPlans,
    required this.onOpenMembers,
  });

  final VoidCallback onOpenPlans;
  final VoidCallback onOpenMembers;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.lg,
          AppSpacing.screen,
          AppSpacing.screen,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hi, Tarek',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.secondary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        AppStrings.ownerGymName,
                        style: AppTextStyles.screenTitle,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.primary,
                    minimumSize: const Size(40, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.input),
                    ),
                  ),
                  icon: const Icon(Icons.logout_rounded, size: 18),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            _GymIdCard(onCopy: () => _copyGymId(context)),
            const SizedBox(height: AppSpacing.md),
            const Row(
              children: [
                Expanded(
                  child: _DashboardStat(value: '6', label: 'Active members'),
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _DashboardStat(value: '0', label: 'Pending requests'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _DashboardAction(
                    icon: Icons.receipt_long_outlined,
                    title: AppStrings.subscriptionPlans,
                    detail: '3 plans',
                    onTap: onOpenPlans,
                  ),
                  const Divider(height: 1, indent: 14, endIndent: 14),
                  _DashboardAction(
                    icon: Icons.groups_outlined,
                    title: AppStrings.members,
                    detail: '6 active · 0 pending',
                    onTap: onOpenMembers,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Future<void> _copyGymId(BuildContext context) async {
    await Clipboard.setData(const ClipboardData(text: "gymId"));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Gym ID copied')));
  }
}

class _GymIdCard extends StatelessWidget {
  const _GymIdCard({required this.onCopy});

  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(AppSpacing.button),
    decoration: BoxDecoration(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(AppRadius.cardLarge),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'GYM ID',
              style: AppTextStyles.monoLabel.copyWith(
                color: AppColors.secondary,
                fontSize: 9,
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: onCopy,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.white,
                backgroundColor: AppColors.primaryHover,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                textStyle: AppTextStyles.bodyMedium.copyWith(fontSize: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.badge),
                ),
              ),
              icon: const Icon(Icons.copy_rounded, size: 12),
              label: const Text('Copy'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          "AppStrings.gymId",
          style: AppTextStyles.monoGymId.copyWith(color: AppColors.accent),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Share this code with members so they can find your gym and request a plan.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.white.withValues(alpha: 0.68),
            fontSize: 11,
          ),
        ),
      ],
    ),
  );
}

class _DashboardStat extends StatelessWidget {
  const _DashboardStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minHeight: 72),
    padding: const EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppRadius.card),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(value, style: AppTextStyles.planCardTitle.copyWith(fontSize: 24)),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.secondary,
            fontSize: 10,
          ),
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
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(AppRadius.card),
    child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.neutral2,
              borderRadius: BorderRadius.circular(AppRadius.badge),
            ),
            child: Icon(icon, size: 16, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyMedium),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  detail,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.secondary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.secondary,
            size: 20,
          ),
        ],
      ),
    ),
  );
}
