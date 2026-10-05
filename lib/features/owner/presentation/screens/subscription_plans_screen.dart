import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ironbook/core/constants/app_colors.dart';
import 'package:ironbook/core/extenstions/screen_size_extension.dart';
import 'package:ironbook/core/global_widgets/app_text_form_field.dart';
import 'package:ironbook/core/global_widgets/main_button.dart';
import 'package:ironbook/features/auth/providers/gym_provider.dart';
import 'package:ironbook/features/loading/providers/loading_provider.dart';
import 'package:ironbook/features/owner/models/plan_model.dart';
import 'package:ironbook/features/owner/models/services/plan_services.dart';
import 'package:provider/provider.dart';

class SubscriptionPlansScreen extends StatefulWidget {
  const SubscriptionPlansScreen({super.key});

  @override
  State<SubscriptionPlansScreen> createState() =>
      _SubscriptionPlansScreenState();
}

class _SubscriptionPlansScreenState extends State<SubscriptionPlansScreen> {
  List<SubscriptionPlan?> _plans = [];

  @override
  void initState() {
    super.initState();
    showAllPlans();
  }

  Future<void> showAllPlans() async {
    try {
      _plans = await PlanServices.getPlans(
        context.read<GymProvider>().getGym!.id,
      );

      if (!mounted) return;

      setState(() {});
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

  Future<void> _createNewPlan(SubscriptionPlan plan) async {
    try {
      await PlanServices.createPlan(plan);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('plan added successfully'),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Problem when creating plan, try again later.'),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  Future<void> _deletePlan(String id) async {
    try {
      await PlanServices.deletePlan(id);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('plan removed successfully'),
          backgroundColor: AppColors.warning,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Problem when creating plan, try again later.'),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  void _showAddSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _NewPlanSheet(
        onSubmit: (plan) async {
          context.read<LoadingProvider>().show();

          try {
            await _createNewPlan(plan);

            if (!mounted) return;

            await showAllPlans();
            Navigator.pop(context);
          } finally {
            if (mounted) {
              context.read<LoadingProvider>().hide();
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Plans', style: TextTheme.of(context).titleLarge),
                    Text(
                      'What members can request',
                      style: TextTheme.of(context).bodyLarge!
                          .copyWith(color: AppColors.secondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: _showAddSheet,
                icon: const Icon(Icons.add, size: 21),
                label: Text(
                  'Add plan',
                  style: TextTheme.of(context).bodyMedium!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (_plans.isEmpty)
            const Center(
              child: Column(
                children: [
                  Icon(Icons.hourglass_empty_outlined),
                  Text(
                    'No subscription plans available.\nAdd a plan to get started.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          if (_plans.isNotEmpty)
            ..._plans.map(
              (plan) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: PlanCard(
                  plan: plan!,
                  onDelete: () async {
                    context.read<LoadingProvider>().show();
                    await _deletePlan(plan.id!);
                    await showAllPlans();
                    if (!mounted) return;
                    context.read<LoadingProvider>().hide();
                    setState(() {});
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _NewPlanSheet extends StatefulWidget {
  const _NewPlanSheet({required this.onSubmit});

  final Future<void> Function(SubscriptionPlan) onSubmit;

  @override
  State<_NewPlanSheet> createState() => _NewPlanSheetState();
}

class _NewPlanSheetState extends State<_NewPlanSheet> {
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _price = TextEditingController();
  final _duration = TextEditingController();
  final _sessions = TextEditingController();
  final _validity = TextEditingController();

  bool _isTimeBased = true;

  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    _duration.dispose();
    _sessions.dispose();
    _validity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: context.screenHeight * 0.94),
      clipBehavior: Clip.antiAlias,
      padding: context.isKeyboardOpend
          ? EdgeInsets.only(bottom: context.keyboardInsets)
          : EdgeInsets.zero,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(1000),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CATALOG ENTRY',
                          style: GoogleFonts.libertinusSerif(
                            fontSize: 11,
                            color: const Color(0xFF566500),
                          ),
                        ),
                        Text(
                          'New plan',
                          style: GoogleFonts.libertinusSerif(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton.filledTonal(
                    tooltip: 'Close',
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    style: IconButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      backgroundColor: AppColors.border,
                      minimumSize: const Size(36, 36),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Plan type
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.neutral,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Material(
                        color: _isTimeBased
                            ? AppColors.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _isTimeBased = true;
                            });
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            height: 48,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.calendar_today_outlined,
                                  size: 19,
                                  color: _isTimeBased
                                      ? AppColors.white
                                      : AppColors.textMuted,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Time-based',
                                  style: TextTheme.of(context).bodyMedium!
                                      .copyWith(
                                        color: _isTimeBased
                                            ? AppColors.white
                                            : AppColors.textMuted,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Material(
                        color: !_isTimeBased
                            ? AppColors.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _isTimeBased = false;
                            });
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            height: 48,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.swap_horiz,
                                  size: 19,
                                  color: !_isTimeBased
                                      ? AppColors.white
                                      : AppColors.textMuted,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Session-based',
                                  style: TextTheme.of(context).bodyMedium!
                                      .copyWith(
                                        color: !_isTimeBased
                                            ? AppColors.white
                                            : AppColors.textMuted,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              AppTextFormField(
                title: 'PLAN NAME*',
                controller: _name,
                suffixIcon: const Icon(Icons.edit_outlined),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter a plan name';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AppTextFormField(
                      controller: _price,
                      title: 'PRICE (EGP)*',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Required';
                        }

                        final price = double.tryParse(value.trim());

                        if (price == null || price <= 0) {
                          return 'Enter a valid price';
                        }

                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppTextFormField(
                      controller: _isTimeBased ? _duration : _sessions,
                      title: _isTimeBased ? 'DAYS*' : 'SESSION*',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Required';
                        }

                        final number = int.tryParse(value.trim());

                        if (number == null || number < 1) {
                          return 'Enter a positive number';
                        }

                        return null;
                      },
                    ),
                  ),
                ],
              ),

              if (!_isTimeBased) ...[
                const SizedBox(height: 16),
                AppTextFormField(
                  controller: _validity,
                  title: 'VALIDITY (DAYS)*',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Required';
                    }

                    final number = int.tryParse(value.trim());

                    if (number == null || number < 1) {
                      return 'Enter a positive number';
                    }

                    return null;
                  },
                ),
              ],

              const SizedBox(height: 20),

              ListenableBuilder(
                listenable: Listenable.merge([
                  _name,
                  _price,
                  _duration,
                  _sessions,
                  _validity,
                ]),
                builder: (context, child) {
                  final details = _isTimeBased
                      ? '${_duration.text} days · Unlimited sessions'
                      : '${_sessions.text} sessions · Valid ${_validity.text} days';

                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.badge_outlined,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'CARD PREVIEW',
                                    style: TextTheme.of(context).bodyMedium!
                                        .copyWith(
                                          color: const Color(0xFF687500),
                                          fontSize: 11,
                                        ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(
                                    Icons.circle,
                                    size: 8,
                                    color: AppColors.accent,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    _isTimeBased ? 'Time Pass' : 'Session Pass',
                                    style: TextTheme.of(context).bodyLarge!
                                        .copyWith(
                                          color: AppColors.textMuted,
                                          fontSize: 11,
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${_name.text} · ${_price.text} EGP · $details',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.libertinusSerif(
                                  fontSize: 13,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              SizedBox(
                height: 54,
                child: MainButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }

                    final plan = SubscriptionPlan(
                      name: _name.text.trim(),
                      type: _isTimeBased
                          ? SubscriptionPlanType.timeBased
                          : SubscriptionPlanType.sessionBased,
                      price: double.parse(_price.text.trim()),
                      durationInDays: _isTimeBased
                          ? int.parse(_duration.text.trim())
                          : null,
                      sessionCount: _isTimeBased
                          ? null
                          : int.parse(_sessions.text.trim()),
                      validityInDays: _isTimeBased
                          ? null
                          : int.parse(_validity.text.trim()),
                      gymId: context.read<GymProvider>().getGym!.id,
                    );

                    await widget.onSubmit(plan);
                  },
                  title: 'Add Plan',
                  icon: Icons.add,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlanCard extends StatelessWidget {
  const PlanCard({super.key, required this.plan, required this.onDelete});

  final SubscriptionPlan plan;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final isTimeBased = plan.type == SubscriptionPlanType.timeBased;

    final details = isTimeBased
        ? '${plan.durationInDays} days · Unlimited sessions'
        : '${plan.sessionCount} sessions · Valid ${plan.validityInDays} days';

    final price = plan.price.truncateToDouble() == plan.price
        ? plan.price.toInt().toString()
        : plan.price.toStringAsFixed(2);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Text(
                          plan.name,
                          style: TextTheme.of(context).titleMedium,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.neutral2,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isTimeBased ? 'TIME-BASED' : 'SESSION-BASED',
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
                      details,
                      style: TextTheme.of(context).bodyLarge!
                          .copyWith(color: AppColors.textMuted, fontSize: 14),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, size: 21),
                style: IconButton.styleFrom(
                  foregroundColor: AppColors.danger,
                  fixedSize: const Size(42, 42),
                  side: const BorderSide(color: AppColors.errorBackground),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1, color: AppColors.neutral2),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                price,
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
}
