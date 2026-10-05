///data:
///id
///ownerId
///plans
///type from enum type{timeBased, sessionBased}
///name
///price
///work start at
///work end at
///
///
///
class GymModel {
  const GymModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.workStartAt,
    required this.workEndAt,
  });
  final String id;
  final String ownerId;
  final String name;
  final String workStartAt;
  final String workEndAt;

  Map<String, dynamic> toMap(){
    return {
      'ownerId' : ownerId,
      'name' : name,
      'workStartAt' : workStartAt,
      'workEndAt' : workEndAt,
    };
  }
}