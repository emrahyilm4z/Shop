// ignore_for_file: unused_local_variable, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:provider/provider.dart';
import 'package:shop/consts/colors.dart';
import 'package:shop/consts/my_icons.dart';
import 'package:shop/inner_screens/products_details.dart';
import 'package:shop/provider/cart_provider.dart';
import 'package:shop/provider/dark_theme_provider.dart';
import 'package:shop/provider/favs_provider.dart';
import 'package:shop/provider/products.dart';

class FeedDialog extends StatelessWidget {
  final String productId;
   FeedDialog({required this.productId});

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context);
    final favsProvider = Provider.of<FavsProvider>(context);
    final prodAttr = productsData.findById(productId);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Column(children: [
          Container(
            constraints: BoxConstraints(
                minHeight: 100,
                maxHeight: MediaQuery.of(context).size.height * 0.5),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: Image.network(
              prodAttr.imageUrl,
            ),
          ),
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: dialogContent(
                        context,
                        0,
                        () => {
                              favsProvider.addAndRemoveFromFav(
                                  productId,
                                  prodAttr.price,
                                  prodAttr.title,
                                  prodAttr.imageUrl),
                              Navigator.canPop(context)
                                  ? Navigator.pop(context)
                                  : null
                            }),
                  ),
                  Flexible(
                      child: dialogContent(
                          context,
                          1,
                          () => {
                                Navigator.pushNamed(
                                        context, ProductDetails.routeName,
                                        arguments: prodAttr.id)
                                    .then((value) => Navigator.canPop(context)
                                        ? Navigator.pop(context)
                                        : null)
                              })),
                  Flexible(
                    child: dialogContent(
                      context,
                      2,
                      () {
                        cartProvider.getCartItemns.containsKey(productId)
                            ? Null
                            : cartProvider.addProductToCart(
                                productId,
                                prodAttr.price,
                                prodAttr.title,
                                prodAttr.imageUrl);
                        Navigator.canPop(context)
                            ? Navigator.pop(context)
                            : null;
                      },
                    ),
                  ),
                ]),
          ),

          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.3),
                shape: BoxShape.circle),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                splashColor: Colors.grey,
                onTap: () =>
                    Navigator.canPop(context) ? Navigator.pop(context) : null,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.close, size: 28, color: Colors.white),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget dialogContent(BuildContext context, int index, VoidCallback fct) {
    final cart = Provider.of<CartProvider>(context);
    final favs = Provider.of<FavsProvider>(context);
    List<IconData> _dialogIcons = [
      favs.getFavsItemns.containsKey(productId)
          ? Icons.favorite
          : Icons.favorite_border,
      Feather.eye,
      MyAppIcons.cart,
      MyAppIcons.trash,
    ];

    List<String> _texts = [
      favs.getFavsItemns.containsKey(productId) ? 'Favorilerde' : 'Favorilerde',
      'Ürünü incele',
      cart.getCartItemns.containsKey(productId) ? 'Sepetinde' : 'Sepete ekle',
    ];
    List<Color?> _colors = [
      favs.getFavsItemns.containsKey(productId)
          ? Colors.red
          : Theme.of(context).textSelectionTheme.selectionColor,
      Theme.of(context).textSelectionTheme.selectionColor,
      Theme.of(context).textSelectionTheme.selectionColor,
    ];
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return FittedBox(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: fct,
          splashColor: Colors.grey,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.25,
            padding: const EdgeInsets.all(4),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: Offset(0.0, 10.0),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    // inkwell color
                    child: SizedBox(
                        width: 50,
                        height: 50,
                        child: Icon(
                          _dialogIcons[index],
                          color: _colors[index],
                          size: 25,
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: FittedBox(
                    child: Text(
                      _texts[index],
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        //  fontSize: 15,
                        color: themeChange.darkTheme
                            ? Theme.of(context).disabledColor
                            : ColorsConsts.subTitle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
