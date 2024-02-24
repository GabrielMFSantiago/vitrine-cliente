import 'package:flutter/material.dart';

class FavoritasPage extends StatefulWidget {
  final Map<String, String>? lojaFavoritada;

   const FavoritasPage({Key? key, this.lojaFavoritada}) : super(key: key);

  @override
  State<FavoritasPage> createState() => _FavoritasPageState();
}

class _FavoritasPageState extends State<FavoritasPage> {
  TextEditingController _filtragemController = TextEditingController();
  List<Map<String, String>> favoritas = []; // Lista de lojas favoritadas

  @override
  void initState() {
    super.initState();
    _adicionarFavorita(widget.lojaFavoritada); // Adiciona a loja favoritada à lista ao iniciar a página
  }

  void _adicionarFavorita(Map<String, String>? lojaFavoritada) {
  if (lojaFavoritada != null) { // Verifica se lojaFavoritada não é nulo antes de adicionar à lista
    setState(() {
      favoritas.add(lojaFavoritada);
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Suas Vitrines Favoritas:',
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
            child: ListView.builder(
              itemCount: favoritas.length,
              itemBuilder: (context, index) {
                final loja = favoritas[index];
                return ListTile(
                  onTap: () {
                    // Navegue para a página do perfil da loja ou realize a ação desejada
                  },
                  leading: CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(loja['imageUrl'] ?? ''),
                  ),
                  title: Text(loja['nomeLoja'] ?? ''),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
