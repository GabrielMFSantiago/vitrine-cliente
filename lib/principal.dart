import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vitrine/componentes/side_menu.dart';
import 'package:vitrine/componentes/side_menu_title.dart';
import 'package:vitrine/pages/perfil_page.dart';
import 'firebase_options.dart';
import 'database.dart';
import 'dart:async';
import 'pages/favoritas_page.dart';




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
  List docs = [];
  List<bool> selectedItems = List.generate(0, (_) => false);
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
  try {
    List<Map<String, dynamic>> result = await db.listarUsuariosLoja();
    setState(() {
      usuariosLoja = result;
    });
  } catch (e) {
    print('Erro ao inicializar dados: $e');
  }
}

void _filtrandoTudo(String query) async {
    if (query.isNotEmpty) {
      List<dynamic> resultados = await Database().filtrarInformacoes(query);
      print('Resultados da filtragem: $resultados');
      setState(() {
        docs = resultados;
      });
    } else {
      // Se a consulta estiver vazia, reverta para todos os itens
      setState(() {
        docs = List.from(usuariosLoja); // Cria uma cópia da lista original
        print('Consulta vazia, revertendo para todos os itens: $docs');
      });
    }
  }







 void _atualizarListaDeLojas() {
    setState(() {
      usuariosLoja.clear(); // Limpa a lista de lojas
      initialize(); // Restaura a lista original de lojas
    });
  }



  void _filtrarPorCidade(String cidade) {
    setState(() {
      if (cidade.isNotEmpty) {
        usuariosLoja = usuariosLoja.where((loja) {
          String endereco = loja['endereco'] ?? ''; // Verifica se endereco é nulo
          print('Endereço da loja: $endereco'); // Adiciona este log
          endereco = endereco.toLowerCase(); // Converte para minúsculas
          return endereco.contains(cidade.toLowerCase());
        }).toList();
      } else {
        // Se a cidade estiver vazia, restauramos todas as lojas
        _atualizarListaDeLojas();
      }
    });
  }

  
// Função para navegar para a tela de lojas favoritas
void _navegarParaFavoritas() {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => FavoritasPage()),
  );
}


/*
 void _buscarLojasPorCidade(String cidade) async {
  try {
    List<Map<String, dynamic>> result = await db.listarUsuariosLojaPorEndereco(cidade);

    setState(() {
      usuariosLoja = result;
    });
  } catch (e) {
    print('Erro ao buscar lojas por cidade: $e');
  }
}*/

void _filtrarUsuariosPorCidade(String cidade) {
  setState(() {
    if (cidade.isNotEmpty) {
      // Faça uma cópia dos dados originais para não perdê-los
      List<Map<String, dynamic>> todasAsLojas = List.from(usuariosLoja);

      // Filtrar as lojas com base na cidade
      usuariosLoja = todasAsLojas.where((loja) {
        String cidadeLoja = loja['cidade'] ?? '';
        cidadeLoja = cidadeLoja.toLowerCase();
        return cidadeLoja == cidade.toLowerCase(); // Alteração na condição de filtragem
      }).toList();
    } else {
      // Se a cidade estiver vazia, restauramos todas as lojas
      _atualizarListaDeLojas();
    }
  });
}







Widget _buildImageWidget(String? imageUrl) {
  if (imageUrl != null && imageUrl.isNotEmpty) {
    return CircleAvatar(
      radius: 40,
      backgroundImage: NetworkImage(imageUrl),
    );
  } else {
    // Caso a URL da imagem seja inválida, retornamos um widget de espaço reservado
    return Placeholder(
      fallbackHeight: 80, // Altura do espaço reservado
      fallbackWidth: 80, // Largura do espaço reservado
    );
  }
}

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
            color: Colors.white, 
          ),
        ),
        actions: [



IconButton(
  onPressed: () {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Escolha uma Cidade:',
            style: TextStyle(
              fontSize: 18, // Tamanho da fonte
              color: Colors.black, // Cor do texto
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _filtrarUsuariosPorCidade('itaperuna');
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Itaperuna',
                    style: TextStyle(
                      fontSize: 16, 
                      color: Colors.black, 
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _filtrarUsuariosPorCidade('campos dos goytacazes');
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Campos dos Goytacazes',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black, 
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _filtrarUsuariosPorCidade('macaé');
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Macaé',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black, 
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Fechar',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black, 
                ),
              ),
            ),
          ],
        );
      },
    );
  },
  icon: Image.asset("images/mapa.png"),
),




        ],

      ),
      
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _filtragemController,
              onChanged: (query) {
              _filtrandoTudo(query);
              
            },
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


                leading: Container(
                  width: 80, // Defina o tamanho desejado aqui
                  height: 80, // Defina o tamanho desejado aqui
                  child: _buildImageWidget(usuariosLoja[index]['img']),
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
          _navegarParaFavoritas();
        },
        tooltip: 'Favoritas',
        child: Image.asset(
          "images/btndiamante.png",
        ),
      ),




      
    );
  }
}