
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:warranty_manager/models/product.dart';
import 'package:warranty_manager/shared/category.dart';
import 'package:warranty_manager/shared/contants.dart';
import 'package:warranty_manager/shared/file.dart';
import 'package:warranty_manager/widgets/product_image_preview.dart';

class AddItem extends StatefulWidget {
  @override
  _AddItemState createState() => _AddItemState();

  final Product? product;
  final bool isUpdate;
  final void Function(bool)? actionCallback;

  const AddItem({super.key, this.product, this.isUpdate = false, this.actionCallback});
}

class _AddItemState extends State<AddItem> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  // mandatory
  // FocusNode productFocus = FocusNode();
  // FocusNode priceFocus = FocusNode();
  // FocusNode warrantyFocus = FocusNode();

  // // optional
  // FocusNode categoryFocus = FocusNode();
  // FocusNode purchasedAtFocus = FocusNode();
  // FocusNode companyFocus = FocusNode();
  // FocusNode salesPersonFocus = FocusNode();
  // FocusNode phoneFocus = FocusNode();
  // FocusNode emailFocus = FocusNode();
  // FocusNode notesFocus = FocusNode();

  // steps
  int currentStep = 0;
  bool complete = false;

  void next() {
    currentStep + 1 != 3
        ? goTo(currentStep + 1)
        : setState(() {
            complete = true;
          });
  }

  void cancel() {
    if (currentStep > 0) {
      goTo(currentStep - 1);
    }
  }

  void goTo(int step) {
                    if (_fbKey.currentState!.saveAndValidate()) {
      setState(() {
        currentStep = step;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // productFocus.dispose();
    // priceFocus.dispose();
    // warrantyFocus.dispose();

    // // optional
    // categoryFocus.dispose();
    // purchasedAtFocus.dispose();
    // companyFocus.dispose();
    // salesPersonFocus.dispose();
    // phoneFocus.dispose();
    // emailFocus.dispose();
    // notesFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                    ? widget.product!.purchaseDate
                    : _fbKey.currentState != null
                        ? _fbKey.currentState!.value['purchaseDate']
                        : DateTime.now(),
                'warranty': widget.isUpdate
                    ? widget.product!.warrantyPeriod
                    : _fbKey.currentState != null
                        ? _fbKey.currentState!.value['warranty']
                        : null,
                'product': widget.isUpdate
                    ? widget.product?.name
                    : _fbKey.currentState != null
                        ? _fbKey.currentState!.value['product']
                        : '',
                'price': widget.isUpdate
                    ? widget.product!.price.toString()
                    : _fbKey.currentState != null
                        ? _fbKey.currentState!.value['price']
                        : '',
                'company': widget.isUpdate
                    ? widget.product?.company
                    : _fbKey.currentState != null
                        ? _fbKey.currentState!.value['company']
                        : '',
                'purchasedAt': widget.isUpdate
                    ? widget.product?.purchasedAt ?? ''
                    : _fbKey.currentState != null
                        ? _fbKey.currentState!.value['purchasedAt']
                        : '',
                'salesPerson': widget.isUpdate
                    ? widget.product?.salesPerson ?? ''
                    : _fbKey.currentState != null
                        ? _fbKey.currentState!.value['salesPerson']
                        : '',
                'phone': widget.isUpdate
                    ? widget.product?.phone ?? ''
                    : _fbKey.currentState != null
                        ? _fbKey.currentState!.value['phone']
                        : '',
                'email': widget.isUpdate
                    ? widget.product?.email ?? ''
                    : _fbKey.currentState != null
                        ? _fbKey.currentState!.value['email']
                        : '',
                'notes': widget.isUpdate
                    ? widget.product?.notes ?? ''
                    : _fbKey.currentState != null
                        ? _fbKey.currentState!.value['notes']
                        : '',
                'productImage': const [],
                'imgBill': const [],
                'imgWarranty': const [],
                'imgAdditional': const [],
                'category': widget.isUpdate
                    ? widget.product?.category ?? 'Other'
                    : _fbKey.currentState != null
                        ? _fbKey.currentState!.value['category']
                        : 'Other'
              },
              // autovalidate: false,
              child: Stepper(
                currentStep: currentStep,
                onStepContinue: next,
                onStepTapped: (step) => goTo(step),
                onStepCancel: cancel,
                steps: [
                  Step(
                    isActive: currentStep == 0,
                    title: const Text('Required*'),
                    content: Column(
                      key: UniqueKey(),
                      children: [
                        FormBuilderDateTimePicker(
                            name: "purchaseDate",
                            textInputAction: TextInputAction.next,
                            validator: FormBuilderValidators.compose(
                                [FormBuilderValidators.required()]),
                            keyboardType: TextInputType.datetime,
                            inputType: InputType.date,
                            format: DateFormat("EEE, MMMM d, yyyy"),
                            decoration: const InputDecoration(
                              labelText: "Purchase Date",
                              prefixIcon: Icon(Icons.calendar_today),
                            ),
                            // onEditingComplete: () => FocusScope.of(context)
                            //     .requestFocus(warrantyFocus),
                          ),
                        FormBuilderDropdown(
                          name: "warranty",
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.timer),
                            labelText: "Warranty Period",
                          ),
                          // initialValue: 'Other',
                          hint: const Text('Select Warranty Period'),
                          validator: FormBuilderValidators.compose(
                              [FormBuilderValidators.required()]),
                          items: warrantyPeriods
                              .map((period) => DropdownMenuItem(
                                  value: period, child: Text(period)))
                              .toList(),
                        ),
                        FormBuilderTextField(
                          name: 'product',
                          // focusNode: productFocus,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.minLength(3),
                            FormBuilderValidators.maxLength(24)
                          ]),
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.shopping_basket),
                            hintText: 'Product/Service Name ?',
                            labelText: 'Product/Service Name *',
                          ),
                          // onEditingComplete: () =>
                          //     FocusScope.of(context).requestFocus(priceFocus),
                        ),
                        FormBuilderTextField(
                          name: 'price',
                          // focusNode: priceFocus,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.min(1),
                            FormBuilderValidators.max(9999999)
                          ]),
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.monetization_on),
                            hintText: 'Total Bill Amount ?',
                            labelText: 'Price *',
                          ),
                          // onEditingComplete: () =>
                          //     FocusScope.of(context).requestFocus(companyFocus),
                        ),
                        FormBuilderTextField(
                          name: 'company',
                          // focusNode: companyFocus,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.branding_watermark),
                            hintText: 'Company or Brand Name?',
                            labelText: 'Brand/Company',
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.minLength(2),
                            FormBuilderValidators.maxLength(24)
                          ]),
                          // onEditingComplete: () => FocusScope.of(context)
                          //     .requestFocus(categoryFocus),
                        ),
                      ],
                    ),
                  ),
                  Step(
                    isActive: currentStep == 1,
                    title: const Text('Optional'),
                    content: Column(
                      key: UniqueKey(),
                      children: <Widget>[
                        FormBuilderDropdown(
                          name: 'category',
                          // focusNode: categoryFocus,

                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.category),
                            hintText: 'Product Category',
                            labelText: 'Category',
                          ),
                          initialValue: 'Other',
                          items: categoryList
                              .map((category) => DropdownMenuItem(
                                  value: category, child: Text(category)))
                              .toList(),
                        ),
                        FormBuilderTextField(
                          name: 'purchasedAt',
                          // focusNode: purchasedAtFocus,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.add_location),
                            hintText: 'Where did you purchase?',
                            labelText: 'Purchased At',
                          ),
                          initialValue: '',
                          // onEditingComplete: () => FocusScope.of(context)
                          //     .requestFocus(salesPersonFocus),
                        ),
                        FormBuilderTextField(
                          name: 'salesPerson',
                          // focusNode: salesPersonFocus,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.people),
                            hintText: 'Do you remember sales person name?',
                            labelText: 'Sales Person Name',
                          ),
                          initialValue: '',
                          // onEditingComplete: () =>
                          //     FocusScope.of(context).requestFocus(phoneFocus),
                        ),
                        FormBuilderTextField(
                          name: 'phone',
                          keyboardType: TextInputType.number,
                          // focusNode: phoneFocus,
                          textInputAction: TextInputAction.next,
                          initialValue: '',
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.phone),
                            hintText:
                                'Contact number, i.e customer care number',
                            labelText: 'Phone number',
                          ),
                          // onEditingComplete: () =>
                          //     FocusScope.of(context).requestFocus(emailFocus),
                        ),
                        FormBuilderTextField(
                          name: 'email',
                          // focusNode: emailFocus,
                          textInputAction: TextInputAction.next,
                          initialValue: '',
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            hintText: 'Customer Service E-Mail Address',
                            labelText: 'Email Addresss',
                          ),
                          // onEditingComplete: () =>
                          //     FocusScope.of(context).requestFocus(notesFocus),
                        ),
                        FormBuilderTextField(
                          // focusNode: notesFocus,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          name: 'notes',
                          initialValue: '',
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.note_add),
                            hintText: 'Any other additional information',
                            labelText: 'Quick Note',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Step(
                    isActive: currentStep == 2,
                    title: const Text('Attachments'),
                    content: Column(
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.start,
                      key: UniqueKey(),
                      children: [
                        // Text(
                        //     'Image Path is ${widget.product.productImagePath}'),
                        if (widget.isUpdate == true &&
                                widget.product!.productImagePath != null) Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ProductImagePreview(
                                     image: widget.product!.productImagePath!,
                                    previewTitle:
                                        'Existing Product Image Preview',
                                    imageTitle: 'Purchase Image',
                                  ),
                                  IconButton(
                                    iconSize: 32,
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () => {
                                      setState(() {
                                        widget.product!.productImagePath = null;
                                        context.showToast(msg: "Image Removed.");
                                      })
                                    },
                                  )
                                ],
                              ) else const SizedBox(),
                        FormBuilderImagePicker(
                          bottomSheetPadding: const EdgeInsets.only(bottom: 50),
                          name: 'productImage',
                          decoration: const InputDecoration(
                            labelText: 'Upload Product Image',
                          ),
                          maxImages: 1,
                          imageQuality: 50,
                          maxHeight: 720,
                          maxWidth: 720,
                        ),
                        if (widget.isUpdate == true &&
                                widget.product!.purchaseCopyPath != null) Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ProductImagePreview(
                                     image: widget.product!.purchaseCopyPath!,
                                    previewTitle:
                                        'Existing Purchase Bill/Receipt Preview',
                                    imageTitle: 'Purchase Copy',
                                  ),
                                  IconButton(
                                    iconSize: 32,
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () => {
                                      setState(() {
                                        widget.product!.purchaseCopyPath = null;
                                        context.showToast(msg: "Image Removed.");
                                      })
                                    },
                                  )
                                ],
                              ) else const SizedBox(),
                        FormBuilderImagePicker(
                          name: 'imgBill',
                          decoration: const InputDecoration(
                            labelText: 'Upload Purchased Bill/Receipt',
                          ),
                          maxImages: 1,
                          imageQuality: 50,
                          maxHeight: 720,
                          maxWidth: 720,
                        ),
                        if (widget.isUpdate == true &&
                                widget.product!.warrantyCopyPath != null) Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ProductImagePreview(
                                     image: widget.product!.warrantyCopyPath!,
                                    previewTitle:
                                        'Existing Warranty Copy Preview',
                                    imageTitle: 'Warranty Copy',
                                  ),
                                  IconButton(
                                    iconSize: 32,
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () => {
                                        setState(() {
                                        widget.product!.warrantyCopyPath = null;
                                        context.showToast(msg: "Image Removed.");
                                      }),
                                      setState(() {}),
                                    },
                                  )
                                ],
                              ) else const SizedBox(),
                        FormBuilderImagePicker(
                          name: 'imgWarranty',
                          decoration: const InputDecoration(
                            labelText: 'Upload Warraty Copy',
                          ),
                          maxImages: 1,
                        ),
                        if (widget.isUpdate == true &&
                                widget.product!.additionalImagePath != null) Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ProductImagePreview(
                                     image: widget.product!.additionalImagePath!,
                                    previewTitle:
                                        'Existing Additional Image Preview',
                                    imageTitle: 'Additional Image',
                                  ),
                                  IconButton(
                                    iconSize: 32,
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed: () => {
                                      setState(() {
                                        widget.product!.additionalImagePath =
                                            null;
                                        context.showToast(msg: "Image Removed.");
                                      }),
                                      setState(() {}),
                                    },
                                  )
                                ],
                              ) else const SizedBox(),
                        FormBuilderImagePicker(
                          name: 'imgAdditional',
                          decoration: const InputDecoration(
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
          const SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              MaterialButton(
                color: primaryColor,
                textColor: Colors.white,
                child: const Text("Reset"),
                onPressed: () {
                  _fbKey.currentState!.reset();
                },
              ),
              MaterialButton(
                color: secondaryColor,
                textColor: Colors.white,
                child: const Text("Submit"),
                onPressed: () async {
                  if (_fbKey.currentState!.saveAndValidate()) {
                    final String prodImgPath = await saveFileAsImagePath(
                        _fbKey.currentState!.value['productImage']);

                    final String purBillPath = await saveFileAsImagePath(
                        _fbKey.currentState!.value['imgBill']);

                    final String warrImgPath = await saveFileAsImagePath(
                        _fbKey.currentState!.value['imgWarranty']);

                    final String addImgPath = await saveFileAsImagePath(
                        _fbKey.currentState!.value['imgAdditional']);

                    if (widget.isUpdate == true) {
                      widget.product!.name =                     _fbKey.currentState!.value['product']
                          .toString()
                          .trim();
                      widget.product!.price = double.parse(
                          _fbKey.currentState!.value['price'].toString());
                      widget.product!.purchaseDate =
                          _fbKey.currentState!.value['purchaseDate'] as DateTime;
                      widget.product!.warrantyPeriod = _fbKey
                          .currentState!.value['warranty']
                          .toString()
                          .trim();
                      widget.product!.purchasedAt = _fbKey
                          .currentState!.value['purchasedAt']
                          .toString()
                          .trim();
                      widget.product!.company = _fbKey
                          .currentState!.value['company']
                          .toString()
                          .trim();
                      widget.product!.salesPerson = _fbKey
                          .currentState!.value['salesPerson']
                          .toString()
                          .trim();
                      widget.product!.phone =
                          _fbKey.currentState!.value['phone'].toString().trim();
                      widget.product!.email =
                          _fbKey.currentState!.value['email'].toString().trim();
                      widget.product!.notes =
                          _fbKey.currentState!.value['notes'].toString();
                      // widget.product.productImage =
                      //     _fbKey.currentState.value['productImage'].length > 0
                      //         ? _fileToBlob(
                      //             _fbKey.currentState.value['productImage'][0])
                      //         : widget.product?.productImage != null
                      //             ? widget.product.productImage
                      //             : null;
                      // widget.product.purchaseCopy = _fbKey
                      //             .currentState.value['imgBill'].length >
                      //         0
                      //     ? _fileToBlob(_fbKey.currentState.value['imgBill'][0])
                      //     : widget.product?.purchaseCopy != null
                      //         ? widget.product.purchaseCopy
                      //         : null;
                      // widget.product?.warrantyCopy =
                      //     _fbKey.currentState.value['imgWarranty'].length > 0
                      //         ? _fileToBlob(
                      //             _fbKey.currentState.value['imgWarranty'][0])
                      //         : widget.product?.warrantyCopy != null
                      //             ? widget.product.warrantyCopy
                      //             : null;
                      // widget.product?.additionalImage =
                      //     _fbKey.currentState.value['imgAdditional'].length > 0
                      //         ? _fileToBlob(
                      //             _fbKey.currentState.value['imgAdditional'][0])
                      //         : widget.product?.additionalImage != null
                      //             ? widget.product.additionalImage
                      //             : null;
                      widget.product!.category = _fbKey
                          .currentState!.value['category']
                          .toString()
                          .trim();
                      widget.product!.productImagePath = prodImgPath;
                      widget.product!.purchaseCopyPath = purBillPath;
                      widget.product!.warrantyCopyPath = warrImgPath;
                      widget.product!.additionalImagePath = addImgPath;
                      await widget.product!.updateProduct();
                      if (!mounted) return;
                      context.showToast(msg: "Updated Product Successfully!");
                    } else {
                      final Product newProduct = Product();
                      newProduct.name =                     _fbKey.currentState!.value['product']
                          .toString()
                          .trim();
                      newProduct.price = double.parse(
                          _fbKey.currentState!.value['price'].toString());
                      newProduct.purchaseDate =
                          _fbKey.currentState!.value['purchaseDate'] as DateTime;
                      newProduct.warrantyPeriod = _fbKey
                          .currentState!.value['warranty']
                          .toString()
                          .trim();
                      newProduct.purchasedAt = _fbKey
                          .currentState!.value['purchasedAt']
                          .toString()
                          .trim();
                      newProduct.company =                     _fbKey.currentState!.value['company']
                          .toString()
                          .trim();
                      newProduct.salesPerson = _fbKey
                          .currentState!.value['salesPerson']
                          .toString()
                          .trim();
                      newProduct.phone =
                          _fbKey.currentState!.value['phone'].toString().trim();
                      newProduct.email =
                          _fbKey.currentState!.value['email'].toString().trim();
                      newProduct.notes =
                          _fbKey.currentState!.value['notes'].toString();
                      // newProduct.productImage =
                      //     _fbKey.currentState.value['productImage'] != null
                      //         ? _fileToBlob(
                      //             _fbKey.currentState.value['productImage'][0])
                      //         : null;
                      // newProduct.purchaseCopy = _fbKey
                      //             .currentState.value['imgBill'] !=
                      //         null
                      //     ? _fileToBlob(_fbKey.currentState.value['imgBill'][0])
                      //     : null;
                      // newProduct.warrantyCopy =
                      //     _fbKey.currentState.value['imgWarranty'] != null
                      //         ? _fileToBlob(
                      //             _fbKey.currentState.value['imgWarranty'][0])
                      //         : null;
                      // newProduct.additionalImage =
                      //     _fbKey.currentState.value['imgAdditional'] != null
                      //         ? _fileToBlob(
                      //             _fbKey.currentState.value['imgAdditional'][0])
                      //         : null;
                      newProduct.category = _fbKey
                          .currentState!.value['category']
                          .toString()
                          .trim();
                      newProduct.productImagePath = prodImgPath;
                      newProduct.purchaseCopyPath = purBillPath;
                      newProduct.warrantyCopyPath = warrImgPath;
                      newProduct.additionalImagePath = addImgPath;
                      await newProduct.insertProduct();
                      if (!mounted) return;
                      context.showToast(msg: "Saved Product Successfully!");
                    }

                    setState(() {
                      Navigator.pop(context, true);
                      if (!widget.isUpdate) {
                        widget.actionCallback?.call(true);
                      }
                    });
                  }
                },
              ),
            ],
          ),
          // AdmobBanner(
          //   adUnitId: AdManager.bannerAdUnitId,
          //   adSize: AdmobBannerSize.BANNER,
          //   listener: (AdmobAdEvent event, Map<String, dynamic> args) {
          //     print([event, args, 'Banner']);
          //   },
          //   onBannerCreated: (AdmobBannerController controller) {
          //     // Dispose is called automatically for you when Flutter removes the banner from the widget tree.
          //     // Normally you don't need to worry about disposing this yourself, it's handled.
          //     // If you need direct access to dispose, this is your guy!
          //     // controller.dispose();
          //   },
          // ),
        ],
      ),
    );
  }

  // Uint8List _fileToBlob(File file) {
  //   if (file != null) {
  //     return file.readAsBytesSync();
  //   }
  //   return null;
  // }

  // File _blobToFile(Uint8List byteData) {
  //   print(byteData);
  //   if (byteData.length > 0) {
  //     return File.fromRawPath(byteData);
  //   }
  //   return null;
  // }
}
