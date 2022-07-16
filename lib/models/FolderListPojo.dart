class FolderListPojo {
  String success;
  List<FolderList> folderList;

  FolderListPojo({this.success, this.folderList});

  FolderListPojo.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['folderList'] != null) {
      folderList = new List<FolderList>();
      json['folderList'].forEach((v) {
        folderList.add(new FolderList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.folderList != null) {
      data['folderList'] = this.folderList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FolderList {
  String id;
  String userId;
  String folderName;
  String isVisible;
  String timestamp;
  String createdAt;

  FolderList(
      {this.id,
        this.userId,
        this.folderName,
        this.isVisible,
        this.timestamp,
        this.createdAt});

  FolderList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    folderName = json['folderName'];
    isVisible = json['isVisible'];
    timestamp = json['timestamp'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['folderName'] = this.folderName;
    data['isVisible'] = this.isVisible;
    data['timestamp'] = this.timestamp;
    data['createdAt'] = this.createdAt;
    return data;
  }
}