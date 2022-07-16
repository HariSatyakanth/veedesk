class EventListPOJO {
  String success;
  List<EventsList> eventsList;
  List<FunList> funList;

  EventListPOJO({this.success, this.eventsList, this.funList});

  EventListPOJO.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['eventsList'] != null) {
      eventsList = new List<EventsList>();
      json['eventsList'].forEach((v) {
        eventsList.add(new EventsList.fromJson(v));
      });
    }
    if (json['funList'] != null) {
      funList = new List<FunList>();
      json['funList'].forEach((v) {
        funList.add(new FunList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.eventsList != null) {
      data['eventsList'] = this.eventsList.map((v) => v.toJson()).toList();
    }
    if (this.funList != null) {
      data['funList'] = this.funList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EventsList {
  String id;
  String userId;
  String title;
  String startDate;
  String endDate;
  String createdAt;

  EventsList(
      {this.id,
        this.userId,
        this.title,
        this.startDate,
        this.endDate,
        this.createdAt});

  EventsList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    title = json['title'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['title'] = this.title;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['createdAt'] = this.createdAt;
    return data;
  }
}

class FunList {
  String id;
  String userId;
  String name;
  String title;
  String description;
  String imgUrl;
  String funDate;
  String createdAt;

  FunList(
      {this.id,
        this.userId,
        this.name,
        this.title,
        this.description,
        this.imgUrl,
        this.funDate,
        this.createdAt});

  FunList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    name = json['name'];
    title = json['title'];
    description = json['description'];
    imgUrl = json['imgUrl'];
    funDate = json['funDate'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['name'] = this.name;
    data['title'] = this.title;
    data['description'] = this.description;
    data['imgUrl'] = this.imgUrl;
    data['funDate'] = this.funDate;
    data['createdAt'] = this.createdAt;
    return data;
  }
}