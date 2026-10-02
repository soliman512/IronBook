import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:ironbook/core/constants/app_routes.dart';
import 'package:ironbook/core/constants/app_strings.dart';
import 'package:ironbook/core/providers/auth_provider.dart';
import 'package:ironbook/core/theme/app_theme.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
        runApp(
          MultiProvider(
            providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],

            child: const IronbookApp(),
          ),
        );
      });
}

class IronbookApp extends StatelessWidget {
  const IronbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,),
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
