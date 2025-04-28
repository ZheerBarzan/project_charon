// lib/models/debtor.dart
class Debtor {
  String id;
  String name;
  String? phoneNumber;
  String? note;
  String currency; // "IQD" or "USD"
  double currentBalance;

  Debtor({
    required this.id,
    required this.name,
    this.phoneNumber,
    this.note,
    required this.currency,
    required this.currentBalance,
  });

  factory Debtor.fromMap(Map<String, dynamic> map) {
    return Debtor(
      id: map['\$id'],
      name: map['name'],
      phoneNumber: map['phoneNumber'],
      note: map['note'],
      currency: map['currency'],
      currentBalance: map['currentBalance'].toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'note': note,
      'currency': currency,
      'currentBalance': currentBalance,
    };
  }
}
