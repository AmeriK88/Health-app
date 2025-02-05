import 'package:flutter/material.dart';
import '../services/chatgpt_service.dart';

///  **ChatNotifier** - Notificador que gestiona la comunicación con ChatGPT.
/// Esta clase es responsable de manejar el historial del chat y actualizar la UI en tiempo real.
class ChatNotifier extends ChangeNotifier {
  final ChatGPTService _chatService; //  Instancia del servicio que maneja la comunicación con ChatGPT.

  ///  Constructor que inicializa el servicio de ChatGPT.
  ChatNotifier(this._chatService);

  bool isLoading = false; // Indica si la app está esperando una respuesta del asistente.
  String errorMessage = ''; // Almacena mensajes de error en caso de fallo.

  ///  **Lista de mensajes** en formato {role: "user/assistant/system", content: "mensaje"}
  /// Se utiliza para almacenar el historial del chat con ChatGPT.
  List<Map<String, String>> messages = [
    {
      "role": "system",
      "content": "Soy tu asistente personal de fitness..." // Mensaje inicial del sistema.
    }
  ];

  /// **sendUserMessage** - Maneja el flujo del chat cuando el usuario envía un mensaje.
  /// 1️⃣ Agrega el mensaje del usuario al historial.
  /// 2️⃣ Llama al servicio de ChatGPT para obtener una respuesta.
  /// 3️⃣ Agrega la respuesta del asistente a la lista de mensajes.
  /// 4️⃣ Actualiza la UI en cada paso del proceso.
  Future<void> sendUserMessage(String userMessage) async {
    // 1️⃣ Agregar el mensaje del usuario a la lista.
    messages.add({"role": "user", "content": userMessage});
    notifyListeners(); // Notificar cambios para actualizar la UI.

    // 2️⃣ Indicar que la aplicación está esperando respuesta.
    isLoading = true;
    notifyListeners();

    try {
      // 3️⃣ Enviar los mensajes acumulados a ChatGPT y obtener la respuesta.
      final response = await _chatService.sendMessage(messages: messages);

      // 4️⃣ Agregar la respuesta del asistente al historial del chat.
      messages.add({"role": "assistant", "content": response});
      errorMessage = ''; // ✅ Reiniciar mensaje de error si la respuesta fue exitosa.
    } catch (e) {
      errorMessage = 'Error: $e'; // ❌ Captura errores en caso de fallo.
    } finally {
      // 5️⃣ Marcar la finalización del proceso y actualizar la UI.
      isLoading = false;
      notifyListeners();
    }
  }
}
