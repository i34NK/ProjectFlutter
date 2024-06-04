class FormModel {
    Payload payload;

    FormModel({
        required this.payload,
    });

    static FormModel fromJson(Map<String, dynamic> jsonData) {
        return FormModel(
            payload: Payload.fromJson(jsonData['payload']),
        );
    }
}

class Payload {
    Dashboard dashboard;
    List<ConsentForm> forms;

    Payload({
        required this.dashboard,
        required this.forms,
    });

    static Payload fromJson(Map<String, dynamic> jsonData) {
        return Payload(
            dashboard: Dashboard.fromJson(jsonData['dashboard']),
            forms: (jsonData['forms'] as List)
                .map((form) => ConsentForm.fromJson(form))
                .toList(),
        );
    }
}

class Dashboard {
    String totalForms;
    String pendingApproval;
    String approvedForms;
    String expiredOrCancelled;

    Dashboard({
        required this.totalForms,
        required this.pendingApproval,
        required this.approvedForms,
        required this.expiredOrCancelled,
    });

    static Dashboard fromJson(Map<String, dynamic> jsonData) {
        return Dashboard(
            totalForms: jsonData['totalForms'],
            pendingApproval: jsonData['pendingApproval'],
            approvedForms: jsonData['approvedForms'],
            expiredOrCancelled: jsonData['expiredOrCancelled'],
        );
    }
}

class ConsentForm  {
    String formId;
    String recipientPhone;
    String recipientName;
    String formName;
    String formDetail;
    String statusId;
    String statusName;
    DateTime requestDate;
    DateTime startDate;
    DateTime endDate;
    dynamic cancelledDate;

    ConsentForm ({
        required this.formId,
        required this.recipientPhone,
        required this.recipientName,
        required this.formName,
        required this.formDetail,
        required this.statusId,
        required this.statusName,
        required this.requestDate,
        required this.startDate,
        required this.endDate,
        required this.cancelledDate,
    });
factory ConsentForm .fromJson(Map<String, dynamic> json) {
    return ConsentForm (
      formId: json['form_id'] ?? '0',
      recipientPhone: json['recipient_phone'] ?? '',
      recipientName: json['recipient_name'] ?? '',
      formName: json['form_name'] ?? '',
      formDetail: json['form_detail'] ?? '',
      statusId: json['status_id'] ?? '',
      statusName: json['status_name'] ?? '',
      requestDate:
          DateTime.parse(json['request_date'] ?? DateTime.now().toString()),
      startDate:
          DateTime.parse(json['start_date'] ?? DateTime.now().toString()),
      endDate: DateTime.parse(json['end_date'] ?? DateTime.now().toString()),
      cancelledDate:
          DateTime.parse(json['cancelled_date'] ?? DateTime.now().toString()),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['form_id'] = this.formId;
    data['recipient_phone'] = this.recipientPhone;
    data['recipient_name'] = this.recipientName;
    data['form_name'] = this.formName;
    data['form_detail'] = this.formDetail;
    data['status_id'] = this.statusId;
    data['status_name'] = this.statusName;
    data['request_date'] = this.requestDate.toIso8601String();
    data['start_date'] = this.startDate.toIso8601String();
    data['end_date'] = this.endDate.toIso8601String();
    data['cancelled_date'] = this.cancelledDate?.toIso8601String();
    return data;
  }
}


