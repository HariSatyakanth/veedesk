import 'package:flutter/cupertino.dart';

class AddNoteModel {
  String id;
  String name;
  String discription;
  String audioUrl;
  String time;
  String date;
  List<NetworkImage> images;
  bool visibliity;

  AddNoteModel({
    this.id,
    this.name,
    this.discription,
    this.audioUrl,
    this.time,
    this.date,
    this.images,
    this.visibliity
  });
}