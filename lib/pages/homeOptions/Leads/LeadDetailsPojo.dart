class LeadDetailsPojo {
  String id;
  String projectName;
  String client;
  String status;
  String estimateValue;
  String estimateTimeline;
  String proposal;
  String quotation;
  String reamrks;
  String description;
  List<String> imageUpload;
  String audioUpload;
  String clientName;
  String clientContact;
  String clientWhatsapp;
  String clientEmail;
  String address;
  String remarks;
  String clientStatus;
  String country;
  String companyName;
  String compnayCode;
  String compnayLogo;
  String companyAddress;
  String companyContact;
  String companyEmail;
  String companyWebsite;
  List<FollowupLeads> followupLeads;
  int success;

  LeadDetailsPojo(
      {this.id,
        this.projectName,
        this.client,
        this.status,
        this.estimateValue,
        this.estimateTimeline,
        this.proposal,
        this.quotation,
        this.reamrks,
        this.description,
        this.imageUpload,
        this.audioUpload,
        this.clientName,
        this.clientContact,
        this.clientWhatsapp,
        this.clientEmail,
        this.address,
        this.remarks,
        this.clientStatus,
        this.country,
        this.companyName,
        this.compnayCode,
        this.compnayLogo,
        this.companyAddress,
        this.companyContact,
        this.companyEmail,
        this.companyWebsite,
        this.followupLeads,
        this.success});

  LeadDetailsPojo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    projectName = json['Project_Name'];
    client = json['Client'];
    status = json['Status'];
    estimateValue = json['Estimate_Value'];
    estimateTimeline = json['Estimate_Timeline'];
    proposal = json['Proposal'];
    quotation = json['Quotation'];
    reamrks = json['Reamrks'];
    description = json['description'];
    imageUpload = json['imageUpload'].cast<String>();
    audioUpload = json['audioUpload'];
    clientName = json['Client_Name'];
    clientContact = json['Client_Contact'];
    clientWhatsapp = json['Client_Whatsapp'];
    clientEmail = json['Client_Email'];
    address = json['Address'];
    remarks = json['Remarks'];
    clientStatus = json['clientStatus'];
    country = json['Country'];
    companyName = json['company_name'];
    compnayCode = json['compnay_code'];
    compnayLogo = json['Compnay_logo'];
    companyAddress = json['Company_address'];
    companyContact = json['Company_contact'];
    companyEmail = json['Company_email'];
    companyWebsite = json['Company_Website'];
    if (json['followup_leads'] != String) {
      followupLeads = new List<FollowupLeads>();
      json['followup_leads'].forEach((v) {
        followupLeads.add(new FollowupLeads.fromJson(v));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Project_Name'] = this.projectName;
    data['Client'] = this.client;
    data['Status'] = this.status;
    data['Estimate_Value'] = this.estimateValue;
    data['Estimate_Timeline'] = this.estimateTimeline;
    data['Proposal'] = this.proposal;
    data['Quotation'] = this.quotation;
    data['Reamrks'] = this.reamrks;
    data['description'] = this.description;
    data['imageUpload'] = this.imageUpload;
    data['audioUpload'] = this.audioUpload;
    data['Client_Name'] = this.clientName;
    data['Client_Contact'] = this.clientContact;
    data['Client_Whatsapp'] = this.clientWhatsapp;
    data['Client_Email'] = this.clientEmail;
    data['Address'] = this.address;
    data['Remarks'] = this.remarks;
    data['clientStatus'] = this.clientStatus;
    data['Country'] = this.country;
    data['company_name'] = this.companyName;
    data['compnay_code'] = this.compnayCode;
    data['Compnay_logo'] = this.compnayLogo;
    data['Company_address'] = this.companyAddress;
    data['Company_contact'] = this.companyContact;
    data['Company_email'] = this.companyEmail;
    data['Company_Website'] = this.companyWebsite;
    if (this.followupLeads != String) {
      data['followup_leads'] =
          this.followupLeads.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    return data;
  }
}

class FollowupLeads {
  String id;
  String projectId;
  String followupDate;
  String followupText;
  String attachment;
  String status;
  String audioUrl;
  String followupBy;
  String description;

  FollowupLeads(
      {this.id,
        this.projectId,
        this.followupDate,
        this.followupText,
        this.attachment,
        this.status,
        this.audioUrl,
        this.followupBy,
        this.description});

  FollowupLeads.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    projectId = json['Project_Id'];
    followupDate = json['Followup_Date'];
    followupText = json['Followup_Text'];
    attachment = json['Attachment'];
    status = json['Status'];
    audioUrl = json['audioUrl'];
    followupBy = json['Followup_by'];
    description = json['Description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Project_Id'] = this.projectId;
    data['Followup_Date'] = this.followupDate;
    data['Followup_Text'] = this.followupText;
    data['Attachment'] = this.attachment;
    data['Status'] = this.status;
    data['audioUrl'] = this.audioUrl;
    data['Followup_by'] = this.followupBy;
    data['Description'] = this.description;
    return data;
  }
}
