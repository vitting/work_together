import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ProjectDetailFileImageViewer extends StatelessWidget {
  final String url;

  const ProjectDetailFileImageViewer({Key key, this.url}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: PhotoView(
        enableRotation: true,
        imageProvider: CachedNetworkImageProvider(url),
      ),
    );
  }
}
