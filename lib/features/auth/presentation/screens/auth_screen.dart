import 'package:flutter/material.dart';
import 'package:ironbook/core/constants/app_routes.dart';

import 'package:ironbook/core/constants/app_colors.dart';
import 'package:ironbook/core/constants/app_radius.dart';
import 'package:ironbook/core/constants/app_spacing.dart';
import 'package:ironbook/core/constants/app_text_styles.dart';
import 'package:ironbook/core/providers/auth_provider.dart';
import 'package:ironbook/core/widgets/app_text_form_field.dart';
import 'package:ironbook/core/widgets/main_button.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  //login vars
  final loginFormKey = GlobalKey<FormState>();
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  //register vars
  final registerFormKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final gymNameController = TextEditingController();
  final openingTimeController = TextEditingController();
  final closingTimeController = TextEditingController();
  final registerEmailController = TextEditingController();
  final registerPasswordController = TextEditingController();

  bool isLoginSection = true;
  bool termsAccepted = false;

  @override
  void dispose() {
    loginEmailController.dispose();
    loginPasswordController.dispose();

    fullNameController.dispose();
    phoneController.dispose();
    gymNameController.dispose();
    openingTimeController.dispose();
    closingTimeController.dispose();
    registerEmailController.dispose();
    registerPasswordController.dispose();

    super.dispose();
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    if (!value.contains('@')) {
      return 'Enter a valid email';
    }

    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }

    return null;
  }

  String? validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }

    return null;
  }

  Future<void> selectTime(
    BuildContext context,
    TextEditingController controller, {
    required TimeOfDay initialTime,
  }) async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (!mounted || selectedTime == null) {
      return;
    } else {
      controller.text = MaterialLocalizations.of(context)
          .formatTimeOfDay(selectedTime);
    }
  }

  void login() {
    if (!loginFormKey.currentState!.validate()) {
      return;
    }
  }

  void register({required bool isOwner}) {
    if (isOwner) {
      Navigator.pushNamed(context, AppRoutes.ownerShell);
    }
    if (!termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the terms to continue.')),
      );
    }
    if (!registerFormKey.currentState!.validate()) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mode = context.watch<AuthProvider>().getUserGymMode;
    final isOwner = mode == UserGymMode.owner;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const .all(24),
        child: isLoginSection ? _buildLogin(mode) : _buildRegister(isOwner),
      ),
    );
  }

  // =========================
  // Login UI
  // =========================

  Widget _buildLogin(UserGymMode? mode) {
    return Form(
      key: loginFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(mode: mode, isRegister: false),
          const SizedBox(height: 24),
          _buildAuthSwitcher(),
          const SizedBox(height: 24),
          AppTextFormField(
            title: 'Email',
            controller: loginEmailController,
            hintText: 'name@example.com',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: validateEmail,
          ),
          const SizedBox(height: 16),
          AppTextFormField(
            title: 'Password',
            controller: loginPasswordController,
            hintText: 'Enter your password',
            obscureText: true,
            textInputAction: TextInputAction.done,
            validator: validatePassword,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text('Forgot password?'),
            ),
          ),
          const SizedBox(height: 120),
          SizedBox(
            height: 54,
            child: MainButton(
              title: 'Log in',
              icon: Icons.arrow_forward_ios,
              color: AppColors.primary,
              onPressed: login,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // =========================
  // Register UI
  // =========================

  Widget _buildRegister(bool isOwner) {
    return Form(
      key: registerFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(
            mode: isOwner ? UserGymMode.owner : UserGymMode.member,
            isRegister: true,
          ),
          const SizedBox(height: 24),
          _buildAuthSwitcher(),
          const SizedBox(height: 24),
          AppTextFormField(
            title: 'Full name',
            controller: fullNameController,
            hintText: 'Enter your full name',
            textInputAction: TextInputAction.next,
            validator: validateFullName,
          ),
          const SizedBox(height: 16),
          AppTextFormField(
            title: 'Phone number',
            controller: phoneController,
            hintText: '+1 (555) 000-0000',
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            validator: validateRequired,
          ),
          if (isOwner) ...[
            const SizedBox(height: 16),
            AppTextFormField(
              title: 'Gym name',
              controller: gymNameController,
              hintText: 'Enter your gym name',
              textInputAction: TextInputAction.next,
              validator: validateRequired,
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AppTextFormField(
                    title: 'From',
                    controller: openingTimeController,
                    hintText: 'Opening time',
                    readOnly: true,
                    onTap: () => selectTime(
                      context,
                      openingTimeController,
                      initialTime: const TimeOfDay(hour: 6, minute: 0),
                    ),
                    validator: validateRequired,
                    suffixIcon: const Icon(Icons.schedule_outlined),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: AppTextFormField(
                    title: 'To',
                    controller: closingTimeController,
                    hintText: 'Closing time',
                    readOnly: true,
                    onTap: () => selectTime(
                      context,
                      closingTimeController,
                      initialTime: const TimeOfDay(hour: 22, minute: 0),
                    ),
                    validator: validateRequired,
                    suffixIcon: const Icon(Icons.schedule_outlined),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          AppTextFormField(
            title: 'Email',
            controller: registerEmailController,
            hintText: 'name@example.com',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: validateEmail,
          ),
          const SizedBox(height: 16),
          AppTextFormField(
            title: 'Password',
            controller: registerPasswordController,
            hintText: 'At least 6 characters',
            obscureText: true,
            textInputAction: TextInputAction.done,
            validator: validatePassword,
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: termsAccepted,
                  onChanged: (value) => setState(() {
                    termsAccepted = value ?? false;
                  }),
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  'I agree to receive updates and accept the terms.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 11,
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 54,
            child: MainButton(
              title: 'Create account',
              icon: Icons.arrow_forward_rounded,
              color: AppColors.primary,
              onPressed: () => register(isOwner: isOwner),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              'SECURED BY  IRONBOOK ONE',
              style: AppTextStyles.monoLabel.copyWith(fontSize: 9),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildHeader({required UserGymMode? mode, required bool isRegister}) {
    final modeLabel = mode == UserGymMode.owner ? 'GYM OWNER' : 'GYM MEMBER';
    final subtitle = switch ((isRegister, mode)) {
      (true, UserGymMode.owner) => 'Set up your owner account and gym.',
      (true, _) => 'Register, then join your gym with its ID.',
      (false, UserGymMode.owner) => 'Log in to manage your gym.',
      (false, _) => 'Log in to access your membership.',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.white,
                foregroundColor: AppColors.primary,
                minimumSize: const Size(40, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 15),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Text(
                modeLabel,
                style: AppTextStyles.monoLabel.copyWith(
                  color: AppColors.accent,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          isRegister ? 'Create account' : 'Welcome back',
          style: AppTextStyles.authHeader,
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: AppTextStyles.bodyMedium.copyWith(
            fontSize: 12,
            color: AppColors.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildAuthSwitcher() {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.neutral,
        borderRadius: .circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: _authTab(
              title: 'Log in',
              selected: isLoginSection,
              onTap: () {
                setState(() {
                  isLoginSection = true;
                });
              },
            ),
          ),
          Expanded(
            child: _authTab(
              title: 'Register',
              selected: !isLoginSection,
              onTap: () {
                setState(() {
                  isLoginSection = false;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _authTab({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: double.infinity,
        alignment: .center,
        decoration: BoxDecoration(
          color: selected ? AppColors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            fontSize: 14,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? AppColors.primary : AppColors.secondary,
          ),
        ),
      ),
    );
  }
}
