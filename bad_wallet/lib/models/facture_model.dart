class FactureModel {
  final String reference;
  final String serviceName;
  final double amount;
  final String periode;
  bool isSelected;

  FactureModel({
    required this.reference,
    required this.serviceName,
    required this.amount,
    required this.periode,
    this.isSelected = false,
  });

  factory FactureModel.fromJson(Map<String, dynamic> json) => FactureModel(
        reference: json['reference'] as String,
        serviceName: json['serviceName'] as String,
        amount: (json['amount'] as num).toDouble(),
        periode: json['periode'] as String? ?? '',
      );
}
