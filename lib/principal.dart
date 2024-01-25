import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'database.dart';
import 'dart:async';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vitrine Principal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Sua Vitrine está aqui!'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Database db;
  List<Map<String, dynamic>> usuariosLoja = [];

  @override
  void initState() {
    super.initState();
    db = Database();
    db.initialize();
    initialize();
  }

  void initialize() async {
    List<Map<String, dynamic>> result = await db.listarUsuariosLoja();

    setState(() {
      usuariosLoja = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        itemCount: usuariosLoja.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(usuariosLoja[index]['nomeLoja'] ?? ''),
            subtitle: Text(usuariosLoja[index]['img'] ?? ''),
            // Adicione aqui o código para exibir os usuários loja
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          // Adicione aqui o código para lidar com a ação do botão flutuante
        },
        tooltip: 'Novo Item',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
