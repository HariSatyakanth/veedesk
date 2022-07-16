import 'package:flutter/material.dart';
import 'package:newproject/Interfaces/callBackWidget.dart';

class LoadImage{

  void showPicker(BuildContext context,WidgetCallBack callBackInterface) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        callBackInterface.callBackInterface('Gallery');
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      callBackInterface.callBackInterface('Camera');
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

}