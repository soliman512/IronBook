import 'package:flutter/material.dart';

import 'package:ironbook/constants/app_strings.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Text(
        AppStrings.roleSelection,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    ),
  );
}
