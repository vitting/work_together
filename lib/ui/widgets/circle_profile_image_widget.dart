import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

enum CircleProfileImageType { url, asset, file, none }

class CircleProfileImage extends StatelessWidget {
  final ValueChanged<bool> onTap;
  /// Can be a String or a File object
  final dynamic image;
  final double size;
  final CircleProfileImageType type;
  final IconData icon;
  final double iconSize;
  final Color iconColor;
  final BoxFit fit;
  final Color backgroundColor;
  final String tooltip;
  final double borderWidth;
  final Color borderColor;

  const CircleProfileImage(
      {Key key,
      this.onTap,
      this.image = "",
      this.size = 40,
      @required this.type,
      this.icon,
      this.iconColor = Colors.black,
      this.iconSize = 14,
      this.fit = BoxFit.cover,
      this.backgroundColor = Colors.blue,
      this.tooltip = "", this.borderWidth = 0, this.borderColor = Colors.black})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    Widget value = _button();
    if (tooltip.isNotEmpty) {
      value = Tooltip(
        message: tooltip,
        child: _button(),
      );
    }
    return value;
  }

  Widget _button() {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap(true);
        }
      },
      child: Stack(
        children: <Widget>[
          Container(
            width: size,
            height: size,
            decoration:
                BoxDecoration(
                  color: backgroundColor, 
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: borderColor,
                    width: borderWidth
                  )
                  ),
            child: type != CircleProfileImageType.none ? ClipOval(
              child: type == CircleProfileImageType.asset
                  ? Image.asset(
                      image,
                      fit: fit,
                      width: size,
                      height: size,
                    )
                  : type == CircleProfileImageType.url ? CachedNetworkImage(
                      imageUrl: image,
                      fit: fit,
                      width: size,
                      height: size,
                    ) : Image.file(
                      image,
                      fit: fit,
                      width: size,
                      height: size,
                      ),
            ) : null,
          ),
          icon != null
              ? Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Icon(icon, size: iconSize, color: iconColor),
                )
              : Container()
        ],
      ),
    );
  }
}
