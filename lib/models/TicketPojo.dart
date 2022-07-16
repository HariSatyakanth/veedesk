class TicketPojo {
  String success;
  List<MyTicketsList> myTicketsList;

  TicketPojo({this.success, this.myTicketsList});

  TicketPojo.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['myTicketsList'] != null) {
      myTicketsList = new List<MyTicketsList>();
      json['myTicketsList'].forEach((v) {
        myTicketsList.add(new MyTicketsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.myTicketsList != null) {
      data['myTicketsList'] =
          this.myTicketsList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MyTicketsList {
  String id;
  String userId;
  String clientId;
  String ticketTitle;
  String description;
  String ticketDate;
  String ticketTime;
  int status;
  int isEscalate;
  List<String> imagesUrl;
  String audioUrl;
  String fullName;

  MyTicketsList(
      {this.id,
        this.userId,
        this.clientId,
        this.ticketTitle,
        this.description,
        this.ticketDate,
        this.ticketTime,
        this.status,
        this.isEscalate,
        this.imagesUrl,
        this.audioUrl,
        this.fullName});

  MyTicketsList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    clientId = json['clientId'];
    ticketTitle = json['ticketTitle'];
    description = json['description'];
    ticketDate = json['ticketDate'];
    ticketTime = json['ticketTime'];
    status = json['status'];
    isEscalate = json['isEscalate'];
    imagesUrl = json['imagesUrl'].cast<String>();
    audioUrl = json['audioUrl'];
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
    data['status'] = this.status;
    data['isEscalate'] = this.isEscalate;
    data['imagesUrl'] = this.imagesUrl;
    data['audioUrl'] = this.audioUrl;
    data['Full_Name'] = this.fullName;
    return data;
  }
}
