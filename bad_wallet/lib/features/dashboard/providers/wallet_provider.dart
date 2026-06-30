import 'package:flutter/material.dart';
import '../../../core/network/http_client.dart';
import '../../../core/constants/api_constants.dart';
import '../../../models/transaction_model.dart';

enum WalletState { loading, loaded, error }

class WalletProvider extends ChangeNotifier {
  WalletState _state = WalletState.loading;
  double _balance = 0;
  List<TransactionModel> _transactions = [];
  String? _errorMessage;

  WalletState get state => _state;
  double get balance => _balance;
  String? get errorMessage => _errorMessage;

  List<TransactionModel> get transactions => _transactions;
  List<TransactionModel> get lastFiveTransactions =>
      _transactions.take(5).toList();

  Future<void> loadDashboard(String phone) async {
    _state = WalletState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        ApiClient.instance.get(ApiConstants.walletBalance(phone)),
        ApiClient.instance.get(ApiConstants.transactionHistory(phone)),
      ]);

      _balance = (results[0] as num).toDouble();
      _transactions = (results[1] as List)
          .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
          .toList();
      _state = WalletState.loaded;
    } on ApiException catch (e) {
      _errorMessage = 'Erreur ${e.statusCode}: ${e.message}';
      _state = WalletState.error;
    } catch (_) {
      _errorMessage = 'Impossible de joindre le serveur. Vérifiez votre connexion.';
      _state = WalletState.error;
    }

    notifyListeners();
  }

  Future<void> refresh(String phone) => loadDashboard(phone);
}
