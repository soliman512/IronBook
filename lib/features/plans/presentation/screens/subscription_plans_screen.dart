import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:ironbook/core/constants/app_colors.dart';
import 'package:ironbook/core/constants/app_text_styles.dart';

class SubscriptionPlansScreen extends StatelessWidget {
  const SubscriptionPlansScreen({super.key});

  static const _plans = [
    _Plan(
      name: 'Monthly',
      type: 'TIME-BASED',
      details: '30 days · Unlimited sessions',
      price: '500',
    ),
    _Plan(
      name: '12 Sessions',
      type: 'SESSION-BASED',
      details: '12 sessions · Valid 60 days',
      price: '500',
    ),
    _Plan(
      name: 'Quarterly',
      type: 'TIME-BASED',
      details: '90 days · Unlimited sessions',
      price: '1,300',
    ),
  ];

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Column(
      crossAxisAlignment: .stretch,
      children: [
        Row(
          crossAxisAlignment: .center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text('Plans', style: AppTextStyles.screenTitle),
                  Text(
                    'What members can request',
                    style: AppTextStyles.bodyText.copyWith(
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 21),
              label: Text(
                'Add plan',
                style: AppTextStyles.bodyMedium.copyWith(fontWeight: .w600),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                textStyle: AppTextStyles.buttonText,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        for (final plan in _plans) ...[
          _PlanCard(plan: plan),
          if (plan != _plans.last) const SizedBox(height: 12),
        ],
      ],
    ),
  );
}

class _Plan {
  const _Plan({
    required this.name,
    required this.type,
    required this.details,
    required this.price,
  });

  final String name;
  final String type;
  final String details;
  final String price;
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.plan});

  final _Plan plan;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: AppColors.white,
      border: Border.all(color: AppColors.border, width: 1),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: .start,
      children: [
        Row(
          crossAxisAlignment: .start,
          children: [
            Expanded(
              child: Column(
                spacing: 4,
                crossAxisAlignment: .start,
                children: [
                  Wrap(
                    crossAxisAlignment: .center,
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      Text(plan.name, style: AppTextStyles.planCardTitle),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.neutral2,
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Text(
                          plan.type,
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    plan.details,
                    style: AppTextStyles.bodyText.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Delete ${plan.name}',
              onPressed: () {},
              icon: const Icon(Icons.delete_outline, size: 21),
              style: IconButton.styleFrom(
                foregroundColor: AppColors.danger,
                fixedSize: const Size(42, 42),
                padding: EdgeInsets.zero,
                side: const BorderSide(color: AppColors.errorBackground),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        //divider
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 14),
          child: Divider(height: 1, color: AppColors.neutral2),
        ),
        Row(
          crossAxisAlignment: .baseline,
          textBaseline: .alphabetic,
          children: [
            Text(
              plan.price,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              'EGP',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.secondary,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
