class Schedule {
  final String id;
  final DateTime menstruationStartDate;
  final DateTime sadariStartDate; // Hari ke-7
  final DateTime sadariEndDate; // Hari ke-10
  final List<DateTime> reminderDates; // Tanggal-tanggal reminder
  final bool isActive;
  final DateTime createdAt;
  final String? notes;

  Schedule({
    required this.id,
    required this.menstruationStartDate,
    required this.sadariStartDate,
    required this.sadariEndDate,
    required this.reminderDates,
    this.isActive = true,
    required this.createdAt,
    this.notes,
  });

  // Calculate sadari dates from menstruation start date
  factory Schedule.fromMenstruationDate({
    required String id,
    required DateTime menstruationStartDate,
    String? notes,
  }) {
    final sadariStartDate = menstruationStartDate.add(
      Duration(days: 6),
    ); // Day 7
    final sadariEndDate = menstruationStartDate.add(
      Duration(days: 9),
    ); // Day 10

    // Create reminder dates (day 7, 8, 9, 10)
    final reminderDates = <DateTime>[];
    for (int i = 6; i <= 9; i++) {
      reminderDates.add(menstruationStartDate.add(Duration(days: i)));
    }

    return Schedule(
      id: id,
      menstruationStartDate: menstruationStartDate,
      sadariStartDate: sadariStartDate,
      sadariEndDate: sadariEndDate,
      reminderDates: reminderDates,
      createdAt: DateTime.now(),
      notes: notes,
    );
  }

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'menstruationStartDate': menstruationStartDate.millisecondsSinceEpoch,
      'sadariStartDate': sadariStartDate.millisecondsSinceEpoch,
      'sadariEndDate': sadariEndDate.millisecondsSinceEpoch,
      'reminderDates':
          reminderDates.map((date) => date.millisecondsSinceEpoch).toList(),
      'isActive': isActive,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'notes': notes,
    };
  }

  // Create from JSON
  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'],
      menstruationStartDate: DateTime.fromMillisecondsSinceEpoch(
        json['menstruationStartDate'],
      ),
      sadariStartDate: DateTime.fromMillisecondsSinceEpoch(
        json['sadariStartDate'],
      ),
      sadariEndDate: DateTime.fromMillisecondsSinceEpoch(json['sadariEndDate']),
      reminderDates:
          (json['reminderDates'] as List)
              .map(
                (timestamp) => DateTime.fromMillisecondsSinceEpoch(timestamp),
              )
              .toList(),
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      notes: json['notes'],
    );
  }

  // Copy with method for updates
  Schedule copyWith({
    String? id,
    DateTime? menstruationStartDate,
    DateTime? sadariStartDate,
    DateTime? sadariEndDate,
    List<DateTime>? reminderDates,
    bool? isActive,
    DateTime? createdAt,
    String? notes,
  }) {
    return Schedule(
      id: id ?? this.id,
      menstruationStartDate:
          menstruationStartDate ?? this.menstruationStartDate,
      sadariStartDate: sadariStartDate ?? this.sadariStartDate,
      sadariEndDate: sadariEndDate ?? this.sadariEndDate,
      reminderDates: reminderDates ?? this.reminderDates,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      notes: notes ?? this.notes,
    );
  }

  // Check if current date is in sadari window
  bool get isInSadariWindow {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final startDay = DateTime(
      sadariStartDate.year,
      sadariStartDate.month,
      sadariStartDate.day,
    );
    final endDay = DateTime(
      sadariEndDate.year,
      sadariEndDate.month,
      sadariEndDate.day,
    );

    return today.isAfter(startDay.subtract(Duration(days: 1))) &&
        today.isBefore(endDay.add(Duration(days: 1)));
  }

  // Get next reminder date
  DateTime? get nextReminderDate {
    final now = DateTime.now();
    for (final reminderDate in reminderDates) {
      if (reminderDate.isAfter(now)) {
        return reminderDate;
      }
    }
    return null;
  }

  // Get days until next sadari window
  int get daysUntilSadari {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final startDay = DateTime(
      sadariStartDate.year,
      sadariStartDate.month,
      sadariStartDate.day,
    );

    if (today.isBefore(startDay)) {
      return startDay.difference(today).inDays;
    }
    return 0;
  }
}
