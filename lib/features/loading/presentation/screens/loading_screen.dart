import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ironbook/core/constants/app_colors.dart';
import 'package:ironbook/features/loading/providers/loading_provider.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: context.watch<LoadingProvider>().getLoadingStatus,
      child: Stack(
        alignment: .center,
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Container(color: Colors.black26),
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
