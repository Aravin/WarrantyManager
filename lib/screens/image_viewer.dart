import 'dart:io';

import 'package:flutter/material.dart';

class DisplayImage extends StatelessWidget {
  final String imagePath;
  final String imageName;

  const DisplayImage({super.key, required this.imagePath, required this.imageName});

  @override
  Widget build(BuildContext context) {
    print('epix - path $imagePath - $imageName');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          imageName,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 11,
            child: InteractiveViewer(
              child: Image.file(File(imagePath)),
            ),
          ),
          // Expanded(
          //   flex: 1,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: [
          //       ElevatedButton(
          //         style: ElevatedButton.styleFrom(
          //           primary: primaryColor,
          //         ),
          //         child: Text("Save to Gallery"),
          //         onPressed: () async {
          //           // saveBolbAsImage(this.imageBlob, this.imageName)
          //           //     .then(
          //           //       (value) => Toast.show(
          //           //         "Image Saved Successfully to Gallery!",
          //           //         context,
          //           //         duration: Toast.LENGTH_LONG,
          //           //         gravity: Toast.BOTTOM,
          //           //         backgroundColor: Colors.green,
          //           //       ),
          //           //     )
          //           //     .catchError(
          //           //       (onError) => {
          //           //         Toast.show(
          //           //           "Failed to Save Image to Gallery!",
          //           //           context,
          //           //           duration: Toast.LENGTH_LONG,
          //           //           gravity: Toast.BOTTOM,
          //           //           backgroundColor: Colors.red,
          //           //         )
          //           //       },
          //           //     );
          //         },
          //       ),
          //       ElevatedButton(
          //         style: ElevatedButton.styleFrom(
          //           primary: primaryColor,
          //         ),
          //         child: Text("Share"),
          //         onPressed: () async {
          //           // TODO: Replace with existing func
          //           final directory = await getApplicationDocumentsDirectory();
          //           String savePath =
          //               '${directory.path}/warranty_manager_${removeSpaceInText(this.imageName)}_${DateTime.now().millisecondsSinceEpoch}.jpg';
          //           File(savePath)
          //               .copy(
          //                 this.imagePath,
          //               )
          //               .then(
          //                 (value) => {
          //                   Share.shareFiles(
          //                     [
          //                       savePath,
          //                     ],
          //                     text: this.imageName,
          //                   ),
          //                 },
          //               );
          //         },
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
