import 'package:encontro_08/views/home.dart';
import 'package:encontro_08/views/local_notifications.dart';
import 'package:flutter/material.dart';
import '../views/remove_background.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Encontro 08',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const Home(),
        '/local_notifications': (context) => const LocalNotifications(),
        '/remove_background': (context) => const RemoveBackground(title: 'Remove Background'),
      },
    );
  }
}

