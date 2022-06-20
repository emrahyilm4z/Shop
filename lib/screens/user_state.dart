// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shop/screens/landing_page.dart';
import 'package:shop/screens/main_screen.dart';

class UserState extends StatelessWidget {
  const UserState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (userSnapshot.connectionState == ConnectionState.active) {
          if (userSnapshot.hasData) {
            print('kullanıcı zaten daha önce oturum açmış');
            return const MainScreens();
          } else {
            print('Kullanıcı oturum açmamış');
            return LandingPage();
          }
        } else {
          return const Center(
            child: Text('HATA'),
          );
        }
      },
    );
  }
}
