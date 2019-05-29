import 'package:flutter/material.dart';
import 'package:loja_virtual/tabs/home_tab.dart';
import 'package:loja_virtual/tabs/orders_tab.dart';
import 'package:loja_virtual/tabs/places_tab.dart';
import 'package:loja_virtual/tabs/products_tab.dart';
import 'package:loja_virtual/widgets/cart_button.dart';
import 'package:loja_virtual/widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {

  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(//posibilita a passagem de tela pro lado
      controller: _pageController,//controla as paginas
      physics: NeverScrollableScrollPhysics(),//não deixa fazer a passagem por movimentos na tela
      children: <Widget>[
       Scaffold(
         body: HomeTab(),
         drawer: CustomDrawer(_pageController),//acrescenta o botão de 3 barras, mandando o _pageController
         floatingActionButton: CartButton(),
       ),
       Scaffold(
         appBar: AppBar(//criação das paginas
           title: Text("Produtos"),
           centerTitle: true,
         ),
         drawer: CustomDrawer(_pageController),
         body: ProductsTab(),
         floatingActionButton: CartButton(),
       ),
       Scaffold(
         appBar: AppBar(
           title: Text("Lojas"),
           centerTitle: true,
         ),
         body: PlacesTab(),
         drawer: CustomDrawer(_pageController),
       ),
       Scaffold(
         appBar: AppBar(
           title: Text("Meus pedidos"),
           centerTitle: true,
         ),
         drawer: CustomDrawer(_pageController),
         body: OrdersTab(),
         floatingActionButton: CartButton(),
       )
      ],
    );
  }
}
