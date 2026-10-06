import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ironbook/core/constants/app_colors.dart';
import 'package:ironbook/core/constants/app_routes.dart';
import 'package:ironbook/features/loading/providers/loading_provider.dart';
import 'package:provider/provider.dart';

class LogoutButton extends StatelessWidget {
  const new({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Logout'),
              content: const Text(
                'Are you sure you want to logout?',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    context.read<LoadingProvider>().show();
                    await FirebaseAuth.instance.signOut();
                    if(!context.mounted) return;
                    Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.roleSelection,
                    );
                    context.read<LoadingProvider>().hide();
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.danger,
                  ),
                  child: const Text('Logout'),
                ),
              ],
            );
          },
        );
      },
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
    );
  }
}
