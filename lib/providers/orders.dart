import 'dart:convert';

import 'package:flutter/foundation.dart';

import './cart.dart';
import 'package:http/http.dart' as http;

const ordersUrl =
    'https://buy-it-186b8-default-rtdb.firebaseio.com/orders.json';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
  Map<String, dynamic> toJson() => {
        'amount': amount,
        'products': products.map((e) => e.toJson()).toList(),
        'dateTime': dateTime.toString(),
      };
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartProducts, double total) async {
    var orderDto = OrderItem(
      id: DateTime.now().toString(),
      amount: total,
      dateTime: DateTime.now(),
      products: cartProducts,
    );
    final response =
        await http.post(ordersUrl, body: jsonEncode(orderDto.toJson()));
    if (response.statusCode == 200) {
      _orders.insert(0, orderDto);
      notifyListeners();
    }
  }
}
