import 'package:flutter/material.dart';

import 'package:ironbook/constants/app_routes.dart';
import 'package:ironbook/constants/app_strings.dart';
import 'package:ironbook/theme/app_theme.dart';

void main() {
  runApp(const IronbookApp());
}

class IronbookApp extends StatelessWidget {
  const IronbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppStrings.appName,
        theme: AppTheme.light,
        initialRoute: AppRoutes.roleSelection,
        routes: AppRoutes.routes,
      ),
    );
  }
}
