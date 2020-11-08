import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:warranty_manager/models/product.dart';
import 'package:warranty_manager/screens/home.dart';
import 'package:warranty_manager/shared/contants.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:toast/toast.dart';

class BulkUploadScreen extends StatefulWidget {
  @override
  _BulkUploadScreenState createState() => _BulkUploadScreenState();
}

class _BulkUploadScreenState extends State<BulkUploadScreen> {
  String _fileName;
  List<PlatformFile> _paths;
  String _directoryPath;
  bool _loadingPath = false;
  List<Product> productList = [];
  List<DataRow> datarow = [];
  int lineCount = 0;
  List<int> failureRows = [];

  void _openFileExplorer() async {
    productList = [];
    datarow = [];
    lineCount = 0;
    failureRows = [];
    setState(() => _loadingPath = true);
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['txt'],
      ))
          ?.files;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
    setState(
      () {
        _loadingPath = false;
        _fileName =
            _paths != null ? _paths.map((e) => e.name).toString() : '...';

        // if file selected
        if (_paths.length > 0) {
          Stream<List> inputStream = File(_paths[0].path).openRead();

          inputStream
              .transform(utf8.decoder) // Decode bytes to UTF-8.
              .transform(LineSplitter()) // Convert stream to individual lines.
              .listen((String line) {
            // Process results.
            lineCount++;
            if (lineCount > 1) {
              List<String> row = line.split(','); // split by comma
              Product tempProduct = Product();
              tempProduct.name = row[0].trim();
              tempProduct.price = double.parse(row[1].trim());
              tempProduct.purchaseDate = DateTime.parse(row[2].trim());
              tempProduct.warrantyPeriod = row[3].trim() + ' Year';
              tempProduct.company = row[4].trim();
              tempProduct.category = row[5].trim();
              tempProduct.purchasedAt = row[6].trim();
              tempProduct.salesPerson = row[7].trim();
              tempProduct.phone = row[8].trim();
              tempProduct.email = row[9].trim();
              tempProduct.notes = row[10].trim();

              productList.add(tempProduct);

              List<DataCell> datacell = [];
              datacell.add(DataCell(Text(tempProduct.name)));
              datacell.add(DataCell(Text(tempProduct.price.toString())));
              datacell.add(DataCell(Text(tempProduct.purchaseDate.toString())));
              datacell
                  .add(DataCell(Text(tempProduct.warrantyPeriod + ' Year')));
              datacell.add(DataCell(Text(tempProduct.company)));
              datacell.add(DataCell(Text(tempProduct.category)));
              datacell.add(DataCell(Text(tempProduct.purchasedAt)));
              datacell.add(DataCell(Text(tempProduct.salesPerson)));
              datacell.add(DataCell(Text(tempProduct.phone)));
              datacell.add(DataCell(Text(tempProduct.email)));
              datacell.add(DataCell(Text(tempProduct.notes)));
              datarow.add(DataRow(cells: datacell));
            }
          }, onDone: () {
            setState(() {});
          }, onError: (e) {
            failureRows.add(lineCount);
            print(e.toString());
          });
        }
      },
    );
  }

  void _clearCachedFiles() {
    FilePicker.platform.clearTemporaryFiles();
  }

  // todo: replace with file downloader
  // todo: move to new file
  void _requestFileCopy(Uint8List data, String copyTo) async {
    File(copyTo)
        .writeAsBytes(data)
        .then(
          (value) => Toast.show(
            "File Saved Successfully!",
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM,
            backgroundColor: Colors.green,
          ),
        )
        .catchError(
          (onError) => {
            Toast.show(
              "Failed to Save the File! $onError",
              context,
              duration: Toast.LENGTH_LONG,
              gravity: Toast.BOTTOM,
              backgroundColor: Colors.red,
            )
          },
        );
  }

  // bulk upload
  Future<void> _processBulkUpload(List<Product> products) async {
    products.forEach((element) {
      element.insertProduct();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        textTheme: TextTheme(),
        title: Text(
          'Bulk Upload',
        ),
      ),
      body: Padding(
        padding: appPaddingLarge,
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Download Sample File',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(
                  height: 5,
                ),
                RaisedButton.icon(
                  icon: Icon(Icons.download_sharp),
                  label: Text('Download Sample'),
                  onPressed: () async {
                    const url =
                        'https://drive.google.com/file/d/1koyZ3phMxFdu8AtQbk4lPFmKt1cpc-5H/view?usp=sharing';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      print('Could not launch $url');
                    }
                  },
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  'Bulk Uploader (.txt)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                RaisedButton.icon(
                  onPressed: () => _openFileExplorer(),
                  icon: Icon(Icons.file_upload),
                  label: Text("Open File Picker"),
                ),
                SizedBox(
                  height: 20,
                ),
                Builder(
                  builder: (BuildContext context) => _loadingPath
                      ? Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: CircularProgressIndicator(),
                        )
                      : _directoryPath != null
                          ? ListTile(
                              title: Text('Directory path'),
                              subtitle: Text(_directoryPath),
                            )
                          : _paths != null
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Text(
                                        'Data Preview',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25.0,
                                        ),
                                      ),
                                    ),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: DataTable(
                                        columns: <DataColumn>[
                                          DataColumn(
                                            label: Text(
                                              'Name',
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Price',
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Purchase Date',
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Warranty Period',
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Company',
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Category',
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Purchase at',
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Contact Person',
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Phone',
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Email',
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Notes',
                                            ),
                                          ),
                                        ],
                                        rows: datarow,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                        child: Text(
                                            'Total number of Rows : ${lineCount - 1}')),
                                    Container(
                                        child: Text(
                                            'Number of Rows parsed : ${datarow.length}')),
                                    Container(
                                        child: Text(
                                            'Number of Rows Failed : ${lineCount - 1 - datarow.length}')),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      child: RaisedButton.icon(
                                        color: secondaryColor,
                                        onPressed: () async =>
                                            await _processBulkUpload(
                                                    productList)
                                                .then(
                                                  (value) => {
                                                    Toast.show(
                                                      "Bulk Import Successfully!",
                                                      context,
                                                      duration:
                                                          Toast.LENGTH_LONG,
                                                      gravity: Toast.BOTTOM,
                                                      backgroundColor:
                                                          Colors.green,
                                                    ),
                                                    _clearCachedFiles(),
                                                    Navigator.pop(context),
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            Home(),
                                                      ),
                                                    ),
                                                  },
                                                )
                                                .catchError(
                                                  (err) => {
                                                    Toast.show(
                                                      "Failed to import!",
                                                      context,
                                                      duration:
                                                          Toast.LENGTH_LONG,
                                                      gravity: Toast.BOTTOM,
                                                      backgroundColor:
                                                          Colors.green,
                                                    ),
                                                    _clearCachedFiles(),
                                                    Navigator.pop(context),
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            Home(),
                                                      ),
                                                    ),
                                                  },
                                                ),
                                        icon: Icon(Icons.save,
                                            color: Colors.white),
                                        label: Text(
                                          'Complete Bulk Import',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : SizedBox(),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
