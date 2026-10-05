import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ironbook/core/constants/app_colors.dart';
import 'package:ironbook/core/constants/app_images.dart';
import 'package:ironbook/core/constants/app_routes.dart';
import 'package:ironbook/core/extenstions/screen_size_extension.dart';

class SplashScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 2000), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.roleSelection);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset(AppImages.splashBackground, fit: .cover),
          ),
          BackdropFilter(
            filter: .blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(
                  255,
                  112,
                  112,
                  112,
                ).withValues(alpha: .6),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  const Spacer(),
                  // Logo
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: context.screenWidth * .34,
                        height: context.screenWidth * .34,
                        child: CircularProgressIndicator(
                          strokeWidth: 6,
                          valueColor: AlwaysStoppedAnimation(AppColors.primary),
                          backgroundColor: AppColors.accent.withValues(
                            alpha: .7,
                          ),
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: .25),
                              blurRadius: 30,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 48,
                          backgroundImage: AssetImage(AppImages.appLogo),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // App name
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -.5,
                      ),
                      children: [
                        TextSpan(
                          text: 'Iron',
                          style: const TextStyle(color: AppColors.accent),
                        ),
                        TextSpan(
                          text: 'Book',
                          style: const TextStyle(color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Tagline
                  Text(
                    'Your gym. Your goals. \nOne place.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.accent.withValues(alpha: .65),
                      fontWeight: FontWeight.w500,
                      letterSpacing: .2,
                    ),
                  ),
                  const Spacer(),

                  SizedBox(
                    width: context.screenWidth * .8,
                    child: Row(
                      mainAxisAlignment: .start,
                      crossAxisAlignment: .center,
                      spacing: 12,
                      children: [
                        Image.asset(
                          AppImages.appLogoWithoutBackground,
                          fit: .contain,
                          color: AppColors.primary,
                          width: 40,
                        ),
                        Text(
                          'please wait...\nwe set all thing for you',
                          style: TextTheme.of(context).bodyMedium,
                          textAlign: .start,
                        ),
                      ],
                    ),
                  ),

                  // SizedBox(
                  //   width: context.screenWidth * .4,
                  //   child: Row(
                  //     children: [
                  //       Column(
                  //         children: [
                  //           Text('we set all thing for you...'),
                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
