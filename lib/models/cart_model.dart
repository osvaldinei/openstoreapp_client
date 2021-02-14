import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:openstoreapp_client/datas/cart_product.dart';
import 'package:openstoreapp_client/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model{

  UserModel user;
  List<CartProduct> products = [];

  bool isLoading = false;

  CartModel(this.user){
    if(user.isLoggedIn()){
      _loadCardItems();
    }
  }

  static CartModel of(BuildContext context) =>
    ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct cartProduct){
    products.add(cartProduct);

    Firestore.instance.collection("users").doc(user.firebaseUser.user.uid).collection("cart").add(cartProduct.toMap()).then((doc){
      cartProduct.cid = doc.documentID;
    });

    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct){

    Firestore.instance.collection("users").doc(user.firebaseUser.user.uid).collection("cart").document(cartProduct.cid).delete();

    products.remove(cartProduct);

    notifyListeners();

  }
  
  void decProduct(CartProduct cartProduct){
    cartProduct.quantity--;

    Firestore.instance.collection("users").document(user.firebaseUser.user.uid).collection("cart").doc(cartProduct.cid).updateData(cartProduct.toMap());

    notifyListeners();
  }

  void incProduct(CartProduct cartProduct){
    cartProduct.quantity++;

    Firestore.instance.collection("users").document(user.firebaseUser.user.uid).collection("cart").doc(cartProduct.cid).updateData(cartProduct.toMap());

    notifyListeners();
  }

  void _loadCardItems() async{
    QuerySnapshot query = await FirebaseFirestore.instance.collection("users").doc(user.firebaseUser.user.uid).collection("cart").get();
    
    products = query.docs.map((doc) => CartProduct.fromDocument(doc)).toList();

    notifyListeners();
  }
}