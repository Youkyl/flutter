import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import 'transfer_confirm_screen.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _receiverController = TextEditingController();
  String _amount = '';
  String? _receiverError;

  @override
  void dispose() {
    _receiverController.dispose();
    super.dispose();
  }

  String get _formattedAmount {
    if (_amount.isEmpty) return '0';
    final value = double.tryParse(_amount) ?? 0;
    return NumberFormat('#,###', 'fr_FR').format(value);
  }

  void _onKeyTap(String key) {
    setState(() {
      if (key == '⌫') {
        if (_amount.isNotEmpty) {
          _amount = _amount.substring(0, _amount.length - 1);
        }
      } else if (key == '000') {
        if (_amount.isNotEmpty) _amount += '000';
      } else {
        if (_amount.length < 10) _amount += key;
      }
    });
  }

  void _submit() {
    final receiver = _receiverController.text.trim();
    final amount = double.tryParse(_amount) ?? 0;

    setState(() {
      _receiverError = receiver.isEmpty
          ? 'Veuillez entrer le numéro du destinataire'
          : receiver.length < 9
              ? 'Numéro invalide'
              : null;
    });

    if (_receiverError != null) return;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez saisir un montant')),
      );
      return;
    }

    final fullReceiver = receiver.startsWith('+221')
        ? receiver
        : '+221$receiver';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TransferConfirmScreen(
          receiverPhone: fullReceiver,
          amount: amount,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transfert')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Champ destinataire
                  const Text(
                    'Destinataire',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _receiverController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(9),
                    ],
                    decoration: InputDecoration(
                      hintText: '7X XXX XX XX',
                      prefixText: '+221 ',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: const OutlineInputBorder(),
                      errorText: _receiverError,
                    ),
                    onChanged: (_) => setState(() => _receiverError = null),
                  ),
                  const SizedBox(height: 32),

                  // Affichage du montant
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          'Montant',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$_formattedAmount XOF',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Pavé numérique custom
                  _NumPad(onKeyTap: _onKeyTap),
                ],
              ),
            ),
          ),

          // Bouton Continuer
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Continuer',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NumPad extends StatelessWidget {
  final void Function(String) onKeyTap;

  const _NumPad({required this.onKeyTap});

  @override
  Widget build(BuildContext context) {
    final keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['000', '0', '⌫'],
    ];

    return Column(
      children: keys.map((row) {
        return Row(
          children: row.map((key) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: TextButton(
                  onPressed: () => onKeyTap(key),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: AppTheme.background,
                  ),
                  child: Text(
                    key,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}
