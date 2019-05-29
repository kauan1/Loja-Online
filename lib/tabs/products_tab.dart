import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/tiles/category_tile.dart';

class ProductsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(//pega um valor futuro para se construir a tela
      future: Firestore.instance.collection("products").getDocuments(),//pega o caminho dos dados
      builder: (context, snapshot) {//cria a tela de produtos
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        else {
          var dividedTiles = ListTile.divideTiles(//faz as divisorias entre cada categoria
                  tiles: snapshot.data.documents.map((doc) {
                    return CategoryTile(doc);
                  }).toList(),
                  color: Theme.of(context).primaryColor)
              .toList();//retorna uma lista com todas as categorias e divisorias

          return ListView(//cria a lista
            children: dividedTiles,
          );
        }
      },
    );
  }
}
