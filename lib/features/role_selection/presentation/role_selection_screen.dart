import 'package:flutter/material.dart';
import 'package:ironbook/core/constants/app_images.dart';
import 'package:ironbook/core/constants/app_routes.dart';

import 'package:ironbook/core/constants/app_strings.dart';
import 'package:ironbook/core/constants/app_colors.dart';
import 'package:ironbook/core/extenstions/screen_size_extension.dart';
import 'package:ironbook/core/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: context.screenHeight * .35,
            child: Opacity(
              opacity: .2,
              child: Image.asset(
                AppImages.backgroundShape,
                width: 300,
                fit: .cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              spacing: 40,
              mainAxisAlignment: .start,
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    spacing: 10,
                    children: [
                      Container(
                        padding: .all(6),
                        height: 34,
                        width: 34,
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: .circular(10),
                          shape: BoxShape.rectangle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Text(
                          "i",
                          textAlign: .center,
                          style: TextTheme.of(context).titleMedium!
                              .copyWith(fontSize: 18),
                        ),
                      ),
                      Text(
                        AppStrings.appName,
                        style: TextTheme.of(context).titleLarge!
                            .copyWith(fontSize: 19),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      spacing: 0,
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          "Your gym,\non one card.",
                          style: TextTheme.of(context).displayLarge!
                              .copyWith(height: 0),
                        ),
                        Text(
                          "Choose how you'll use Ironbook.",
                          style: TextTheme.of(context).bodyMedium!
                              .copyWith(color: AppColors.textMuted),
                        ),
                        const Spacer(),
                        RoleOptionCard(
                          cardColor: AppColors.primary,
                          icon: Icons.home_outlined,
                          iconBackgroundColor: AppColors.accent,
                          iconColor: AppColors.primary,
                          title: 'Gym Owner',
                          titleForegroundColor: AppColors.white,
                          subtitle: 'Manage plans, approve members, chat.',
                          subtitleForegroundColor: const Color(0xFFB5B2AA),
                          onTap: () {
                            context.read<AuthProvider>().setUserGymMode =
                                UserGymMode.owner;
                            Navigator.pushNamed(context, AppRoutes.auth);
                          },
                        ),
                        const SizedBox(height: 14),
                        RoleOptionCard(
                          cardColor: AppColors.white,
                          icon: Icons.person_outline,
                          iconBackgroundColor: AppColors.border,
                          iconColor: AppColors.primary,
                          title: 'Gym Member',
                          titleForegroundColor: AppColors.primary,
                          subtitle: 'Join with a Gym ID and track your plan.',
                          subtitleForegroundColor: const Color(0xFFB5B2AA),
                          onTap: () {
                            context.read<AuthProvider>().setUserGymMode =
                                UserGymMode.member;
                            Navigator.pushNamed(context, AppRoutes.auth);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          //loading:
          Visibility(
            visible: false,
            child: Container(
              color: Colors.black.withValues(alpha: 0.35),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const CircularProgressIndicator(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RoleOptionCard extends StatelessWidget {
  const RoleOptionCard({
    super.key,
    required this.cardColor,
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.title,
    required this.titleForegroundColor,
    required this.subtitle,
    required this.subtitleForegroundColor,
    required this.onTap,
  });

  final Color cardColor;
  final IconData icon;
  final Color iconBackgroundColor;
  final Color iconColor;
  final String title;
  final Color titleForegroundColor;
  final String subtitle;
  final Color subtitleForegroundColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Container(
    margin: .zero,
    padding: .symmetric(vertical: 10, horizontal: 20),
    alignment: .center,
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 4)),
      ],
      color: cardColor,
      borderRadius: .circular(22),
      border: .all(color: AppColors.border),
    ),
    child: Material(
      child: ListTile(
        onTap: onTap,
        contentPadding: .zero,
        tileColor: cardColor,
        leading: Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: iconBackgroundColor,
            borderRadius: .circular(14),
          ),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(
          title,
          style: TextTheme.of(context).titleMedium!
              .copyWith(fontSize: 18, color: titleForegroundColor),
        ),
        subtitle: Text(
          subtitle,
          style: TextTheme.of(context).bodyMedium!.copyWith(
            fontSize: 13,
            fontWeight: .w200,
            color: subtitleForegroundColor,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          color: titleForegroundColor,
        ),
      ),
    ),
  );
}
