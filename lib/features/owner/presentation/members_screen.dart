import 'package:flutter/material.dart';
import 'package:ironbook/core/constants/app_colors.dart';
import 'package:ironbook/core/constants/app_radius.dart';
import 'package:ironbook/core/widgets/app_switcher.dart';
import 'package:ironbook/features/owner/models/member_models.dart';
import 'package:ironbook/core/widgets/member_request_card.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  static const members = <Member>[
    Member(name: 'Nour Adel', plan: 'Monthly · 18 days left'),
    Member(name: 'Maya Karim', plan: 'Monthly · 12 days left'),
    Member(name: 'Omar Aziz', plan: 'Annual · 94 days left'),
    Member(name: 'Lina Hassan', plan: 'Monthly · 3 days left'),
  ];

  final requests = <MemberRequest>[
    MemberRequest(
      name: 'Omar Hassan',
      plan: 'Monthly',
      requestTime: 'Just now',
      duration: '30 days · Unlimited sessions',
      price: '500 EGP',
    ),
    MemberRequest(
      name: 'Sara Mohamed',
      plan: 'Monthly',
      requestTime: '12 min ago',
      duration: '30 days · 12 sessions',
      price: '450 EGP',
    ),
    MemberRequest(
      name: 'Sara Mohamed',
      plan: 'Monthly',
      requestTime: '12 min ago',
      duration: '30 days · 12 sessions',
      price: '450 EGP',
    ),
    MemberRequest(
      name: 'Youssef Ali',
      plan: 'Annual',
      requestTime: '25 min ago',
      duration: '90 days · Unlimited sessions',
      price: '1,200 EGP',
    ),
    MemberRequest(
      name: 'Youssef Ali',
      plan: 'Annual',
      requestTime: '25 min ago',
      duration: '90 days · Unlimited sessions',
      price: '1,200 EGP',
    ),
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: [
        Text('Members', style: TextTheme.of(context).titleLarge!),
        AppSwitcher(
          selectedIndex: selectedIndex,
          onSelected: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          children: [
            Text(
              'Members · ${members.length}',
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
                    "${requests.length}",
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
                    itemCount: members.length,
                    separatorBuilder: (context, index) =>
                        Divider(color: AppColors.border),
                    itemBuilder: (context, index) {
                      final member = members[index];

                      return Material(
                        color: Colors.transparent,
                        child: ListTile(
                          contentPadding: .zero,
                          leading: CircleAvatar(
                            backgroundColor: AppColors.neutral2,
                            child: Text(
                              member.initials,
                              style: TextTheme.of(context).bodyMedium!
                                  .copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                          title: Text(
                            member.name,
                            style: TextTheme.of(context).bodyMedium!
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(
                            member.plan,
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
                              member.status,
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
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final request = requests[index];
                    return MemberRequestCard(
                      request: request,
                      onReject: () => setState(() => requests.removeAt(index)),
                      onApprove: () => setState(() => requests.removeAt(index)),
                    );
                  },
                ),
        ),
      ],
    ),
  );
}
