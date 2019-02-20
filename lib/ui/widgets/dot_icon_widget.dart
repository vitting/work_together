import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DotIcon extends StatelessWidget {
  final IconData icon;
  final EdgeInsetsGeometry margin;
  final String imagePath;
  final double size;
  final double iconSize;
  final Color backgroundColor;
  final Color iconColor;
  const DotIcon({Key key, this.icon, this.margin, this.imagePath, this.size = 80, this.iconSize = 35, this.backgroundColor, this.iconColor = Colors.white}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return icon != null ? Container(
      margin: margin,
      child: Icon(icon, color: iconColor, size: iconSize),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.blue[700], 
        shape: BoxShape.circle
      )
    ) : Container(
      margin: margin,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.blue[700], 
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(4),
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
