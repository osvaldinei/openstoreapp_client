import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {

  final String orderId;

  OrderTile(this.orderId);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: StreamBuilder<DocumentSnapshot>(
          
          stream: Firestore.instance.collection("orders").document(orderId).snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData)
              return Center(child: CircularProgressIndicator(),);
            else{
              return Column(children: [
                Text("Código do pedido: ${snapshot.data.documentID}", style: TextStyle(fontWeight: FontWeight.bold),)
              ],);
            }  
          }, 
        )
      )
    );
  }
}