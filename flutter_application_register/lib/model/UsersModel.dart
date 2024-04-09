class UsersModel {
  int? status;
  String? message;
  Payload? payload;
  String? token;
  String? userId; // เพิ่มฟิลด์ userId

  UsersModel({this.status, this.message, this.payload, this.token, this.userId}); // รับค่า userId ผ่านคอนสตรักเตอร์

  UsersModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    payload =
        json['payload'] != null ? new Payload.fromJson(json['payload']) : null;
    token = json['token'];
    userId = json['user_id']; // รับค่า userId จาก JSON
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.payload != null) {
      data['payload'] = this.payload!.toJson();
    }
    data['token'] = this.token;
    data['user_id'] = this.userId; // ส่งค่า userId ไปใน JSON
    return data;
  }
}


class Payload {
  String? fname;
  String? lname;
  String? fullname;
  String? company;
  String? phone;
  String? email;
  String? userId; // เพิ่มฟิลด์ userId

  Payload({
    this.fname,
    this.lname,
    this.fullname,
    this.company,
    this.phone,
    this.email,
    this.userId, // เพิ่มฟิลด์ userId
  });

  Payload.fromJson(Map<String, dynamic> json) {
    fname = json['fname'];
    lname = json['lname'];
    fullname = json['fullname'];
    company = json['company'];
    phone = json['phone'];
    email = json['email'];
    userId = json['user_id']; // รับค่า userId จาก JSON
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fname'] = this.fname;
    data['lname'] = this.lname;
    data['fullname'] = this.fullname;
    data['company'] = this.company;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['user_id'] = this.userId; // ส่งค่า userId ไปใน JSON
    return data;
  }
}

