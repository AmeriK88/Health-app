class DailyStatus {
  final String date;
  final String energyLevel;
  final bool hasPain;
  final bool isTired;
  final String mood;

  DailyStatus({
    required this.date,
    required this.energyLevel,
    required this.hasPain,
    required this.isTired,
    required this.mood,
  });

  factory DailyStatus.fromJson(Map<String, dynamic> json) {
    return DailyStatus(
      date: json['date'],
      energyLevel: json['energy_level'],
      hasPain: json['has_pain'],
      isTired: json['is_tired'],
      mood: json['mood'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'energy_level': energyLevel,
      'has_pain': hasPain,
      'is_tired': isTired,
      'mood': mood,
    };
  }
}
