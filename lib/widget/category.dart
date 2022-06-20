// ignore_for_file: non_constant_identifier_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:shop/inner_screens/categories.feed.dart';

class CategoryWidget extends StatelessWidget with ChangeNotifier {
  CategoryWidget({Key? key, required this.index}) : super(key: key);
  final int index;
  List<Map<String?, Object>> categories = [
    {
      "categoryName": 'Phones',
      'categoryImagesPath': 'assets/images/Catphones.png'
    },
    {
      'categoryName': 'Clothes',
      'categoryImagesPath': 'assets/images/Clothes.jpg'
    },
    {'categoryName': 'Shoes', 'categoryImagesPath': 'assets/images/Shoes.jpg'},
    {
      'categoryName': 'Beauty&Health',
      'categoryImagesPath': 'assets/images/Guzellik.jpg'
    },
    {
      'categoryName': 'Laptops',
      'categoryImagesPath': 'assets/images/Laptop.jpg'
    },
    {
      'categoryName': 'Furniture',
      'categoryImagesPath': 'assets/images/Mobilya.jpeg'
    },
    {
      'categoryName': 'Watches',
      'categoryImagesPath': 'assets/images/Kolsaati.jpg'
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(CategoriesFeedScreen.routeName,
                arguments: '${categories[index]['categoryName']}');
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                    categories[index]['categoryImagesPath'] as String),
              ),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            width: 150,
            height: 150,
          ),
        ),
      ],
    );
  }
}
