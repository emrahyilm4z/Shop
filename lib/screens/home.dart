// ignore_for_file: prefer_const_constructors, unused_local_variable, avoid_unnecessary_containers, sized_box_for_whitespace, use_key_in_widget_constructors, unused_field, unnecessary_null_in_if_null_operators

import 'package:card_swiper/card_swiper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:backdrop/backdrop.dart';
import 'package:provider/provider.dart';
import 'package:shop/consts/colors.dart';
import 'package:shop/inner_screens/brands_navigation_rail.dart';
import 'package:shop/provider/products.dart';
import 'package:shop/screens/backlayer.dart';
import 'package:shop/screens/feeds.dart';
import 'package:shop/widget/category.dart';
import 'package:shop/widget/populer_products.dart';

class HomeScreen extends StatefulWidget {
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _userImageUrl;
  String? _uid;
  @override
  void initState() {
    super.initState();
    setState(() {});
    getData();
  }

  void getData() async {
    User user = _auth.currentUser!;
    _uid = user.uid;
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    setState(() {
      _userImageUrl = userDoc.get('imageUrl');
    });
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    productsData.FetchProducts();
    final popularItems = productsData.popularProducts;
    getData();
    final List<String> images = [
      'https://pbs.twimg.com/media/FR3oiiYWUAE0wQO?format=png&name=large',
      'https://pbs.twimg.com/media/FR3ofkkXIAA-W5S?format=jpg&name=360x360',
      'https://pbs.twimg.com/media/FR3oevXXoAIE_qi?format=jpg&name=small',
      'https://pbs.twimg.com/media/FR3od16XMAADaHx?format=png&name=360x360',
    ];
    List _brandImages = [
      'assets/images/addidas.jpg',
      'assets/images/apple.jpg',
      'assets/images/dell.jpg',
      'assets/images/hm.jpg',
      'assets/images/nike.jpg',
      'assets/images/samsung.jpg',
      'assets/images/huawei.jpg',
    ];
    return Scaffold(
      body: Center(
        child: BackdropScaffold(
          frontLayerBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
          headerHeight: MediaQuery.of(context).size.height * 0.25,
          appBar: BackdropAppBar(
            title: const Text("Anasayfa"),
            leading: const BackdropToggleButton(
              icon: AnimatedIcons.home_menu,
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [ColorsConsts.starterColor, ColorsConsts.endColor],
              )),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Container(
                  height: kToolbarHeight / 1.8,
                  width: kToolbarHeight / 1.8,
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.white,
                        blurRadius: 1.0,
                      ),
                    ],
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.contain,
                      image: NetworkImage(_userImageUrl ??
                          'https://t3.ftcdn.net/jpg/01/83/55/76/240_F_183557656_DRcvOesmfDl5BIyhPKrcWANFKy2964i9.jpg'),
                    ),
                  ),
                ),
              ),
            ],
          ),
          backLayer: Center(child: BackLayerMenu()),
          frontLayer: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    height: 190,
                    width: double.infinity,
                    child: CarouselSlider.builder(
                      itemCount: images.length,
                      options: CarouselOptions(
                        autoPlay: true,
                        aspectRatio: 1.0,
                        enlargeCenterPage: true,
                      ),
                      itemBuilder: (context, index, realIdx) {
                        return Container(
                          child: Center(
                              child: Image.network(images[index],
                                  fit: BoxFit.cover, width: 1000)),
                        );
                      },
                    )),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Kategoriler',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                  ),
                ),
                Container(
                    width: double.infinity,
                    height: 180,
                    child: ListView.builder(
                      itemCount: 7,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext ctx, int index) {
                        return CategoryWidget(
                          index: index,
                        );
                      },
                    )),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        'Popüler markalar',
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 20),
                      ),
                      Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                              BrandNavigationRailScreen.routeName,
                              arguments: 7);
                        },
                        child: Text(
                          'Hepsini gör  >',
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                              color: Colors.red),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 210,
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: Swiper(
                    itemCount: _brandImages.length,
                    autoplay: true,
                    onTap: (index) {
                      Navigator.of(context).pushNamed(
                          BrandNavigationRailScreen.routeName,
                          arguments: {index});
                    },
                    itemBuilder: (BuildContext ctx, int index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                            color: Colors.transparent,
                            child: Image.asset(
                              _brandImages[index],
                              fit: BoxFit.contain,
                            )),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        'Popüler ürünler',
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 20),
                      ),
                      Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            FeedsScreen.routeName,
                            arguments: {
                              10,
                            },
                          );
                        },
                        child: Text(
                          'Hepsini gör  >',
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                              color: Colors.red),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 285,
                  margin: EdgeInsets.symmetric(horizontal: 3),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: popularItems.length,
                    itemBuilder: ((BuildContext context, int index) {
                      return ChangeNotifierProvider.value(
                        value: popularItems[index],
                        child: PopularProducts(),
                      );
                    }),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
