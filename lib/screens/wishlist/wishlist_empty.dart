// ignore_for_file: prefer_const_constructors, deprecated_member_use, unused_local_variable, unused_import, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/consts/colors.dart';
import 'package:shop/models/dark_theme_preference.dart';
import 'package:shop/provider/dark_theme_provider.dart';
import 'package:shop/screens/feeds.dart';

class WishlistEmpty extends StatelessWidget {
  const WishlistEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Padding(
      padding: EdgeInsets.all(25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 80),
            width: MediaQuery.of(context).size.height * 0.24,
            height: MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage('assets/images/bosSepet.png'))),
          ),
          Padding(
            padding: EdgeInsets.only(top: 80),
            child: Text(
              'Favorilerin boş!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).textSelectionTheme.selectionColor,
                  fontSize: 36,
                  fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            'Görünüşe göre bir şey beğenmemissin',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: themeChange.darkTheme
                    ? Theme.of(context).disabledColor
                    : ColorsConsts.subTitle,
                fontSize: 26,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height * 0.05,
            child: ElevatedButton(
              onPressed: () =>
                  {Navigator.of(context).pushNamed(FeedsScreen.routeName)},
              style: ElevatedButton.styleFrom(
                primary: Colors.pinkAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.purple),
                ),
              ),
              child: Text(
                'Beğenmeyi dene :)'.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).textSelectionTheme.selectionColor,
                    fontSize: 25,
                    fontWeight: FontWeight.w400),
              ),
            ),
          )
        ],
      ),
    );
  }
}
