
class Visitor {
  final String name;
  final String cnic;
  final String contact;
  final String purpose;
  final String photoPath; // Changed from XFile
  final DateTime checkInTime;
  final DateTime? checkOutTime;
  final bool wasPreApproved;

  // Added a unique ID for easier management
  String get id => '$cnic-${checkInTime.millisecondsSinceEpoch}';

  Visitor({
    required this.name,
    required this.cnic,
    required this.contact,
    required this.purpose,
    required this.photoPath,
    required this.checkInTime,
    this.checkOutTime,
    this.wasPreApproved = false,
  });

  // Factory to create a Visitor from JSON
  factory Visitor.fromJson(Map<String, dynamic> json) {
    return Visitor(
      name: json['name'],
      cnic: json['cnic'],
      contact: json['contact'],
      purpose: json['purpose'],
      photoPath: json['photoPath'],
      checkInTime: DateTime.parse(json['checkInTime']),
      checkOutTime: json['checkOutTime'] != null ? DateTime.parse(json['checkOutTime']) : null,
      wasPreApproved: json['wasPreApproved'],
    );
  }
}