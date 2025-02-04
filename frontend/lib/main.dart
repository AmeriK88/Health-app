import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/daily_status_notifier.dart';
import 'providers/chat_notifier.dart';
import 'services/chatgpt_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/configuration_screen.dart';
import 'package:frontend/utils/styles.dart';


void main() async {
  // Carga las variables del archivo .env (incluida la OPENAI_API_KEY)
  await dotenv.load(fileName: "assets/.env");

  runApp(
    MultiProvider(
      providers: [
        // DailyStatusNotifier ahora inicia SIN un token vacío
        ChangeNotifierProvider<DailyStatusNotifier>(
          create: (_) => DailyStatusNotifier(token: ''),
        ),

        // ChatNotifier para ChatGPT
        ChangeNotifierProvider(
          create: (_) => ChatNotifier(ChatGPTService()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),

        // Corregido: Obtiene el token de forma segura
        '/home': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          if (args is String && args.isNotEmpty) {
            context.read<DailyStatusNotifier>().setToken(args);
            return HomeScreen(token: args);
          }
          // Si no hay token, vuelve al login
          return const LoginScreen(); 
        },

        '/configuracion': (context) => const ConfigurationScreen(),
      },
    );
  }
}
