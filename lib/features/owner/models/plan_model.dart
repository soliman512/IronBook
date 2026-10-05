enum SubscriptionPlanType { timeBased, sessionBased }

class SubscriptionPlan {
  const SubscriptionPlan({
    this.id,
    required this.name,
    required this.type,
    required this.price,
    this.durationInDays,
    this.sessionCount,
    this.validityInDays,
    required this.gymId,
  });

  final String? id;
  final String name;
  final SubscriptionPlanType type;
  final double price;
  final int? durationInDays;
  final int? sessionCount;
  final int? validityInDays;
  final String gymId;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type.name,
      'price': price,
      'durationInDays': durationInDays,
      'sessionCount': sessionCount,
      'validityInDays': validityInDays,
      'gymId': gymId,
    };
  }

  factory SubscriptionPlan.fromMap(Map<String, dynamic> map, String id) {
    return SubscriptionPlan(
      id: id,
      name: map['name'],
      type: SubscriptionPlanType.values.byName(map['type']),
      price: (map['price'] as num).toDouble(),
      durationInDays: map['durationInDays'],
      sessionCount: map['sessionCount'],
      validityInDays: map['validityInDays'],
      gymId: map['gymId'],
    );
  }
}
