// home.dart
import 'package:flutter/material.dart';


class Home extends StatelessWidget {
  final int? userId;
  const Home({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[400],
      appBar: AppBar(
        title: const Text('Seletor de Funcionalidades'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Galeria de Imagens",
            style: TextStyle(color: Colors.white, fontSize: 24),),
            IconButton(
              onPressed: () {
                // Navegar para a tela de agendamento de notificações locais
                Navigator.pushNamed(context, '/local_notifications');
              },
              icon: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.asset('assets/tomato.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Remover de Fundo de Imagens",
            style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            IconButton(
              onPressed: () {
                // Navegar para a tela de remoção de fundo de imagens
                Navigator.pushNamed(context, '/remove_background', arguments: {'userId': userId});
              },
              icon: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.asset('assets/shiba01.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}