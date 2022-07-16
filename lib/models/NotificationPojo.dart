class NotificationPojo {
  String success;
  List<GetNotificationList> getNotificationList;

  NotificationPojo({this.success, this.getNotificationList});

  NotificationPojo.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['getNotificationList'] != null) {
      getNotificationList = new List<GetNotificationList>();
      json['getNotificationList'].forEach((v) {
        getNotificationList.add(new GetNotificationList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.getNotificationList != null) {
      data['getNotificationList'] =
          this.getNotificationList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetNotificationList {
  String id;
  String notificationId;
  String userId1;
  String userId2;
  String description;

  GetNotificationList(
      {this.id,
        this.notificationId,
        this.userId1,
        this.userId2,
        this.description});

  GetNotificationList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    notificationId = json['notificationId'];
    userId1 = json['userId1'];
    userId2 = json['userId2'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['notificationId'] = this.notificationId;
    data['userId1'] = this.userId1;
    data['userId2'] = this.userId2;
    data['description'] = this.description;
    return data;
  }
}
