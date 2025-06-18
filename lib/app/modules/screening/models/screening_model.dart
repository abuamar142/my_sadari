class ScreeningResult {
  final DateTime timestamp;
  final String riskLevel;
  final List<int> answers;

  ScreeningResult({
    required this.timestamp,
    required this.riskLevel,
    required this.answers,
  });

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'riskLevel': riskLevel,
    'answers': answers,
  };

  factory ScreeningResult.fromJson(Map<String, dynamic> json) {
    return ScreeningResult(
      timestamp: DateTime.parse(json['timestamp']),
      riskLevel: json['riskLevel'],
      answers: List<int>.from(json['answers']),
    );
  }
}