import 'package:flutter/material.dart';
import 'package:ironbook/core/constants/app_colors.dart';
import 'package:ironbook/core/widgets/app_text_form_field.dart';

class PlanOption {
  const PlanOption({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.isSelected,
  });

  final String title;
  final String subtitle;
  final String price;
  final bool isSelected;
}

class ShowPlanWidget extends StatelessWidget {
  const ShowPlanWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.isSelected,
  });

  final String title;
  final String subtitle;
  final String price;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
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
        title,
        style: Theme.of(context).textTheme.titleMedium!
            .copyWith(fontWeight: FontWeight.w700, color: AppColors.primary),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodyMedium!
            .copyWith(color: AppColors.secondary, fontSize: 12),
      ),
      trailing: Text(
        price,
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
  final List<PlanOption> plans = const [
    PlanOption(
      title: 'Monthly',
      subtitle: 'Time-based • 30 days • Unlimited sessions',
      price: '500 EGP',
      isSelected: true,
    ),
    PlanOption(
      title: '12 Sessions',
      subtitle: 'Session-based • 12 sessions • Valid 60 days',
      price: '500 EGP',
      isSelected: false,
    ),
    PlanOption(
      title: 'Quarterly',
      subtitle: 'Time-based • 90 days • Unlimited sessions',
      price: '1,300 EGP',
      isSelected: false,
    ),
  ];

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
          Row(
            spacing: 10,
            children: [
              Expanded(
                child: AppTextFormField(
                  controller: TextEditingController(),
                  hintText: 'EXP-0000',
                ),
              ),
              Container(
                padding: .symmetric(vertical: 15, horizontal: 20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  'Find',
                  style: Theme.of(context).textTheme.bodyMedium!
                      .copyWith(color: AppColors.white),
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListTile(
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
                'Iron Yard Gym',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                'Owner • Tarek Mansour',
                style: Theme.of(context).textTheme.bodyMedium!
                    .copyWith(color: AppColors.secondary, fontSize: 12.5),
              ),
              trailing: Text(
                'IRN-4821',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: AppColors.accent,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
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
          ...plans.map((plan) {
            return ShowPlanWidget(
              title: plan.title,
              subtitle: plan.subtitle,
              price: plan.price,
              isSelected: plan.isSelected,
            );
          }),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
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
        ],
      ),
    );
  }
}
