import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {

  final String OrderId;

  OrderTile(this.OrderId);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Text(OrderId)
    );
  }
}