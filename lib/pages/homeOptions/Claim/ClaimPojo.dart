//class ClaimPOJO {
//  String success;
//  List<ClaimList> list;
//
//  ClaimPOJO({this.success, this.list});
//
//  ClaimPOJO.fromJson(Map<String, dynamic> json) {
//    success = json['success'];
//    if (json['list'] != null) {
//      list = new List<ClaimList>();
//      json['list'].forEach((v) {
//        list.add(new ClaimList.fromJson(v));
//      });
//    }
//  }
//
//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['success'] = this.success;
//    if (this.list != null) {
//      data['list'] = this.list.map((v) => v.toJson()).toList();
//    }
//    return data;
//  }
//}
class ClaimPojo {
  String id;
  String userId;
  String claimId;
  String title;
  String amount;
  String imageUrl;
  String audioUrl;
  String description;
  String claimName;

  ClaimPojo(
      {this.id,
        this.userId,
        this.claimId,
        this.title,
        this.amount,
        this.imageUrl,
        this.audioUrl,
        this.description,
        this.claimName});

  ClaimPojo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    claimId = json['claimId'];
    title = json['title'];
    amount = json['amount'];
    imageUrl = json['imageUrl'];
    audioUrl = json['audioUrl'];
    description = json['description'];
    claimName = json['claimName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['claimId'] = this.claimId;
    data['title'] = this.title;
    data['amount'] = this.amount;
    data['imageUrl'] = this.imageUrl;
    data['audioUrl'] = this.audioUrl;
    data['description'] = this.description;
    data['claimName'] = this.claimName;
    return data;
  }
}