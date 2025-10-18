class PreApprovedVisitor {
  final String name;
  final String cnic;
  final String purpose;
  final String residentHost;

  PreApprovedVisitor({
    required this.name,
    required this.cnic,
    required this.purpose,
    required this.residentHost,
  });

  factory PreApprovedVisitor.fromJson(Map<String, dynamic> json) {
    return PreApprovedVisitor(
      name: json['name'],
      cnic: json['cnic'],
      purpose: json['purpose'],
      residentHost: json['residentHost'],
    );
  }
}