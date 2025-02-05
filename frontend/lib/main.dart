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
import 'utils/styles.dart'; // ✅ Asegura que styles.dart esté correctamente importado

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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: AppStyles.primarySwatch, // ✅ Usa el color principal definido en styles.dart
        scaffoldBackgroundColor: AppStyles.backgroundColor, // ✅ Fondo global
        useMaterial3: true,

        // Personalización del AppBar
        appBarTheme: AppBarTheme(
          backgroundColor: AppStyles.primaryColor,
          foregroundColor: Colors.white,
          elevation: 4,
        ),

        // Botones
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: AppStyles.primaryButtonStyle, // ✅ Aplica el estilo global a los botones elevados
        ),

        // Inputs
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppStyles.primaryColor, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
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
