import 'package:flutter/material.dart';
import 'package:ironbook/core/constants/app_colors.dart';

class MemberRequestCard extends StatelessWidget {
  const MemberRequestCard({
    required this.request,
    required this.onReject,
    required this.onApprove,
    super.key,
  });

  final String request;
  final VoidCallback onReject;
  final VoidCallback onApprove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .only(top: 6),
      child: Container(
        padding: const .all(16),
        margin: .symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          spacing: 14,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.neutral2,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'AK',
                    style: TextTheme.of(context).bodySmall!,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'request.name',
                        style: TextTheme.of(context).bodySmall!,
                      ),
                      Text(
                        '${'request.plan'} · ${'request.requestTime'}',
                        style: TextTheme.of(context).bodySmall!.copyWith(
                          fontSize: 12,
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                //status
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.neutral,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Pending',
                    style: TextTheme.of(context).bodySmall!.copyWith(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const .all(12),
              decoration: BoxDecoration(
                color: AppColors.neutral2,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'request.duration',
                      style: TextTheme.of(context).bodySmall!.copyWith(
                        fontWeight: FontWeight.w400,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                  Text(
                    'request.price',
                    style: TextTheme.of(context).bodySmall!
                        .copyWith(fontSize: 16),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: ElevatedButton(
                    onPressed: onReject,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.neutral,
                      foregroundColor: AppColors.danger,
                      padding: .symmetric(vertical: 12),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Reject',
                      style: TextTheme.of(context).bodySmall!
                          .copyWith(color: AppColors.danger),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 6,
                  child: ElevatedButton(
                    onPressed: onApprove,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      padding: .symmetric(vertical: 12),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Approve',
                      style: TextTheme.of(context).bodySmall!
                          .copyWith(color: AppColors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
