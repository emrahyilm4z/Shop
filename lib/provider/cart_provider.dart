// ignore_for_file: prefer_final_fields, non_constant_identifier_names

import 'package:flutter/widgets.dart';

import 'package:flutter/cupertino.dart';
import 'package:shop/models/cart_attr.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartAttr> _cartItems = {};
  Map<String, CartAttr> get getCartItemns {
    return {..._cartItems};
  }

  double get totalAmount {
    var total = 0.0;
    _cartItems.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void addProductToCart(
      String productId, double price, String title, String imageUrl) {
    if (_cartItems.containsKey(productId)) {
      _cartItems.update(
          productId,
          (exitingCartItem) => CartAttr(
              exitingCartItem.id,
              exitingCartItem.title,
              exitingCartItem.quantity + 1,
              exitingCartItem.price,
              exitingCartItem.imageUrl));
    } else {
      _cartItems.putIfAbsent(productId,
          () => CartAttr(DateTime.now().toString(), title, 1, price, imageUrl));
    }
    notifyListeners();
  }

  void reduceItemByOne(
      String productId) {
    _cartItems.update(
        productId,
        (exitingCartItem) => CartAttr(
            exitingCartItem.id,
            exitingCartItem.title,
            exitingCartItem.quantity - 1,
            exitingCartItem.price,
            exitingCartItem.imageUrl));
    notifyListeners();
  }

  void removeItem(String productId) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
