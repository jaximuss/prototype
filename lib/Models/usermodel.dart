// lib/Models/usermodel.dart
class UserProfile {
  final String name;
  final String mentalHealthFocus;
  final int daysActive;
  final String profilePictureUrl;

  UserProfile({
    required this.name,
    required this.mentalHealthFocus,
    required this.daysActive,
    required this.profilePictureUrl,
  });
}
