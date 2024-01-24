import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void initialize() {
    _firestore = FirebaseFirestore.instance;
  }

  Future<List<Map<String, dynamic>>> listarUsuariosLoja() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('usersadm')
          .orderBy("nome")
          .get();

      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return {
          "nomeLoja": data['nome'] ?? '',
          "img": data["profileImage"] ?? '',
          // Adicione outros campos relevantes dos usuários loja aqui
        };
      }).toList();
    } catch (e) {
      print('Erro ao listar usuários loja: $e');
      return [];
    }
  }

  // Adicione outros métodos relevantes para sua aplicação, como incluir, editar, excluir, etc.

  Future<Map<String, dynamic>?> getLojaInfo(String userId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('usersadm').doc(userId).get();
      return doc.data() as Map<String, dynamic>?; // Retorna as informações da loja
    } catch (e) {
      print('Erro ao buscar informações da loja: $e');
      return null;
    }
  }
}
