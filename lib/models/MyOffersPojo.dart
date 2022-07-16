class MyoffersPojo {
  String success;
  List<MyoffersList> myoffersList;

  MyoffersPojo({this.success, this.myoffersList});

  MyoffersPojo.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['myoffersList'] != null) {
      myoffersList = new List<MyoffersList>();
      json['myoffersList'].forEach((v) {
        myoffersList.add(new MyoffersList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.myoffersList != null) {
      data['myoffersList'] = this.myoffersList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MyoffersList {
  String id;
  String userId;
  String offerName;
  String cupponCode;
  String cupponDate;
  String cupponSite;
  String cupponImage;
  String cupponStatus;
  String createdAt;

  MyoffersList(
      {this.id,
        this.userId,
        this.offerName,
        this.cupponCode,
        this.cupponDate,
        this.cupponSite,
        this.cupponImage,
        this.cupponStatus,
        this.createdAt});

  MyoffersList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    offerName = json['offerName'];
    cupponCode = json['cupponCode'];
    cupponDate = json['cupponDate'];
    cupponSite = json['cupponSite'];
    cupponImage = json['cupponImage'];
    cupponStatus = json['cupponStatus'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['offerName'] = this.offerName;
    data['cupponCode'] = this.cupponCode;
    data['cupponDate'] = this.cupponDate;
    data['cupponSite'] = this.cupponSite;
    data['cupponImage'] = this.cupponImage;
    data['cupponStatus'] = this.cupponStatus;
    data['createdAt'] = this.createdAt;
    return data;
  }
}