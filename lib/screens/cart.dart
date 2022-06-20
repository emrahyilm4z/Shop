// ignore_for_file: prefer_const_constructors, deprecated_member_use, unnecessary_cast, unnecessary_string_escapes
import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:provider/provider.dart';
import 'package:shop/consts/colors.dart';
import 'package:shop/provider/cart_provider.dart';
import 'package:shop/services/global_method.dart';
import 'package:shop/screens/cart/cart_empty.dart';
import 'package:shop/screens/cart/cart_full.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/CartScreen';
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalMethod globalMethods = GlobalMethod();
    final cartProvider = Provider.of<CartProvider>(context);

    return cartProvider.getCartItemns.isEmpty
        ? Scaffold(body: CartEmpty())
        : Scaffold(
            bottomSheet: checkoutSection(context, cartProvider.totalAmount),
            appBar: AppBar(
                backgroundColor: Theme.of(context).backgroundColor,
                title: Text(
                  'Sepetinde ${cartProvider.getCartItemns.length} adet ürün var',
                  style: TextStyle(
                      color:
                          Theme.of(context).textSelectionTheme.selectionColor),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      globalMethods.showDialogg(
                          'Dikkat',
                          'Sepetteki ürünleri silmek istediğine emin misin?',
                          () => cartProvider.clearCart(),
                          context);
                    },
                    icon: Icon(
                      Feather.trash,
                      color:
                          Theme.of(context).textSelectionTheme.selectionColor,
                    ),
                  )
                ]),
            body: Container(
              margin: EdgeInsets.only(bottom: 60),
              child: ListView.builder(
                  itemCount: cartProvider.getCartItemns.length,
                  itemBuilder: (BuildContext contex, int index) {
                    return ChangeNotifierProvider.value(
                      value: cartProvider.getCartItemns.values.toList()[index],
                      child: CartFull(
                        productId:
                            cartProvider.getCartItemns.keys.toList()[index],
                      ),
                    );
                  }),
            ));
  }

  Widget checkoutSection(BuildContext context, double subTotal) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(colors: [
                    ColorsConsts.gradiendLStart,
                    ColorsConsts.gradiendLEnd,
                  ], stops: const [
                    0.0,
                    0.9
                  ]),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext ctx) {
                            return AlertDialog(
                              title: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 6.0),
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
                              content:
                                  Text('Şu anda isteğini gerçekleştiremiyorum'),
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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Sipariş ver',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context as BuildContext)
                                .textSelectionTheme
                                .selectionColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Spacer(),
            Text(
              'Toplam : ',
              style: TextStyle(
                  color: Theme.of(context as BuildContext)
                      .textSelectionTheme
                      .selectionColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            Text(
              '${subTotal.toStringAsFixed(3)}\ ₺',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
