// lib/models/transaction.dart
class Transaction {
  String id;
  String debtorId;
  double amount;
  String currency; // "IQD" or "USD"
  String? note;
  DateTime date;

  Transaction({
    required this.id,
    required this.debtorId,
    required this.amount,
    required this.currency,
    this.note,
    required this.date,
  });

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['\$id'],
      debtorId: map['debtorId'],
      amount: map['amount'].toDouble(),
      currency: map['currency'],
      note: map['note'],
      date: DateTime.parse(map['date']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'debtorId': debtorId,
      'amount': amount,
      'currency': currency,
      'note': note,
      'date': date.toIso8601String(),
    };
  }
}
