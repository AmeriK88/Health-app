import 'package:flutter/material.dart';
// 1. Import Provider
import 'package:provider/provider.dart';

// 2. Imports de Notifiers
import 'providers/daily_status_notifier.dart';
import 'providers/chat_notifier.dart';

// 3. Imports de Services (ChatGPTService)
import 'services/chatgpt_service.dart';

// 4. Import de dotenv
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Import screens
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/configuration_screen.dart';

void main() async {
  // Carga las variables del archivo .env (incluida la OPENAI_API_KEY)
  await dotenv.load(fileName: "assets/.env");

  runApp(
    MultiProvider(
      providers: [
        // 3. Inyectar tu DailyStatusNotifier
        // De momento, no tenemos un token real aquí, por lo que le pasamos un string vacío.
        // Más adelante, podrías setear el token tras el
        ChangeNotifierProvider(
          create: (_) => DailyStatusNotifier(token: ''),
        ),

        // B) Inyectas ChatNotifier para ChatGPT
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
        '/home': (context) {
          final token = ModalRoute.of(context)!.settings.arguments as String;
          return HomeScreen(token: token);
        },
        '/configuracion': (context) => const ConfigurationScreen(),
      },
    );
  }
}

// Opcional: tu MyHomePage si lo usas
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
