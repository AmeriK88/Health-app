// lib/providers/chat_notifier.dart
import 'package:flutter/material.dart';
import '../services/chatgpt_service.dart';

class ChatNotifier extends ChangeNotifier {
  final ChatGPTService _chatService;
  ChatNotifier(this._chatService);

  bool isLoading = false;
  String errorMessage = '';
  
  // Estructura local de los mensajes
  List<Map<String, String>> messages = [
    {
      "role": "system",
      "content": "Eres un asistente personal de fitness..."
    }
  ];

  Future<void> sendUserMessage(String userMessage) async {
    // 1) Añadimos el mensaje del usuario a la lista
    messages.add({"role": "user", "content": userMessage});
    notifyListeners();

    // 2) Llamar a ChatGPT
    isLoading = true;
    notifyListeners();

    try {
      final response = await _chatService.sendMessage(messages: messages);
      // 3) Añadir la respuesta al final
      messages.add({"role": "assistant", "content": response});
      errorMessage = '';
    } catch (e) {
      errorMessage = 'Error: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
