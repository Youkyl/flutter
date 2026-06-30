class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'http://192.168.1.4:8080';

  // Wallets
  static const String wallets = '/api/wallets';
  static String walletByPhone(String phone) => '/api/wallets/$phone';
  static String walletBalance(String phone) => '/api/wallets/$phone/balance';

  // Transactions
  static const String transfer = '/api/wallets/transactions/transfer';
  static String transactionHistory(String phone) =>
      '/api/wallets/transactions/$phone/history';

  // Payments
  static const String payFactures = '/api/wallets/payments/pay-factures';

  // Factures
  static String facturesCurrent(String walletCode) =>
      '/api/external/factures/$walletCode/current';
  static String facturesPeriode(String walletCode) =>
      '/api/external/factures/$walletCode/periode';
}
