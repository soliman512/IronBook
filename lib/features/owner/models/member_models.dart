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

class Member {
  const Member({
    required this.name,
    required this.plan,
    this.status = 'Active',
  });

  final String name;
  final String plan;
  final String status;

  String get initials => _initialsFromName(name);
}

class MemberRequest {
  const MemberRequest({
    required this.name,
    required this.plan,
    required this.requestTime,
    required this.duration,
    required this.price,
  });

  final String name;
  final String plan;
  final String requestTime;
  final String duration;
  final String price;

  String get initials => _initialsFromName(name);
}
