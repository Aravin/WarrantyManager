import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:warranty_manager/models/product.dart';
import 'package:warranty_manager/screens/home.dart';
import 'package:warranty_manager/shared/ads.dart';
import 'package:warranty_manager/shared/contants.dart';
import 'package:warranty_manager/widgets/bulk_actions.dart';

class BulkUploadScreen extends StatefulWidget {
  @override
  _BulkUploadScreenState createState() => _BulkUploadScreenState();
}

class _BulkUploadScreenState extends State<BulkUploadScreen> {
  List<PlatformFile>? _paths;
  String? _directoryPath;
  bool _loadingPath = false;
  List<Product> productList = [];
  List<DataRow> datarow = [];
  int lineCount = 0;
  List<int> failureRows = [];

  Future<void> _openFileExplorer() async {
    productList = [];
    datarow = [];
    lineCount = 0;
    failureRows = [];
    setState(() => _loadingPath = true);
    try {
      _directoryPath = null;
      _paths = (await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt'],
      ))
          ?.files;
    } on PlatformException catch (e) {
      print("Unsupported operation$e");
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
    setState(
      () {
        _loadingPath = false;
        _paths != null ? _paths!.map((e) => e.name).toString() : '...';

        // if file selected
        if (_paths != null && _paths!.isNotEmpty) {
          final Stream<List> inputStream = File(_paths![0].path!).openRead();

          inputStream
              .transform(utf8.decoder) // Decode bytes to UTF-8.
              .transform(const LineSplitter()) // Convert stream to individual lines.
              .listen((String line) {
            // Process results.
            lineCount++;
            if (lineCount > 1) {
              final List<String> row = line.split(','); // split by comma
              final Product tempProduct = Product();
              tempProduct.name = row[0].trim();
              tempProduct.price = double.parse(row[1].trim());
              tempProduct.purchaseDate = DateTime.parse(row[2].trim());
              tempProduct.warrantyPeriod = '${row[3].trim()} Year';
              tempProduct.company = row[4].trim();
              tempProduct.category = row[5].trim();
              tempProduct.purchasedAt = row[6].trim();
              tempProduct.salesPerson = row[7].trim();
              tempProduct.phone = row[8].trim();
              tempProduct.email = row[9].trim();
              tempProduct.notes = row[10].trim();

              productList.add(tempProduct);

              final List<DataCell> datacell = [];
              datacell.add(DataCell(Text(tempProduct.name)));
              datacell.add(DataCell(Text(tempProduct.price.toString())));
              datacell.add(DataCell(Text(tempProduct.purchaseDate.toString())));
              datacell
                  .add(DataCell(Text('${tempProduct.warrantyPeriod} Year')));
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
            print(e);
          });
        }
      },
    );
  }

  void _clearCachedFiles() {
    FilePicker.clearTemporaryFiles();
  }

  // todo: replace with file downloader
  // todo: move to new file
  // void _requestFileCopy(Uint8List data, String copyTo) async {
  //   File(copyTo)
  //       .writeAsBytes(data)
  //       .then(
  //         (value) => Toast.show(
  //           "File Saved Successfully!",
  //           context,
  //           duration: Toast.LENGTH_LONG,
  //           gravity: Toast.BOTTOM,
  //           backgroundColor: Colors.green,
  //         ),
  //       )
  //       .catchError(
  //         (onError) => {
  //           Toast.show(
  //             "Failed to Save the File! $onError",
  //             context,
  //             duration: Toast.LENGTH_LONG,
  //             gravity: Toast.BOTTOM,
  //             backgroundColor: Colors.red,
  //           )
  //         },
  //       );
  // }

  // bulk upload
  Future<void> _processBulkUpload(List<Product> products) async {
    for (final element in products) {
      await element.insertProduct();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bulk Upload',
        ),
      ),
      body: Padding(
        padding: appPaddingLarge,
        child: ListView(
          children: [
            Column(
              children: [
                'Download Sample File'.text.xl2.bold.makeCentered(),
                const HeightBox(10),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                  ),
                  icon: const Icon(Icons.download_sharp),
                  label: const Text('Download Sample'),
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
                const HeightBox(25),
                'Bulk Uploader (.txt)'.text.xl2.bold.makeCentered(),
                const SizedBox(
                  height: 5,
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                  ),
                  onPressed: () => _openFileExplorer(),
                  icon: const Icon(Icons.file_upload),
                  label: const Text("Open File Picker"),
                ),
                const HeightBox(20),
                Builder(
                  builder: (BuildContext context) => _loadingPath
                      ? const Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: CircularProgressIndicator(),
                        )
                      : _directoryPath != null
                          ? ListTile(
                              title: const Text('Directory path'),
                              subtitle: Text(_directoryPath ?? ''),
                            )
                          : _paths != null
                              ? Column(
                                  children: [
                                    Container(
                                      child: 'Data Preview'
                                          .text
                                          .xl2
                                          .bold
                                          .makeCentered(),
                                    ),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: DataTable(
                                        columns: const <DataColumn>[
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
                                    const SizedBox(
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
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: secondaryColor,
                                        ),
                                        onPressed: () async =>
                                            await _processBulkUpload(
                                                    productList)
                                                .then(
                                                  (value) => {
                                                    context.showToast(msg: "Bulk Import Successfully!"),
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
                                                    context.showToast(msg: "Failed to import!"),
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
                                        icon: const Icon(Icons.save,
                                            color: Colors.white),
                                        label: const Text(
                                          'Complete Bulk Import',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
            const AdBannerWidget(),
          ],
        ),
      ),
      bottomNavigationBar: const BulkActionScreen(currentIndex: 0),
    );
  }
}
