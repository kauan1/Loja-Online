import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:collection';//para poder usar o LinkedHashMap

class OrderTile extends StatelessWidget {

  final String orderId;

  OrderTile(this.orderId);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: StreamBuilder<DocumentSnapshot>(//fica analisando o banco de dados em tempo real pra ver se tem alguma alteração
          //e se tiver faz essa alteração
            stream: Firestore.instance.collection("orders").document(orderId)
            .snapshots(),//se fosse usado get no lugar de snapshot, faria uma imagem do banco e não algo dinamico
            builder: (context, snapshot){
              if(!snapshot.hasData){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }else{

                int status = snapshot.data["status"];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Código do pedido: ${snapshot.data.documentID}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4.0,),
                    Text(
                      _buildProductsText(snapshot.data),
                    ),
                    SizedBox(height: 4.0,),
                    Text(
                      "Status:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 4.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,//para ajudar no espaçamento dos circulos
                      children: <Widget>[
                        _buildCircle("1", "Preparação", status, 1),
                        _line(),
                        _buildCircle("2", "Transporte", status, 2),
                        _line(),
                        _buildCircle("3", "Entrega", status, 3)
                      ],
                    )
                  ],
                );
              }
            }
        ),
      ),
    );
  }
  String _buildProductsText(DocumentSnapshot snapshot){
    String text = "Descrição:\n";
    for(LinkedHashMap p in snapshot.data["products"]){
      text += "${p["quantity"]} x ${p["product"]["title"]} (R\$ ${p["product"]["price"].toStringAsFixed(2)})\n";
    }
    text += "Total: R\$ ${snapshot.data["totalPrice"]}";
    return text;
  }

  Widget _buildCircle(String title, String subTitle, int status, int thisStatus){
//cria os circulos dos status do pedido
    Color backColor;
    Widget child;

    if(status<thisStatus){
      backColor = Colors.grey[500];
      child = Text(title, style: TextStyle(color: Colors.white),);
    }else if(status == thisStatus){
      backColor = Colors.blue;
      child = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Text(title, style: TextStyle(color: Colors.white),),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        ],
      );
    }else{
     backColor = Colors.green;
     child = Icon(Icons.check, color: Colors.white,);
    }

    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 20.0,
          backgroundColor: backColor,
          child: child,
        ),
        Text(subTitle)
      ],
    );
  }

  Widget _line(){//cria a linha
    return Container(
      height: 1.0,
      width: 40.0,
      color: Colors.grey[500],
    );
  }
}
