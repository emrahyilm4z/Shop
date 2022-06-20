// ignore_for_file: unused_field, unnecessary_null_comparison, unused_local_variable, deprecated_member_use, unused_element, use_key_in_widget_constructors, avoid_print, prefer_final_fields

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop/consts/colors.dart';
import 'package:shop/services/global_method.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = '/SignUpScreen';
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  bool _obscureText = true;
  late String _emailAddress = '';
  late String _password = '';
  late String _fullName = '';
  late int _phoneNumber;
  late String url;
   bool _isLoading = false;
  File? _pickedImage;
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalMethod _globalMethods = GlobalMethod();
 
  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    super.dispose();
  }

  void _submitForm() async {
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();
    var date = DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    var formattedDate =
        "${dateParse.day} - ${dateParse.month} - ${dateParse.year}";
    if (isValid != null) {
      _formKey.currentState?.save();
      try {
        if (_pickedImage == null) {
          _globalMethods.authErrorHandle('Lütfen bir resim yükle', context);
        } else {
          setState(() {
            _isLoading = true;
          });
          final ref = FirebaseStorage.instance
              .ref()
              .child('usersimages')
              .child(_fullName + '.jpg');
          await ref.putFile(_pickedImage!);
          url = await ref.getDownloadURL();
          await _auth.createUserWithEmailAndPassword(
              email: _emailAddress.toLowerCase().trim(),
              password: _password.trim());
          final User? user = _auth.currentUser;
          final _uid = user?.uid;
          user?.updateProfile(photoURL: url, displayName: _fullName);
          user?.reload();
          await FirebaseFirestore.instance.collection('users').doc(_uid).set({
            'id': _uid,
            'name': _fullName,
            'email': _emailAddress,
            'password': _password,
            'phoneNumber': _phoneNumber,
            'imageUrl': url,
            'joinedAt': formattedDate,
            'createdAt': Timestamp.now(),
          });
          Navigator.canPop(context) ? Navigator.pop(context) : null;
        }
      } catch (error) {
        _globalMethods.authErrorHandle(error as String, context);
        print(' Hata var $error');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _pickImageCamera() async {
    final picker = ImagePicker();
    final pickedImage =
        await picker.getImage(source: ImageSource.camera, imageQuality: 10);
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    Navigator.pop(context);
  }

  void _pickImageGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    Navigator.pop(context);
  }

  void _remove() async {
    setState(() {
      _pickedImage == null;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.95,
            child: RotatedBox(
              quarterTurns: 2,
              child: WaveWidget(
                config: CustomConfig(
                  gradients: [
                    [ColorsConsts.gradiendFStart, ColorsConsts.gradiendLStart],
                    [ColorsConsts.gradiendFEnd, ColorsConsts.gradiendLEnd],
                  ],
                  durations: [19440, 10800],
                  heightPercentages: [0.20, 0.25],
                  blur: const MaskFilter.blur(BlurStyle.solid, 10),
                  gradientBegin: Alignment.bottomLeft,
                  gradientEnd: Alignment.topRight,
                ),
                waveAmplitude: 0,
                size: const Size(
                  double.infinity,
                  double.infinity,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 30, horizontal: 30),
                      child: CircleAvatar(
                        radius: 71,
                        backgroundColor: ColorsConsts.gradiendLEnd,
                        child: CircleAvatar(
                          radius: 65,
                          backgroundColor: ColorsConsts.gradiendFEnd,
                          backgroundImage: _pickedImage == null
                              ? null
                              : FileImage(_pickedImage!),
                        ),
                      ),
                    ),
                    Positioned(
                        top: 115,
                        left: 115,
                        child: RawMaterialButton(
                          elevation: 10,
                          fillColor: ColorsConsts.gradiendLEnd,
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
                                          onTap: _pickImageCamera,
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
                                          onTap: _pickImageGallery,
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
                                          onTap: _remove,
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
                          child: const Icon(Icons.add_a_photo),
                          padding: const EdgeInsets.all(15),
                          shape: const CircleBorder(),
                        )),
                  ],
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextFormField(
                            key: const ValueKey('İsim'),
                            validator: (value) {
                              if (value == null) {
                                return 'İsim boş olamaz';
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_emailFocusNode),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                border: const UnderlineInputBorder(),
                                filled: true,
                                prefixIcon: const Icon(Icons.person),
                                labelText: 'İsim',
                                fillColor: Theme.of(context).backgroundColor),
                            onSaved: (value) {
                              _fullName = value!;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextFormField(
                            key: const ValueKey('e-mail'),
                            focusNode: _emailFocusNode,
                            validator: (value) {
                              if (value == null || !value.contains('@')) {
                                return 'Lütfen geçerli bir posta girin';
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_passwordFocusNode),
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
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextFormField(
                            key: const ValueKey('Şifre'),
                            validator: (value) {
                              if (value == null || value.length < 7) {
                                return 'Lütfen geçerli bir şifre girin';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                            focusNode: _passwordFocusNode,
                            decoration: InputDecoration(
                                border: const UnderlineInputBorder(),
                                filled: true,
                                prefixIcon: const Icon(Icons.lock),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                  child: Icon(_obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                ),
                                labelText: 'Şifre',
                                fillColor: Theme.of(context).backgroundColor),
                            onSaved: (value) {
                              _password = value!;
                            },
                            obscureText: _obscureText,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_phoneNumberFocusNode),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextFormField(
                            key: const ValueKey('Telefon numara'),
                            focusNode: _phoneNumberFocusNode,
                            validator: (value) {
                              if (value == null) {
                                return 'lütfen geçerli bir telefon numarası girin';
                              }
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            textInputAction: TextInputAction.next,
                            onEditingComplete: _submitForm,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                border: const UnderlineInputBorder(),
                                filled: true,
                                prefixIcon: const Icon(Icons.phone_android),
                                labelText: 'Telefon',
                                fillColor: Theme.of(context).backgroundColor),
                            onSaved: (value) {
                              _phoneNumber = int.parse(value!);
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(width: 10),
                            _isLoading
                                ? const CircularProgressIndicator()
                                : ElevatedButton(
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        side: BorderSide(
                                            color:
                                                ColorsConsts.backgroundColor),
                                      ),
                                    )),
                                    onPressed: _submitForm,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: const [
                                        Text(
                                          '         Kayıt ol         ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Feather.user,
                                          size: 18,
                                        )
                                      ],
                                    )),
                          ],
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
