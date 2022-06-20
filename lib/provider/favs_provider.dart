// ignore_for_file: prefer_final_fields, non_constant_identifier_names

import 'package:flutter/widgets.dart';

import 'package:flutter/cupertino.dart';
import 'package:shop/models/favs_attr.dart';

class FavsProvider with ChangeNotifier {
  Map<String, FavsAttr> _favsItems = {};
  Map<String, FavsAttr> get getFavsItemns {
    return {..._favsItems};
  }

  void addAndRemoveFromFav(
      String productId, double price, String title, String imageUrl) {
    if (_favsItems.containsKey(productId)) {
      removeItem(productId);
    } else {
      _favsItems.putIfAbsent(productId,
          () => FavsAttr(DateTime.now().toString(), title, price, imageUrl));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _favsItems.remove(productId);
    notifyListeners();
  }

  void clearFavs() {
    _favsItems.clear();
    notifyListeners();
  }
}
