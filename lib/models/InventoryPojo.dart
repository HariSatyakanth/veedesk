class InventoryPojo {
  String success;
  List<InventoryList> inventoryList;

  InventoryPojo({this.success, this.inventoryList});

  InventoryPojo.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['inventoryList'] != null) {
      inventoryList = new List<InventoryList>();
      json['inventoryList'].forEach((v) {
        inventoryList.add(new InventoryList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.inventoryList != null) {
      data['inventoryList'] =
          this.inventoryList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class InventoryList {
  String id;
  String userId;
  String categotyId;
  String categoryName;
  String itemName;
  String qty;
  String status;
  String imageUrl;
  String remark;
  String inventoryDate;
  String createAt;

  InventoryList(
      {this.id,
        this.userId,
        this.categotyId,
        this.categoryName,
        this.itemName,
        this.qty,
        this.status,
        this.imageUrl,
        this.remark,
        this.inventoryDate,
        this.createAt});

  InventoryList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    categotyId = json['categotyId'];
    categoryName = json['categoryName'];
    itemName = json['itemName'];
    qty = json['qty'];
    status = json['status'];
    imageUrl = json['imageUrl'];
    remark = json['remark'];
    inventoryDate = json['inventoryDate'];
    createAt = json['create_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['categotyId'] = this.categotyId;
    data['categoryName'] = this.categoryName;
    data['itemName'] = this.itemName;
    data['qty'] = this.qty;
    data['status'] = this.status;
    data['imageUrl'] = this.imageUrl;
    data['remark'] = this.remark;
    data['inventoryDate'] = this.inventoryDate;
    data['create_at'] = this.createAt;
    return data;
  }
}