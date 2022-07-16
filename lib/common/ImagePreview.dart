import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImagePreview extends StatelessWidget {
  String imgUrl;
  String name;

  ImagePreview(this.imgUrl,this.name );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(name),
        ),
        body: Container(
            child: PhotoView(
          imageProvider: NetworkImage(imgUrl),
        )));
  }
}
