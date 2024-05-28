import '../views/home.dart';
import '../views/local_notifications.dart';
import 'package:flutter/material.dart';
import '../views/remove_background.dart';
import '../views/login_page.dart';

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
      initialRoute: '/login',
      routes: {
        '/home': (context) => const Home(userId: 1,),
        '/local_notifications': (context) => const ImageListPage(userId: 1,),
        '/remove_background': (context) => const RemoveBackground(userId: 1,),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}

