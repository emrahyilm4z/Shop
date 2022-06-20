// ignore_for_file: prefer_const_constructors, missing_required_param, unnecessary_new, import_of_legacy_library_into_null_safe, override_on_non_overriding_member, prefer_const_constructors_in_immutables, no_logic_in_create_state, unused_element

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/consts/colors.dart';
import 'package:shop/consts/my_icons.dart';
import 'package:shop/models/products.dart';
import 'package:shop/provider/cart_provider.dart';
import 'package:shop/provider/favs_provider.dart';
import 'package:shop/provider/products.dart';
import 'package:shop/screens/cart.dart';
import 'package:shop/screens/wishlist/wishlist.dart';
import 'package:shop/widget/feeds_products.dart';

class FeedsScreen extends StatefulWidget {
  static const routeName = '/FeedsScreen';

  const FeedsScreen({super.key});

  @override
  _FeedsScreenState createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  Future<void> _getProductsOnRefresh() async {
    await Provider.of<Products>(context, listen: false).FetchProducts();
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    final popular = ModalRoute.of(context)!.settings.arguments.toString();

    final productProvider = Provider.of<Products>(context);

    List<Product> productsList = productProvider.products;
    if (popular.length == 4) {
      productsList = productProvider.popularProducts;
    }
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Önerilenler',
            style: TextStyle(
                color: Theme.of(context).textSelectionTheme.selectionColor),
          ),
          backgroundColor: Theme.of(context).cardColor,
          actions: [
            Consumer<FavsProvider>(
              builder: ((_, favs, ch) => Badge(
                    badgeColor: Colors.red,
                    animationType: BadgeAnimationType.slide,
                    toAnimate: true,
                    position: BadgePosition.topEnd(top: 5, end: 7),
                    badgeContent: Text(
                      favs.getFavsItemns.length.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                    child: IconButton(
                      icon: Icon(
                        MyAppIcons.wishlist,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(WishlistScreen.routeName);
                      },
                    ),
                  )),
            ),
            Consumer<CartProvider>(
              builder: ((_, cart, ch) => Badge(
                    badgeColor: Colors.red,
                    animationType: BadgeAnimationType.slide,
                    toAnimate: true,
                    position: BadgePosition.topEnd(top: 5, end: 7),
                    badgeContent: Text(
                      cart.getCartItemns.length.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                    child: IconButton(
                      icon: Icon(
                        MyAppIcons.cart,
                        color: ColorsConsts.cartColor,
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(CartScreen.routeName);
                      },
                    ),
                  )),
            ),
          ]),
      body: RefreshIndicator(
        onRefresh: _getProductsOnRefresh,
        child: GridView.count(
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
      ),
    );
  }
}
