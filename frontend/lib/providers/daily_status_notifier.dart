import 'package:flutter/material.dart';
import '../services/daily_status_service.dart';

/// Un ChangeNotifier que maneja la lógica de
/// 1) Obtener la lista de estados diarios,
/// 2) Registrar un nuevo estado diario,
/// y 3) Notificar a la UI cuando hay cambios.
class DailyStatusNotifier extends ChangeNotifier {
  // NOTA: cambiamos 'final' a 'late' para poder actualizarlo con setToken().
  late String _token;

  // Constructor para inyectar el token desde fuera.
  // Si vienes con un token vacío, lo asignas a _token inicial
  DailyStatusNotifier({required String token}) {
    _token = token;
  }

  // Método para cambiar el token después de hacer login
  void setToken(String newToken) {
    _token = newToken;
    print('Token actualizado en DailyStatusNotifier: $_token');
    // Normalmente no hay que llamar notifyListeners() 
    // si solo actualizamos el token y no depende la UI,
    // pero no hace daño si quieres asegurarte de que cambie algo en la UI.
  }

  // Estado interno
  bool _isLoading = false;
  String _errorMessage = '';
  List<dynamic> _dailyStatuses = [];

  // Getters
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<dynamic> get dailyStatuses => _dailyStatuses;

  // Método para obtener los daily statuses desde la API
  Future<void> fetchDailyStatusesFromApi() async {
    _isLoading = true;
    notifyListeners(); // Avísale a la UI que empieza la carga

    try {
      final List<dynamic> fetchedStatuses = await fetchDailyStatuses(_token);
      _dailyStatuses = fetchedStatuses;
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Error al obtener estados: $e';
    } finally {
      _isLoading = false;
      notifyListeners(); // Avísale a la UI que terminó la carga
    }
  }

  // Método para registrar un nuevo daily status
  Future<void> registerDailyStatusToApi(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      await registerDailyStatus(_token, data);
      _errorMessage = '';
      // Se registró OK. Podemos refrescar la lista si queremos:
      await fetchDailyStatusesFromApi();
    } catch (e) {
      _errorMessage = 'Error al registrar estado: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
