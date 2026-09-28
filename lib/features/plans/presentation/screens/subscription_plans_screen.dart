import 'package:flutter/material.dart';

import 'package:ironbook/constants/app_strings.dart';

class SubscriptionPlansScreen extends StatelessWidget {
  const SubscriptionPlansScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Text(
        AppStrings.subscriptionPlans,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    ),
  );
}
