class TransactionModel {
  final int id;
  final String type;
  final double amount;
  final String? paymentMethod;
  final DateTime createdAt;

  const TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    this.paymentMethod,
    required this.createdAt,
  });

  bool get isDebit =>
      type == 'TRANSFER' || type == 'WITHDRAW' || type == 'PAYMENT';

  String get label {
    switch (type) {
      case 'TRANSFER':
        return 'Transfert';
      case 'DEPOSIT':
        return 'Dépôt';
      case 'WITHDRAW':
        return 'Retrait';
      case 'PAYMENT':
        return 'Paiement';
      default:
        return type;
    }
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as int,
      type: (json['type'] as String),
      amount: (json['amount'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] as String?,
      createdAt: _parseDate(json['createdAt']),
    );
  }

  /// Gère les deux formats possibles de Spring Boot :
  /// - Tableau : [2026, 6, 30, 10, 30, 0]
  /// - String ISO : "2026-06-30T10:30:00"
  static DateTime _parseDate(dynamic value) {
    if (value is String) {
      return DateTime.parse(value);
    }
    if (value is List) {
      return DateTime(
        value[0] as int,
        value[1] as int,
        value[2] as int,
        value.length > 3 ? value[3] as int : 0,
        value.length > 4 ? value[4] as int : 0,
        value.length > 5 ? value[5] as int : 0,
      );
    }
    throw FormatException('Format de date inconnu: $value');
  }
}
