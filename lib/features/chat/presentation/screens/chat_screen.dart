import 'package:flutter/material.dart';

import 'package:ironbook/core/constants/app_colors.dart';
import 'package:ironbook/core/constants/app_images.dart';
import 'package:ironbook/core/global_widgets/app_text_form_field.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(
      children: [
        ListTile(
          contentPadding: .symmetric(horizontal: 12),
          tileColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: .circular(30),
            side: BorderSide(color: AppColors.white),
          ),
          leading: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'I',
                  style: TextTheme.of(context).headlineMedium!
                      .copyWith(color: AppColors.accent, fontSize: 32),
                ),
              ),
              Positioned(
                right: -1,
                bottom: -1,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.background, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent,
                        blurRadius: 2,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          title: Text(
            'Iron Yard Gym',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextTheme.of(context).bodySmall!
                .copyWith(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          subtitle: Text.rich(
            TextSpan(
              style: TextTheme.of(context).bodySmall!
                  .copyWith(color: AppColors.secondary, fontSize: 12),
              children: const [
                TextSpan(text: 'Tarek Mansour'),
                TextSpan(text: '  •  Owner  •  '),
                TextSpan(
                  text: 'Online',
                  style: TextStyle(color: AppColors.success, fontWeight: .w600),
                ),
              ],
            ),
          ),
          trailing: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 3,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: IconButton(
              tooltip: 'More options',
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert,
                color: AppColors.primary,
                size: 16,
              ),
            ),
          ),
        ),
        Expanded(
          child: Stack(
            alignment: .center,
            children: [
              Opacity(
                opacity: .04,
                child: Image.asset(AppImages.chatBackground, fit: .cover),
              ),
              //body:
              Column(
                children: [
                  //: chat will be here
                  Expanded(
                    child: Center(
                      child: Text(
                        'chat messages',
                        style: TextTheme.of(context).bodySmall!
                            .copyWith(fontSize: 32),
                      ),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: .spaceBetween,
                    crossAxisAlignment: .center,
                    children: [
                      Expanded(
                        child: AppTextFormField(
                          controller: messageController,
                          hintText: 'write any thing..',
                        ),
                      ),
                      const SizedBox(width: 10),
                      ValueListenableBuilder(
                        valueListenable: messageController,
                        builder: (context, value, child) {
                          return GestureDetector(
                            onTap: value.text.isEmpty ? null : () {},
                            child: CircleAvatar(
                              radius: 25,
                              foregroundColor: AppColors.primary,
                              backgroundColor: value.text.isEmpty
                                  ? AppColors.border
                                  : AppColors.accent,

                              child: const Icon(Icons.send_rounded, size: 20),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
