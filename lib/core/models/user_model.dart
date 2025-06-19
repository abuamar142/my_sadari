class UserModel {
  final String id;
  final String email;
  final String name;
  final int age;
  final String phone;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.age,
    required this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'name': name, 'age': age, 'phone': phone};
  }
}
