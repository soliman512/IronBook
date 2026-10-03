import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ironbook/core/constants/app_colors.dart';
import 'package:ironbook/core/extenstions/screen_size_extension.dart';
import 'package:ironbook/core/widgets/app_text_form_field.dart';
import 'package:ironbook/core/widgets/main_button.dart';
import 'package:ironbook/features/owner/models/subscription_plan_model.dart';

class SubscriptionPlansScreen extends StatefulWidget {
  const SubscriptionPlansScreen({super.key});

  @override
  State<SubscriptionPlansScreen> createState() =>
      _SubscriptionPlansScreenState();
}

class _SubscriptionPlansScreenState extends State<SubscriptionPlansScreen> {
  final _plans = <SubscriptionPlan>[
    SubscriptionPlan(
      id: '1',
      name: 'Monthly',
      type: SubscriptionPlanType.timeBased,
      price: 500,
      durationInDays: 30,
      gymId: 'gym_1',
    ),
    SubscriptionPlan(
      id: '2',
      name: '12 Sessions',
      type: SubscriptionPlanType.sessionBased,
      price: 500,
      sessionCount: 12,
      validityInDays: 60,
      gymId: 'gym_1',
    ),
    SubscriptionPlan(
      id: '3',
      name: 'Quarterly',
      type: SubscriptionPlanType.timeBased,
      price: 1300,
      durationInDays: 90,
      gymId: 'gym_1',
    ),
  ];

  void _showAddSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _NewPlanSheet(
        onSubmit: (plan) {
          setState(() => _plans.insert(0, plan));
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
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
        for (int i = 0; i < _plans.length; i++) ...[
          _PlanCard(
            plan: _plans[i],
            onDelete: () => setState(() => _plans.removeAt(i)),
          ),
          if (i != _plans.length - 1) const SizedBox(height: 12),
        ],
      ],
    ),
  );
}

class _NewPlanSheet extends StatefulWidget {
  const _NewPlanSheet({required this.onSubmit});
  final ValueChanged<SubscriptionPlan> onSubmit;
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

  String get _details => _isTimeBased
      ? '${_duration.text} days \u00b7 Unlimited sessions'
      : '${_sessions.text} sessions \u00b7 Valid ${_validity.text} days';

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    widget.onSubmit(
      SubscriptionPlan(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _name.text.trim(),
        type: _isTimeBased
            ? SubscriptionPlanType.timeBased
            : SubscriptionPlanType.sessionBased,
        price: double.parse(_price.text.trim()),
        durationInDays: _isTimeBased ? int.parse(_duration.text.trim()) : null,
        sessionCount: _isTimeBased ? null : int.parse(_sessions.text.trim()),
        validityInDays: _isTimeBased ? null : int.parse(_validity.text.trim()),
        gymId: 'gym_1',
      ),
    );
  }

  String? _requiredInt(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    final n = int.tryParse(v.trim());
    if (n == null || n < 1) return 'Enter a positive number';
    return null;
  }

  String? _requiredPrice(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    final n = double.tryParse(v.trim());
    if (n == null || n <= 0) return 'Enter a valid price';
    return null;
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
              _buildTypeToggle(),
              const SizedBox(height: 16),
              AppTextFormField(
                title: 'PLAN NAME*',
                controller: _name,
                suffixIcon: const Icon(Icons.edit_outlined),
                onChanged: (_) => setState(() {}),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Enter a plan name' : null,
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
                      onChanged: (_) => setState(() {}),
                      validator: _requiredPrice,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppTextFormField(
                      controller: _isTimeBased ? _duration : _sessions,
                      title: _isTimeBased ? 'DAYS*' : 'SESSION*',
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() {}),
                      validator: _requiredInt,
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
                  onChanged: (_) => setState(() {}),
                  validator: _requiredInt,
                ),
              ],
              const SizedBox(height: 20),
              _buildPreview(),
              const SizedBox(height: 16),
              SizedBox(
                height: 54,
                child: MainButton(
                  onPressed: _submit,
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

  Widget _buildTypeToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.neutral,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _toggleOption(
            label: 'Time-based',
            icon: Icons.calendar_today_outlined,
            selected: _isTimeBased,
            onTap: () => setState(() => _isTimeBased = true),
          ),
          _toggleOption(
            label: 'Session-based',
            icon: Icons.swap_horiz,
            selected: !_isTimeBased,
            onTap: () => setState(() => _isTimeBased = false),
          ),
        ],
      ),
    );
  }

  Widget _toggleOption({
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Material(
        color: selected ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            height: 48,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 19,
                  color: selected ? AppColors.white : AppColors.textMuted,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextTheme.of(context).bodyMedium!.copyWith(
                      color: selected ? AppColors.white : AppColors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPreview() {
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
            child: const Icon(Icons.badge_outlined, color: AppColors.primary),
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
                      style: TextTheme.of(context).bodyMedium!.copyWith(
                        color: const Color(0xFF687500),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.circle, size: 8, color: AppColors.accent),
                    const SizedBox(width: 5),
                    Text(
                      _isTimeBased ? 'Time Pass' : 'Session Pass',
                      style: TextTheme.of(context).bodyLarge!
                          .copyWith(color: AppColors.textMuted, fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  '${_name.text} \u00b7 ${_price.text} EGP \u00b7 $_details',
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
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.plan, required this.onDelete});
  final SubscriptionPlan plan;
  final VoidCallback onDelete;

  String get _typeLabel => plan.type == SubscriptionPlanType.timeBased
      ? 'TIME-BASED'
      : 'SESSION-BASED';

  String get _details {
    if (plan.type == SubscriptionPlanType.timeBased)
      return '${plan.durationInDays} days \u00b7 Unlimited sessions';
    return '${plan.sessionCount} sessions \u00b7 Valid ${plan.validityInDays} days';
  }

  String get _price {
    if (plan.price.truncateToDouble() == plan.price)
      return plan.price.toInt().toString();
    return plan.price.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) => Container(
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
                      Text(plan.name, style: TextTheme.of(context).titleMedium),
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
                          _typeLabel,
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
                    _details,
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
              _price,
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
