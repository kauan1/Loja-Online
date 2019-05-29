import 'package:flutter/material.dart';
import 'package:loja_virtual/screens/home_screen.dart';
import 'package:scoped_model/scoped_model.dart';

import 'models/cart_model.dart';
import 'models/user_model.dart';

void main(){
  runApp(Home());
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),//vai conter o estado do login
      child: ScopedModelDescendant<UserModel>(//esse
          builder: (context, child, model){
            return ScopedModel<CartModel>(//e esse faz o cartmodel ter acesso ao usermodel
              model: CartModel(model),
              child: MaterialApp(
                title: "Flutter's Clothing",
                theme: ThemeData(//declaração do tema pricipal
                    primarySwatch: Colors.blue,
                    primaryColor: Color.fromARGB(255, 4, 125, 141)
                ),
                home: HomeScreen(),
                debugShowCheckedModeBanner: false,
              ),
            );
          }
      )
    );
  }
}
