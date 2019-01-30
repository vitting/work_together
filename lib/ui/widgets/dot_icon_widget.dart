import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DotIcon extends StatelessWidget {
  final IconData icon;
  final EdgeInsetsGeometry margin;
  final String imagePath;
  const DotIcon({Key key, this.icon, this.margin, this.imagePath}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return icon != null ? Container(
      margin: margin,
      child: Icon(icon, color: Colors.white, size: 35),
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.blue[700], 
        shape: BoxShape.circle
      )
    ) : Container(
      margin: margin,
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.blue[700], 
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: _getImage()
        )
      ),
    );
  }

  ImageProvider _getImage() {
    ImageProvider value;
    if (imagePath.toLowerCase().contains("http")) {
        value = CachedNetworkImageProvider(imagePath);
      } else {
        value = FileImage(File(imagePath));
      }

    return value;
  }
}
