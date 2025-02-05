/// Modelo que representa el estado diario del usuario.
/// Contiene información sobre la energía, el estado de ánimo, el dolor y el cansancio.
class DailyStatus {
  final String date; // 📅 Fecha del registro del estado diario.
  final String energyLevel; // ⚡ Nivel de energía del usuario (ej. "low", "medium", "high").
  final bool hasPain; // ❌ Indica si el usuario tiene dolor (true/false).
  final bool isTired; // 😴 Indica si el usuario está cansado (true/false).
  final String mood; // 😊 Estado de ánimo del usuario (ej. "mal", "neutral", "bien").

  /// Constructor de la clase DailyStatus.
  /// Recibe todos los parámetros como requeridos.
  DailyStatus({
    required this.date,
    required this.energyLevel,
    required this.hasPain,
    required this.isTired,
    required this.mood,
  });

  /// Método de fábrica que convierte un Map<String, dynamic> en un objeto DailyStatus.
  /// Se usa para transformar los datos JSON recibidos desde la API.
  factory DailyStatus.fromJson(Map<String, dynamic> json) {
    return DailyStatus(
      date: json['date'], // 📅 Extrae la fecha del estado diario.
      energyLevel: json['energy_level'], // ⚡ Extrae el nivel de energía.
      hasPain: json['has_pain'], // ❌ Extrae si el usuario tiene dolor.
      isTired: json['is_tired'], // 😴 Extrae si el usuario está cansado.
      mood: json['mood'], // 😊 Extrae el estado de ánimo.
    );
  }

  /// Método que convierte un objeto DailyStatus en un Map<String, dynamic>.
  /// Se usa para enviar los datos en formato JSON a la API.
  Map<String, dynamic> toJson() {
    return {
      'date': date, // 📅 Convierte la fecha en un formato JSON.
      'energy_level': energyLevel, // ⚡ Convierte el nivel de energía.
      'has_pain': hasPain, // ❌ Convierte el estado de dolor a JSON.
      'is_tired': isTired, // 😴 Convierte el estado de cansancio a JSON.
      'mood': mood, // 😊 Convierte el estado de ánimo a JSON.
    };
  }
}
