class LeaderBoardPOJO {
  String success;
  List<LeaderBoardList> leaderBoardList;

  LeaderBoardPOJO({this.success, this.leaderBoardList});

  LeaderBoardPOJO.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['leaderBoardList'] != null) {
      leaderBoardList = new List<LeaderBoardList>();
      json['leaderBoardList'].forEach((v) {
        leaderBoardList.add(new LeaderBoardList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.leaderBoardList != null) {
      data['leaderBoardList'] =
          this.leaderBoardList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LeaderBoardList {
  String id;
  String name;
  String designation;
  String userImg;
  String upDown;
  String userDate;
  String createdAt;

  LeaderBoardList(
      {this.id,
        this.name,
        this.designation,
        this.userImg,
        this.upDown,
        this.userDate,
        this.createdAt});

  LeaderBoardList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    designation = json['designation'];
    userImg = json['userImg'];
    upDown = json['upDown'];
    userDate = json['userDate'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['designation'] = this.designation;
    data['userImg'] = this.userImg;
    data['upDown'] = this.upDown;
    data['userDate'] = this.userDate;
    data['createdAt'] = this.createdAt;
    return data;
  }
}