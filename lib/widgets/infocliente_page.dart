import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class InfoClientePage extends StatefulWidget {
  final String? userId;

  InfoClientePage({Key? key, required this.userId}) : super(key: key);

  @override
  _InfoClientePageState createState() => _InfoClientePageState();
}

class _InfoClientePageState extends State<InfoClientePage> {
  late String _userId;
  late String _nomeCliente;
  late String _email;
  late String _telefone;

  @override
  void initState() {
    super.initState();
    _userId = widget.userId ?? '';
    print('User ID in initState: $_userId');
    _nomeCliente = '';
    _email = '';
    _telefone = '';

    _loadClienteData();
  }

  Future<void> _loadClienteData() async {
    try {
      if (_userId.isNotEmpty) {
        DocumentSnapshot clienteDoc = await FirebaseFirestore.instance
            .collection('userscliente')
            .doc(_userId)
            .get();

        if (clienteDoc.exists) {
          setState(() {
            _nomeCliente = clienteDoc['nome'] ?? '';
            _email = clienteDoc['email'] ?? '';
            _telefone = clienteDoc['telefone'] ?? '';
          });
        }
      }
    } catch (e) {
      print('Erro ao carregar dados do cliente: $e');
      setState(() {
        _nomeCliente = '';
        _email = '';
        _telefone = '';
      });
    }
  }

  _editarInformacoes() async {
    TextEditingController enderecoController = TextEditingController(text: _email);
    TextEditingController telefoneController = TextEditingController(text: _telefone);

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Informações'),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              
              TextField(
                controller: telefoneController,
                decoration: InputDecoration(labelText: 'Novo Telefone'),
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (telefoneController.text.length == 11) {
                  await FirebaseFirestore.instance
                      .collection('userscliente')
                      .doc(_userId)
                      .update({
                    'telefone': telefoneController.text,
                  });

                  await _loadClienteData();

                  Navigator.pop(context);
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Erro'),
                        content: Text('O telefone deve ter 11 dígitos.'),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Alterar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_userId.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Minhas Informações', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: const Center(
          child: Text('O ID do usuário está vazio.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Informações', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: _editarInformacoes,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfo('Nome:', _nomeCliente),
              _buildInfo('Telefone:', _telefone),
              _buildInfo('email:', _email),            
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4.0),
        Text('$value', style: TextStyle(fontSize: 20.0)),
        const SizedBox(height: 30.0),
      ],
    );
  }
}
