import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

class CartModel extends Model {

  UserModel user;

  List<CartProduct> products = [];

  String coupunCode;
  int discountPercentage = 0;

  bool isLoading = false;

  CartModel(this.user){
    if(user.isLoggedIn())
    _loadCartItems();
  }

  static CartModel of (BuildContext context) =>
      ScopedModel.of<CartModel>(context);//isso faz não precisar mais do ScopedModelDescendant

  void addCartItem(CartProduct cartProduct){//adicona um item ao carrinho
    products.add(cartProduct);

    Firestore.instance.collection("users").document(user.firebaseUser.uid)
    .collection("cart").add(cartProduct.toMap()).then((doc){
      cartProduct.cid = doc.documentID;
    });

    notifyListeners();
  }

  void removeCartProduct(CartProduct cartProduct){//remove o item do carrinho
    Firestore.instance.collection("users").document(user.firebaseUser.uid)
        .collection("cart").document(cartProduct.cid).delete();

    products.remove(cartProduct);

    notifyListeners();
  }

  void decProduct(CartProduct cartProduct){//diminui a quantidade
    cartProduct.quantity--;

    Firestore.instance.collection("users").document(user.firebaseUser.uid).
    collection("cart").document(cartProduct.cid).updateData(cartProduct.toMap());

    notifyListeners();
  }

  void incProduct(CartProduct cartProduct){//aumenta a quantidade
    cartProduct.quantity++;

    Firestore.instance.collection("users").document(user.firebaseUser.uid).
    collection("cart").document(cartProduct.cid).updateData(cartProduct.toMap());

    notifyListeners();
  }

  void setCoupon(String couponCode, int discountPercentage){//colocar o valor do desconto
    this.coupunCode = couponCode;
    this.discountPercentage = discountPercentage;
  }

  void updatePrices(){
    notifyListeners();
  }

  double getProductsPrice(){
    double price = 0.0;
    for(CartProduct c in products){
      if(c.productData != null){
        price+= c.quantity*c.productData.price;
      }
    }
    return price;
  }

  double getDiscount(){
    return getProductsPrice()*discountPercentage/100;
  }

  double getShipPrice(){
    return 9.99;
  }

  Future<String> finishOrder() async{//aqui fecha o pedido
    if(products.length == 0) return null;

    isLoading=true;
    notifyListeners();

    double productsPrice = getProductsPrice();
    double discount = getDiscount();
    double shipPrice = getShipPrice();
    
    DocumentReference refOrder = await
    Firestore.instance.collection("orders").add(//addciona um documento a coleção order
      {//campos do documento
        "clientId": user.firebaseUser.uid,
        "products": products.map((cartProduct)=>cartProduct.toMap()).toList(),
        "shipPrice": shipPrice,
        "productPrice": productsPrice,
        "discount": discount,
        "totalPrice": (productsPrice - discount + shipPrice),
        "status": 1
      }
    );

    await Firestore.instance.collection("users").document(user.firebaseUser.uid).
    collection("orders").document(refOrder.documentID).setData(//add a coleção order ao users
        {//add o campo orderId a coleção users
          "orderId" : refOrder.documentID
        }
      );

    QuerySnapshot query = await Firestore.instance.collection("users").
    document(user.firebaseUser.uid).collection("cart").getDocuments();//pega todos os documentos da coleçao cart

    for(DocumentSnapshot doc in query.documents){
      doc.reference.delete();//deleta todos os documentos da coleção users para deixar em um so lugar
    }

    products.clear();//limpa todos os produtos

    coupunCode = null;
    discountPercentage = 0;

    isLoading = false;
    notifyListeners();

    return refOrder.documentID;

  }

  void _loadCartItems() async {//carrega os itens do carrinho

    QuerySnapshot query = await Firestore.instance.collection("users").
    document(user.firebaseUser.uid).collection("cart").getDocuments();

    products = query.documents.map((doc)=> CartProduct.fromDocument(doc)).
    toList();

    notifyListeners();

  }

}