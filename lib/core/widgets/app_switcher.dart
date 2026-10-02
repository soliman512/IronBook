import 'package:flutter/material.dart';
import 'package:ironbook/core/constants/app_colors.dart';

class AppSwitcher extends StatelessWidget {
  const AppSwitcher({
    required this.children,
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  final List<Widget> children;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.neutral,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          for (var i = 0; i < children.length; i++)
            Expanded(
              child: GestureDetector(
                onTap: () => onSelected(i),
                child: Container(
                  height: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: i == selectedIndex
                        ? AppColors.white
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: children[i],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
