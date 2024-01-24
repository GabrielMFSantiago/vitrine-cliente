import 'package:firebase_auth/firebase_auth.dart';

class Cliente {
  User? userscl = FirebaseAuth.instance.currentUser;
  String nome;
  String telefone;
  Cliente(
    this.nome,
    this.telefone,
    this.userscl,
  );
}
