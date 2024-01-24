import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProdutoPage extends StatefulWidget {
  const ProdutoPage({Key? key}) : super(key: key);

  @override
  State<ProdutoPage> createState() => _ProdutoPageInfo();
}

class _ProdutoPageInfo extends State<ProdutoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Color.fromARGB(255, 255, 255, 255),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height *
                      0.55, // 55% da altura da tela
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: MediaQuery.of(context).size.width *
                          100, // 100% da largura da tela
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0.0, 2.0),
                            blurRadius: 6.0,
                          ),
                        ],
                        color: Colors.white, // Cor de fundo do Container
                      ),
                      child: Image.asset(
                        "images/background5.jpg",
                        fit: BoxFit.cover, // Ajusta a imagem para cobrir todo o espaço disponível
                        width: double.infinity, // Define a largura para ocupar todo o espaço
                        height: double.infinity, // Define a altura para ocupar todo o espaço
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
