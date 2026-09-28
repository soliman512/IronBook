import 'package:flutter/material.dart';

import 'package:ironbook/constants/app_strings.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Text(
        AppStrings.chat,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    ),
  );
}
