// user_model.dart
class User {
  final String name;
  final int? sisaCuti;

  User({required this.name, this.sisaCuti});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      sisaCuti: json['sisa_cuti'] is int
          ? json['sisa_cuti']
          : int.tryParse(json['sisa_cuti'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sisa_cuti': sisaCuti,
    };
  }
}
