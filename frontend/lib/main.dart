import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart'; // Pantalla Home
import 'screens/configuration_screen.dart'; // Pantalla de configuración

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health App', // Nombre de la aplicación
      theme: ThemeData(
        primarySwatch: Colors.blue, // Color principal
        useMaterial3: true, // Activar Material 3
      ),
      initialRoute: '/', // Ruta inicial
      routes: {
        '/': (context) => const LoginScreen(), // Ruta inicial (Login)
        '/register': (context) => const RegisterScreen(), // Registro
        '/home': (context) {
          final token = ModalRoute.of(context)!.settings.arguments as String; // Obtener el token
          return HomeScreen(token: token); // Pasar el token a HomeScreen
        },
        '/configuracion': (context) => const ConfigurationScreen(), // Configuración inicial
      },
    );
  }
}

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
            const Text(
              'You have pushed the button this many times:',
            ),
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
