class UserDTO {
  final String? username;
  final String? email;
  final String? fullName;
  final String? avatar;
  final int? hearts;
  final int? experience;
  final int? streak;
  final String? languages;

  UserDTO(
      {required this.username,
      required this.email,
      required this.fullName,
      required this.avatar,
      required this.hearts,
      required this.experience,
      required this.streak,
      required this.languages});
}
