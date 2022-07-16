class TasksDetailPOJO {
  String id;
  String task;
  String assignedTo;
  String currentStatus;
  String sevirity;
  String attachment;
  String assignedBy;
  String assignedTime;
  String eTC;
  String remarks;
  String targetTime;
  String aging;
  String due;
  String company;
  String description;
  String imageUpload;
  String audioUpload;
  String asingName;
  String asingImage;
  String progress;

  List<FollowupTask> followupTask;
  int success;

  TasksDetailPOJO(
      {this.id,
        this.task,
        this.assignedTo,
        this.currentStatus,
        this.sevirity,
        this.attachment,
        this.assignedBy,
        this.assignedTime,
        this.eTC,
        this.remarks,
        this.targetTime,
        this.aging,
        this.due,
        this.company,
        this.description,
        this.imageUpload,
        this.audioUpload,
        this.asingName,
        this.progress,
        this.asingImage,

        this.followupTask,
        this.success});

  TasksDetailPOJO.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    task = json['Task'];
    assignedTo = json['Assigned_To'];
    currentStatus = json['Current_Status'];
    sevirity = json['Sevirity'];
    attachment = json['Attachment'];
    assignedBy = json['Assigned_By'];
    assignedTime = json['Assigned_Time'];
    eTC = json['ETC'];
    remarks = json['Remarks'];
    targetTime = json['Target_Time'];
    aging = json['Aging'];
    due = json['Due'];
    company = json['company'];
    description = json['description'];
    imageUpload = json['imageUpload'];
    audioUpload = json['audioUpload'];
    asingName = json['asingName'];
    asingImage = json['asingImage'];
    progress = json['progress'];
    if (json['followup_task'] != null) {
      followupTask = new List<FollowupTask>();
      json['followup_task'].forEach((v) {
        followupTask.add(new FollowupTask.fromJson(v));
      });
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Task'] = this.task;
    data['Assigned_To'] = this.assignedTo;
    data['Current_Status'] = this.currentStatus;
    data['Sevirity'] = this.sevirity;
    data['Attachment'] = this.attachment;
    data['Assigned_By'] = this.assignedBy;
    data['Assigned_Time'] = this.assignedTime;
    data['ETC'] = this.eTC;
    data['Remarks'] = this.remarks;
    data['Target_Time'] = this.targetTime;
    data['Aging'] = this.aging;
    data['Due'] = this.due;
    data['company'] = this.company;
    data['description'] = this.description;
    data['imageUpload'] = this.imageUpload;
    data['audioUpload'] = this.audioUpload;
    data['asingName'] = this.asingName;
    data['asingImage'] = this.asingImage;
    data['progress'] = this.progress;
    if (this.followupTask != null) {
      data['followup_task'] = this.followupTask.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    return data;
  }
}

class FollowupTask {
  String id;
  String taskNumber;
  String title;
  String followupTime;
  String attachment;
  String audioUrl;
  String status;
  String followupBy;
  String Followup_Time;
  String description;
  String createAt;

  FollowupTask(
      {this.id,
        this.taskNumber,
        this.title,
        this.followupTime,
        this.Followup_Time,
        this.attachment,
        this.audioUrl,
        this.status,
        this.followupBy,
        this.description,
        this.createAt});

  FollowupTask.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    taskNumber = json['task_number'];
    title = json['title'];
    followupTime = json['Followup_Time'];
    attachment = json['Attachment'];
    audioUrl = json['audioUrl'];
    status = json['Status'];
    followupBy = json['Followup_By'];
    description = json['Description'];
    createAt = json['createAt'];
    Followup_Time = json['Followup_Time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['task_number'] = this.taskNumber;
    data['title'] = this.title;
    data['Followup_Time'] = this.followupTime;
    data['Attachment'] = this.attachment;
    data['audioUrl'] = this.audioUrl;
    data['Status'] = this.status;
    data['Followup_By'] = this.followupBy;
    data['Description'] = this.description;
    data['createAt'] = this.createAt;
    data['Followup_Time'] = this.Followup_Time;
    return data;
  }
}