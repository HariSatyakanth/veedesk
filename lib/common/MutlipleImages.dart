import 'package:flutter/material.dart';
import 'package:newproject/Utiles/constants.dart';
class MultipleImages extends StatelessWidget {
  MultipleImages();
  @override
  Widget build(BuildContext context) {
    var arr = [Constants.ImageBaseUrl+"img_1606240537.jpg",Constants.ImageBaseUrl+"img_1606240680.jpg",Constants.ImageBaseUrl+"img_1606240537.jpg"];
    return ListView.builder(
      itemCount: arr.length,
      itemBuilder: (context, index) {
        return Image.network(arr[index]);
      },
    );
  }
}
