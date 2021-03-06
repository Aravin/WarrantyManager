import 'dart:io';

import 'package:flutter/material.dart';
import 'package:warranty_manager/shared/contants.dart';
import 'package:warranty_manager/screens/image_viewer.dart';

class ProductImagePreview extends StatelessWidget {
  const ProductImagePreview({
    @required this.image,
    @required this.previewTitle,
    @required this.imageTitle,
  });

  final String image;
  final String previewTitle;
  final String imageTitle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 2.5),
          Text(
            this.previewTitle,
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 2.5),
          Image.file(
            File(this.image),
            height: 150,
            width: 150,
            alignment: Alignment.bottomLeft,
          ),
        ],
      ),
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctxt) => DisplayImage(
              imagePath: this.image,
              imageName: this.imageTitle,
            ),
          ),
        ),
      },
    );
  }
}
