import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SquareThumbImage extends StatelessWidget {
  final Color textColor;
  final String imageUrl;
  final double size;

  const SquareThumbImage({Key key, this.textColor, this.imageUrl, this.size = 40}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorWidget: Icon(Icons.image, size: 40, color: textColor),
          placeholder: Icon(Icons.image, size: 40, color: textColor),
        ),
      );
  }
}