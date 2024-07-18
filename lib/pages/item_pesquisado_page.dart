import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vitrine/pages/favoritas_page.dart';
import 'package:vitrine/reserva.dart';
import 'package:vitrine/pages/reservas_page.dart';
import 'package:vitrine/database.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart' show UrlLauncher, Intent;
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:vitrine/pages/perfil_page.dart';



class ItemPesquisadoPage extends StatefulWidget {
  final String nomeLoja;
  final String imageUrl;

  const ItemPesquisadoPage({Key? key, required this.nomeLoja, required this.imageUrl, required String nomeItem})
      : super(key: key);

  @override
  State<ItemPesquisadoPage> createState() => _ItemPesquisadoPageInfoState();
}

class _ItemPesquisadoPageInfoState extends State<ItemPesquisadoPage> {
  late String telefone = '';
  late String endereco = '';
  List<Map<String, dynamic>> produtos = [];
  List<Map<String, dynamic>> reservas = [];

  @override
  void initState() {
    super.initState();
    _fetchLojaData();
  }

  Future<void> _fetchLojaData() async {
    try {
      print('Nome da loja: ${widget.nomeLoja}');

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('usersadm')
          .where('nome', isEqualTo: widget.nomeLoja)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String idDocumento = querySnapshot.docs.first.id;

        print('ID do documento: $idDocumento');

        DocumentSnapshot lojaSnapshot = await FirebaseFirestore.instance
            .collection('usersadm')
            .doc(idDocumento)
            .get();

        Map<String, dynamic> lojaData =
            lojaSnapshot.data() as Map<String, dynamic>;

      
       // Alterado o caminho para acessar a nova coleção "Items"
        QuerySnapshot produtosQuerySnapshot = await FirebaseFirestore.instance
          .collection('Items')
          .where('userId', isEqualTo: idDocumento)
          .get();


        List<Map<String, dynamic>> produtos = produtosQuerySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();

        print('Produtos da loja: $produtos');

        setState(() {
          telefone = lojaData['telefone'] ?? '';
          endereco = lojaData['endereco'] ?? '';
          this.produtos = produtos;
        });
      } else {
        print('Nenhum documento encontrado para ${widget.nomeLoja}');
      }
    } catch (e) {
      print('Erro ao buscar dados da loja: $e');
    }
  }









void _abrirWhatsApp(String telefone, String mensagem) async {
  final whatsappUrl = "https://wa.me/$telefone?text=${Uri.encodeFull(mensagem)}";
  try {
    await launch(whatsappUrl);
  } catch (e) {
    throw 'Não foi possível abrir o WhatsApp.';
  }
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height,
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Color.fromARGB(255, 0, 0, 0),
          child: SafeArea(
            child: Column(
              children: [



Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 6, right: 6),
                    child: SingleChildScrollView(
                      child: Column(
                        children: produtos.map((produto) {
                          return Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(top: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(0.0, 2.0),
                                  blurRadius: 6.0,
                                ),
                              ],
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                    child: produto['img'] != null
                                        ? Image.network(
                                            produto['img'],
                                            fit: BoxFit.cover,
                                          )
                                        : SizedBox.shrink(),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 1),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  produto['nomeitem'] != null &&
                                                          produto['nomeitem']
                                                              .isNotEmpty
                                                      ? produto['nomeitem']
                                                      : 'Nome não disponível',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 33,
                                                    fontFamily: 'Work Sans',
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        produto['descricao'] != null &&
                                                produto['descricao'].isNotEmpty
                                            ? "Descrição: ${produto['descricao']}"
                                            : 'Descrição não disponível',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        produto['tamanho'] != null &&
                                                produto['tamanho'].isNotEmpty
                                            ? "Tamanho: ${produto['tamanho']}"
                                            : 'Tamanho não disponível',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        produto['cor'] != null &&
                                                produto['cor'].isNotEmpty
                                            ? "Cor: ${produto['cor']}"
                                            : 'Cor não disponível',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                      ),
                                     Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          produto['preco'] != null && produto['preco'].isNotEmpty
                                              ? "Valor: ${produto['preco']}"
                                              : 'Preço não disponível',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 25,
                                            fontFamily: 'Work Sans',
                                            fontStyle: FontStyle.italic,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                             final nomeProduto = produto['nomeitem'] ?? 'Produto não disponível';
                                              final mensagem = 'Olá, Gostei do(a) $nomeProduto e gostaria de reservá-lo(a)!';

                                              final url = 'https://wa.me/$telefone?text=${Uri.encodeFull(mensagem)}';
                                              _abrirWhatsApp(telefone, mensagem);
                                            if (await canLaunch(url)) {
                                              await launch(url);
                                            } else {
                                              throw 'Não foi possível abrir $url';
                                            }
                                          },
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Icon(
                                                Icons.favorite,
                                                color: Colors.black,
                                              ),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  SizedBox(height: 30), // Ajuste o espaçamento vertical aqui
                                                  Text(
                                                    'Reservar',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),


                                      ],
                                    ),

                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),









                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.42,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SingleChildScrollView(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: 170,
                              height: 170,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(widget.imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              widget.nomeLoja,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                             SizedBox(height: 20),
                           
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PerfilPage(
                                      nomeLoja: widget.nomeLoja,
                                      imageUrl: widget.imageUrl,
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                "Ir para Vitrine",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
   
    );
  }



}
