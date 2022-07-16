class GetFileListPOJO {
  String success;
  List<FileList> fileList;

  GetFileListPOJO({this.success, this.fileList});

  GetFileListPOJO.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['fileList'] != null) {
      fileList = new List<FileList>();
      json['fileList'].forEach((v) {
        fileList.add(new FileList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.fileList != null) {
      data['fileList'] = this.fileList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FileList {
  String id;
  String userId;
  String folderId;
  String fileName;
  String timestamp;
  String url;
  String type;
  String createdAt;

  FileList(
      {this.id,
        this.userId,
        this.folderId,
        this.fileName,
        this.timestamp,
        this.url,
        this.type,
        this.createdAt});

  FileList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    folderId = json['folderId'];
    fileName = json['fileName'];
    timestamp = json['timestamp'];
    url = json['url'];
    type = json['type'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['folderId'] = this.folderId;
    data['fileName'] = this.fileName;
    data['timestamp'] = this.timestamp;
    data['url'] = this.url;
    data['type'] = this.type;
    data['createdAt'] = this.createdAt;
    return data;
  }
}