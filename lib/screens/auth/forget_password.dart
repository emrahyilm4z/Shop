// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, prefer_const_constructors, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop/services/global_method.dart';

class ForgetPassword extends StatefulWidget {
  static const routeName = '/ForgetPassword';

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  String _emailAddress = '';
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalMethod _globalMethods = GlobalMethod();
  bool _isLoading = false;
  void _submitForm() async {
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();
    if (isValid != null) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState?.save();
      try {
        await _auth.sendPasswordResetEmail(
            email: _emailAddress.trim().toLowerCase());
        Fluttertoast.showToast(
            msg: "Şifre yenilemen için link gönderildi",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.canPop(context) ? Navigator.pop(context) : null;
      } on FirebaseAuthException catch (error) {
        _globalMethods.authErrorHandle(
            'Mail adresin yada şifren yanlış :(', context);
        print(' Hata var ${error.toString()}');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 80,
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Şifremi unuttum',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: _formKey,
              child: TextFormField(
                key: const ValueKey('E-posta'),
                validator: (value) {
                  if (value == null || !value.contains('@')) {
                    return 'Lütfen mevcut bir E-posta adresi girin';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    filled: true,
                    prefixIcon: const Icon(Icons.email),
                    labelText: 'E-mail',
                    fillColor: Theme.of(context).backgroundColor),
                onSaved: (value) {
                  _emailAddress = value!;
                },
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: _isLoading
                ? Align(alignment:Alignment.center ,child: CircularProgressIndicator(color: Colors.green,))
                : ElevatedButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        side: BorderSide(color: Theme.of(context).cardColor),
                      ),
                    )),
                    onPressed: _submitForm,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Gönder',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 17),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Entypo.key,
                          size: 18,
                        )
                      ],
                    )),
          ),
        ],
      ),
    );
  }
}
