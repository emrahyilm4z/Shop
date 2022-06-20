// ignore_for_file: unused_field, non_constant_identifier_names, avoid_function_literals_in_foreach_calls, prefer_final_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:shop/models/products.dart';

class Products extends ChangeNotifier {
  List<Product> _products = [];
  List<Product> get products {
    return [..._products];
  }

  Future<void> FetchProducts() async {
    await FirebaseFirestore.instance
        .collection('products')
        .get()
        .then((QuerySnapshot productSnapshot) {
      _products = [];
      productSnapshot.docs.forEach((element) {
        _products.insert(
            0,
            Product(
                element.get('productId'),
                element.get('productTitle'),
                element.get('productDescription'),
                double.parse(element.get('price')),
                element.get('productImage'),
                element.get('productCategory'),
                element.get('productBrand'),
                int.parse(element.get('productQuantity')),
                true));
      });
    });
  }

  List<Product> findByCategory(String categoryName) {
    var _categoryList = _products
        .where((element) => element.productCategoryName
            .toLowerCase()
            .contains(categoryName.toLowerCase()))
        .toList();

    return _categoryList;
  }

  List<Product> get popularProducts {
    return _products.where((element) => element.isPopular).toList();
  }

  List<Product> findByBrand(String brandName) {
    var _categoryList = _products
        .where((element) =>
            element.brand.toLowerCase().contains(brandName.toLowerCase()))
        .toList();
    return _categoryList;
  }

  Product findById(String productId) {
    return _products.firstWhere((element) => element.id == productId);
  }

