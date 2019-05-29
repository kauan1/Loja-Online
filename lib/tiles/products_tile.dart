import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/screens/product_screen.dart';

class ProductTile extends StatelessWidget {

  final String type;
  final ProductData product;

  ProductTile(this.type, this.product);

  @override
  Widget build(BuildContext context) {
    return InkWell(//quando se toca nela faz uma pequena animação diferente
      // do Getoridetector
      onTap: (){//faz abrir a tela do produto
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context)=> ProductScreen(product))
        );
      },
      child: Card(//criação de cada elemento da grid ou list
        child: type == "grid" ?
          Column(//quando for grid
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              AspectRatio(
                aspectRatio: 0.808,
                child: Image.network(
                    product.images[0],
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                          product.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w500
                        ),
                      ),
                      Text(
                          "R\$ ${product.price.toStringAsFixed(2)}",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
          : Row(//criação quando for lista
           children: <Widget>[
             Flexible(
               flex: 1,
               child: Image.network(
                   product.images[0],
                 fit: BoxFit.cover,
                 height: 250.0,
               ),
             ),
             Flexible(
               flex: 1,
               child: Container(
                 padding: EdgeInsets.all(8.0),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: <Widget>[
                     Text(
                       product.title,
                       style: TextStyle(fontWeight: FontWeight.w500),
                     ),
                     Text(
                       "R\$ ${product.price.toStringAsFixed(2)}",
                       style: TextStyle(
                         color: Theme.of(context).primaryColor,
                         fontSize: 18.0,
                         fontWeight: FontWeight.bold
                       ),
                     ),
                   ],
                 ),
               ),
             )
           ],
        )
      ),
    );
  }
}
