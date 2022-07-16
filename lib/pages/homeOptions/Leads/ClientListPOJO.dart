class ClientListPOJO {
  String success;
  List<GetClietnsList> getClietnsList;

  ClientListPOJO({this.success, this.getClietnsList});

  ClientListPOJO.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['getClietnsList'] != String) {
      getClietnsList = new List<GetClietnsList>();
      json['getClietnsList'].forEach((v) {
        getClietnsList.add(new GetClietnsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.getClietnsList != String) {
      data['getClietnsList'] =
          this.getClietnsList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetClietnsList {
  String id;
  String clientName;
  String clientContact;
  String clientWhatsapp;
  String clientEmail;
  String address;
  String remarks;
  String status;
  String country;
  String company;

  GetClietnsList(
      {this.id,
        this.clientName,
        this.clientContact,
        this.clientWhatsapp,
        this.clientEmail,
        this.address,
        this.remarks,
        this.status,
        this.country,
        this.company});

  GetClietnsList.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    clientName = json['Client_Name'];
    clientContact = json['Client_Contact'];
    clientWhatsapp = json['Client_Whatsapp'];
    clientEmail = json['Client_Email'];
    address = json['Address'];
    remarks = json['Remarks'];
    status = json['Status'];
    country = json['Country'];
    company = json['company'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Client_Name'] = this.clientName;
    data['Client_Contact'] = this.clientContact;
    data['Client_Whatsapp'] = this.clientWhatsapp;
    data['Client_Email'] = this.clientEmail;
    data['Address'] = this.address;
    data['Remarks'] = this.remarks;
    data['Status'] = this.status;
    data['Country'] = this.country;
    data['company'] = this.company;
    return data;
  }
}
