import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

// imgFullPath can be name.jpg or path/name.jpg
Future<File> saveBolbAsImage(Uint8List bolb, String imgFullPath) async {
  final directory = await getApplicationDocumentsDirectory();
  String savePath = '';

  if (bolb == null) {
    throw ('Invalid Blob');
  }

  if (imgFullPath == null) {
    savePath =
        '${directory.path}/warranty_manager_${DateTime.now().millisecondsSinceEpoch}';
  } else {
    savePath = imgFullPath;
  }

  return File(savePath).writeAsBytes(bolb);
}

Future<String> saveBolbAsImagePath(Uint8List bolb) async {
  final directory = await getApplicationDocumentsDirectory();

  if (bolb == null) {
    return '';
  }

  new Directory('${directory.path}/products/').createSync(recursive: true);

  String img =
      '${directory.path}/products/${DateTime.now().millisecondsSinceEpoch}.jpg';
  saveBolbAsImage(bolb, img)
      .then((value) => print('epix - file saved'))
      .catchError((onError) => print('epix - file not saved $onError'));

  print('epix - image path - $img');
  return img;
}

// imgFullPath can be name.jpg or path/name.jpg
Future<File> saveFilebAsImage(File file, String imgFullPath) async {
  final directory = await getApplicationDocumentsDirectory();
  String savePath = '';

  if (file == null) {
    throw ('Invalid File');
  }

  if (imgFullPath == null) {
    savePath =
        '${directory.path}/warranty_manager_${DateTime.now().millisecondsSinceEpoch}.jpg';
  } else {
    savePath = imgFullPath;
  }

  return file.copy(savePath);
}

Future<String> saveFileAsImagePath(List<dynamic> file) async {
  final directory = await getApplicationDocumentsDirectory();

  if (file == null || file.isEmpty) {
    return '';
  }

  new Directory('${directory.path}/products/').createSync(recursive: true);

  String img =
      '${directory.path}/products/${DateTime.now().millisecondsSinceEpoch}.jpg';
  saveFilebAsImage(file[0], img)
      .then((value) => print('epix - file saved'))
      .catchError((onError) => print('epix - file not saved $onError'));

  print('epix - image path - $img');
  return img;
}
