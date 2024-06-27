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

  initialize() {
    db = Database();
    db.initialize(); 
    print('ID do Usuário Atual: ${db.getCurrentUserId()}');
    db.listar_favoritos().then((value) {
      setState(() {
        docs = value; // Atualiza a lista de registros
        selectedItems = List.generate(docs.length, (_) => false);
        print('Dados da Favoritas: $docs'); // Log para verificar os dados
      });
    }).catchError((error) {
      print('Erro ao listar lojas favoritas: $error'); // Log para capturar erros
    });
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
             // onChanged: _filtrandoTudo, // Atualiza a lista de registros de acordo com o termo de pesquisa
              decoration: InputDecoration(
                hintText: 'Pesquisar',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),

        Expanded(
         child: docs.isNotEmpty
          ? ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PerfilPage(
                              nomeLoja: docs[index]['nomeLoja'] ?? 'Nome da Loja não disponível',
                              imageUrl: docs[index]['imageUrl'] ?? '', // Passe a URL da imagem da loja
                            ),
                          ), 
                        );
                      },
                    
                      leading: Container(
                        width: 80, 
                        height: 80, 
                        child: _buildImageWidget(docs[index]['imageUrl'] ?? ''), 
                      ),
                      
                      title: Text(docs[index]['nomeLoja'] ?? 'Nome da Loja não disponível'),
                    
                    ),
                    
                    
                    const Divider(
                        color: Colors.grey,
                        thickness: 0.5,
                        height: 25,
                      ),
                  ],
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
