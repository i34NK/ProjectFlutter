class Payloads {
  String formId;
  String recipientPhone;
  String formName;
  String formDetail;
  String formType;
  String statusId;
  DateTime requestDate;
  DateTime? fulfilledDate;
  DateTime? cancelledDate;
  String recipientName;

  Payloads({
    required this.formId,
    required this.recipientPhone,
    required this.formName,
    required this.formDetail,
    required this.formType,
    required this.statusId,
    required this.requestDate,
    this.fulfilledDate,
    this.cancelledDate,
    required this.recipientName,
  });

  factory Payloads.fromJson(Map<String, dynamic> json) {
    return Payloads(
      formId: json['form_id'] ?? '0',
      recipientPhone: json['recipient_phone'] ?? '',
      formName: json['form_name'] ?? '',
      formDetail: json['form_detail'] ?? '',
      formType: json['form_type'] ?? '',
      statusId: json['status_id'] ?? '',
      requestDate: DateTime.parse(json['request_date'] ?? DateTime.now().toString()),
      fulfilledDate: json['fulfilled_date'] != null ? DateTime.parse(json['fulfilled_date']) : null,
      cancelledDate: json['cancelled_date'] != null ? DateTime.parse(json['cancelled_date']) : null,
      recipientName: json['recipient_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['form_id'] = this.formId;
    data['recipient_phone'] = this.recipientPhone;
    data['form_name'] = this.formName;
    data['form_detail'] = this.formDetail;
    data['form_type'] = this.formType;
    data['status_id'] = this.statusId;
    data['request_date'] = this.requestDate.toIso8601String();
    data['fulfilled_date'] = this.fulfilledDate?.toIso8601String();
    data['cancelled_date'] = this.cancelledDate?.toIso8601String();
    data['recipient_name'] = this.recipientName;
    return data;
  }
}
