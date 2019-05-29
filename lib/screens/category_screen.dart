import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/tiles/products_tile.dart';

class CategoryScreen extends StatelessWidget {
  final DocumentSnapshot snapshot;//variavel q consegue pegar os dados

  CategoryScreen(this.snapshot);//inicialização

  @override
  Widget build(BuildContext context) {//nesse arquivo se cria as paginas das
    // categorias da pagina de produtos e demais
    return DefaultTabController(//faz os botões de grade e lista
      length: 2,//quantidade de formars que ira aparecer
      child: Scaffold(//habilita o appbar
        appBar: AppBar(
          title: Text(snapshot.data["title"]),
          //o titulo da appbar será o nome que o banco fornecer que será
          // qual produto será comprado
          centerTitle: true,
          bottom: TabBar(//declara onde os botões da appbar
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(//botão da appbar de grade
                icon: Icon(Icons.grid_on),
              ),
              Tab(//botão da appbar de lista
                icon: Icon(Icons.list),
              ),
            ],
          ),
        ),
        body: FutureBuilder<QuerySnapshot>(//pega um valor futuro para se construir a tela
            //fotografia de uma coleção de documentos
            future: Firestore.instance
                .collection("products")
                .document(snapshot.documentID)
                .collection("items")
                .getDocuments(),//chegando ate o local dos dados
            builder: (context, snapshot1) {//constroi a tela
              if (!snapshot1.hasData)//se não carregou os dados
                return Center(
                  child: CircularProgressIndicator(),//simbolo circular de carregamento
                );
              else
                return TabBarView(
                  physics: NeverScrollableScrollPhysics(),//não deixa passar de
                  // tela só passando pro lado. precisa usar os botões
                  children: [
                    GridView.builder(//criação em forma de grade e
                      // o buider faz com que os produtos vão sendo carregados
                      // enquanto o usuario vai passando para baixo, não
                      // carregando todos os dados de uma vez
                        padding: EdgeInsets.all(4.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          //quantidade de itens na horizontal e o espaçamento
                          // entre eles
                            crossAxisCount: 2,
                            mainAxisSpacing: 4.0,
                            crossAxisSpacing: 4.0,
                            childAspectRatio: 0.65
                        ),
                        itemCount: snapshot1.data.documents.length,//quantidade
                        // de itens
                        itemBuilder: (context,index){//construção de cada item
                          ProductData data = ProductData.fromDocument
                            (snapshot1.data.documents[index]);
                          data.category = this.snapshot.documentID;
                          return ProductTile("grid",data);
                        }
                    ),
                    ListView.builder(//criação em forma de lista e
                      // o buider faz com que os produtos vão sendo carregados
                      // enquanto o usuario vai passando para baixo, não
                      // carregando todos os dados de uma vez
                        padding: EdgeInsets.all(4.0),
                        itemCount: snapshot1.data.documents.length,//quantidade
                        // de itens
                        itemBuilder: (context,index){
                          ProductData data = ProductData.fromDocument
                            (snapshot1.data.documents[index]);
                          data.category = this.snapshot.documentID;
                          return ProductTile("list",data);
                        },
                    )
                  ],
                );
            }),
      ),
    );
  }
}
