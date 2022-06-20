// ignore_for_file: sized_box_for_whitespace, non_constant_identifier_names, unused_local_variable, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/consts/colors.dart';
import 'package:shop/models/favs_attr.dart';
import 'package:shop/provider/favs_provider.dart';
import 'package:shop/services/global_method.dart';

class WishlistFull extends StatefulWidget {
  final String productId;
  const WishlistFull({
    required this.productId,
  });
  @override
  State<WishlistFull> createState() => _WishlistFull();
}

class _WishlistFull extends State<WishlistFull> {
  @override
  Widget build(BuildContext context) {
    final favsAttr = Provider.of<FavsAttr>(context);
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(right: 30.0, bottom: 10.0),
          child: Material(
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.circular(5.0),
            elevation: 3.0,
            child: InkWell(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 80,
                      child: Image.network(favsAttr.imageUrl),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          favsAttr.title,
                          style: const TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          '${favsAttr.price} ₺',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0),
                        )
                      ],
                    ))
                  ],
                ),
              ),
            ),
          ),
        ),
        positionRemove(widget.productId, context),
      ],
    );
  }

  Widget positionRemove(String productId, BuildContext context) {
    GlobalMethod globalMethods = GlobalMethod();
    final favsProvider = Provider.of<FavsProvider>(context);
    return Positioned(
      top: 20,
      right: 15,
      child: Container(
        height: 30,
        width: 30,
        child: MaterialButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          padding: const EdgeInsets.all(0.0),
          color: ColorsConsts.favColor,
          child: const Icon(
            Icons.clear,
            color: Colors.white,
          ),
          onPressed: () => {
            globalMethods.showDialogg(
                'Dikkat',
                'Favori ürününü silmek istediğine emin misin?',
                () => favsProvider.removeItem(productId),
                context)
          },
        ),
      ),
    );
  }
}
