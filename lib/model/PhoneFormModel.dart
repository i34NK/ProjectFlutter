class Json {
  int? status;
  String? message;
  List<Payload>? payload;

  Json({this.status, this.message, this.payload});

  Json.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['payload'] != null) {
      payload = <Payload>[];
      json['payload'].forEach((v) {
        payload!.add(new Payload.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.payload != null) {
      data['payload'] = this.payload!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Payload {
  String? formId;
  String? phone;
  String? title;
  String? content;
  String? footer;
  String? dataType;
  String? statusId;
  String? requestDate;
  Null? fulfilledDate;
  Null? cancelledDate;

  Payload(
      {this.formId,
      this.phone,
      this.title,
      this.content,
      this.footer,
      this.dataType,
      this.statusId,
      this.requestDate,
      this.fulfilledDate,
      this.cancelledDate});

  Payload.fromJson(Map<String, dynamic> json) {
    formId = json['form_id'];
    phone = json['phone'];
    title = json['title'];
    content = json['content'];
    footer = json['footer'];
    dataType = json['data_type'];
    statusId = json['status_id'];
    requestDate = json['request_date'];
    fulfilledDate = json['fulfilled_date'];
    cancelledDate = json['cancelled_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['form_id'] = this.formId;
    data['phone'] = this.phone;
    data['title'] = this.title;
    data['content'] = this.content;
    data['footer'] = this.footer;
    data['data_type'] = this.dataType;
    data['status_id'] = this.statusId;
    data['request_date'] = this.requestDate;
    data['fulfilled_date'] = this.fulfilledDate;
    data['cancelled_date'] = this.cancelledDate;
    return data;
  }
}
