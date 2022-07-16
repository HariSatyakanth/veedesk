import 'package:flutter/cupertino.dart';

class WorkLogModel {
  String id;
  String userId;
  String projectName;
  String initialTime;
  String finishTime;
  String title;
  List<NetworkImage> images;
  String description;
  String logDate;

  WorkLogModel(
      {this.id,
        this.userId,
        this.projectName,
        this.initialTime,
        this.finishTime,
        this.title,
        this.images,
        this.description,
        this.logDate}
        );
}