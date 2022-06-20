// ignore_for_file: prefer_const_constructors, deprecated_member_use, unnecessary_cast, unnecessary_string_escapes, unused_local_variable
import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/favs_provider.dart';
import 'package:shop/services/global_method.dart';

import 'package:shop/screens/wishlist/wishlist_empty.dart';
import 'package:shop/screens/wishlist/wishlist_full.dart';

class WishlistScreen extends StatelessWidget {
  static const routeName = '/WishlistScreen';
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favsProvider = Provider.of<FavsProvider>(context);
    GlobalMethod globalMethods = GlobalMethod();
    return favsProvider.getFavsItemns.isEmpty
        ? Scaffold(body: WishlistEmpty())
        : Scaffold(
            appBar: AppBar(
              title: Text(
                  '${favsProvider.getFavsItemns.length} adet favori ürününüz var'),
              actions: [
                IconButton(
                  onPressed: () {
                    globalMethods.showDialogg(
                        'Dikkat',
                        'Foveri ürünleri silmek istediğine emin misin?',
                        () => favsProvider.clearFavs(),
                        context);
                  },
                  icon: Icon(
                    Feather.trash,
                    color: Theme.of(context).textSelectionTheme.selectionColor,
                  ),
                )
              ],
            ),
            body: ListView.builder(
              itemCount: favsProvider.getFavsItemns.length,
              itemBuilder: ((context, index) {
                return ChangeNotifierProvider.value(
                    value: favsProvider.getFavsItemns.values.toList()[index],
                    child: WishlistFull(
                      productId:
                          favsProvider.getFavsItemns.keys.toList()[index],
                    ));
              }),
            ),
          );
  }
}
