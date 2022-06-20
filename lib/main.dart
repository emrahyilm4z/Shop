// ignore_for_file: unused_import, prefer_const_constructors, avoid_types_as_parameter_names, non_constant_identifier_names, annotate_overrides, equal_keys_in_map

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/inner_screens/brands_navigation_rail.dart';
import 'package:shop/inner_screens/categories.feed.dart';
import 'package:shop/screens/auth/forget_password.dart';
import 'package:shop/inner_screens/products_details.dart';
import 'package:shop/provider/cart_provider.dart';
import 'package:shop/provider/favs_provider.dart';
import 'package:shop/provider/products.dart';
import 'package:shop/screens/auth/sign_up.dart';
import 'package:shop/screens/bottom_bar.dart';
import 'package:shop/consts/theme.dart';
import 'package:shop/provider/dark_theme_provider.dart';
import 'package:shop/screens/cart.dart';
import 'package:shop/screens/feeds.dart';
import 'package:shop/screens/main_screen.dart';
import 'package:shop/screens/user_info.dart';
import 'package:shop/screens/wishlist/wishlist.dart';

import 'screens/auth/login.dart';
import 'screens/landing_page.dart';
import 'screens/user_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();
  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreferences.getTheme();
  }

  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  final Future<FirebaseApp> _initalization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initalization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
              home: Scaffold(
                  body: Center(
                child: CircularProgressIndicator(),
              )),
            );
          } else if (snapshot.hasError) {
            MaterialApp(
              home: Scaffold(
                  body: Center(
                child: Text('Eroor occured'),
              )),
            );
          }
          return MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) {
                  return themeChangeProvider;
                }),
                ChangeNotifierProvider(
                  create: (_) => Products(),
                ),
                ChangeNotifierProvider(
                  create: (_) => CartProvider(),
                ),
                ChangeNotifierProvider(
                  create: (_) => FavsProvider(),
                ),
              ],
              child: Consumer<DarkThemeProvider>(
                  builder: (context, themeData, child) {
                return Consumer<DarkThemeProvider>(
                  builder: (context, themeChangeProvider, ch) {
                    return MaterialApp(
                        debugShowCheckedModeBanner: false,
                        title: 'Flutter Demo',
                        theme: Styles.themeData(
                            themeChangeProvider.darkTheme, context),
                        home: UserState(),
                        routes: {
                          BrandNavigationRailScreen.routeName: (ctx) =>
                              BrandNavigationRailScreen(),
                          CartScreen.routeName: (ctx) => CartScreen(),
                          FeedsScreen.routeName: (ctx) => FeedsScreen(),
                          WishlistScreen.routeName: (ctx) => WishlistScreen(),
                          ProductDetails.routeName: (ctx) => ProductDetails(),
                          CategoriesFeedScreen.routeName: (ctx) =>
                              CategoriesFeedScreen(),
                          LoginScreen.routeName: (ctx) => LoginScreen(),
                          SignUpScreen.routeName: (ctx) => SignUpScreen(),
                          BottomBarScreen.routName: (ctx) => BottomBarScreen(),
                          ForgetPassword.routeName: (ctx) => ForgetPassword(),
                        });
                  },
                );
              }));
        });
  }
}
