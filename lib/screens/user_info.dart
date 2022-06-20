// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, unused_field, unused_local_variable, unnecessary_string_interpolations, unnecessary_null_comparison, prefer_if_null_operators, prefer_final_fields, unused_element, deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:provider/provider.dart';
import 'package:shop/consts/colors.dart';
import 'package:flutter/material.dart';
import 'package:list_tile_switch/list_tile_switch.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shop/consts/my_icons.dart';
import 'package:shop/provider/dark_theme_provider.dart';
import 'package:shop/screens/cart.dart';
import 'package:shop/screens/wishlist/wishlist.dart';

class UserInfo extends StatefulWidget {
  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  late ScrollController _scrollController;
  var top = 0.0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _uid;
  String? _name;
  String? _email;
  String? _joinedAt;
  String? userImageUrl;
  int? _phoneNumber;
  late String version;
  @override
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {});
    });
    getData();
  }

  void getData() async {
    User? user = _auth.currentUser;
    _uid = user!.uid;
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    if (userDoc == null) {
      return;
    } else {
      setState(() {
        _name = userDoc.get('name');
        _email = user.email;
        _joinedAt = userDoc.get('joinedAt');
        _phoneNumber = userDoc.get('phoneNumber');
        userImageUrl = userDoc.get('imageUrl');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: <Widget>[
              SliverAppBar(
                elevation: 0,
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  top = constraints.biggest.height;

                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            ColorsConsts.starterColor,
                            ColorsConsts.endColor,
                          ],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 0.0),
                          stops: const [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    child: FlexibleSpaceBar(
                      // collapseMode: CollapseMode.parallax,
                      centerTitle: true,
                      title: AnimatedOpacity(
                        duration: Duration(milliseconds: 300),
                        opacity: top <= 110.0 ? 1.0 : 0,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 12,
                            ),
                            Container(
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
                                  image: NetworkImage(userImageUrl ??
                                      'https://t3.ftcdn.net/jpg/01/83/55/76/240_F_183557656_DRcvOesmfDl5BIyhPKrcWANFKy2964i9.jpg'),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              _name == null ? 'Ben' : _name!,
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      background: Image(
                        image: NetworkImage(userImageUrl ??
                            'https://t3.ftcdn.net/jpg/01/83/55/76/240_F_183557656_DRcvOesmfDl5BIyhPKrcWANFKy2964i9.jpg'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                }),
              ),
              SliverToBoxAdapter(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: userTitle(title: 'Sepetim')),
                    Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Navigator.of(context)
                            .pushNamed(WishlistScreen.routeName),
                        splashColor: Colors.red,
                        child: ListTile(
                          title: Text('Favorilerim'),
                          trailing: Icon(Icons.chevron_right_rounded),
                          leading: Icon(MyAppIcons.wishlist),
                        ),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.of(context).pushNamed(CartScreen.routeName);
                      },
                      title: Text('Sepetim'),
                      trailing: Icon(Icons.chevron_right_rounded),
                      leading: Icon(MyAppIcons.cart),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: userTitle(title: 'Bilgilerim'),
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    userListTile('Email', _email ?? '', 0, context),
                    userListTile('Telefon numaram',
                        _phoneNumber.toString() ?? '', 1, context),
                    userListTile('Adres', 'Fırat Üniversitesi', 2, context),
                    userListTile('Katılım tarihi', _joinedAt ?? '', 3, context),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: userTitle(title: 'Ayarlar'),
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    ListTileSwitch(
                      value: themeChange.darkTheme,
                      leading: Icon(Ionicons.moon),
                      onChanged: (value) {
                        setState(() {
                          themeChange.darkTheme = value;
                        });
                      },
                      visualDensity: VisualDensity.comfortable,
                      switchType: SwitchType.cupertino,
                      switchActiveColor: Colors.indigo,
                      title: Text('Koyu tema'),
                    ),
                    userListTile('Sürüm Bilgileri', "Sürüm 1.0.0", 5, context),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Theme.of(context).splashColor,
                        child: ListTile(
                          onTap: () async {
                            // Navigator.canPop(context)? Navigator.pop(context):null;
                            showDialog(
                                context: context,
                                builder: (BuildContext ctx) {
                                  return AlertDialog(
                                    title: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 6.0),
                                          child: Image.network(
                                            'https://cdn.pixabay.com/photo/2012/04/16/13/51/sign-36070_960_720.png',
                                            height: 20,
                                            width: 20,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('Çıkış yap'),
                                        ),
                                      ],
                                    ),
                                    content:
                                        Text('Çıkmak istediğine emin misin?'),
                                    actions: [
                                      TextButton(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Hayır')),
                                      TextButton(
                                          onPressed: () async {
                                            await _auth.signOut().then(
                                                (value) =>
                                                    Navigator.pop(context));
                                          },
                                          child: Text(
                                            'Evet',
                                            style: TextStyle(color: Colors.red),
                                          ))
                                    ],
                                  );
                                });
                          },
                          title: Text('Çıkış yap'),
                          leading: Icon(Icons.exit_to_app_rounded),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          _buildFab()
        ],
      ),
    );
  }

  Widget _buildFab() {
    //starting fab position
    const double defaultTopMargin = 200.0 - 4.0;
    //pixels from top where scaling should start
    const double scaleStart = 160.0;
    //pixels from top where scaling should end
    const double scaleEnd = scaleStart / 2;

    double top = defaultTopMargin;
    double scale = 1.0;
    if (_scrollController.hasClients) {
      double offset = _scrollController.offset;
      top -= offset;
      if (offset < defaultTopMargin - scaleStart) {
        //offset small => don't scale down

        scale = 1.0;
      } else if (offset < defaultTopMargin - scaleEnd) {
        //offset between scaleStart and scaleEnd => scale down

        scale = (defaultTopMargin - scaleEnd - offset) / scaleEnd;
      } else {
        //offset passed scaleEnd => hide fab
        scale = 0.0;
      }
    }

    return Positioned(
      top: top,
      right: 16.0,
      child: Transform(
        transform: Matrix4.identity()..scale(scale),
        alignment: Alignment.center,
        child: FloatingActionButton(
          backgroundColor: Colors.purple,
          heroTag: "btn1",
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext contex) {
                  return AlertDialog(
                    title: Text(
                      'Yüklemek istediğin yeri seç',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: ColorsConsts.gradiendLStart),
                    ),
                    content: SingleChildScrollView(
                      child: ListBody(children: [
                        InkWell(
                          onTap: () {},
                          splashColor: Colors.purpleAccent,
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.camera,
                                  color: Colors.purpleAccent,
                                ),
                              ),
                              Text(
                                'Kamera',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500,
                                    color: ColorsConsts.title),
                              )
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          splashColor: Colors.purpleAccent,
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.image,
                                  color: Colors.purpleAccent,
                                ),
                              ),
                              Text(
                                'Galeri',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500,
                                    color: ColorsConsts.title),
                              )
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          splashColor: Colors.purpleAccent,
                          child: Row(
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                ),
                              ),
                              Text(
                                'Kaldır',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red),
                              )
                            ],
                          ),
                        )
                      ]),
                    ),
                  );
                });
          },
          child: Icon(Icons.camera_alt_outlined),
        ),
      ),
    );
  }

  List<IconData> _userTileIcons = [
    Icons.email,
    Icons.phone,
    Icons.local_shipping,
    Icons.watch_later,
    Icons.exit_to_app_rounded,
    Icons.info
  ];

  Widget userListTile(
      String title, String subTitle, int index, BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subTitle),
      leading: Icon(_userTileIcons[index]),
    );
  }

  Widget userTitle({required String title}) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
      ),
    );
  }
}
