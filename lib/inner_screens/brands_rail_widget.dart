// ignore_for_file: use_key_in_widget_constructors, unnecessary_string_escapes, prefer_const_constructors, unused_local_variable

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/inner_screens/products_details.dart';
import 'package:shop/models/products.dart';

class BrandsNavigationRail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productAttributes = Provider.of<Product>(context);
    return InkWell(
      onTap: () => Navigator.pushNamed(context, ProductDetails.routeName ,arguments:productAttributes.id ),
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 20),
        margin: EdgeInsets.only(right: 20.0, bottom: 5, top: 18),
        constraints: BoxConstraints(
            minHeight: 150, minWidth: double.infinity, maxHeight: 180),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  image: DecorationImage(
                      image: NetworkImage(
                        productAttributes.imageUrl,
                      ),
                      fit: BoxFit.contain),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.grey,
                        offset: Offset(2.0, 2.0),
                        blurRadius: 2.0)
                  ],
                ),
              ),
            ),
            FittedBox(
              child: Container(
                margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(10.0),
                        topRight: Radius.circular(10.0)),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(5.0, 5.0),
                          blurRadius: 10.0)
                    ]),
                width: 160,
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      productAttributes.title,
                      maxLines: 4,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context)
                              .textSelectionTheme
                              .selectionColor),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    FittedBox(
                      child: Text('TL ${productAttributes.price} \₺',
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 30.0,
                          )),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Text(productAttributes.productCategoryName,
                        style: TextStyle(color: Colors.black, fontSize: 18.0)),
                    const SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
