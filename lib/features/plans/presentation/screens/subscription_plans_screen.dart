import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:ironbook/core/constants/app_colors.dart';
import 'package:ironbook/core/constants/app_text_styles.dart';
import 'package:ironbook/core/extenstions/screen_size_extension.dart';
import 'package:ironbook/core/widgets/app_text_form_field.dart';
import 'package:ironbook/core/widgets/main_button.dart';

class SubscriptionPlansScreen extends StatefulWidget {
  const SubscriptionPlansScreen({super.key});

  @override
  State<SubscriptionPlansScreen> createState() =>
      _SubscriptionPlansScreenState();
}

class _SubscriptionPlansScreenState extends State<SubscriptionPlansScreen> {
  final _plans = <_Plan>[
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
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  useSafeArea: true,
                  backgroundColor: Colors.transparent,
                  builder: (sheetContext) => _NewPlanSheet(
                    onSubmit: (plan) {
                      setState(() => _plans.insert(0, plan));
                      Navigator.pop(context);
                    },
                  ),
                );
              },
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
        for (int i = 0; i < _plans.length; i++) ...[
          _PlanCard(
            plan: _plans[i],
            onDelete: () {
              setState(() {
                _plans.removeAt(i);
              });
            },
          ),
          if (_plans[i] != _plans.last) const SizedBox(height: 12),
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

class _NewPlanSheet extends StatefulWidget {
  const _NewPlanSheet({required this.onSubmit});

  final ValueChanged<_Plan> onSubmit;

  @override
  State<_NewPlanSheet> createState() => _NewPlanSheetState();
}

class _NewPlanSheetState extends State<_NewPlanSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _durationController = TextEditingController();
  final _sessionsController = TextEditingController();
  final _validityController = TextEditingController();
  bool _isTimeBased = true;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    _sessionsController.dispose();
    _validityController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final details = _isTimeBased
        ? '${_durationController.text} days · Unlimited sessions'
        : '${_sessionsController.text} sessions · Valid ${_validityController.text} days';
    widget.onSubmit(
      _Plan(
        name: _nameController.text.trim(),
        type: _isTimeBased ? 'TIME-BASED' : 'SESSION-BASED',
        details: details,
        price: _priceController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: context.screenHeight * 0.94),
      clipBehavior: Clip.antiAlias,
      padding: context.isKeyboardOpend
          ? .only(bottom: context.keyboardInsets)
          : .zero,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: .stretch,
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
                  //close button
                  IconButton.filledTonal(
                    tooltip: 'Close',
                    onPressed: () => Navigator.of(context).pop(),
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
              _PlanTypeSelector(
                isTimeBased: _isTimeBased,
                onChanged: (value) => setState(() => _isTimeBased = value),
              ),
              const SizedBox(height: 16),
              AppTextFormField(
                title: 'PLAN NAME*',
                controller: _nameController,
                suffixIcon: const Icon(Icons.edit_outlined),
                onChanged: (_) => setState(() {}),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter a plan name'
                    : null,
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AppTextFormField(
                      controller: _priceController,
                      title: 'PRICE (EGP)*',
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() {}),
                      validator: _requiredNumber,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _isTimeBased
                        ? AppTextFormField(
                            controller: _durationController,
                            title: 'DAYS*',
                            keyboardType: TextInputType.number,
                            onChanged: (_) => setState(() {}),
                            validator: _requiredNumber,
                          )
                        : AppTextFormField(
                            controller: _sessionsController,
                            title: 'SESSION*',
                            keyboardType: TextInputType.number,
                            onChanged: (_) => setState(() {}),
                            validator: _requiredNumber,
                          ),
                  ),
                ],
              ),
              if (!_isTimeBased) ...[
                const SizedBox(height: 16),
                AppTextFormField(
                  controller: _validityController,
                  title: 'VALIDITY (DAYS)*',
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(() {}),
                  validator: _requiredNumber,
                ),
              ],
              const SizedBox(height: 20),
              _PlanPreview(
                name: _nameController.text,
                price: _priceController.text,
                details: _isTimeBased
                    ? '${_durationController.text} days · Unlimited sessions'
                    : '${_sessionsController.text} sessions · Valid ${_validityController.text} days',
                isTimeBased: _isTimeBased,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 54,
                child: MainButton(
                  onPressed: () {
                    _submit();
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

  String? _requiredNumber(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    final number = int.tryParse(value.trim());
    if (number == null || number < 1) return 'Enter a positive number';
    return null;
  }
}

class _PlanTypeSelector extends StatelessWidget {
  const _PlanTypeSelector({required this.isTimeBased, required this.onChanged});

  final bool isTimeBased;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: AppColors.neutral,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        Expanded(
          child: _PlanTypeOption(
            label: 'Time-based',
            icon: Icons.calendar_today_outlined,
            selected: isTimeBased,
            onTap: () => onChanged(true),
          ),
        ),
        Expanded(
          child: _PlanTypeOption(
            label: 'Session-based',
            icon: Icons.swap_horiz,
            selected: !isTimeBased,
            onTap: () => onChanged(false),
          ),
        ),
      ],
    ),
  );
}

class _PlanTypeOption extends StatelessWidget {
  const _PlanTypeOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
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
                style: AppTextStyles.bodyMedium.copyWith(
                  color: selected ? AppColors.white : AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _PlanPreview extends StatelessWidget {
  const _PlanPreview({
    required this.name,
    required this.price,
    required this.details,
    required this.isTimeBased,
  });

  final String name;
  final String price;
  final String details;
  final bool isTimeBased;

  @override
  Widget build(BuildContext context) => Container(
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
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: const Color(0xFF687500),
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.circle, size: 8, color: AppColors.accent),
                  const SizedBox(width: 5),
                  Text(
                    isTimeBased ? 'Time Pass' : 'Session Pass',
                    style: AppTextStyles.bodyText.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                '$name · $price EGP · $details',
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

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.plan, required this.onDelete});
  final VoidCallback onDelete;
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
                          borderRadius: BorderRadius.circular(6),
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
              onPressed: onDelete,
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
