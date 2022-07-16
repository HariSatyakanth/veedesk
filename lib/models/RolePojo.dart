class Role {
  String id;
  String role;

  Role({this.id, this.role});

  Role.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    role = json['Role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Role'] = this.role;
    return data;
  }
}