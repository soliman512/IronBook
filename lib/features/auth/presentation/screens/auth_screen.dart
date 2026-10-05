import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ironbook/core/constants/app_routes.dart';
import 'package:ironbook/core/constants/app_colors.dart';
import 'package:ironbook/core/constants/app_radius.dart';
import 'package:ironbook/features/auth/models/generate_auto_gym_id.dart';
import 'package:ironbook/features/auth/models/gym_model.dart';
import 'package:ironbook/features/auth/models/user_model.dart';
import 'package:ironbook/features/auth/providers/auth_provider.dart';
import 'package:ironbook/core/global_widgets/app_switcher.dart';
import 'package:ironbook/core/global_widgets/app_text_form_field.dart';
import 'package:ironbook/core/global_widgets/main_button.dart';
import 'package:ironbook/features/auth/providers/gym_provider.dart';
import 'package:ironbook/features/auth/services/auth_services.dart';
import 'package:ironbook/features/auth/services/gym_services.dart';
import 'package:ironbook/features/loading/providers/loading_provider.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLoginSection = true;
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

  void register({required bool isOwner}) async {
    //check form state
    if (registerFormKey.currentState!.validate()) {
      // check terms accept
      if (!termsAccepted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please accept the terms to continue.'),
            backgroundColor: AppColors.danger,
          ),
        );
        // stop method if terms not accepted
        return;
      }
      //complete if accepted (else)
      if (isOwner) {
        //if the user is owner
        context.read<LoadingProvider>().show();
        String? userId = await AuthServices.signup(
          emailAddress: registerEmailController.text,
          password: registerPasswordController.text,
        );
        if (userId == null || userId.isEmpty) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('there is problem, please try again'),
              backgroundColor: AppColors.danger,
            ),
          );
          context.read<LoadingProvider>().hide();
          return;
        }
        if (userId == 'weak-password') {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('weak password'),
              backgroundColor: AppColors.warning,
            ),
          );
          context.read<LoadingProvider>().hide();
          return;
        } else if (userId == 'email-already-in-use') {
          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('this email is already exist.'),
              backgroundColor: AppColors.warning,
            ),
          );

          context.read<LoadingProvider>().hide();
          return;
        }
        //if user id done :
        // context.read<AuthProvider>().setUserGymMode = UserGymMode.owner;
        try {
          final UserModel userModel = UserModel(
            id: userId,
            email: registerEmailController.text,
            fullName: fullNameController.text,
            phone: phoneController.text,
            role: UserGymMode.owner,
          );
          await AuthServices.createUserDocument(userModel);

          if (!mounted) return;
          context.read<AuthProvider>().setUser = userModel;
        } catch (e) {
          if (!mounted) return;

          context.read<LoadingProvider>().hide();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'There is a problem saving your data. Please try again.',
              ),
              backgroundColor: AppColors.danger,
            ),
          );

          context.read<LoadingProvider>().hide();
          return;
        }

        //add gym to gyms collection
        if (!mounted) return;
        final gym = await GymServices.createGymDocument(
          GymModel(
            id: generateGymId(),
            ownerId: context.read<AuthProvider>().getUser!.id,
            name: gymNameController.text,
            workStartAt: openingTimeController.text,
            workEndAt: closingTimeController.text,
          ),
        );

        if (!mounted) return;
context.read<GymProvider>().setGym = gym;
        context.read<LoadingProvider>().hide();

        Navigator.pushNamed(context, AppRoutes.ownerShell);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('you\'re signed up successfully.'),
            backgroundColor: AppColors.success,
          ),
        );
        return;
      } else {
        //TODO: if the user is member
        Navigator.pushNamed(context, AppRoutes.memberShell);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mode = context.watch<AuthProvider>().getUserGymMode;
    final isOwner = mode == UserGymMode.owner;
    final selectedIndex = isLoginSection ? 0 : 1;

    final Widget fields;
    if (isLoginSection) {
      fields = _buildLoginFields();
    } else if (isOwner) {
      fields = _buildOwnerRegisterFields();
    } else {
      fields = _buildMemberRegisterFields();
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //top bar
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    isOwner ? 'GYM OWNER' : 'GYM MEMBER',
                    style: TextTheme.of(context).labelSmall!
                        .copyWith(color: AppColors.accent, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              isLoginSection ? 'Welcome back' : 'Create account',
              style: TextTheme.of(context).headlineMedium!,
            ),
            Text(
              isLoginSection
                  ? 'Sign in to continue.'
                  : 'Create an account to continue.',
              style: TextTheme.of(context).bodyMedium!
                  .copyWith(fontSize: 12, color: AppColors.secondary),
            ),
            const SizedBox(height: 24),
            AppSwitcher(
              selectedIndex: selectedIndex,
              onSelected: (index) {
                setState(() {
                  isLoginSection = index == 0;
                });
              },
              children: [
                Text(
                  'Login',
                  style: TextTheme.of(context).bodyMedium!.copyWith(
                    fontSize: 14,
                    fontWeight: selectedIndex == 0
                        ? FontWeight.w600
                        : FontWeight.w400,
                    color: selectedIndex == 0
                        ? AppColors.primary
                        : AppColors.secondary,
                  ),
                ),
                Text(
                  'Register',
                  style: TextTheme.of(context).bodyMedium!.copyWith(
                    fontSize: 14,
                    fontWeight: selectedIndex == 1
                        ? FontWeight.w600
                        : FontWeight.w400,
                    color: selectedIndex == 1
                        ? AppColors.primary
                        : AppColors.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Form(
              key: isLoginSection ? loginFormKey : registerFormKey,
              child: fields,
            ),
          ],
        ),
      ),
    );
  }

  //shared (Login fields)
  Widget _buildLoginFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        // Align(
        //   alignment: Alignment.centerRight,
        //   child: TextButton(
        //     onPressed: () {},
        //     child: const Text('Forgot password?'),
        //   ),
        // ),
        const SizedBox(height: 60),
        SizedBox(
          height: 54,
          child: MainButton(
            title: 'Log in',
            icon: Icons.arrow_forward_ios,
            color: AppColors.primary,
            onPressed: () async {
              context.read<LoadingProvider>().show();
              await Future.delayed(const Duration(seconds: 3));
              login();
              if (!mounted) return;
              context.read<LoadingProvider>().hide();
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  //member register
  Widget _buildMemberRegisterFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          hintText: '01*********',
          maxLength: 11,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,

          validator: validateRequired,
        ),
        const SizedBox(height: 16),
        ..._buildRegisterAccountFields(isOwner: false),
      ],
    );
  }

  //owner regiseter
  Widget _buildOwnerRegisterFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          hintText: '01*********',
          maxLength: 11,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          validator: validateRequired,
        ),
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
            const SizedBox(width: 8),
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
        const SizedBox(height: 16),
        ..._buildRegisterAccountFields(isOwner: true),
      ],
    );
  }

  List<Widget> _buildRegisterAccountFields({required bool isOwner}) {
    return [
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
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              'I agree to receive updates and accept the terms.',
              style: TextTheme.of(context).bodyMedium!
                  .copyWith(fontSize: 11, color: AppColors.secondary),
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
          style: TextTheme.of(context).labelSmall!.copyWith(fontSize: 9),
        ),
      ),
      const SizedBox(height: 16),
    ];
  }
}
