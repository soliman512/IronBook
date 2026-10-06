import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ironbook/core/constants/app_colors.dart';
import 'package:ironbook/core/constants/app_images.dart';
import 'package:ironbook/core/global_widgets/logout_button.dart';
import 'package:ironbook/core/global_widgets/main_button.dart';
import 'package:ironbook/features/member/models/member_ship_model.dart';
import 'package:ironbook/features/member/providers/member_ship_provider.dart';
import 'package:ironbook/features/member/services/member_ship_services.dart';
import 'package:ironbook/features/owner/models/plan_model.dart';
import 'package:provider/provider.dart';

class MemberHomeScreen extends StatefulWidget {
  const MemberHomeScreen({
    super.key,
    required this.onOpenJoinToGym,
    required this.userFullName,
    required this.loadMembership,
    required this.plan,
    this.gymName,
  });

  final VoidCallback onOpenJoinToGym;
  final String? gymName;
  final String userFullName;
  final Future<void> Function() loadMembership;
  final SubscriptionPlan? plan;

  @override
  State<MemberHomeScreen> createState() => _MemberHomeScreenState();
}

class _MemberHomeScreenState extends State<MemberHomeScreen> {
  Widget _noMembershipWidget(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(color: Colors.black12, offset: Offset(0, 1), blurRadius: 2),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            padding: const EdgeInsets.all(18.8),
            decoration: BoxDecoration(
              color: AppColors.neutral,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(Icons.fitness_center, color: AppColors.primary),
          ),
          const SizedBox(height: 26),
          Text(
            'No active membership',
            textAlign: TextAlign.center,
            style: TextTheme.of(context).bodySmall!.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 12),
          Text(
            "Enter your gym's ID to see their plans and send a membership request.",
            textAlign: TextAlign.center,
            style: TextTheme.of(context).bodySmall!
                .copyWith(color: AppColors.secondary),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 50,
            child: MainButton(
              onPressed: widget.onOpenJoinToGym,
              title: 'Join a gym',
              icon: Icons.arrow_forward_ios_rounded,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _pendingMembershipWidget(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            padding: const EdgeInsets.all(18.8),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.schedule_rounded, color: AppColors.primary),
          ),
          const SizedBox(height: 18),
          Text(
            'Membership request pending',
            textAlign: TextAlign.center,
            style: TextTheme.of(context).bodySmall!.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 10),
          Text(
            'Your request has been sent to the gym owner. '
            'You will see your membership here once it is approved.',
            textAlign: TextAlign.center,
            style: TextTheme.of(context).bodySmall!
                .copyWith(color: AppColors.secondary),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              'PENDING',
              style: TextTheme.of(context).labelSmall!
                  .copyWith(color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 12),
          MainButton(
            onPressed: () async {
              await widget.loadMembership();
            },
            title: 'Check',
            icon: Icons.refresh,
            color: AppColors.warning,
          ),
        ],
      ),
    );
  }

  Widget _rejectedMembershipWidget(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.danger.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.danger.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.cancel_outlined,
                  color: AppColors.danger,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Request rejected',
                      style: TextTheme.of(context).bodySmall!
                          .copyWith(fontSize: 18, color: AppColors.danger),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Your membership request was rejected by the gym.',
                      style: TextTheme.of(context).labelSmall!
                          .copyWith(color: AppColors.secondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          FilledButton(
            onPressed: widget.onOpenJoinToGym,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: AppColors.white,
              minimumSize: const Size.fromHeight(54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Choose plan',
              style: TextTheme.of(context).bodyMedium!
                  .copyWith(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(
    BuildContext context, {
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium!
                .copyWith(color: AppColors.secondary, fontSize: 12),
          ),
          Text(
            value,
            style: GoogleFonts.numans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _activeMemberShipWidget(
    BuildContext context, {
    required MembershipModel membership,
    required SubscriptionPlan plan,
  }) {
    final isTimeBased = plan.type == SubscriptionPlanType.timeBased;

    final endDate = membership.endDate;

    if (endDate == null) {
      return const Center(child: Text('Membership data is incomplete.'));
    }

    late String mainValue;
    late String mainLabel;
    late String progressLeft;
    late String progressRight;
    late double progress;
    late String remainingTitle;
    late String remainingValue;
    late bool showCheckIn;

    if (isTimeBased) {
      if (membership.startDate == null || plan.durationInDays == null) {
        return const Center(child: Text('Membership data is incomplete.'));
      }

      final today = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );

      final startDate = DateTime(
        membership.startDate!.year,
        membership.startDate!.month,
        membership.startDate!.day,
      );

      final expiryDate = DateTime(endDate.year, endDate.month, endDate.day);

      final totalDays = expiryDate.difference(startDate).inDays;

      final daysUsed = today
          .difference(startDate)
          .inDays
          .clamp(0, totalDays)
          .toInt();

      final daysRemaining = expiryDate
          .difference(today)
          .inDays
          .clamp(0, totalDays)
          .toInt();

      progress = totalDays > 0 ? (daysUsed / totalDays).clamp(0.0, 1.0) : 0.0;

      mainValue = '$daysRemaining';
      mainLabel = 'days remaining';

      progressLeft = 'Day $daysUsed of $totalDays';
      progressRight =
          'Expires ${expiryDate.day} ${_monthName(expiryDate.month)} ${expiryDate.year}';

      remainingTitle = 'Remaining';
      remainingValue = '$daysRemaining days';

      showCheckIn = false;
    } else {
      if (plan.sessionCount == null) {
        return const Center(child: Text('Membership data is incomplete.'));
      }

      final sessionsTotal = plan.sessionCount!;

      final sessionsUsed = membership.sessionsUsed
          .clamp(0, sessionsTotal)
          .toInt();

      final sessionsRemaining = (sessionsTotal - sessionsUsed)
          .clamp(0, sessionsTotal)
          .toInt();

      progress = sessionsTotal > 0
          ? (sessionsUsed / sessionsTotal).clamp(0.0, 1.0)
          : 0.0;

      mainValue = '$sessionsRemaining';
      mainLabel = 'sessions remaining';

      progressLeft = 'Used $sessionsUsed of $sessionsTotal';
      progressRight =
          'Valid until ${endDate.day} ${_monthName(endDate.month)} ${endDate.year}';

      remainingTitle = 'Remaining';
      remainingValue = '$sessionsRemaining sessions';

      showCheckIn = true;
    }

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(26),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 4),
                blurRadius: 12,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isTimeBased ? 'TIME-BASED' : 'SESSION-BASED',
                    style: Theme.of(context).textTheme.bodyMedium!
                        .copyWith(color: AppColors.secondary, fontSize: 10),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFBDE3C8),
                      borderRadius: BorderRadius.circular(1000),
                    ),
                    child: Text(
                      'Active',
                      style: Theme.of(context).textTheme.bodyMedium!
                          .copyWith(color: AppColors.success, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                plan.name,
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 4),

              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    mainValue,
                    style: GoogleFonts.numans(
                      fontSize: 42,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    mainLabel,
                    style: Theme.of(context).textTheme.bodySmall!
                        .copyWith(color: AppColors.secondary),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(1000),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFFD7F34A),
                ),
                minHeight: 10,
              ),

              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    progressLeft,
                    style: Theme.of(context).textTheme.bodySmall!
                        .copyWith(fontSize: 12, color: AppColors.secondary),
                  ),
                  Text(
                    progressRight,
                    style: Theme.of(context).textTheme.bodySmall!
                        .copyWith(fontSize: 12, color: AppColors.secondary),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
          childAspectRatio: 1.8,
          children: [
            _statCard(context, title: 'Paid', value: '${plan.price} EGP'),
            _statCard(
              context,
              title: isTimeBased ? 'Days used' : 'Sessions used',
              value: isTimeBased
                  ? progressLeft.replaceFirst('Day ', '')
                  : progressLeft.replaceFirst('Used ', ''),
            ),
            _statCard(context, title: remainingTitle, value: remainingValue),
            _statCard(
              context,
              title: isTimeBased ? 'Expiry' : 'Valid until',
              value:
                  '${endDate.day} ${_monthName(endDate.month)} | ${endDate.year}',
            ),
          ],
        ),

        if (showCheckIn) ...[
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: membership.sessionsUsed >= plan.sessionCount!
                  ? null
                  : () async {
                      try {
                        await MembershipServices.checkInSession(
                          membership,
                          plan,
                        );

                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Check-in successful.'),
                            backgroundColor: AppColors.success,
                          ),
                        );

                        await widget.loadMembership();
                      } catch (e) {
                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              e.toString().replaceFirst('Exception: ', ''),
                            ),
                            backgroundColor: AppColors.danger,
                          ),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                disabledBackgroundColor: AppColors.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 2,
                shadowColor: AppColors.accentHover.withValues(alpha: 0.7),
                padding: const EdgeInsets.all(16),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Check In',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.check, color: AppColors.accent, size: 20),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return months[month - 1];
  }

  Widget _buildMembershipContent(
    BuildContext context,
    MembershipModel membership,
  ) {
    switch (membership.status) {
      case MembershipStatus.active:
        if (widget.plan == null) {
          return const Center(child: Text('Membership data is incomplete.'));
        }

        return _activeMemberShipWidget(
          context,
          membership: membership,
          plan: widget.plan!,
        );

      case MembershipStatus.pending:
        return _pendingMembershipWidget(context);

      case MembershipStatus.rejected:
        return _rejectedMembershipWidget(context);



      case MembershipStatus.cancelled:
        return const Center(child: Text('Membership cancelled'));
    }
  }

  @override
  Widget build(BuildContext context) {
    final membership = context.watch<MembershipProvider>().membership;

    return Stack(
      children: [
        Positioned(
          bottom: -80,
          right: 24,
          left: 24,
          child: Opacity(
            opacity: 0.1,
            child: Image.asset(AppImages.backgroundShape2),
          ),
        ),
        SingleChildScrollView(
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
                          widget.gymName ?? 'No gym selected yet',
                          style: TextTheme.of(context).bodyMedium!.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Hi, ${widget.userFullName.split(' ').first}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ),
                  LogoutButton(),
                ],
              ),
              const SizedBox(height: 20),
              if (membership == null)
                _noMembershipWidget(context)
              else
                _buildMembershipContent(context, membership),
            ],
          ),
        ),
      ],
    );
  }
}
