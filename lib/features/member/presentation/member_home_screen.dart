import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ironbook/core/constants/app_colors.dart';
import 'package:ironbook/core/constants/app_images.dart';
import 'package:ironbook/core/widgets/main_button.dart';

class MemberStatItem {
  const MemberStatItem({
    required this.title,
    required this.value,
    this.valueColor,
  });

  final String title;
  final String value;
  final Color? valueColor;
}

class MemberHomeScreen extends StatelessWidget {
  const MemberHomeScreen({super.key, required this.onOpenJoinToGym});

  final VoidCallback onOpenJoinToGym;

  @override
  Widget build(BuildContext context) {
    final stats = [
      const MemberStatItem(title: 'Paid', value: '500 EGP'),
      const MemberStatItem(title: 'Remaining', value: '0 EGP'),
      const MemberStatItem(title: 'Days used', value: '12 / 30'),
      const MemberStatItem(title: 'Expiry', value: '15 Oct'),
    ];

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
                          'Iron Yard Gym',
                          style: TextTheme.of(context).bodyMedium!.copyWith(
                            color: AppColors.secondary,
                            fontWeight: .w300,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Hi, Omar',
                          style: TextTheme.of(context).titleLarge!,
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
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    icon: Transform.flip(
                      flipX: true,
                      child: const Icon(Icons.logout_outlined, size: 18),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              //status card
              Container(
                width: double.infinity,
                padding: const .all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(26),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              'TIME-BASED',
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(
                                    color: AppColors.secondary,
                                    fontSize: 10,
                                  ),
                            ),
                          ],
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
                                .copyWith(
                                  color: AppColors.success,
                                  fontSize: 12,
                                ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Monthly',
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 26,
                      ),
                    ),
                    const SizedBox(height: 4),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: .alphabetic,
                      mainAxisAlignment: .start,
                      children: [
                        Text(
                          '18',
                          style: GoogleFonts.numans(
                            fontSize: 42,
                            fontWeight: .w700,
                            color: AppColors.accent,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'days remaining',
                          style: Theme.of(context).textTheme.bodySmall!
                              .copyWith(color: AppColors.secondary),
                        ),
                      ],
                    ),
                    LinearProgressIndicator(
                      value: 0.4,
                      backgroundColor: Colors.white.withValues(alpha: .18),
                      borderRadius: .circular(1000),

                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFD7F34A),
                      ),
                      minHeight: 10,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Day 12 of 30',
                          style: Theme.of(context).textTheme.bodySmall!
                              .copyWith(
                                fontSize: 12,
                                color: AppColors.secondary,
                              ),
                        ),
                        Text(
                          'Expires 15 Oct 2026',
                          style: Theme.of(context).textTheme.bodySmall!
                              .copyWith(
                                fontSize: 12,
                                color: AppColors.secondary,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.8,
                children: [
                  for (final stat in stats)
                    Container(
                      padding: const .all(14),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: .min,
                        children: [
                          Text(
                            stat.title,
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(
                                  color: AppColors.secondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                          Text(
                            stat.value,
                            style: GoogleFonts.numans(
                              fontSize: 16,
                              fontWeight: .w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      shape: RoundedRectangleBorder(
                        borderRadius: .circular(18),
                      ),
                      side: BorderSide(color: AppColors.secondary, width: .5),

                      padding: .all(16),
                    ),

                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 8,
                      children: [
                        Icon(Icons.check, color: AppColors.primary, size: 20),
                        Text(
                          'Check In',
                          style: TextTheme.of(context).titleMedium!
                              .copyWith(fontSize: 18, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
