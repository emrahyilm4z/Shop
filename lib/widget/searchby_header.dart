// ignore_for_file: prefer_const_constructors

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/consts/colors.dart';
import 'package:shop/provider/cart_provider.dart';
import 'package:shop/provider/favs_provider.dart';
import 'package:shop/screens/cart.dart';
import 'package:shop/screens/user_info.dart';
import 'package:shop/screens/wishlist/wishlist.dart';

class SearchByHeader extends SliverPersistentHeaderDelegate {
  final double flexibleSpace;
  final double backGroundHeight;
  final double stackPaddingTop;
  final double titlePaddingTop;
  final Widget title;
  final Widget? subTitle;
  final Widget? leading;
  final Widget? action;
  final Widget stackChild;

  SearchByHeader({
    this.flexibleSpace = 250,
    this.backGroundHeight = 200,
    required this.stackPaddingTop,
    this.titlePaddingTop = 35,
    required this.title,
    required this.subTitle,
    required this.leading,
    required this.action,
    required this.stackChild,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    UserInfo user = new UserInfo();
    var percent = shrinkOffset / (maxExtent - minExtent);
    double calculate = 1 - percent < 0 ? 0 : (1 - percent);
    return SizedBox(
      height: maxExtent,
      child: Stack(
        children: <Widget>[
          Container(
            height: minExtent + ((backGroundHeight - minExtent) * calculate),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    ColorsConsts.starterColor,
                    ColorsConsts.endColor,
                  ],
                  begin: const FractionalOffset(0.0, 1.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: const [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
          ),
          Positioned(
            top: 30,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Consumer<FavsProvider>(
                  builder: (_, favs, ch) => Badge(
                    badgeColor: ColorsConsts.favBadgeColor,
                    position: BadgePosition.topEnd(top: 5, end: 7),
                    badgeContent: Text(
                      favs.getFavsItemns.length.toString(),
                      style: TextStyle(color: ColorsConsts.white),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.favorite, color: ColorsConsts.favColor),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(WishlistScreen.routeName);
                      },
                    ),
                  ),
                ),
                Consumer<CartProvider>(
                  builder: (_, cart, ch) => Badge(
                    badgeColor: ColorsConsts.cartBadgeColor,
                    position: BadgePosition.topEnd(top: 5, end: 7),
                    badgeContent: Text(
                      cart.getCartItemns.length.toString(),
                      style: TextStyle(color: ColorsConsts.white),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.shopping_cart,
                        color: ColorsConsts.cartColor,
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(CartScreen.routeName);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 32,
            left: 10,
            child: Material(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10.0),
                splashColor: Colors.grey,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserInfo(),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.account_circle,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width * 0.35,
            top: titlePaddingTop * calculate + 27,
            bottom: 0.0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              width: MediaQuery.of(context).size.width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  leading ?? SizedBox(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Transform.scale(
                        alignment: Alignment.centerLeft,
                        scale: 1 + (calculate * .5),
                        child: Padding(
                          padding: EdgeInsets.only(top: 14 * (1 - calculate)),
                          child: title,
                        ),
                      ),
                      if (calculate > .5) ...[
                        SizedBox(height: 10),
                        Opacity(
                          opacity: calculate,
                          child: subTitle ?? const SizedBox(),
                        ),
                      ]
                    ],
                  ),
                  Expanded(child: SizedBox()),
                  Padding(
                    padding: EdgeInsets.only(top: 14 * calculate),
                    child: action ?? const SizedBox(),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: minExtent + ((stackPaddingTop - minExtent) * calculate),
            child: Opacity(
              opacity: calculate,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: stackChild,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  double get maxExtent => flexibleSpace;

  @override
  double get minExtent => kToolbarHeight + 25;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
