class Payload {
  String formId;
  String phone;
  String content;
  DateTime requestDate;
  String dataType;
  DateTime? fulfilledDate;
  String statusId;
  String title;
  dynamic footer;

  Payload({
    required this.formId,
    required this.phone,
    required this.content,
    required this.requestDate,
    required this.dataType,
    required this.fulfilledDate,
    required this.statusId,
    required this.title,
    required this.footer,
  });

  factory Payload.fromJson(Map<String, dynamic> json) {
    return Payload(
      formId: json['form_id'] ?? '0',
      phone: json['phone'] ?? '',
      content: json['content'] ?? '',
      requestDate:
          DateTime.parse(json['request_date'] ?? DateTime.now().toString()),
      dataType: json['data_type'] ?? '',
      fulfilledDate: json['fulfilled_date'] != null
          ? DateTime.parse(json['fulfilled_date'])
          : null,
      statusId: json['status_id'].toString(), // Ensure this is a string
      title: json['title'] ?? '',
      footer: json['footer'],
    );
  }
}
