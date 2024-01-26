import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vitrine/Cliente.dart';
import 'package:vitrine/database.dart';

class InfoClientePage extends StatefulWidget {
  final String? userId;
  final Map? ClienteSelecionada;
  final Database? db;

  InfoClientePage({
    Key? key,
    required this.userId,
    required this.ClienteSelecionada,
    required this.db,
  }) : super(key: key);

  @override
  _InfoClientePageState createState() => _InfoClientePageState();
}

class _InfoClientePageState extends State<InfoClientePage> {
  TextEditingController nomeClienteCtrl = TextEditingController();
  TextEditingController telefoneCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();

  String? userId;
  String? id;

  @override
  void initState() {
    super.initState();

    userId = widget.userId;

    if (userId != null) {
      widget.db?.getClienteInfo(userId!).then((ClienteInfo) {
        if (ClienteInfo != null) {
          setState(() {
            nomeClienteCtrl.text = ClienteInfo['nome'] ?? '';
            telefoneCtrl.text = ClienteInfo['telefone'] ?? '';
            emailCtrl.text = ClienteInfo['email'] ?? '';
          });
        }
      });
    }

    if (widget.ClienteSelecionada != null) {
      id = widget.ClienteSelecionada!['id']?.toString();
      nomeClienteCtrl.text = widget.ClienteSelecionada!['nome']?.toString() ?? '';
      telefoneCtrl.text = widget.ClienteSelecionada!['telefone']?.toString() ?? '';
      emailCtrl.text = widget.ClienteSelecionada!['email']?.toString() ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text('Minhas Informações...'),
        leading: BackButton(onPressed: () {
          Navigator.pop(context);
        }),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: nomeClienteCtrl,
                decoration: const InputDecoration(labelText: "Nome"),
              ),
              TextField(
                controller: telefoneCtrl,
                decoration: const InputDecoration(labelText: "Telefone"),
              ),
              TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: "email"),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (nomeClienteCtrl.text.trim() != "") {
                    Database db = Database();
                    if (widget.ClienteSelecionada!['id'] == null) {
                      db.editarCliente(
                        id!,
                        Cliente(
                          nomeClienteCtrl.text,
                          telefoneCtrl.text,
                          FirebaseAuth.instance.currentUser, 
                        ),
                      );
                    } else {
                      // não fazer nada
                    }
                    Navigator.pop(context);
                  }
                },
                child: const Text('Gravar'),
              ),

              if (widget.ClienteSelecionada!['id'] != null)
                ElevatedButton(
                  onPressed: () async {
                    if (id != null) {
                      Database db = Database();
                      db.excluir(id!);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Excluir'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
