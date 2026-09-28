import 'package:flutter/material.dart';

import 'package:ironbook/constants/app_strings.dart';

class OwnerHomeScreen extends StatelessWidget {
  const OwnerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Text(
        AppStrings.ownerHome,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    ),
  );
}
