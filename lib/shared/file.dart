import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

// imgFullPath can be name.jpg or path/name.jpg
Future<File> saveBolbAsImage(Uint8List bolb, String imgFullPath) async {
  return File(imgFullPath).writeAsBytes(bolb);
}

Future<String> saveBolbAsImagePath(Uint8List bolb) async {
  final directory = await getApplicationDocumentsDirectory();

  Directory('${directory.path}/products/').createSync(recursive: true);

  final String img =
      '${directory.path}/products/${DateTime.now().millisecondsSinceEpoch}.jpg';
  saveBolbAsImage(bolb, img)
      .then((value) => print('epix - file saved'))
      .catchError((onError) => print('epix - file not saved $onError'));

  print('epix - image path - $img');
  return img;
}

// imgFullPath can be name.jpg or path/name.jpg
Future<File> saveFilebAsImage(File file, String imgFullPath) async {
  return file.copy(imgFullPath);
}

Future<String> saveFileAsImagePath(List<dynamic> file) async {
  final directory = await getApplicationDocumentsDirectory();

  if (file.isEmpty) {
    return '';
  }

  Directory('${directory.path}/products/').createSync(recursive: true);

  final String img =
      '${directory.path}/products/${DateTime.now().millisecondsSinceEpoch}.jpg';
  saveFilebAsImage(file[0], img)
      .then((value) => print('epix - file saved'))
      .catchError((onError) => print('epix - file not saved $onError'));

  print('epix - image path - $img');
  return img;
}
