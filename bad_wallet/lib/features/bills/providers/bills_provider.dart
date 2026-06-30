import 'package:flutter/material.dart';
import '../../../core/network/http_client.dart';
import '../../../core/constants/api_constants.dart';
import '../../../models/facture_model.dart';

enum BillsState { idle, loading, loaded, paying, success, error }

class BillsProvider extends ChangeNotifier {
  BillsState _state = BillsState.idle;
  List<FactureModel> _factures = [];
  String? _errorMessage;

  BillsState get state => _state;
  List<FactureModel> get factures => _factures;
  String? get errorMessage => _errorMessage;

  List<FactureModel> get selectedFactures =>
      _factures.where((f) => f.isSelected).toList();

  double get totalSelected =>
      selectedFactures.fold(0, (sum, f) => sum + f.amount);

  Future<void> loadFactures(String walletCode, String serviceName) async {
    _state = BillsState.loading;
    _factures = [];
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await ApiClient.instance.get(
        '${ApiConstants.facturesCurrent(walletCode)}?unite=$serviceName',
      );
      _factures = (data as List)
          .map((e) => FactureModel.fromJson(e as Map<String, dynamic>))
          .toList();
      _state = BillsState.loaded;
    } on ApiException catch (e) {
      _errorMessage = 'Erreur ${e.statusCode}';
      _state = BillsState.error;
    } catch (_) {
      _errorMessage = 'Impossible de récupérer les factures.';
      _state = BillsState.error;
    }

    notifyListeners();
  }

  void toggleSelection(String reference) {
    final index = _factures.indexWhere((f) => f.reference == reference);
    if (index != -1) {
      _factures[index].isSelected = !_factures[index].isSelected;
      notifyListeners();
    }
  }

  void selectAll() {
    for (final f in _factures) {
      f.isSelected = true;
    }
    notifyListeners();
  }

  Future<void> paySelected(String phone, String serviceName) async {
    if (selectedFactures.isEmpty) return;

    _state = BillsState.paying;
    _errorMessage = null;
    notifyListeners();

    try {
      await ApiClient.instance.post(ApiConstants.payFactures, {
        'phone': phone,
        'serviceName': serviceName,
        'factureReferences': selectedFactures.map((f) => f.reference).toList(),
      });
      _state = BillsState.success;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _state = BillsState.error;
    } catch (_) {
      _errorMessage = 'Erreur réseau. Vérifiez votre connexion.';
      _state = BillsState.error;
    }

    notifyListeners();
  }

  void reset() {
    _state = BillsState.idle;
    _factures = [];
    _errorMessage = null;
    notifyListeners();
  }
}
