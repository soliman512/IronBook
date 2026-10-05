import 'dart:math';

String generateGymId() {
  const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  final random = Random();

  String firstPart = List.generate(
    3,
    (_) => letters[random.nextInt(letters.length)],
  ).join();

  final secondPart = List.generate(
    4,
    (_) => random.nextInt(10),
  ).join();

  return '$firstPart-$secondPart';
}