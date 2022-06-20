// ignore_for_file: prefer_const_constructors, missing_required_param, unnecessary_new, import_of_legacy_library_into_null_safe, override_on_non_overriding_member, prefer_const_constructors_in_immutables, unused_local_variable, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/products.dart';
import 'package:shop/widget/feeds_products.dart';

class CategoriesFeedScreen extends StatelessWidget {
  static const routeName = '/CategoriesFeedScreen';
  CategoriesFeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<Products>(context, listen: false);
    final categoryName = ModalRoute.of(context)!.settings.arguments as String;
    print(categoryName);
    final productsList = productProvider.findByCategory(categoryName);
    return Scaffold(
      body: productsList.isEmpty
          ? Padding(
              padding: const EdgeInsets.only(left: 80, top: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Icon(
                    Feather.database,
                    size: 80,
                  ),
                  Text(
                    'Aradığınız ürün şuan da yok',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                ],
              ),
            )
          : GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 220 / 420,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: List.generate(productsList.length, (index) {
                return ChangeNotifierProvider.value(
                  value: productsList[index],
                  child: FeedProducts(),
                );
              }),
            ),
    );
  }
}
