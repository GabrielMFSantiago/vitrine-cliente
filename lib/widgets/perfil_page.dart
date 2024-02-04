import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PerfilPage extends StatefulWidget {
  final String nomeLoja;
  final String imageUrl;

  const PerfilPage({Key? key, required this.nomeLoja, required this.imageUrl})
      : super(key: key);

  @override
  State<PerfilPage> createState() => _PerfilPageInfo();
}

class _PerfilPageInfo extends State<PerfilPage> {
  late String telefone = '';
  late String endereco = '';

  @override
  void initState() {
    super.initState();
    _fetchLojaData();
  }

  Future<void> _fetchLojaData() async {
    try {
      print('Nome da loja: ${widget.nomeLoja}');  // Adiciona log

      // Consultando a coleção de mapeamento para obter o ID do documento correspondente ao nome da loja
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('usersadm')
          .where('nome', isEqualTo: widget.nomeLoja)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Se encontrar um documento correspondente, obtenha o ID do documento
        String idDocumento = querySnapshot.docs.first.id;

        print('ID do documento: $idDocumento');  // Adiciona log

        // Usando o ID de documento correspondente para buscar os dados da loja no Firestore
        DocumentSnapshot lojaSnapshot = await FirebaseFirestore.instance
            .collection('usersadm')
            .doc(idDocumento)
            .get();

        Map<String, dynamic> lojaData = lojaSnapshot.data() as Map<String, dynamic>;
        print('Dados da loja: $lojaData');  // Adiciona log

        setState(() {
          telefone = lojaData['telefone'] ?? '';
          endereco = lojaData['endereco'] ?? '';
        });
      } else {
        print('Nenhum documento encontrado para ${widget.nomeLoja}');
      }
    } catch (e) {
      print('Erro ao buscar dados da loja: $e');
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
                            buildInfoRowWithDivider(
                              "Telefone:",
                              telefone,
                              icon: Image.asset(
                                "images/iconewhatsapp.png",
                                height: 24,
                                width: 24,
                              ),
                            ),
                            buildInfoRowWithDivider(
                              "Endereço:",
                              endereco,
                              icon: Image.asset(
                                "images/iconegps.png",
                                height: 24,
                                width: 24,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin:
                        EdgeInsets.only(top: 0, bottom: 16, left: 6, right: 6),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(horizontal: 6),
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
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 10),
                                  Image.asset(
                                    "images/LogoVitrine2.png",
                                    height: 100,
                                    width: 100,
                                  ),
                                  Text(
                                    "Teste",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 24,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Image.asset(
                                    "images/LogoVitrine2.png",
                                    height: 100,
                                    width: 100,
                                  ),
                                  Text(
                                    "Teste",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 24,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Image.asset(
                                    "images/LogoVitrine2.png",
                                    height: 100,
                                    width: 100,
                                  ),
                                  Text(
                                    "Teste",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 24,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Image.asset(
                                    "images/LogoVitrine2.png",
                                    height: 100,
                                    width: 100,
                                  ),
                                  Text(
                                    "Teste",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 24,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Image.asset(
                                    "images/LogoVitrine2.png",
                                    height: 100,
                                    width: 100,
                                  ),
                                  Text(
                                    "Teste",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 24,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment(1.0, -0.8),
        child: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 0, 0, 0),
          onPressed: () {
            // _favoritar perfil
          },
          child: Image.asset(
            "images/btndiamante.png",
          ),
        ),
      ),
    );
  }

  Widget buildInfoRowWithIcon(String label, String value, {Widget? icon}) {
    return Row(
      children: [
        buildInfoRow(label, value),
        Spacer(),
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: icon ?? Container(),
        ),
      ],
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget buildInfoRowWithDivider(String label, String value, {Widget? icon}) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: icon ?? Container(),
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
