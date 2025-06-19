class ResponseModel {
  final bool success;
  final String message;
  final bool infiniteToken;
  final String token;
  final dynamic data;

  ResponseModel({
    required this.success,
    required this.message,
    required this.infiniteToken,
    required this.token,
    required this.data,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      infiniteToken: json['infinite_token'] ?? false,
      token: json['token'] ?? '',
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'infinite_token': infiniteToken,
      'token': token,
      'data': data,
    };
  }
}
