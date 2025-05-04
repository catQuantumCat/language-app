class RegisterModel {
  final String username;
  final String email;
  final String password;
  final String fullName;

  RegisterModel({
    required this.username,
    required this.email,
    required this.password,
    required this.fullName,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'fullName': fullName,
    };
  }
}
