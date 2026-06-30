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

  bool get isDebit => type == 'TRANSFER_SENT' || type == 'WITHDRAWAL';

  String get label {
    switch (type) {
      case 'TRANSFER_SENT':
        return 'Transfert envoyé';
      case 'TRANSFER_RECEIVED':
        return 'Transfert reçu';
      case 'DEPOSIT':
        return 'Dépôt';
      case 'WITHDRAWAL':
        return 'Retrait';
      default:
        return type;
    }
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        id: json['id'] as int,
        type: json['type'] as String,
        amount: (json['amount'] as num).toDouble(),
        paymentMethod: json['paymentMethod'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
