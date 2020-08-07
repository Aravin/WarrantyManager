import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:warranty_manager/models/product.dart';

import '../contants.dart';

class AddItem extends StatefulWidget {
  @override
  _AddItemState createState() => _AddItemState();

  final Product product;
  final bool isUpdate;
  final Function actionCallback;

  AddItem({this.product, this.isUpdate, this.actionCallback});
}

class _AddItemState extends State<AddItem> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  final FocusNode productFocus = FocusNode();
  final FocusNode priceFocus = FocusNode();
  final FocusNode purchasedAt = FocusNode();
  final FocusNode warrantyFocus = FocusNode();
  final FocusNode purchasedAtFocus = FocusNode();
  final FocusNode companyFocus = FocusNode();
  final FocusNode salesPersonFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode notesFocus = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        textTheme: TextTheme(),
        title: Text(
          'Add or Edit Item',
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
                    : new DateTime.now(),
                'warranty':
                    widget.isUpdate ? widget.product.warrantyPeriod : null,
                'product': widget.isUpdate ? widget.product?.name : '',
                'price': widget.isUpdate ? widget.product.price.toString() : '',
                'purchasedAt':
                    widget.isUpdate ? widget.product?.purchasedAt : '',
                'company': widget.isUpdate ? widget.product?.company : '',
                'salesPerson':
                    widget.isUpdate ? widget.product?.salesPerson : '',
                'phone': widget.isUpdate ? widget.product?.phone : '',
                'email': widget.isUpdate ? widget.product?.email : '',
                'notes': widget.isUpdate ? widget.product?.notes : '',
              },
              autovalidate: false,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: DefaultTabController(
                      length: 2,
                      child: Scaffold(
                        appBar: TabBar(
                          indicatorColor: secondaryCOlor,
                          labelColor: primaryColor,
                          tabs: [
                            Tab(text: 'Required'),
                            Tab(text: 'Optional'),
                            // Tab(text: 'Images'),
                          ],
                        ),
                        body: TabBarView(
                          children: [
                            ListView(
                              padding: appEdgeInsets,
                              children: <Widget>[
                                FormBuilderDateTimePicker(
                                  attribute: "purchaseDate",
                                  textInputAction: TextInputAction.next,
                                  validators: [
                                    FormBuilderValidators.required()
                                  ],
                                  inputType: InputType.date,
                                  format: DateFormat("EEE, MMMM d, yyyy"),
                                  decoration: InputDecoration(
                                    labelText: "Purchase Date",
                                    prefixIcon: Icon(Icons.calendar_today),
                                  ),
                                  onEditingComplete: () =>
                                      FocusScope.of(context)
                                          .requestFocus(priceFocus),
                                ),
                                FormBuilderDropdown(
                                  attribute: "warranty",
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.timer),
                                    labelText: "Warranty Period",
                                  ),
                                  // initialValue: 'Male',
                                  hint: Text('Select Warranty Period'),
                                  validators: [
                                    FormBuilderValidators.required()
                                  ],
                                  items: warrantyPeriods
                                      .map((period) => DropdownMenuItem(
                                          value: period,
                                          child: Text("$period")))
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
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.shopping_basket),
                                    hintText: 'Product/Service Name ?',
                                    labelText: 'Product/Service Name *',
                                  ),
                                  onEditingComplete: () =>
                                      FocusScope.of(context)
                                          .requestFocus(priceFocus),
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
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.monetization_on),
                                    hintText: 'Total Bill Amount ?',
                                    labelText: 'Price *',
                                  ),
                                  onEditingComplete: () =>
                                      FocusScope.of(context)
                                          .requestFocus(companyFocus),
                                ),
                                FormBuilderTextField(
                                  attribute: 'company',
                                  focusNode: companyFocus,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.branding_watermark),
                                    hintText: 'Company or Brand Name?',
                                    labelText: 'Brand/Company',
                                  ),
                                  validators: [
                                    FormBuilderValidators.required(),
                                    FormBuilderValidators.minLength(3),
                                    FormBuilderValidators.maxLength(24)
                                  ],
                                  onEditingComplete: () =>
                                      FocusScope.of(context)
                                          .requestFocus(purchasedAtFocus),
                                ),
                              ],
                            ),
                            ListView(
                              padding: appEdgeInsets,
                              children: <Widget>[
                                FormBuilderTextField(
                                  attribute: 'purchasedAt',
                                  focusNode: purchasedAtFocus,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.add_location),
                                    hintText: 'Where did you purchase?',
                                    labelText: 'Purchased At',
                                  ),
                                  onEditingComplete: () =>
                                      FocusScope.of(context)
                                          .requestFocus(salesPersonFocus),
                                ),
                                FormBuilderTextField(
                                  attribute: 'salesPerson',
                                  focusNode: salesPersonFocus,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.people),
                                    hintText:
                                        'Do you remember sales person name?',
                                    labelText: 'Sales Person Name',
                                  ),
                                  onEditingComplete: () =>
                                      FocusScope.of(context)
                                          .requestFocus(phoneFocus),
                                ),
                                FormBuilderTextField(
                                  attribute: 'phone',
                                  keyboardType: TextInputType.number,
                                  focusNode: phoneFocus,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.phone),
                                    hintText:
                                        'Contact number, i.e customer care number',
                                    labelText: 'Phone number',
                                  ),
                                  onEditingComplete: () =>
                                      FocusScope.of(context)
                                          .requestFocus(emailFocus),
                                ),
                                FormBuilderTextField(
                                  attribute: 'email',
                                  focusNode: emailFocus,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.email),
                                    hintText: 'Customer Service E-Mail Address',
                                    labelText: 'Email Addresss',
                                  ),
                                  onEditingComplete: () =>
                                      FocusScope.of(context)
                                          .requestFocus(notesFocus),
                                ),
                                FormBuilderTextField(
                                  focusNode: notesFocus,
                                  maxLines: null,
                                  keyboardType: TextInputType.multiline,
                                  attribute: 'notes',
                                  textInputAction: TextInputAction.done,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.note_add),
                                    hintText:
                                        'Any other additional information',
                                    labelText: 'Quick Note',
                                  ),
                                ),
                              ],
                            ),
                            // todo implement image upload
                            // ListView(
                            //   children: <Widget>[
                            //     FormBuilderImagePicker(
                            //       attribute: 'imgBill',
                            //       decoration: const InputDecoration(
                            //         labelText: 'Purchased Bill/Receipt',
                            //       ),
                            //     ),
                            //     FormBuilderImagePicker(
                            //       attribute: 'imgWarranty',
                            //       decoration: const InputDecoration(
                            //         hintText: 'Where did you purchase?',
                            //         labelText: 'Warraty Copy',
                            //       ),
                            //     ),
                            //     FormBuilderImagePicker(
                            //       attribute: 'imgAdditional',
                            //       decoration: const InputDecoration(
                            //         hintText: 'Where did you purchase?',
                            //         labelText:
                            //             'Any Other Additional Information',
                            //       ),
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
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
                        color: secondaryCOlor,
                        textColor: Colors.white,
                        child: Text("Submit"),
                        onPressed: () async {
                          if (_fbKey.currentState.saveAndValidate()) {
                            // product.customQuery1();
                            // product.customQuery2();
                            if (widget.isUpdate == true) {
                              widget.product.name = _fbKey
                                  .currentState.value['product']
                                  .toString()
                                  .trim();
                              widget.product.price = double.parse(
                                  _fbKey.currentState.value['price']);
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
                              widget.product.phone = _fbKey
                                  .currentState.value['phone']
                                  .toString()
                                  .trim();
                              widget.product.email = _fbKey
                                  .currentState.value['email']
                                  .toString()
                                  .trim();
                              widget.product.notes =
                                  _fbKey.currentState.value['notes'];
                              widget.product.updateProduct();
                              Toast.show(
                                  "Updated Product Successfully!", context,
                                  duration: Toast.LENGTH_LONG,
                                  gravity: Toast.BOTTOM);
                            } else {
                              Product newProduct = Product();
                              newProduct.name = _fbKey
                                  .currentState.value['product']
                                  .toString()
                                  .trim();
                              newProduct.price = double.parse(
                                  _fbKey.currentState.value['price']);
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
                              newProduct.company = _fbKey
                                  .currentState.value['company']
                                  .toString()
                                  .trim();
                              newProduct.salesPerson = _fbKey
                                  .currentState.value['salesPerson']
                                  .toString()
                                  .trim();
                              newProduct.phone = _fbKey
                                  .currentState.value['phone']
                                  .toString()
                                  .trim();
                              newProduct.email = _fbKey
                                  .currentState.value['email']
                                  .toString()
                                  .trim();
                              newProduct.notes =
                                  _fbKey.currentState.value['notes'];
                              newProduct.insertProduct();
                              Toast.show("Saved Product Successfully!", context,
                                  duration: Toast.LENGTH_LONG,
                                  gravity: Toast.BOTTOM);
                            }
                            // print(await product.getProducts());
                            setState(() {
                              Navigator.pop(context, true);
                              widget.actionCallback(true);
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
