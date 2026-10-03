enum SubscriptionPlanType { timeBased, sessionBased }

class SubscriptionPlan {
  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    this.durationInDays,
    this.sessionCount,
    this.validityInDays,
    required this.gymId,
  });

  final String id;
  final String name;
  final SubscriptionPlanType type;
  final double price;

  final int? durationInDays;
  final int? sessionCount;
  final int? validityInDays;

  final String gymId;
}
