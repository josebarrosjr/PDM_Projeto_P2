import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:p1_projeto/controller/utils.dart';

import 'login_controller.dart';

//tarefa

class Tarefa {
  String? uid;
  String? descricao;
  bool? concluida;

  Tarefa({this.uid, this.descricao, this.concluida});

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'descricao': descricao,
      'concluida': concluida,
    };
  }

  static Tarefa fromJson(Map<String, dynamic> json) {
    return Tarefa(
      uid: json['uid'],
      descricao: json['descricao'],
      concluida: json['concluida'],
    );
  }
}

//-----


class TarefaController {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  adicionar(context, Tarefa t) {
    db.collection('tarefas')
      .add(t.toJson())
      .then((value) =>
          sucesso(context,'Operação realizada com sucesso!'))
      .catchError((e) => 
          erro(context,'Não foi possível realizar a operação.'))
      .whenComplete(() => 
          Navigator.pop(context));
  }

  atualizar(context, uid, Tarefa t) {

    db.collection('tarefas')
      .doc(uid)
      .update(t.toJson())
      .then((value) =>
          sucesso(context,'Operação realizada com sucesso!'))
      .catchError((e) => 
          erro(context,'Não foi possível realizar a operação.'))
      .whenComplete(() => 
          Navigator.pop(context));


  }

  excluir(context, uid) {
    db.collection('tarefas')
        .doc(uid)
        .delete()
        .then((value) =>
            sucesso(context,'Operação realizada com sucesso!'))
        .catchError((e) => 
            erro(context,'Não foi possível realizar a operação.'));
  }

  Stream<QuerySnapshot> listar() {
    var resultado = db
        .collection('tarefas')
        .where('uid', isEqualTo: LoginController().idUsuario());
   
    return resultado.snapshots();
  }
}
