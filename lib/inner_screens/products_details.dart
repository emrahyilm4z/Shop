// ignore_for_file: use_key_in_widget_constructors, avoid_print, prefer_const_constructors

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/consts/colors.dart';
import 'package:shop/consts/my_icons.dart';
import 'package:shop/provider/cart_provider.dart';
import 'package:shop/provider/dark_theme_provider.dart';
import 'package:shop/provider/favs_provider.dart';
import 'package:shop/provider/products.dart';
import 'package:shop/screens/cart.dart';
import 'package:shop/screens/wishlist/wishlist.dart';
import 'package:shop/widget/feeds_products.dart';

class ProductDetails extends StatefulWidget {
  static const routeName = '/ProductDetails';

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final productsData = Provider.of<Products>(context, listen: false);
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    final cartProvider = Provider.of<CartProvider>(context);
    final favsProvider = Provider.of<FavsProvider>(context);
    print('productId $productId');
    final prodAttr = productsData.findById(productId);
    final productsList = productsData.products;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            foregroundDecoration: const BoxDecoration(color: Colors.black12),
            height: MediaQuery.of(context).size.height * 0.45,
            width: double.infinity,
            child: Image.network(
              prodAttr.imageUrl,
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 16.0, bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 250),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const <Widget>[],
                  ),
                ),
                Container(
                  //padding: const EdgeInsets.all(16.0),
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Text(
                                prodAttr.title,
                                maxLines: 2,
                                style: const TextStyle(
                                  // color: Theme.of(context).textSelectionColor,
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              '₺ ${prodAttr.price}',
                              style: TextStyle(
                                  color: themeState.darkTheme
                                      ? Theme.of(context).disabledColor
                                      : ColorsConsts.subTitle,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 21.0),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 3.0),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          prodAttr.description,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 21.0,
                            color: themeState.darkTheme
                                ? Theme.of(context).disabledColor
                                : ColorsConsts.subTitle,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey,
                          height: 1,
                        ),
                      ),
                      _details(themeState.darkTheme, 'Marka: ', prodAttr.brand),
                      _details(themeState.darkTheme, 'Kalan adet sayısı: ',
                          '${prodAttr.quantity}'),
                      _details(themeState.darkTheme, 'Kategori: ',
                          prodAttr.productCategoryName),
                      _details(themeState.darkTheme, 'Popülerlik: ',
                          prodAttr.isPopular ? 'Popular' : 'Pupular'),
                      const SizedBox(
                        height: 15,
                      ),
                      const Divider(
                        thickness: 1,
                        color: Colors.grey,
                        height: 1,
                      ),

                      // const SizedBox(height: 15.0),
                      Container(
                        color: Theme.of(context).backgroundColor,
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10.0),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Henüz yorum yok :(',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textSelectionTheme
                                        .selectionColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 21.0),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                'İlk yorumu sen yapabilirsin :)',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20.0,
                                  color: themeState.darkTheme
                                      ? Theme.of(context).disabledColor
                                      : ColorsConsts.subTitle,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 70,
                            ),
                            const Divider(
                              thickness: 1,
                              color: Colors.grey,
                              height: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // const SizedBox(height: 15.0),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8.0),
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: const Text(
                    'Önerilen ürünler:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  width: double.infinity,
                  height: 360,
                  child: ListView.builder(
                    itemCount:
                        productsList.length < 7 ? productsList.length : 7,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext ctx, int index) {
                      return ChangeNotifierProvider.value(
                          value: productsList[index], child: FeedProducts());
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                title: const Text(
                  "DETAY",
                  style:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
                ),
                actions: <Widget>[
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
                              Navigator.of(context)
                                  .pushNamed(CartScreen.routeName);
                            },
                          ),
                        )),
                  ),
                ]),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Row(children: [
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.redAccent.shade400,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(side: BorderSide.none),
                      ),
                      onPressed: () {
                        cartProvider.getCartItemns.containsKey(productId)
                            ? Null
                            : cartProvider.addProductToCart(
                                productId,
                                prodAttr.price,
                                prodAttr.title,
                                prodAttr.imageUrl);
                      },
                      child: Text(
                        cartProvider.getCartItemns.containsKey(productId)
                            ? "Sepetinde mevcut".toUpperCase()
                            : 'Sepete ekle'.toUpperCase(),
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).backgroundColor,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape:
                            const RoundedRectangleBorder(side: BorderSide.none),
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext ctx) {
                              return AlertDialog(
                                title: Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 6.0),
                                      child: Image.network(
                                        'https://cdn.pixabay.com/photo/2012/04/16/13/51/sign-36070_960_720.png',
                                        height: 20,
                                        width: 20,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Üzgünüm'),
                                    ),
                                  ],
                                ),
                                content: Text(
                                    'Şu anda isteğini gerçekleştiremiyorum'),
                                actions: [
                                  TextButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Tamam')),
                                ],
                              );
                            });
                      },
                      child: Row(
                        children: [
                          Text(
                            'satın al'.toUpperCase(),
                            style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context)
                                    .textSelectionTheme
                                    .selectionColor),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.payment,
                            color: Colors.green.shade700,
                            size: 19,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: themeState.darkTheme
                        ? Theme.of(context).disabledColor
                        : ColorsConsts.subTitle,
                    height: 50,
                    child: InkWell(
                      splashColor: ColorsConsts.favColor,
                      onTap: () {
                        favsProvider.addAndRemoveFromFav(productId,
                            prodAttr.price, prodAttr.title, prodAttr.imageUrl);
                      },
                      child: Center(
                        child: Icon(
                          favsProvider.getFavsItemns.containsKey(productId)
                              ? Icons.favorite
                              : MyAppIcons.wishlist,
                          color:
                              favsProvider.getFavsItemns.containsKey(productId)
                                  ? Colors.red
                                  : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ]))
        ],
      ),
    );
  }

  Widget _details(bool themeState, String title, String info) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 16, right: 16),
      child: Row(
        //  mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                color: Theme.of(context).textSelectionTheme.selectionColor,
                fontWeight: FontWeight.w600,
                fontSize: 21.0),
          ),
          Text(
            info,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 20.0,
              color: themeState
                  ? Theme.of(context).disabledColor
                  : ColorsConsts.subTitle,
            ),
          ),
        ],
      ),
    );
  }
}
