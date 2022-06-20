// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shop/screens/upload_product_form.dart';
import 'package:shop/screens/bottom_bar.dart';

class MainScreens extends StatelessWidget {
  const MainScreens({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: [BottomBarScreen(), UploadProductForm()],
    );
  }
}