  List<Product> searchQuery(String searchText) {
    var _searchList = _products
        .where((element) =>
            element.title.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
    return _searchList;
  }
  /* 
  final List<Product> _products = [
    Product(
        'Samsung',
        'Samsung Galaxy S9',
        'Emrah mobile phone',
        50.99,
        'https://images-na.ssl-images-amazon.com/images/I/81%2Bh9mpyQmL._AC_SL1500_.jpg',
        'Telefon',
        'Samsung',
        65,
        true,
        true),
    Product(
        'Samsung Galaxy A10s',
        'Samsung Galaxy A10s',
        'Samsung Galaxy A10s A107M - 32GB, 6.2" HD+ Infinity-V Display, 13MP+2MP Dual Rear +8MP Front Cameras, GSM Unlocked Smartphone - Blue.',
        50.99,
        'https://images-na.ssl-images-amazon.com/images/I/51ME-ADMjRL._AC_SL1000_.jpg',
        'Phones',
        'Samsung',
        1002,
        true,
        true),
    Product(
        'Samsung Galaxy A51',
        'Samsung Galaxy A51',
        'Samsung Galaxy A51 (128GB, 4GB) 6.5", 48MP Quad Camera, Dual SIM GSM Unlocked A515F/DS- Global 4G LTE International Model - Prism Crush Blue.',
        50.99,
        'https://images-na.ssl-images-amazon.com/images/I/61HFJwSDQ4L._AC_SL1000_.jpg',
        'Phones',
        'Samsung',
        6423,
        true,
        true),
    Product(
        'Huawei P40 Pro',
        'Huawei P40 Pro',
        'Huawei P40 Pro (5G) ELS-NX9 Dual/Hybrid-SIM 256GB (GSM Only | No CDMA) Factory Unlocked Smartphone (Silver Frost) - International Version',
        900.99,
        'https://images-na.ssl-images-amazon.com/images/I/6186cnZIdoL._AC_SL1000_.jpg',
        'Phones',
        'Huawei',
        3,
        true,
        true),
    Product(
        'iPhone 12 Pro',
        'iPhone 12 Pro',
        'New Apple iPhone 12 Pro (512GB, Gold) [Locked] + Carrier Subscription',
        1100,
        'https://m.media-amazon.com/images/I/71cSV-RTBSL.jpg',
        'Phones',
        'Apple',
        3,
        true,
        true),
    Product(
        'iPhone 12 Pro Max ',
        'iPhone 12 Pro Max ',
        'New Apple iPhone 12 Pro Max (128GB, Graphite) [Locked] + Carrier Subscription',
        50.99,
        'https://m.media-amazon.com/images/I/71XXJC7V8tL._FMwebp__.jpg',
        'Phones',
        'Apple',
        2654,
        false,
        true),
    Product(
        'Hanes Mens ',
        'Long Sleeve Beefy Henley Shirt',
        'Hanes Men\'s Long Sleeve Beefy Henley Shirt ',
        22.30,
        'https://images-na.ssl-images-amazon.com/images/I/91YHIgoKb4L._AC_UX425_.jpg',
        'Elbiseler',
        'Marka yok',
        58466,
        true,
        true),
    Product(
        'Weave Jogger',
        'Weave Jogger',
        'Champion Mens Reverse Weave Jogger',
        58.99,
        'https://m.media-amazon.com/images/I/71g7tHQt-sL._AC_UL320_.jpg',
        'Elbiseler',
        'H&M',
        84894,
        false,
        true),
    Product(
        'Trefoil Tee',
        'Trefoil Tee',
        'Originals Women\'s Trefoil Tee ',
        88.88,
        'https://images-na.ssl-images-amazon.com/images/I/51KMhoElQcL._AC_UX466_.jpg',
        'Elbiseler',
        'Adidas',
        8941,
        true,
        false),
    Product(
        'Long SleeveWoman',
        'Long Sleeve woman',
        ' Boys\' Long Sleeve Cotton Jersey Hooded T-Shirt Tee',
        68.29,
        'https://images-na.ssl-images-amazon.com/images/I/71lKAfQDUoL._AC_UX466_.jpg',
        'Elbiseler',
        'Adidas',
        3,
        false,
        true),
    Product(
        'Mango Body Yogurt',
        'Mango Body Yogurt',
        'The Body Shop Mango Body Yogurt, 48hr Moisturizer, 100% Vegan, 6.98 Fl.Oz',
        80.99,
        'https://images-na.ssl-images-amazon.com/images/I/81w9cll2RmL._SL1500_.jpg',
        'Bakım',
        'Marka yok',
        3,
        false,
        false),
    Product(
        '15 5000 Laptop',
        '15 5000 Laptop',
        'Dell Inspiron 15 5000 Laptop Computer: Core i7-8550U, 128GB SSD + 1TB HDD, 8GB RAM, 15.6-inch Full HD Display, Backlit Keyboard, Windows 10 ',
        630.99,
        'https://images-na.ssl-images-amazon.com/images/I/31ZSymDl-YL._AC_.jpg',
        'Dizüstü PC',
        'Dell',
        325,
        true,
        false),
    Product(
        'Business Laptop',
        'Business Laptop',
        'Latest Dell Vostro 14 5490 Business Laptop 14.0-Inch FHD 10th Gen Intel Core i7-10510U Up to 4.9 GHz 16GB DDR4 RAM 512GB M.2 PCIe SSD GeForce MX250 2GB GDDR5 GPU Fingerprint Reader Type-C Win10 Pro ',
        1220.99,
        'https://images-na.ssl-images-amazon.com/images/I/71W690nu%2BXL._AC_SL1500_.jpg',
        'Dizüstü PC',
        'Dell',
        81,
        true,
        true),
    Product(
        'New Apple MacBook Pro with Apple',
        'New Apple MacBook Pro with Apple',
        'New Apple MacBook Pro with Apple M1 Chip (13-inch, 8GB RAM, 256GB SSD Storage) - Space Gray (Latest Model)',
        800.99,
        'https://images-na.ssl-images-amazon.com/images/I/71an9eiBxpL._AC_SL1500_.jpg',
        'Dizüstü PC',
        'Apple',
        885,
        true,
        true),
    Product(
        'Furniture Classroom with Teacher\'s',
        'Furniture Classroom with Teacher\'s',
        'L.O.L. Surprise! Furniture Classroom with Teacher\'s Pet & 10+ Surprises',
        120.99,
        'https://images-na.ssl-images-amazon.com/images/I/71xytsyiHzL._AC_SL1500_.jpg',
        'Mobilyalar',
        'Marka yok',
        815,
        true,
        true),
    Product(
        'Training Pant Female',
        'Training Pant Female',
        'Nike Epic Training Pant Female ',
        189.99,
        'https://images-na.ssl-images-amazon.com/images/I/61jvFw72OVL._AC_UX466_.jpg',
        'Elbiseler',
        'Nike',
        89741,
        true,
        true),
    Product(
        'Apple Watch Series 3',
        'Apple Watch Series 3',
        'Apple Watch Series 3 (GPS, 38mm) - Silver Aluminum Case with White Sport Band',
        100.99,
        'https://images-na.ssl-images-amazon.com/images/I/71vCuRn4CkL._AC_SL1500_.jpg',
        'Saat',
        'Apple',
        156,
        true,
        true),
    Product(
        'Huawei Watch 2 Sport Smartwatch',
        'Huawei Watch 2 Sport Smartwatch',
        'Huawei Watch 2 Sport Smartwatch - Ceramic Bezel - Carbon Black Strap (US Warranty)',
        180.99,
        'https://images-na.ssl-images-amazon.com/images/I/71yPa1g4gWL._AC_SL1500_.jpg',
        'Saat',
        'Huawei',
        951,
        true,
        true),
  ];
  */
}
