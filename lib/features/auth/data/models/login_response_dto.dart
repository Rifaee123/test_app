class LoginResponseModel {
  final String? token;
  final String? username;
  final String? role;
  final String? studentId;

  LoginResponseModel({this.token, this.username, this.role, this.studentId});

  // Factory constructor to create a model from JSON
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json['token'] as String?,
      username: json['username'] as String?,
      role: json['role'] as String?,
      studentId: json['studentId'] as String?,
    );
  }

  // Method to convert model back to JSON (useful for local storage)
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'username': username,
      'role': role,
      'studentId': studentId,
    };
  }
}
