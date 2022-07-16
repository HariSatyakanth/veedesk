class ExpensePOJO {
  String success;
  List<ExpenseTrackerList> expenseTrackerList;

  ExpensePOJO({this.success, this.expenseTrackerList});

  ExpensePOJO.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['expenseTrackerList'] != null) {
      expenseTrackerList = new List<ExpenseTrackerList>();
      json['expenseTrackerList'].forEach((v) {
        expenseTrackerList.add(new ExpenseTrackerList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.expenseTrackerList != null) {
      data['expenseTrackerList'] =
          this.expenseTrackerList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ExpenseTrackerList {
  String id;
  String userId;
  String productType;
  String productName;
  String amount;
  String description;
  String dateTime;
  String timeDifference;

  ExpenseTrackerList(
      {this.id,
        this.userId,
        this.productType,
        this.productName,
        this.amount,
        this.description,
        this.dateTime,
        this.timeDifference});

  ExpenseTrackerList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    productType = json['productType'];
    productName = json['productName'];
    amount = json['amount'];
    description = json['description'];
    dateTime = json['date_time'];
    timeDifference = json['timeDifference'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['productType'] = this.productType;
    data['productName'] = this.productName;
    data['amount'] = this.amount;
    data['description'] = this.description;
    data['date_time'] = this.dateTime;
    data['timeDifference'] = this.timeDifference;
    return data;
  }
}
