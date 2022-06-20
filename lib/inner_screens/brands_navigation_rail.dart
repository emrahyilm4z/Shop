// ignore_for_file: avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/products.dart';

import 'brands_rail_widget.dart';

class BrandNavigationRailScreen extends StatefulWidget {
  static const routeName = '/BrandNavigationRailScreen';

  const BrandNavigationRailScreen({super.key});
  @override
  _BrandNavigationRailScreenState createState() =>
      _BrandNavigationRailScreenState();
}

class _BrandNavigationRailScreenState extends State<BrandNavigationRailScreen> {
  int _selectedIndex = 0;
  final padding = 8.0;
  late String routeArgs;
  late String brand;
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
  void didChangeDependencies() {
    routeArgs = ModalRoute.of(context)!.settings.arguments.toString();
    if (routeArgs.length != 1) {
      _selectedIndex = int.parse(
        routeArgs.substring(1, 2),
      );
    } else {
      _selectedIndex = 7;
    }

    print(routeArgs.toString());
    if (_selectedIndex == 0) {
      setState(() {
        brand = 'Adidas';
      });
    }
    if (_selectedIndex == 1) {
      setState(() {
        brand = 'Apple';
      });
    }
    if (_selectedIndex == 2) {
      setState(() {
        brand = 'Dell';
      });
    }
    if (_selectedIndex == 3) {
      setState(() {
        brand = 'H&M';
      });
    }
    if (_selectedIndex == 4) {
      setState(() {
        brand = 'Nike';
      });
    }
    if (_selectedIndex == 5) {
      setState(() {
        brand = 'Samsung';
      });
    }
    if (_selectedIndex == 6) {
      setState(() {
        brand = 'Huawei';
      });
    }
    if (_selectedIndex == 7) {
      setState(() {
        brand = 'Hepsi';
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          LayoutBuilder(
            builder: (context, constraint) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: IntrinsicHeight(
                    child: NavigationRail(
                      minWidth: 56.0,
                      groupAlignment: 1.0,
                      selectedIndex: _selectedIndex,
                      onDestinationSelected: (int index) {
                        setState(() {
                          _selectedIndex = index;
                          if (_selectedIndex == 0) {
                            setState(() {
                              brand = 'Adidas';
                            });
                          }
                          if (_selectedIndex == 1) {
                            setState(() {
                              brand = 'Apple';
                            });
                          }
                          if (_selectedIndex == 2) {
                            setState(() {
                              brand = 'Dell';
                            });
                          }
                          if (_selectedIndex == 3) {
                            setState(() {
                              brand = 'H&M';
                            });
                          }
                          if (_selectedIndex == 4) {
                            setState(() {
                              brand = 'Nike';
                            });
                          }
                          if (_selectedIndex == 5) {
                            setState(() {
                              brand = 'Samsung';
                            });
                          }
                          if (_selectedIndex == 6) {
                            setState(() {
                              brand = 'Huawei';
                            });
                          }
                          if (_selectedIndex == 7) {
                            setState(() {
                              brand = 'Hepsi';
                            });
                          }
                          print(brand);
                        });
                      },
                      labelType: NavigationRailLabelType.all,
                      leading: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 40,
                          ),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).backgroundColor,
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    image: DecorationImage(
                                      image: NetworkImage(_userImageUrl ??
                                          'https://t3.ftcdn.net/jpg/01/83/55/76/240_F_183557656_DRcvOesmfDl5BIyhPKrcWANFKy2964i9.jpg'),
                                      fit: BoxFit.contain,
                                    )),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                      selectedLabelTextStyle: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        letterSpacing: 1,
                        decoration: TextDecoration.underline,
                        decorationThickness: 2.5,
                      ),
                      unselectedLabelTextStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        letterSpacing: 0.8,
                      ),
                      destinations: [
                        buildRotatedTextRailDestination('Addidas', padding),
                        buildRotatedTextRailDestination("Apple", padding),
                        buildRotatedTextRailDestination("Dell", padding),
                        buildRotatedTextRailDestination("H&M", padding),
                        buildRotatedTextRailDestination("Nike", padding),
                        buildRotatedTextRailDestination("Samsung", padding),
                        buildRotatedTextRailDestination("Huawei", padding),
                        buildRotatedTextRailDestination("Hepsi", padding),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          ContentSpace(context, brand)
        ],
      ),
    );
  }
}

NavigationRailDestination buildRotatedTextRailDestination(
    String text, double padding) {
  return NavigationRailDestination(
    icon: const SizedBox.shrink(),
    label: Padding(
      padding: EdgeInsets.symmetric(vertical: padding),
      child: RotatedBox(
        quarterTurns: -1,
        child: Text(text),
      ),
    ),
  );
}

class ContentSpace extends StatelessWidget {
  // final int _selectedIndex;

  final String brand;
  const ContentSpace(BuildContext context, this.brand);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context, listen: false);
    final productsBrand = productsData.findByBrand(brand);
    if (brand == 'Hepsi') {
      for (int i = 0; i < productsData.products.length; i++) {
        productsBrand.add(productsData.products[i]);
      }
    }
    //print('productsBrand ${productsBrand[0].imageUrl}');
    print('brand $brand');
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 0, 0),
        child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: productsBrand.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Feather.database,
                      size: 80,
                    ),
                    Text(
                      'Aradığınız ürün şuan da yok',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  ],
                )
              : ListView.builder(
                  itemCount: productsBrand.length,
                  itemBuilder: (BuildContext context, int index) =>
                      ChangeNotifierProvider.value(
                          value: productsBrand[index],
                          child: BrandsNavigationRail()),
                ),
        ),
      ),
    );
  }
}
