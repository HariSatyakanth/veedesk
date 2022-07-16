class QueryDetailsPojo {
  String id;
  String queryTo;
  String queryBy;
  String title;
  String description;
  String status;
  String sevirity;
  String queryDateTime;
  String imagesUrl;
  String audioUrl;
  List<FollowupQuery> followupQuery;
  int success;

  QueryDetailsPojo(
      {this.id,
        this.queryTo,
        this.queryBy,
        this.title,
        this.description,
        this.status,
        this.sevirity,
        this.queryDateTime,
        this.imagesUrl,
        this.audioUrl,
        this.followupQuery,
        this.success});

  QueryDetailsPojo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    queryTo = json['query_to'];
    queryBy = json['query_by'];
    title = json['title'];
    description = json['description'];
    status = json['status'];
    sevirity = json['sevirity'];
    queryDateTime = json['queryDateTime'];
    imagesUrl = json['imagesUrl'];
    audioUrl = json['audioUrl'];
    if (json['followup_query'] != null) {
      followupQuery = new List<FollowupQuery>();
      json['followup_query'].forEach((v) {
        followupQuery.add(new FollowupQuery.fromJson(v));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['query_to'] = this.queryTo;
    data['query_by'] = this.queryBy;
    data['title'] = this.title;
    data['description'] = this.description;
    data['status'] = this.status;
    data['sevirity'] = this.sevirity;
    data['queryDateTime'] = this.queryDateTime;
    data['imagesUrl'] = this.imagesUrl;
    data['audioUrl'] = this.audioUrl;
    if (this.followupQuery != null) {
      data['followup_query'] =
          this.followupQuery.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    return data;
  }
}

class FollowupQuery {
  String id;
  String queryId;
  String followupTitle;
  String followupDate;
  String followupBy;
  String imagesUrl;
  String audioUrl;
  String status;
  String description;
  String createAt;

  FollowupQuery(
      {this.id,
        this.queryId,
        this.followupTitle,
        this.followupDate,
        this.followupBy,
        this.imagesUrl,
        this.audioUrl,
        this.status,
        this.description,
        this.createAt});

  FollowupQuery.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    queryId = json['queryId'];
    followupTitle = json['followupTitle'];
    followupDate = json['followup_date'];
    followupBy = json['followup_by'];
    imagesUrl = json['imagesUrl'];
    audioUrl = json['audioUrl'];
    status = json['Status'];
    description = json['Description'];
    createAt = json['createAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['queryId'] = this.queryId;
    data['followupTitle'] = this.followupTitle;
    data['followup_date'] = this.followupDate;
    data['followup_by'] = this.followupBy;
    data['imagesUrl'] = this.imagesUrl;
    data['audioUrl'] = this.audioUrl;
    data['Status'] = this.status;
    data['Description'] = this.description;
    data['createAt'] = this.createAt;
    return data;
  }
}
