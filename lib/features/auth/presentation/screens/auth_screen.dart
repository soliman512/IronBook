import 'package:flutter/material.dart';

import 'package:ironbook/constants/app_strings.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Text(
        AppStrings.auth,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    ),
  );
}
