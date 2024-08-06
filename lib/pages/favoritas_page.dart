import 'package:flutter/material.dart';
import 'package:vitrine/database.dart';
import 'package:vitrine/pages/perfil_page.dart';

class FavoritasPage extends StatefulWidget {
  FavoritasPage({Key? key}) : super(key: key);

  @override
  State<FavoritasPage> createState() => _FavoritasPageState();
}

class _FavoritasPageState extends State<FavoritasPage> {
  late Database db;
  List docs = [];
  List<bool> selectedItems = List.generate(0, (_) => false);
  final TextEditingController _filtragemController = TextEditingController();
  List docsFiltrados = [];

  initialize() {
    db = Database();
    db.initialize();
    print('ID do Usuário Atual: ${db.getCurrentUserId()}');
    db.listar_favoritos().then((value) {
      setState(() {
        docs = value; // Atualiza a lista de registros
        docsFiltrados = List.from(docs); // Inicializa a lista de filtrados
        selectedItems = List.generate(docs.length, (_) => false);
        print('Dados da Favoritas: $docs'); // Log para verificar os dados
      });
    }).catchError((error) {
      print('Erro ao listar lojas favoritas: $error'); // Log para capturar erros
    });
  }

  void _filtrandoFavoritas(String query) {
    if (query.isNotEmpty) {
      setState(() {
        docsFiltrados = docs.where((doc) {
          final nomeLoja = doc['nomeLoja']?.toLowerCase() ?? '';
          return nomeLoja.contains(query.toLowerCase());
        }).toList();
      });
    } else {
      setState(() {
        docsFiltrados = List.from(docs);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initialize();
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

  Future<void> _showDeleteConfirmationDialog(BuildContext context, int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // O usuário deve tocar no botão para fechar o diálogo
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Deseja excluir esta Vitrine?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar', style: TextStyle(color: Colors.black)),
              onPressed: () {
                // Atualiza a lista de favoritos ao cancelar a exclusão
                initialize();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Excluir', style: TextStyle(color: Colors.black)),
              onPressed: () async {
                try {
                  // Remove o favorito do banco de dados
                  await db.remover_favorito(docs[index]['docId']);
                  // Remove o favorito da lista local
                  setState(() {
                    docs.removeAt(index);
                    _filtrandoFavoritas(_filtragemController.text); // Atualiza a lista filtrada
                  });
                } catch (e) {
                  print('Erro ao remover favorito: $e');
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () {
          Navigator.pop(context);
        }),
        title: Text(
          'Lojas Favoritas',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _filtragemController,
              onChanged: _filtrandoFavoritas, // Atualiza a lista de registros de acordo com o termo de pesquisa
              decoration: InputDecoration(
                hintText: 'Pesquisar',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: docsFiltrados.isNotEmpty
                ? ListView.builder(
                    itemCount: docsFiltrados.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          // Mostra o diálogo de confirmação
                          _showDeleteConfirmationDialog(context, index);
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PerfilPage(
                                      nomeLoja: docsFiltrados[index]['nomeLoja'] ?? 'Nome da Loja não disponível',
                                      imageUrl: docsFiltrados[index]['imageUrl'] ?? '', // Passe a URL da imagem da loja
                                    ),
                                  ),
                                );
                              },
                              leading: Container(
                                width: 80,
                                height: 80,
                                child: _buildImageWidget(docsFiltrados[index]['imageUrl'] ?? ''),
                              ),
                              title: Text(docsFiltrados[index]['nomeLoja'] ?? 'Nome da Loja não disponível'),
                            ),
                            const Divider(
                              color: Colors.grey,
                              thickness: 0.5,
                              height: 25,
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text('Ainda não há loja favorita...'),
                  ),
          ),
        ],
      ),
    );
  }
}
