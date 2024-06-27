import 'package:firebase_auth/firebase_auth.dart';

class Cliente {
  User? userscl;
  String nome;
  String telefone;

  Cliente(
    this.nome,
    this.telefone,
    User? userscl, 
  ) : this.userscl = userscl;
}
