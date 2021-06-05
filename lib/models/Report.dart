class Report {
  String storeId;
  String storeName;
  String report;

  Report({
    this.storeId,
    this.storeName,
    this.report,
  });

  factory Report.fromFireStore(Map<String, dynamic> json) {
    return Report(
      storeId: json['store_id'],
      storeName: json['store_name'],
      report: json['report'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'store_id': storeId,
      'store_name': storeName,
      'report': report,
    };
  }
}
