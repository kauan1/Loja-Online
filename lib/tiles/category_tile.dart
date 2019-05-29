import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/screens/category_screen.dart';

class CategoryTile extends StatelessWidget {

  final DocumentSnapshot snapshot;

  CategoryTile(this.snapshot);

  @override
  Widget build(BuildContext context) {//criação de cada categoria
    return ListTile(
      leading: CircleAvatar(//criação do icone
        radius: 25.0,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(snapshot.data["icon"]),
      ),
      title: Text(snapshot.data["title"]),
      trailing: Icon(Icons.keyboard_arrow_right),//faz a seta no lado direito
      onTap: (){
        Navigator.of(context).push(//quando se clica na categoria avança para a
          // pgina com os produtos dessa categoria
          MaterialPageRoute(
              builder: (context)=>CategoryScreen(snapshot))
        );
      },
    );
  }
}
