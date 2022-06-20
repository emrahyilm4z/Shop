// ignore_for_file: use_key_in_widget_constructors, unused_element, no_logic_in_create_state, prefer_const_constructors, prefer_final_fields, unused_field, prefer_const_literals_to_create_immutables, deprecated_member_use, unused_import, avoid_unnecessary_containers, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:shop/screens/cart.dart';
import 'package:shop/screens/feeds.dart';
import 'package:shop/screens/home.dart';
import 'package:shop/screens/search.dart';
import 'package:shop/screens/user_info.dart';

class BottomBarScreen extends StatefulWidget {
  static const routName = '/BottomBarScreen';

  @override
  _BottomBarScreenState createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  late List<Map<String, Object>> _pages;
  int _selectedindex = 0;

  @override
  void initState() {
    _pages = [
      {
        'page': HomeScreen(),
      },
      {
        'page': FeedsScreen(),
      },
      {
        'page': Search(),
      },
      {
        'page': CartScreen(),
      },
      {
        'page': UserInfo(),
      },
    ];
    super.initState();
  }

  void _selectedPage(int index) {
    setState(() {
      _selectedindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedindex]['page'] as Widget,
      bottomNavigationBar: BottomAppBar(
        notchMargin: 1,
        clipBehavior: Clip.antiAlias,
        shape: CircularNotchedRectangle(),
        child: Container(
          decoration:
              BoxDecoration(border: Border(top: BorderSide(width: 0.1))),
          child: BottomNavigationBar(
            onTap: _selectedPage,
            backgroundColor: Theme.of(context).primaryColor,
            unselectedItemColor:
                Theme.of(context).textSelectionTheme.selectionColor,
            selectedItemColor: Colors.purple,
            currentIndex: _selectedindex,
            selectedLabelStyle: TextStyle(fontSize: 12),
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  tooltip: 'Anasayfa',
                  label: 'Anasayfa'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.rss_feed),
                  tooltip: 'Besleme',
                  label: 'Önerilen'),
              BottomNavigationBarItem(
                  icon: Icon(null), tooltip: 'Ara', label: ''),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_bag),
                  tooltip: 'Sepet',
                  label: 'Sepet'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), tooltip: 'Ben', label: 'Ben')
            ],
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        tooltip: 'Ara',
        elevation: 4,
        child: (Icon(Icons.search)),
        onPressed: () {
          setState(() {
            _selectedindex = 2;
          });
        },
      ),
    );
  }
}
