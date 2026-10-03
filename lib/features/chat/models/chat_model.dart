class ChatModel {
  const ChatModel({
    required this.id,
    required this.memberId,
    required this.ownerId,
    required this.gymId,
    required this.createdAt,
    this.lastMessage,
    this.lastMessageAt,
  });

  final String id;
  final String memberId;
  final String ownerId;
  final String gymId;
  final DateTime createdAt;
  final String? lastMessage;
  final DateTime? lastMessageAt;
}