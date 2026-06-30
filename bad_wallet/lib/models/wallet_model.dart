class WalletModel {
  final String phone;
  final double balance;

  const WalletModel({required this.phone, required this.balance});

  factory WalletModel.fromJson(Map<String, dynamic> json) => WalletModel(
        phone: json['phone'] as String,
        balance: (json['balance'] as num).toDouble(),
      );
}
