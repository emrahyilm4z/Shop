// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print, deprecated_member_use, avoid_unnecessary_containers, use_key_in_widget_constructors

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop/consts/colors.dart';
import 'package:uuid/uuid.dart';
import 'package:shop/services/global_method.dart';

class UploadProductForm extends StatefulWidget {
  static const routeName = '/UploadProductForm';

  const UploadProductForm({super.key});

  @override
  _UploadProductFormState createState() => _UploadProductFormState();
}

class _UploadProductFormState extends State<UploadProductForm> {
  final _formKey = GlobalKey<FormState>();

  var _productTitle = '';
  var _productPrice = '';
  var _productCategory = '';
  var _productBrand = '';
  var _productDescription = '';
  var _productQuantity = '';
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  var _categoryValue;
  var _brandValue;
  final GlobalMethod _globalMethods = GlobalMethod();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  File? _pickedImage;
  bool _isLoading = false;
  late String url;
  var uuid = const Uuid();
  showAlertDialog(BuildContext context, String title, String body) {
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: [
            TextButton(
              child: const Text("Tamam"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      print(_productTitle);
      print(_productPrice);
      print(_productCategory);
      print(_productBrand);
      print(_productDescription);
      print(_productQuantity);
      // Use those values to send our request ...
    }
    if (isValid) {
      _formKey.currentState!.save();
      try {
        if (_pickedImage == null) {
          _globalMethods.authErrorHandle('Resim se??', context);
        } else {
          setState(() {
            _isLoading = true;
          });
          final ref = FirebaseStorage.instance
              .ref()
              .child('productsImages')
              .child(_productTitle + '.jpg');
          await ref.putFile(_pickedImage!);
          url = await ref.getDownloadURL();

          final User user = _auth.currentUser!;
          final _uid = user.uid;
          final productId = uuid.v4();
          await FirebaseFirestore.instance
              .collection('products')
              .doc(productId)
              .set({
            'productId': productId,
            'productTitle': _productTitle,
            'price': _productPrice,
            'productImage': url,
            'productCategory': _productCategory,
            'productBrand': _productBrand,
            'productDescription': _productDescription,
            'productQuantity': _productQuantity,
            'userId': _uid,
            'createdAt': Timestamp.now(),
          });
          Navigator.canPop(context) ? Navigator.pop(context) : null;
          
        }
      } catch (error) {
        _globalMethods.authErrorHandle(error as String, context);
        print('error occured $error');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _pickImageCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 40,
    );
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    // widget.imagePickFn(pickedImageFile);
  }

  void _pickImageGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    final pickedImageFile = pickedImage == null ? null : File(pickedImage.path);

    setState(() {
      _pickedImage = pickedImageFile;
    });
    // widget.imagePickFn(pickedImageFile);
  }

  void _removeImage() {
    setState(() {
      _pickedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        height: kBottomNavigationBarHeight * 0.8,
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorsConsts.white,
          border: const Border(
            top: BorderSide(
              color: Colors.grey,
              width: 0.5,
            ),
          ),
        ),
        child: Material(
          color: Theme.of(context).backgroundColor,
          child: InkWell(
            onTap: _trySubmit,
            splashColor: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 2),
                  child: _isLoading
                      ? const Center(
                          child: SizedBox(
                              height: 40,
                              width: 40,
                              child: CircularProgressIndicator()))
                      : const Text('Y??kle',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center),
                ),
                const GradientIcon(
                  Feather.upload,
                  20,
                  LinearGradient(
                    colors: <Color>[
                      Colors.green,
                      Colors.yellow,
                      Colors.deepOrange,
                      Colors.orange,
                      Colors.yellow
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Card(
                margin: const EdgeInsets.all(15),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 9),
                                child: TextFormField(
                                  key: const ValueKey('Title'),
                                  validator: (value) {
                                    if (value == null) {
                                      return 'L??tfen bir ba??l??k gir';
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: const InputDecoration(
                                    labelText: '??r??n ba??l??????',
                                  ),
                                  onSaved: (value) {
                                    _productTitle = value!;
                                  },
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: TextFormField(
                                key: const ValueKey('Price \$'),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null) {
                                    return 'Fiyat gir';
                                  }
                                  return null;
                                },
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                ],
                                decoration: const InputDecoration(
                                  labelText: 'Fiyat \$',
                                  //  prefixIcon: Icon(Icons.mail),
                                  // suffixIcon: Text(
                                  //   '\n \n \$',
                                  //   textAlign: TextAlign.start,
                                  // ),
                                ),
                                //obscureText: true,
                                onSaved: (value) {
                                  _productPrice = value!;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        /* Image picker here ***********************************/
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              //  flex: 2,
                              child: _pickedImage == null
                                  ? Container(
                                      margin: const EdgeInsets.all(10),
                                      height: 200,
                                      width: 200,
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 1),
                                        borderRadius: BorderRadius.circular(4),
                                        color:
                                            Theme.of(context).backgroundColor,
                                      ),
                                    )
                                  : Container(
                                      margin: const EdgeInsets.all(10),
                                      height: 200,
                                      width: 200,
                                      child: Container(
                                        height: 200,
                                        // width: 200,
                                        decoration: BoxDecoration(
                                          // borderRadius: BorderRadius.only(
                                          //   topLeft: const Radius.circular(40.0),
                                          // ),
                                          color:
                                              Theme.of(context).backgroundColor,
                                        ),
                                        child: Image.file(
                                          _pickedImage!,
                                          fit: BoxFit.contain,
                                          alignment: Alignment.center,
                                        ),
                                      ),
                                    ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FittedBox(
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        onPrimary: Colors.white),
                                    onPressed: _pickImageCamera,
                                    icon: const Icon(Icons.camera,
                                        color: Colors.purpleAccent),
                                    label: Text(
                                      'Kamera',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context)
                                            .textSelectionTheme
                                            .selectionColor,
                                      ),
                                    ),
                                  ),
                                ),
                                FittedBox(
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        onPrimary: Colors.white),
                                    onPressed: _pickImageGallery,
                                    icon: const Icon(Icons.image,
                                        color: Colors.purpleAccent),
                                    label: Text(
                                      'Galeri',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context)
                                            .textSelectionTheme
                                            .selectionColor,
                                      ),
                                    ),
                                  ),
                                ),
                                FittedBox(
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        onPrimary: Colors.white),
                                    onPressed: _removeImage,
                                    icon: const Icon(
                                      Icons.remove_circle_rounded,
                                      color: Colors.red,
                                    ),
                                    label: const Text(
                                      'Sil',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        //    SizedBox(height: 5),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              // flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 9),
                                child: Container(
                                  child: TextFormField(
                                    controller: _categoryController,

                                    key: const ValueKey('Category'),
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Kategory gir';
                                      }
                                      return null;
                                    },
                                    //keyboardType: TextInputType.emailAddress,
                                    decoration: const InputDecoration(
                                      labelText: 'Kategori',
                                    ),
                                    onSaved: (value) {
                                      _productCategory = value!;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            DropdownButton<String>(
                              items: const [
                                DropdownMenuItem<String>(
                                  child: Text('Telefon'),
                                  value: 'Phones',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('Elbiseler'),
                                  value: 'Clothes',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('G??zellik bak??m'),
                                  value: 'Beauty',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('Ayakkab??lar'),
                                  value: 'Shoes',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('Mobilyalar'),
                                  value: 'Funiture',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('Saatler'),
                                  value: 'Watches',
                                ),
                              ],
                              onChanged: (String? value) {
                                setState(() {
                                  _categoryValue = value!;
                                  _categoryController.text = value;
                                  print(_productCategory);
                                });
                              },
                              hint: const Text('Kategory se??'),
                              value: _categoryValue,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 9),
                                child: Container(
                                  child: TextFormField(
                                    controller: _brandController,

                                    key: const ValueKey('Brand'),
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Brand is missed';
                                      }
                                      return null;
                                    },
                                    //keyboardType: TextInputType.emailAddress,
                                    decoration: const InputDecoration(
                                      labelText: 'Marka',
                                    ),
                                    onSaved: (value) {
                                      _productBrand = value!;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            DropdownButton<String>(
                              items: const [
                                DropdownMenuItem<String>(
                                  child: Text('Marka yok'),
                                  value: 'Brandless',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('Addidas'),
                                  value: 'Addidas',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('Apple'),
                                  value: 'Apple',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('Dell'),
                                  value: 'Dell',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('H&M'),
                                  value: 'H&M',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('Nike'),
                                  value: 'Nike',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('Samsung'),
                                  value: 'Samsung',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('Huawei'),
                                  value: 'Huawei',
                                ),
                              ],
                              onChanged: (String? value) {
                                setState(() {
                                  _brandValue = value!;
                                  _brandController.text = value;
                                  print(_productBrand);
                                });
                              },
                              hint: const Text('L??tfen bir marka se??in'),
                              value: _brandValue,
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                            key: const ValueKey('Description'),
                            validator: (value) {
                              if (value == null) {
                                return 'A????klama gir';
                              }
                              return null;
                            },
                            //controller: this._controller,
                            maxLines: 10,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: const InputDecoration(
                              //  counterText: charLength.toString(),
                              labelText: 'Description',
                              hintText: 'Product description',
                              border: OutlineInputBorder(),
                            ),
                            onSaved: (value) {
                              _productDescription = value!;
                            },
                            onChanged: (text) {
                              // setState(() => charLength -= text.length);
                            }),
                        //    SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              //flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 9),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  key: const ValueKey('Quantity'),
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Adet say??s?? gir';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    labelText: 'Adet',
                                  ),
                                  onSaved: (value) {
                                    _productQuantity = value!;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}

class GradientIcon extends StatelessWidget {
  const GradientIcon(
    this.icon,
    this.size,
    this.gradient,
  );

  final IconData icon;
  final double size;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      child: SizedBox(
        width: size * 1.2,
        height: size * 1.2,
        child: Icon(
          icon,
          size: size,
          color: Colors.white,
        ),
      ),
      shaderCallback: (Rect bounds) {
        final Rect rect = Rect.fromLTRB(0, 0, size, size);
        return gradient.createShader(rect);
      },
    );
  }
}
