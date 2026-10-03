import 'package:ironbook/features/owner/models/subscription_plan_model.dart';

String _initialsFromName(String name) {
   final words = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((word) => word.isNotEmpty);

  if (words.isEmpty) {
    return '';
  }

  final nameParts = words.toList();
  if (nameParts.length == 1) {
    return nameParts.first[0].toUpperCase();
  }

  return '${nameParts.first[0]}${nameParts.last[0]}'.toUpperCase();
}

// class MemberRequest {
//   const MemberRequest({
//     required this.name,
//     required this.plan,
//     required this.requestTime,
//     required this.duration,
//     required this.price,
//   });

//   final String name;
//   final SubscriptionPlan plan;
//   final String requestTime;
//   final String duration;
//   final String price;

//   String get initials => _initialsFromName(name);
// }
