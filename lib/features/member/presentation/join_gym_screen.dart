import 'package:flutter/material.dart';

import 'package:ironbook/core/constants/app_strings.dart';

class JoinGymScreen extends StatelessWidget {
  const JoinGymScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Text(
        AppStrings.joinGym,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    ),
  );
}
