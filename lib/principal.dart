import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vitrine/componentes/side_menu.dart';
import 'package:vitrine/componentes/side_menu_title.dart';
import 'package:vitrine/widgets/perfil_page.dart';
import 'firebase_options.dart';
import 'database.dart';
import 'dart:async';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tela Principal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Seu produto está aqui!'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

StreamController<List<Map<String, dynamic>>?> searchResultsController =
    StreamController<List<Map<String, dynamic>>?>.broadcast();

class _MyHomePageState extends State<MyHomePage> {
  late Database db;
  //List docs = [];
  //List<bool> selectedItems = List.generate(0, (_) => false);
  TextEditingController _filtragemController = TextEditingController();
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


 /*

  wvoid _filtrandoTudo(String query) {
    setState(() {
      if (query.isNotEmpty) {
        docs = docs.here((contact) {
          String nomeItem = contact['nomeitem'].toLowerCase();
          String cor = contact['cor'].toLowerCase();
          String tamanho = contact['tamanho'].toLowerCase();
          String descricao = contact['descricao'].toLowerCase();
          String preco = contact['preco'].toLowerCase();
          return nomeItem.contains(query.toLowerCase()) ||
              cor.contains(query.toLowerCase()) ||
              tamanho.contains(query.toLowerCase()) ||
              descricao.contains(query.toLowerCase()) ||
              preco.contains(query.toLowerCase());
        }).toList();
      } else {
        db.listar().then((value) => {
              setState(() {
                docs = value; // Retorna todos os registros
                selectedItems =
                    List.generate(docs.length, (_) => false);
              })
            });
      }
      selectedItems = List.generate(docs.length, (_) => false);
    });
  }

  */





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        elevation: 0,
        leading: IconButton(
          icon: Image.asset("images/btnopcao.png"),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SideMenu(),
              ),
            );
          },
        ),
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.white, // Cor do título da barra de aplicativos
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _filtragemController,
             // onChanged: _filtrandoTudo, // Atualiza a lista de registros de acordo com o termo de pesquisa
              decoration: InputDecoration(
                hintText: 'Pesquisar',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
      Expanded(
        child: ListView.builder(
          itemCount: usuariosLoja.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                ListTile(
                 onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PerfilPage(
                          nomeLoja: usuariosLoja[index]['nomeLoja'] ?? '',
                          imageUrl: usuariosLoja[index]['img'] ?? '',
                        ),
                      ), 
                    );
                  },

                  leading: CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(usuariosLoja[index]['img'] ?? ''),
                  ),
                  title: Text(usuariosLoja[index]['nomeLoja'] ?? ''),
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                  height: 25,
                ),
              ],
            );
          },
        ),
      ),

        ],
      ),



        //boão flutuante padrão
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        onPressed: () {
          Map<String, String> mapNulo() => {"nomeitem": "", "img": ""};
      //    _abrirFormulario(mapNulo());
        },
        tooltip: 'Novo Item',
        //child: const Icon(Icons.add, color: Colors.white),
        child: Image.asset(
                "images/btndiamante.png",
              ),
      ),
      
    );
  }
}
