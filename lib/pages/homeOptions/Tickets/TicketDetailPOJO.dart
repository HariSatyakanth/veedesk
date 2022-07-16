class TicketDetailsPOJO {
  String success;
  List<MyTicketascaleteDetails> myTicketascaleteDetails;
  List<Followuptickek> followuptickek;

  TicketDetailsPOJO(
      {this.success, this.myTicketascaleteDetails, this.followuptickek});

  TicketDetailsPOJO.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['myTicketascaleteDetails'] != null) {
      myTicketascaleteDetails = new List<MyTicketascaleteDetails>();
      json['myTicketascaleteDetails'].forEach((v) {
        myTicketascaleteDetails.add(new MyTicketascaleteDetails.fromJson(v));
      });
    }
    if (json['followuptickek'] != null) {
      followuptickek = new List<Followuptickek>();
      json['followuptickek'].forEach((v) {
        followuptickek.add(new Followuptickek.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.myTicketascaleteDetails != null) {
      data['myTicketascaleteDetails'] =
          this.myTicketascaleteDetails.map((v) => v.toJson()).toList();
    }
    if (this.followuptickek != null) {
      data['followuptickek'] =
          this.followuptickek.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MyTicketascaleteDetails {
  String id;
  String userId;
  String clientId;
  String ticketTitle;
  String description;
  String ticketDate;
  String ticketTime;
  String clientName;
  String status;
  String isEscalate;
  String imagesUrl;
  String audioUrl;
  String createdAt;
  String ticketascaleteDate;
  String hold;
  String fullName;

  MyTicketascaleteDetails(
      {this.id,
        this.userId,
        this.clientId,
        this.ticketTitle,
        this.description,
        this.ticketDate,
        this.ticketTime,
        this.clientName,
        this.status,
        this.isEscalate,
        this.imagesUrl,
        this.audioUrl,
        this.createdAt,
        this.ticketascaleteDate,
        this.hold,
        this.fullName});

  MyTicketascaleteDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    clientId = json['clientId'];
    ticketTitle = json['ticketTitle'];
    description = json['description'];
    ticketDate = json['ticketDate'];
    ticketTime = json['ticketTime'];
    clientName = json['clientName'];
    status = json['status'];
    isEscalate = json['isEscalate'];
    imagesUrl = json['imagesUrl'];
    audioUrl = json['audioUrl'];
    createdAt = json['createdAt'];
    ticketascaleteDate = json['ticketascaleteDate'];
    hold = json['hold'];
    fullName = json['Full_Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['clientId'] = this.clientId;
    data['ticketTitle'] = this.ticketTitle;
    data['description'] = this.description;
    data['ticketDate'] = this.ticketDate;
    data['ticketTime'] = this.ticketTime;
    data['clientName'] = this.clientName;
    data['status'] = this.status;
    data['isEscalate'] = this.isEscalate;
    data['imagesUrl'] = this.imagesUrl;
    data['audioUrl'] = this.audioUrl;
    data['createdAt'] = this.createdAt;
    data['ticketascaleteDate'] = this.ticketascaleteDate;
    data['hold'] = this.hold;
    data['Full_Name'] = this.fullName;
    return data;
  }
}

class Followuptickek {
  String id;
  String userId;
  String ticketId;
  String title;
  String description;
  String followImage;
  String status;
  String createdAt;

  Followuptickek(
      {this.id,
        this.userId,
        this.ticketId,
        this.title,
        this.description,
        this.followImage,
        this.status,
        this.createdAt});

  Followuptickek.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    ticketId = json['ticketId'];
    title = json['title'];
    description = json['description'];
    followImage = json['followImage'];
    status = json['status'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['ticketId'] = this.ticketId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['followImage'] = this.followImage;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    return data;
  }
}