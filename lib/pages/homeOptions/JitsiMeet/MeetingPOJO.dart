class MeetingPOJO {
  String success;
  List<GetMeetingList> getMeetingList;

  MeetingPOJO({this.success, this.getMeetingList});

  MeetingPOJO.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['getMeetingList'] != null) {
      getMeetingList = new List<GetMeetingList>();
      json['getMeetingList'].forEach((v) {
        getMeetingList.add(new GetMeetingList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.getMeetingList != null) {
      data['getMeetingList'] =
          this.getMeetingList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetMeetingList {
  String id;
  String meetingName;
  String meetingDes;
  String banerImg;
  String dateTime;
  String status;
  String startDate;
  String startTime;
  String endDate;
  String endTime;

  GetMeetingList(
      {this.id,
        this.meetingName,
        this.meetingDes,
        this.banerImg,
        this.dateTime,
        this.status,
        this.startDate,
        this.startTime,
        this.endDate,
        this.endTime});

  GetMeetingList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    meetingName = json['meeting_name'];
    meetingDes = json['meeting_des'];
    banerImg = json['baner_img'];
    dateTime = json['dateTime'];
    status = json['status'];
    startDate = json['start_date'];
    startTime = json['start_time'];
    endDate = json['end_date'];
    endTime = json['end_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['meeting_name'] = this.meetingName;
    data['meeting_des'] = this.meetingDes;
    data['baner_img'] = this.banerImg;
    data['dateTime'] = this.dateTime;
    data['status'] = this.status;
    data['start_date'] = this.startDate;
    data['start_time'] = this.startTime;
    data['end_date'] = this.endDate;
    data['end_time'] = this.endTime;
    return data;
  }
}
