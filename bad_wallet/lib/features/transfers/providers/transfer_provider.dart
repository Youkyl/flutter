import 'package:flutter/material.dart';
import '../../../core/network/http_client.dart';
import '../../../core/constants/api_constants.dart';

enum TransferState { idle, loading, success, error }

class TransferProvider extends ChangeNotifier {
  TransferState _state = TransferState.idle;
  String? _errorMessage;

  TransferState get state => _state;
  String? get errorMessage => _errorMessage;

  Future<void> transfer({
    required String senderPhone,
    required String receiverPhone,
    required double amount,
  }) async {
    _state = TransferState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      await ApiClient.instance.post(ApiConstants.transfer, {
        'senderPhone': senderPhone,
        'receiverPhone': receiverPhone,
        'amount': amount,
      });
      _state = TransferState.success;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _state = TransferState.error;
    } catch (_) {
      _errorMessage = 'Erreur réseau. Vérifiez votre connexion.';
      _state = TransferState.error;
    }

    notifyListeners();
  }

  void reset() {
    _state = TransferState.idle;
    _errorMessage = null;
    notifyListeners();
  }
}
