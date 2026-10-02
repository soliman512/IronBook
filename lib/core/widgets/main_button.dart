import 'package:flutter/material.dart';
import 'package:ironbook/core/constants/app_spacing.dart';

class MainButton extends StatelessWidget {
  const MainButton({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    this.onPressed,
  });

  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 48,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: .circular(16)),
        padding: .all(16),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextTheme.of(context).titleMedium!
                .copyWith(fontSize: 16, color: Colors.white),
          ),
          const SizedBox(width: AppSpacing.sm),
          Icon(icon),
        ],
      ),
    ),
  );
}
