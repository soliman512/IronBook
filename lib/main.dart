import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:ironbook/core/constants/app_routes.dart';
import 'package:ironbook/core/constants/app_strings.dart';
import 'package:ironbook/features/auth/providers/auth_provider.dart';
import 'package:ironbook/core/theme/app_theme.dart';
import 'package:ironbook/features/auth/providers/gym_provider.dart';
import 'package:ironbook/features/loading/presentation/screens/loading_screen.dart';
import 'package:ironbook/features/loading/providers/loading_provider.dart';
import 'package:ironbook/features/member/providers/member_ship_provider.dart';
import 'package:ironbook/firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
        runApp(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => AuthProvider()),
              ChangeNotifierProvider(create: (_) => LoadingProvider()),
              ChangeNotifierProvider(create: (_) => GymProvider()),
              ChangeNotifierProvider(create: (_) => MembershipProvider()),
            ],

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
        systemNavigationBarColor: Colors.transparent,
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppStrings.appName,
        theme: AppTheme.light,
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,
        builder: (context, child) =>
            Stack(children: [child!, const LoadingScreen()]),
      ),
    );
  }
}
