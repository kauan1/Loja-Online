import 'package:scoped_model/scoped_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:async';

class UserModel extends Model{

  //usuario atual

  FirebaseAuth _auth= FirebaseAuth.instance;

  FirebaseUser firebaseUser;
  Map<String, dynamic> userData = Map();

  bool isLoading = false;

  static UserModel of (BuildContext context)=>
      ScopedModel.of<UserModel>(context);//isso faz não precisar mais do ScopedModelDescendant

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    _loadCurrentUser();
  }

  void signUp({@required Map<String, dynamic> userData, @required String pass,
    @required VoidCallback onSuccess, @required VoidCallback onFail})async{//savar usuario
    isLoading = true;
    notifyListeners();

    _auth.createUserWithEmailAndPassword(//criando o usuario
        email: userData["email"],
        password: pass
    ).then((user) async {//salvando o usuario se deu sucesso
      firebaseUser = user;
      await _saveUserData(userData);

      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((e){//se der erro
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void signIn({@required String email, @required String pass,
      @required VoidCallback onSuccess, @required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();//serve para recriar tudo q esta no ScopedModelDescendant

   _auth.signInWithEmailAndPassword(
       email: email,
       password: pass
   ).then((user) async {
     firebaseUser = user;

     await _loadCurrentUser();

     onSuccess();
     isLoading = false;
     notifyListeners();
   }).catchError((e){
     onFail();
     isLoading = false;
     notifyListeners();
   });
  }

  void signOut() async{
    await _auth.signOut();

    userData = Map();
    firebaseUser = null;

    notifyListeners();
  }

  void recoverPass(String email){//redefinir a senha
    _auth.sendPasswordResetEmail(email: email);

  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async{
  //salva os dados no firebase
    this.userData = userData;
    await Firestore.instance.collection("users").document(firebaseUser.uid).setData(userData);
  }

  Future<Null> _loadCurrentUser() async{
    if(firebaseUser == null)
      firebaseUser = await _auth.currentUser();
    if(firebaseUser != null){
      if(userData["name"]==null){
        DocumentSnapshot docUser = await
          Firestore.instance.collection("users").document(firebaseUser.uid).get();
        userData = docUser.data;
      }
    }
    notifyListeners();
  }

  bool isLoggedIn(){
    return firebaseUser != null;
  }
}


