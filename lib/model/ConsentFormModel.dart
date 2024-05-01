class Payload {
    int formId;
    String phone;
    String notes;
    DateTime requestDate;
    String dataType;
    DateTime? fulfilledDate;
    String statusId;
    String title;
    dynamic footer;


    Payload({
        required this.formId,
        required this.phone,
        required this.notes,
        required this.requestDate,
        required this.dataType,
        required this.fulfilledDate,
        required this.statusId,
        required this.title,
        required this.footer,
    });

    factory Payload.fromJson(Map<String, dynamic> json) {
      return Payload(
        formId: json['form_id'] ?? 0,
        phone: json['phone'] ?? '',
        notes: json['notes'] ?? '',
        requestDate: DateTime.parse(json['request_date'] ?? ''),
        dataType: json['data_type'] ?? '',
        fulfilledDate: json['fulfilled_date'] != null ? DateTime.parse(json['fulfilled_date']) : null,
        statusId: json['status_id'] ?? '',
        title: json['title'] ?? '',
        footer: json['footer'],
      );
    }
}
