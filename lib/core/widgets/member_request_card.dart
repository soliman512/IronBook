import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ironbook/core/constants/app_colors.dart';
import 'package:ironbook/features/owner/models/member_models.dart';

class MemberRequestCard extends StatelessWidget {
  const MemberRequestCard({
    required this.request,
    required this.onReject,
    required this.onApprove,
    super.key,
  });

  final MemberRequest request;
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
                    request.initials,
                    style: GoogleFonts.libertinusSerif(
                      fontSize: 14,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.name,
                        style: GoogleFonts.libertinusSerif(
                          fontSize: 14,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${request.plan} · ${request.requestTime}',
                        style: GoogleFonts.libertinusSerif(
                          fontSize: 12,
                          color: AppColors.secondary,
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
                    style: GoogleFonts.libertinusSerif(
                      fontSize: 12,
                      color: AppColors.primary,
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
                      request.duration,
                      style: GoogleFonts.libertinusSerif(
                        fontSize: 14,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  Text(
                    request.price,
                    style: GoogleFonts.libertinusSerif(
                      fontSize: 16,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
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
                      style: GoogleFonts.libertinusSerif(
                        fontSize: 14,
                        color: AppColors.danger,
                        fontWeight: FontWeight.w700,
                      ),
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
                      style: GoogleFonts.libertinusSerif(
                        fontSize: 14,
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                      ),
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
