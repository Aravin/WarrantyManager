import 'dart:io';
import 'dart:typed_data';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:warranty_manager/models/product.dart';
import 'package:warranty_manager/widgets/product_image_preview.dart';
import 'package:warranty_manager/shared/category.dart';

import 'package:warranty_manager/shared/ads.dart';
import 'package:firebase_admob/firebase_admob.dart';

import '../shared/contants.dart';

class AddItem extends StatefulWidget {
  @override
  _AddItemState createState() => _AddItemState();

  final Product product;
  final bool isUpdate;
  final Function actionCallback;

  AddItem({this.product, this.isUpdate, this.actionCallback})
      : super(key: Key('AddItem'));
}

class _AddItemState extends State<AddItem> {
  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;
  AdManager _adManager = AdManager();

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  // mandatory
  final FocusNode productFocus = FocusNode();
  final FocusNode priceFocus = FocusNode();
  final FocusNode warrantyFocus = FocusNode();

  // optional
  final FocusNode categoryFocus = FocusNode();
  final FocusNode purchasedAtFocus = FocusNode();
  final FocusNode companyFocus = FocusNode();
  final FocusNode salesPersonFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode notesFocus = FocusNode();

  // steps
  int currentStep = 0;
  bool complete = false;

  next() {
    currentStep + 1 != 3
        ? goTo(currentStep + 1)
        : setState(() {
            complete = true;
          });
  }

  cancel() {
    if (currentStep > 0) {
      goTo(currentStep - 1);
    }
  }

