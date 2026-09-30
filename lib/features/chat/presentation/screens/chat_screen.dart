import 'package:flutter/material.dart';

import 'package:ironbook/core/constants/app_strings.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) => Center(
    child: Text(AppStrings.chat, style: Theme.of(context).textTheme.titleLarge),
  );
}
