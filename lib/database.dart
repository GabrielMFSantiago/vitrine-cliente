import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vitrine/Cliente.dart';

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

  Future<void> editarCliente(String id, Cliente j) async {
  try {
    DocumentReference clienteRef = _firestore
        .collection('userscliente')
        .doc(id); // Use o ID do cliente, não o ID do usuário

    DocumentSnapshot clienteSnapshot = await clienteRef.get();
    if (clienteSnapshot.exists) {
      final Cliente = <String, dynamic>{
        "nome": j.nome,
        "telefone": j.telefone,
        "userCliente": j.userscl,
      };

      await clienteRef.update(Cliente);
      print('Cliente $id atualizado com sucesso');
    } else {
      print('Cliente $id não atualizado');
    }
  } catch (e) {
    print('Erro ao atualizar o Cliente: $e');
  }
}


//Excluir itens do adm loja
 Future<void> excluir(String id) async {
    User? user = FirebaseAuth.instance.currentUser;
    try {
      DocumentReference productRef = _firestore
          .collection('userscliente')
          .doc(user?.uid)
          .collection('Items')
          .doc(id);

      await productRef.delete(); // Exclui o documento do Firestore

      print('Item $productRef Excluído com sucesso');
    } catch (e) {
      print('Erro ao excluir o documento: $e');
    }
  }



  Future<Map<String, dynamic>?> getClienteInfo(String userId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('userscliente').doc(userId).get();
      return doc.data() as Map<String, dynamic>?; // Retorna as informações do cliente
    } catch (e) {
      print('Erro ao buscar informações do cliente: $e');
      return null;
    }
  }
}
