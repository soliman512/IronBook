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
  factory GymModel.fromMap(Map<String, dynamic> gymData, String gymId){
      return GymModel(
      id: gymId,
      ownerId: gymData['ownerId'],
      name: gymData['name'],
      workStartAt: gymData['workStartAt'],
      workEndAt: gymData['workEndAt'],
    );
  }
}