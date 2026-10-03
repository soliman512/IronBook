import 'package:flutter/material.dart';
import 'package:ironbook/core/constants/app_colors.dart';
import 'package:ironbook/core/constants/app_radius.dart';
import 'package:ironbook/core/widgets/app_switcher.dart';
import 'package:ironbook/features/owner/models/member_request_models.dart';
import 'package:ironbook/core/widgets/member_request_card.dart';
import 'package:ironbook/features/owner/models/subscription_plan_model.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: [
        Text('Members', style: TextTheme.of(context).titleLarge!),
        const SizedBox(height: 18),
        AppSwitcher(
          selectedIndex: selectedIndex,
          onSelected: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          children: [
            Text(
              'Members · ${4}',
              style: TextTheme.of(context).bodyMedium,
            ),
            Row(
              mainAxisAlignment: .center,
              spacing: 6,
              children: [
                Text("Requests", style: TextTheme.of(context).bodyMedium),
                CircleAvatar(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.accent,
                  radius: 10,
                  child: Text(
                    "${3}",
                    style: TextTheme.of(context).bodyMedium!
                        .copyWith(color: AppColors.accent, fontSize: 10),
                  ),
                ),
              ],
            ),
          ],
        ),
        Flexible(
          child: selectedIndex == 0
              /**if the current page is  members*/
              ? Container(
                  margin: .symmetric(vertical: 20),
                  padding: .symmetric(vertical: 14, horizontal: 16),
                  clipBehavior: .antiAlias,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(color: AppColors.border, width: 1),
                    borderRadius: .circular(20),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: 4,
                    separatorBuilder: (context, index) =>
                        Divider(color: AppColors.border),
                    itemBuilder: (context, index) {

                      return Material(
                        color: Colors.transparent,
                        child: ListTile(
                          contentPadding: .zero,
                          leading: CircleAvatar(
                            backgroundColor: AppColors.neutral2,
                            child: Text(
                              'AH',
                              style: TextTheme.of(context).bodyMedium!
                                  .copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                          title: Text(
                            'ahmed',
                            style: TextTheme.of(context).bodyMedium!
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(
                            'member.plan',
                            style: TextTheme.of(context).bodyMedium!.copyWith(
                              color: AppColors.textMuted,
                              fontSize: 10,
                            ),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.successBackground,
                              borderRadius: BorderRadius.circular(
                                AppRadius.pill,
                              ),
                            ),
                            child: Text(
                              'pending',
                              style: TextTheme.of(context).labelSmall!.copyWith(
                                color: AppColors.success,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              : ListView.builder(
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return MemberRequestCard(
                      request: 'request',
                      onReject: () {},
                      onApprove: () {},
                    );
                  },
                ),
        ),
      ],
    ),
  );
}
