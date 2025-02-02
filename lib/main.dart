import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:smile/login_screen.dart';
import  'tutorial_screen.dart'; // Asegúrate de importar la pantalla TutorialScreen

void main() {
  runApp(
    DevicePreview(
      enabled: true, // Activa la vista previa en todos los dispositivos
      builder: (context) => const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(), // Aquí la pantalla inicial será un Splash o algo similar
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Redirigir después de 2 segundos (puedes ajustar el tiempo)
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      // Redirige a la pantalla de usuario (put_user.dart)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(isDarkMode: false, toggleTheme: () {}),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Loading...', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