  goTo(int step) {
    if (_fbKey.currentState.saveAndValidate()) {
      setState(() {
        currentStep = step;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 10), (timer) {
      _adManager.initAdMob().then((value) => {
            _bannerAd = _adManager.createBannerAd()
              ..load()
              ..show(
                anchorType: AnchorType.bottom,
              ),
          });
    });
    Timer.periodic(Duration(seconds: 60), (timer) {
      _adManager.initAdMob().then((value) => {
            _interstitialAd = _adManager.createInterstitialAd()
              ..load()
              ..show(
                anchorType: AnchorType.bottom,
                anchorOffset: 0.0,
                horizontalCenterOffset: 0.0,
              ),
          });
    });
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [SizedBox(height: 35)],
      appBar: AppBar(
        textTheme: TextTheme(),
        title: Text(
          widget.isUpdate ? 'Edit Product' : 'Add Product',
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: FormBuilder(
              key: _fbKey,
              initialValue: {
                'purchaseDate': widget.isUpdate
                    ? widget.product.purchaseDate
                    : _fbKey.currentState != null
                        ? _fbKey.currentState.value['purchaseDate']
                        : new DateTime.now(),
                'warranty': widget.isUpdate
                    ? widget.product.warrantyPeriod
                    : _fbKey.currentState != null
                        ? _fbKey.currentState.value['warranty']
                        : null,
                'product': widget.isUpdate
                    ? widget.product?.name
                    : _fbKey.currentState != null
                        ? _fbKey.currentState.value['product']
                        : '',
                'price': widget.isUpdate
                    ? widget.product.price.toString()
                    : _fbKey.currentState != null
                        ? _fbKey.currentState.value['price']
                        : '',
                'company': widget.isUpdate
                    ? widget.product?.company
                    : _fbKey.currentState != null
                        ? _fbKey.currentState.value['company']
                        : '',
                'purchasedAt': widget.isUpdate
                    ? widget.product?.purchasedAt
                    : _fbKey.currentState != null
                        ? _fbKey.currentState.value['purchasedAt']
                        : '',
                'salesPerson': widget.isUpdate
                    ? widget.product?.salesPerson
                    : _fbKey.currentState != null
                        ? _fbKey.currentState.value['salesPerson']
                        : '',
                'phone': widget.isUpdate
                    ? widget.product?.phone
                    : _fbKey.currentState != null
                        ? _fbKey.currentState.value['phone']
                        : '',
                'email': widget.isUpdate
                    ? widget.product?.email
                    : _fbKey.currentState != null
                        ? _fbKey.currentState.value['email']
                        : '',
                'notes': widget.isUpdate
                    ? widget.product?.notes
                    : _fbKey.currentState != null
                        ? _fbKey.currentState.value['notes']
                        : '',
                'productImage': [],
                'imgBill': [],
                'imgWarranty': [],
                'imgAdditional': [],
                'category': widget.isUpdate
                    ? (widget.product?.category ?? 'Other')
                    : _fbKey.currentState != null
                        ? _fbKey.currentState.value['category']
                        : 'Other'
              },
              // autovalidate: false,
              child: Stepper(
                type: StepperType.horizontal,
                currentStep: currentStep ?? 0,
                onStepContinue: next,
                onStepTapped: (step) => goTo(step),
                onStepCancel: cancel,
                steps: [
                  Step(
                    isActive: currentStep == 0 ? true : false,
                    title: Text('Required*'),
                    content: Column(
                      key: UniqueKey(),
                      children: [
                        FormBuilderDateTimePicker(
                          attribute: "purchaseDate",
                          textInputAction: TextInputAction.next,
                          validators: [FormBuilderValidators.required()],
                          inputType: InputType.date,
                          format: DateFormat("EEE, MMMM d, yyyy"),
                          decoration: InputDecoration(
                            labelText: "Purchase Date",
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(warrantyFocus),
                        ),
                        FormBuilderDropdown(
                          attribute: "warranty",
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.timer),
                            labelText: "Warranty Period",
                          ),
                          // initialValue: 'Male',
                          hint: Text('Select Warranty Period'),
                          validators: [FormBuilderValidators.required()],
                          items: warrantyPeriods
                              .map((period) => DropdownMenuItem(
                                  value: period, child: Text("$period")))
                              .toList(),
                        ),
                        FormBuilderTextField(
                          attribute: 'product',
                          focusNode: productFocus,
                          validators: [
                            FormBuilderValidators.required(),
                            FormBuilderValidators.minLength(3),
                            FormBuilderValidators.maxLength(24)
                          ],
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.shopping_basket),
                            hintText: 'Product/Service Name ?',
                            labelText: 'Product/Service Name *',
                          ),
                          onEditingComplete: () =>
                              FocusScope.of(context).requestFocus(priceFocus),
                        ),
                        FormBuilderTextField(
                          attribute: 'price',
                          focusNode: priceFocus,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          validators: [
                            FormBuilderValidators.required(),
                            FormBuilderValidators.min(1),
                            FormBuilderValidators.max(9999999)
                          ],
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.monetization_on),
                            hintText: 'Total Bill Amount ?',
                            labelText: 'Price *',
                          ),
                          onEditingComplete: () =>
                              FocusScope.of(context).requestFocus(companyFocus),
                        ),
                        FormBuilderTextField(
                          attribute: 'company',
                          focusNode: companyFocus,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.branding_watermark),
                            hintText: 'Company or Brand Name?',
                            labelText: 'Brand/Company',
                          ),
                          validators: [
                            FormBuilderValidators.required(),
                            FormBuilderValidators.minLength(2),
                            FormBuilderValidators.maxLength(24)
                          ],
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(categoryFocus),
                        ),
                      ],
                    ),
                  ),
                  Step(
                    isActive: currentStep == 1 ? true : false,
                    title: Text('Optional'),
                    content: Column(
                      key: UniqueKey(),
                      children: <Widget>[
                        FormBuilderDropdown(
                          attribute: 'category',
                          focusNode: categoryFocus,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.category),
                            hintText: 'Product Category',
                            labelText: 'Category',
                          ),
                          items: categoryList
                              .map((category) => DropdownMenuItem(
                                  value: category, child: Text("$category")))
                              .toList(),
                        ),
                        FormBuilderTextField(
                          attribute: 'purchasedAt',
                          focusNode: purchasedAtFocus,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.add_location),
                            hintText: 'Where did you purchase?',
                            labelText: 'Purchased At',
                          ),
                          onEditingComplete: () => FocusScope.of(context)
                              .requestFocus(salesPersonFocus),
                        ),
                        FormBuilderTextField(
                          attribute: 'salesPerson',
                          focusNode: salesPersonFocus,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.people),
                            hintText: 'Do you remember sales person name?',
                            labelText: 'Sales Person Name',
                          ),
                          onEditingComplete: () =>
                              FocusScope.of(context).requestFocus(phoneFocus),
                        ),
                        FormBuilderTextField(
                          attribute: 'phone',
                          keyboardType: TextInputType.number,
                          focusNode: phoneFocus,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.phone),
                            hintText:
                                'Contact number, i.e customer care number',
                            labelText: 'Phone number',
                          ),
                          onEditingComplete: () =>
                              FocusScope.of(context).requestFocus(emailFocus),
                        ),
                        FormBuilderTextField(
                          attribute: 'email',
                          focusNode: emailFocus,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            hintText: 'Customer Service E-Mail Address',
                            labelText: 'Email Addresss',
                          ),
                          onEditingComplete: () =>
                              FocusScope.of(context).requestFocus(notesFocus),
                        ),
                        FormBuilderTextField(
                          focusNode: notesFocus,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          attribute: 'notes',
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.note_add),
                            hintText: 'Any other additional information',
                            labelText: 'Quick Note',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Step(
                    isActive: currentStep == 2 ? true : false,
                    title: Text('Attachments'),
                    content: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.start,
                      key: UniqueKey(),
                      children: [
                        (widget.isUpdate == true &&
                                widget.product.productImage != null)
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ProductImagePreview(
                                    image: widget.product.productImage,
                                    previewTitle:
                                        'Existing Product Image Preview',
                                    imageTitle: 'Purchase Image',
                                  ),
                                  IconButton(
                                    iconSize: 32,
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () => {
                                      setState(() {
                                        Toast.show(
                                          "Image Removed.",
                                          context,
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.BOTTOM,
                                        );
                                      })
                                    },
                                  )
                                ],
                              )
                            : SizedBox(),
                        FormBuilderImagePicker(
                          bottomSheetPadding: EdgeInsets.only(bottom: 50),
                          attribute: 'productImage',
                          decoration: InputDecoration(
                            labelText: 'Upload Product Image',
                          ),
                          maxImages: 1,
                          imageQuality: 50,
                          maxHeight: 720,
                          maxWidth: 720,
                        ),
                        (widget.isUpdate == true &&
                                widget.product.purchaseCopy != null)
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ProductImagePreview(
                                    image: widget.product.purchaseCopy,
                                    previewTitle:
                                        'Existing Purchase Bill/Receipt Preview',
                                    imageTitle: 'Purchase Copy',
                                  ),
                                  IconButton(
                                    iconSize: 32,
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () => {
                                      setState(() {
                                        widget.product.purchaseCopy = null;
                                        Toast.show(
                                          "Image Removed.",
                                          context,
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.BOTTOM,
                                        );
                                      })
                                    },
                                  )
                                ],
                              )
                            : SizedBox(),
                        FormBuilderImagePicker(
                          attribute: 'imgBill',
                          decoration: InputDecoration(
                            labelText: 'Upload Purchased Bill/Receipt',
                          ),
                          maxImages: 1,
                          imageQuality: 50,
                          maxHeight: 720,
                          maxWidth: 720,
                        ),
                        (widget.isUpdate == true &&
                                widget.product.warrantyCopy != null)
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ProductImagePreview(
                                    image: widget.product.warrantyCopy,
                                    previewTitle:
                                        'Existing Warranty Copy Preview',
                                    imageTitle: 'Warranty Copy',
                                  ),
                                  IconButton(
                                    iconSize: 32,
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () => {
                                      setState(() {
                                        widget.product.warrantyCopy = null;
                                        Toast.show(
                                          "Image Removed.",
                                          context,
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.BOTTOM,
                                        );
                                      }),
                                      setState(() {}),
                                    },
                                  )
                                ],
                              )
                            : SizedBox(),
                        FormBuilderImagePicker(
                          attribute: 'imgWarranty',
                          decoration: InputDecoration(
                            labelText: 'Upload Warraty Copy',
                          ),
                          maxImages: 1,
                        ),
                        (widget.isUpdate == true &&
                                widget.product.additionalImage != null)
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ProductImagePreview(
                                    image: widget.product.additionalImage,
                                    previewTitle:
                                        'Existing Additional Image Preview',
                                    imageTitle: 'Additional Image',
                                  ),
                                  IconButton(
                                    iconSize: 32,
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () => {
                                      setState(() {
                                        widget.product.additionalImage = null;
                                        Toast.show(
                                          "Image Removed.",
                                          context,
                                          duration: Toast.LENGTH_LONG,
                                          gravity: Toast.BOTTOM,
                                        );
                                      }),
                                      setState(() {}),
                                    },
                                  )
                                ],
                              )
                            : SizedBox(),
                        FormBuilderImagePicker(
                          attribute: 'imgAdditional',
                          decoration: InputDecoration(
                            labelText: 'Upload Any Other Additional Image',
                          ),
                          maxImages: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              MaterialButton(
                color: primaryColor,
                textColor: Colors.white,
                child: Text("Reset"),
                onPressed: () {
                  _fbKey.currentState.reset();
                },
              ),
              MaterialButton(
                color: secondaryColor,
                textColor: Colors.white,
                child: Text("Submit"),
                onPressed: () async {
                  if (_fbKey.currentState.saveAndValidate()) {
                    if (widget.isUpdate == true) {
                      widget.product.name = _fbKey.currentState.value['product']
                          .toString()
                          .trim();
                      widget.product.price =
                          double.parse(_fbKey.currentState.value['price']);
                      widget.product.purchaseDate =
                          _fbKey.currentState.value['purchaseDate'];
                      widget.product.warrantyPeriod = _fbKey
                          .currentState.value['warranty']
                          .toString()
                          .trim();
                      widget.product.purchasedAt = _fbKey
                          .currentState.value['purchasedAt']
                          .toString()
                          .trim();
                      widget.product.company = _fbKey
                          .currentState.value['company']
                          .toString()
                          .trim();
                      widget.product.salesPerson = _fbKey
                          .currentState.value['salesPerson']
                          .toString()
                          .trim();
                      widget.product.phone =
                          _fbKey.currentState.value['phone'].toString().trim();
                      widget.product.email =
                          _fbKey.currentState.value['email'].toString().trim();
                      widget.product.notes = _fbKey.currentState.value['notes'];
                      widget.product.productImage =
                          _fbKey.currentState.value['productImage'].length > 0
                              ? _fileToBlob(
                                  _fbKey.currentState.value['productImage'][0])
                              : widget.product?.productImage != null
                                  ? widget.product.productImage
                                  : null;
                      widget.product.purchaseCopy = _fbKey
                                  .currentState.value['imgBill'].length >
                              0
                          ? _fileToBlob(_fbKey.currentState.value['imgBill'][0])
                          : widget.product?.purchaseCopy != null
                              ? widget.product.purchaseCopy
                              : null;
                      widget.product?.warrantyCopy =
                          _fbKey.currentState.value['imgWarranty'].length > 0
                              ? _fileToBlob(
                                  _fbKey.currentState.value['imgWarranty'][0])
                              : widget.product?.warrantyCopy != null
                                  ? widget.product.warrantyCopy
                                  : null;
                      widget.product?.additionalImage =
                          _fbKey.currentState.value['imgAdditional'].length > 0
                              ? _fileToBlob(
                                  _fbKey.currentState.value['imgAdditional'][0])
                              : widget.product?.additionalImage != null
                                  ? widget.product.additionalImage
                                  : null;
                      widget.product.category = _fbKey
                          .currentState.value['category']
                          .toString()
                          .trim();
                      widget.product.updateProduct();
                      Toast.show("Updated Product Successfully!", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    } else {
                      Product newProduct = Product();
                      newProduct.name = _fbKey.currentState.value['product']
                          .toString()
                          .trim();
                      newProduct.price =
                          double.parse(_fbKey.currentState.value['price']);
                      newProduct.purchaseDate =
                          _fbKey.currentState.value['purchaseDate'];
                      newProduct.warrantyPeriod = _fbKey
                          .currentState.value['warranty']
                          .toString()
                          .trim();
                      newProduct.purchasedAt = _fbKey
                          .currentState.value['purchasedAt']
                          .toString()
                          .trim();
                      newProduct.company = _fbKey.currentState.value['company']
                          .toString()
                          .trim();
                      newProduct.salesPerson = _fbKey
                          .currentState.value['salesPerson']
                          .toString()
                          .trim();
                      newProduct.phone =
                          _fbKey.currentState.value['phone'].toString().trim();
                      newProduct.email =
                          _fbKey.currentState.value['email'].toString().trim();
                      newProduct.notes = _fbKey.currentState.value['notes'];
                      newProduct.productImage =
                          _fbKey.currentState.value['productImage'].length > 0
                              ? _fileToBlob(
                                  _fbKey.currentState.value['productImage'][0])
                              : null;
                      newProduct.purchaseCopy = _fbKey
                                  .currentState.value['imgBill'].length >
                              0
                          ? _fileToBlob(_fbKey.currentState.value['imgBill'][0])
                          : null;
                      newProduct.warrantyCopy =
                          _fbKey.currentState.value['imgWarranty'].length > 0
                              ? _fileToBlob(
                                  _fbKey.currentState.value['imgWarranty'][0])
                              : null;
                      newProduct.additionalImage =
                          _fbKey.currentState.value['imgAdditional'].length > 0
                              ? _fileToBlob(
                                  _fbKey.currentState.value['imgAdditional'][0])
                              : null;
                      newProduct.category = _fbKey
                          .currentState.value['category']
                          .toString()
                          .trim();
                      newProduct.insertProduct();
                      Toast.show("Saved Product Successfully!", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    }

                    setState(() {
                      Navigator.pop(context, true);
                      widget.isUpdate ?? widget.actionCallback(true);
                    });
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Uint8List _fileToBlob(File file) {
    if (file != null) {
      return file.readAsBytesSync();
    }
    return null;
  }

  // File _blobToFile(Uint8List byteData) {
  //   print(byteData);
  //   if (byteData.length > 0) {
  //     return File.fromRawPath(byteData);
  //   }
  //   return null;
  // }
}
