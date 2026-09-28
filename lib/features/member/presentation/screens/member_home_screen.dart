import 'package:flutter/material.dart';

import 'package:ironbook/constants/app_strings.dart';

class MemberHomeScreen extends StatelessWidget {
  const MemberHomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Text(
        AppStrings.memberHome,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    ),
  );
}
