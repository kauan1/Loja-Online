import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget _buidBodyBack() => Container(
          //faz um degrade
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Color.fromARGB(255, 211, 118, 130),
            Color.fromARGB(255, 253, 181, 168)
          ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
        );

    return Stack(
      //permite colocar os widget um em cima do outro
      children: <Widget>[
        _buidBodyBack(),
        CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(//cria a Appbar flutuante
              floating: true,//faz com que a appbar flutue
              snap: true,//faz com q reapareça
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text("Novidades"),
                centerTitle: true,
              ),
            ),
            FutureBuilder<QuerySnapshot>(//pega os dados da internet
              future: Firestore.instance
                  .collection("home")
                  .orderBy("pos")
                  .getDocuments(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return SliverToBoxAdapter(//espera o carregamento
                    // - dentro da SliverAppBar tem que usar o SliverToBoxAdapter para exibir os valores
                    child: Container(
                      height: 200,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(//simbolo redondo de carregamento
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  );
                else {
                  return SliverStaggeredGrid.count(//fazer a grade de imagens
                    crossAxisCount: 2,
                    mainAxisSpacing: 1.0,
                    crossAxisSpacing: 1.0,
                    staggeredTiles: snapshot.data.documents.map((doc) {
                      return StaggeredTile.count(doc.data["x"], doc.data["y"]);
                    }).toList(),
                    children: snapshot.data.documents.map(
                        (doc){
                          return FadeInImage.memoryNetwork(//pegar da net
                              placeholder: kTransparentImage,
                              image: doc.data["image"],
                            fit: BoxFit.cover,
                          );
                        }
                    ).toList(),
                  );
                }
              },
            )
          ],
        )
      ],
    );
  }
}
