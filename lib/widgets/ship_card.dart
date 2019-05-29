import 'package:flutter/material.dart';

class ShipCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: ExpansionTile(
          title: Text("Calcular Frete",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[700]
            ),
          ),
        leading: Icon(Icons.location_on),
        trailing: Icon(Icons.keyboard_arrow_down),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: "Digite seu CEP",
                border: OutlineInputBorder()
              ),
              initialValue: "",
              onFieldSubmitted: (text){},
            ),
          )
        ],
      ),
    );
  }
}
