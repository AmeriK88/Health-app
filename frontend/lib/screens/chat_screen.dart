import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_notifier.dart';
import '../utils/styles.dart';

///  **ChatScreen** - Pantalla principal del chat con el asistente de fitness.
/// - Muestra la conversación entre el usuario y el asistente.
/// - Incluye una caja de texto para enviar mensajes.
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatNotifier = context.watch<ChatNotifier>(); // 🛠️ Escucha cambios en el chat.

    return Scaffold(
      appBar: AppBar(
        title: const Text('Asistente Fitness'),
      ),
      body: Column(
        children: [
          ///  **Lista de mensajes**
          /// - Se genera dinámicamente con ListView.builder.
          /// - Alterna la alineación según si el mensaje es del usuario o del asistente.
          Expanded(
            child: ListView.builder(
              itemCount: chatNotifier.messages.length,
              itemBuilder: (context, index) {
                final msg = chatNotifier.messages[index];
                final isUser = msg["role"] == "user"; //  Verifica si el mensaje es del usuario.

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser
                          ? AppStyles.primaryColor.withOpacity(0.1) // Estilo para el usuario.
                          : AppStyles.secondaryColor.withOpacity(0.1), // Estilo para el asistente.
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(msg["content"] ?? ""),
                  ),
                );
              },
            ),
          ),

          ///  **Indicador de carga** - Muestra una barra de progreso cuando el asistente está respondiendo.
          if (chatNotifier.isLoading) const LinearProgressIndicator(),

          ///  **Caja de entrada de texto** - Permite al usuario escribir y enviar mensajes.
          const ChatInputField(),
        ],
      ),
    );
  }
}

///  **ChatInputField** - Componente que maneja la entrada de texto y el envío de mensajes.
class ChatInputField extends StatefulWidget {
  const ChatInputField({Key? key}) : super(key: key);

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _controller = TextEditingController(); // Controlador del input.

  ///  **_sendMessage** - Envía el mensaje si no está vacío.
  /// - Llama al ChatNotifier` para procesar el mensaje.
  /// - Luego, limpia el campo de texto.
  void _sendMessage(BuildContext context) async {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      await context.read<ChatNotifier>().sendUserMessage(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            /// **Campo de texto** - Permite escribir mensajes con un diseño responsivo.
            Expanded(
              child: TextField(
                controller: _controller,
                minLines: 1,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: "Escribe tu mensaje...",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),

            /// **Botón de enviar** - Icono de papel avión para enviar mensajes.
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () => _sendMessage(context),
            ),
          ],
        ),
      ),
    );
  }
}
