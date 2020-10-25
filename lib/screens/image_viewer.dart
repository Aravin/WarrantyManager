import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:toast/toast.dart';
import 'package:warranty_manager/contants.dart';
import 'package:warranty_manager/shared/remove_space_in_string.dart';

class DisplayImage extends StatelessWidget {
  final Uint8List imageBlob;
  final String imageName;

  DisplayImage({this.imageBlob, this.imageName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        textTheme: TextTheme(),
        title: Text(
          imageName ?? 'Image Viewer',
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 11,
            child: Center(
              child: Image.memory(this.imageBlob),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  color: primaryColor,
                  textColor: Colors.white,
                  child: Text("Save to Gallery"),
                  onPressed: () async {
                    final directory = await getApplicationDocumentsDirectory();
                    String savePath =
                        '${directory.path}/warranty_manager_${removeSpaceInText(this.imageName)}_${DateTime.now().millisecondsSinceEpoch}';
                    File(savePath)
                        .writeAsBytes(this.imageBlob)
                        .then(
                          (value) => Toast.show(
                            "Image Saved Successfully to Gallery!",
                            context,
                            duration: Toast.LENGTH_LONG,
                            gravity: Toast.BOTTOM,
                            backgroundColor: Colors.green,
                          ),
                        )
                        .catchError(
                          (onError) => {
                            Toast.show(
                              "Failed to Save Image to Gallery!",
                              context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.BOTTOM,
                              backgroundColor: Colors.red,
                            )
                          },
                        );
                  },
                ),
                RaisedButton(
                  color: primaryColor,
                  textColor: Colors.white,
                  child: Text("Share"),
                  onPressed: () async {
                    final directory = await getApplicationDocumentsDirectory();
                    String savePath =
                        '${directory.path}/warranty_manager_${removeSpaceInText(this.imageName)}_${DateTime.now().millisecondsSinceEpoch}.jpg';
                    File(savePath)
                        .writeAsBytes(
                          this.imageBlob,
                        )
                        .then(
                          (value) => {
                            Share.shareFiles(
                              [
                                savePath,
                              ],
                              text: this.imageName,
                            ),
                          },
                        );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
