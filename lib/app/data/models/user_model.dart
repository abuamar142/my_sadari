// user_model.dart
class User {
  final String idUser;
  final String email;
  final String? password;
  final String username;
  final String name;
  final String birthdate;
  final String address;
  final String phone;
  final String gender;
  final String marriageStatus;
  final String lastEducation;
  final String job;
  final int age;
  final String maritalStatus;
  final String educationLevel;
  final String currentJob;
  final String fieldOfStudy;
  final String educationalBackground;
  final String stayWith;
  final String bodyWeight;
  final String bodyHeight;
  final String status;
  final String? resetPasswordToken;
  final String? fcmToken;
  final String role;
  final String? emailVerifiedAt;
  final String? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.idUser,
    required this.email,
    this.password,
    required this.username,
    required this.name,
    required this.birthdate,
    required this.address,
    required this.phone,
    required this.gender,
    required this.marriageStatus,
    required this.lastEducation,
    required this.job,
    required this.age,
    required this.maritalStatus,
    required this.educationLevel,
    required this.currentJob,
    required this.fieldOfStudy,
    required this.educationalBackground,
    required this.stayWith,
    required this.bodyWeight,
    required this.bodyHeight,
    required this.status,
    this.resetPasswordToken,
    this.fcmToken,
    required this.role,
    this.emailVerifiedAt,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      idUser: json['id_user'] ?? '',
      email: json['email'] ?? '',
      password: json['password'],
      username: json['username'] ?? '',
      name: json['name'] ?? '',
      birthdate: json['birthdate'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      gender: json['gender'] ?? '',
      marriageStatus: json['marriage_status'] ?? '',
      lastEducation: json['last_education'] ?? '',
      job: json['job'] ?? '',
      age: json['age'] ?? 0,
      maritalStatus: json['marital_status'] ?? '',
      educationLevel: json['education_level'] ?? '',
      currentJob: json['current_job'] ?? '',
      fieldOfStudy: json['field_of_study'] ?? '',
      educationalBackground: json['educational_background'] ?? '',
      stayWith: json['stay_with'] ?? '',
      bodyWeight: json['body_weight'] ?? '',
      bodyHeight: json['body_height'] ?? '',
      status: json['status'] ?? '',
      resetPasswordToken: json['resetPasswordToken'],
      fcmToken: json['fcm_token'],
      role: json['role'] ?? '',
      emailVerifiedAt: json['email_verified_at'],
      deletedAt: json['deletedAt'],
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'])
              : DateTime.now(),
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.parse(json['updatedAt'])
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_user': idUser,
      'email': email,
      'password': password,
      'username': username,
      'name': name,
      'birthdate': birthdate,
      'address': address,
      'phone': phone,
      'gender': gender,
      'marriage_status': marriageStatus,
      'last_education': lastEducation,
      'job': job,
      'age': age,
      'marital_status': maritalStatus,
      'education_level': educationLevel,
      'current_job': currentJob,
      'field_of_study': fieldOfStudy,
      'educational_background': educationalBackground,
      'stay_with': stayWith,
      'body_weight': bodyWeight,
      'body_height': bodyHeight,
      'status': status,
      'resetPasswordToken': resetPasswordToken,
      'fcm_token': fcmToken,
      'role': role,
      'email_verified_at': emailVerifiedAt,
      'deletedAt': deletedAt,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
