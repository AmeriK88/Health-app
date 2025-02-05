import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_notifier.dart';
import '../utils/styles.dart';


class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatNotifier = context.watch<ChatNotifier>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Asistente Fitness'),
      ),
      body: Column(
        children: [
          // Lista de mensajes
          Expanded(
            child: ListView.builder(
              itemCount: chatNotifier.messages.length,
              itemBuilder: (context, index) {
                final msg = chatNotifier.messages[index];
                // role => "user", "assistant", "system"
                final isUser = msg["role"] == "user";
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? AppStyles.primaryColor.withOpacity(0.1) : AppStyles.secondaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(msg["content"] ?? ""),
                  ),
                );
              },
            ),
          ),
          if (chatNotifier.isLoading) const LinearProgressIndicator(),

          // Caja de texto para introducir el mensaje
          ChatInputField(),
        ],
      ),
    );
  }
}

// Un widget separado para la caja de texto y el botón enviar
class ChatInputField extends StatefulWidget {
  const ChatInputField({Key? key}) : super(key: key);

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _controller = TextEditingController();

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
