import 'package:flutter/material.dart';
import 'package:ironbook/core/constants/app_colors.dart';
import 'package:ironbook/core/constants/app_text_styles.dart';
import 'package:ironbook/core/extenstions/screen_size_extension.dart';

//navbar ui
class AppBottomNavigationBar<T> extends StatelessWidget {
  const AppBottomNavigationBar({
    required this.items,
    required this.selectedPage,
    required this.onSelect,
    super.key,
  });

  final List<AppNavigationItem<T>> items;
  final T selectedPage;
  final ValueChanged<T> onSelect;

  @override
  Widget build(BuildContext context) => Container(
    height: context.screenHeight * .1,
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: AppColors.white,
      border: Border(top: BorderSide(color: AppColors.border)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (final item in items)
          NavigationItem<T>(
            item: item,
            selected: selectedPage == item.page,
            onTap: () => onSelect(item.page),
          ),
      ],
    ),
  );
}

//ui
class NavigationItem<T> extends StatelessWidget {
  const NavigationItem({
    required this.item,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final AppNavigationItem<T> item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: selected ? AppColors.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            item.icon,
            size: 20,
            color: selected ? AppColors.primary : AppColors.secondary,
          ),
        ),
        Text(
          item.label,
          style: AppTextStyles.monoLabel.copyWith(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? AppColors.primary : AppColors.secondary,
          ),
        ),
      ],
    ),
  );
}

//model
class AppNavigationItem<T> {
  const AppNavigationItem({
    required this.page,
    required this.label,
    required this.icon,
  });

  final T page;
  final String label;
  final IconData icon;
}
