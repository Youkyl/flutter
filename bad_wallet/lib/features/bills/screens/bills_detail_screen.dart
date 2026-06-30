import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/bills_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../dashboard/providers/wallet_provider.dart';
import '../../../core/theme/app_theme.dart';
import 'bills_screen.dart';

class BillsDetailScreen extends StatefulWidget {
  final ServiceInfo service;

  const BillsDetailScreen({super.key, required this.service});

  @override
  State<BillsDetailScreen> createState() => _BillsDetailScreenState();
}

class _BillsDetailScreenState extends State<BillsDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  void _load() {
    final phone = context.read<AuthProvider>().phone!;
    context.read<BillsProvider>().loadFactures(phone, widget.service.name);
  }

  Future<void> _pay() async {
    final phone = context.read<AuthProvider>().phone!;
    final provider = context.read<BillsProvider>();

    await provider.paySelected(phone, widget.service.name);

    if (!mounted) return;

    if (provider.state == BillsState.success) {
      await context.read<WalletProvider>().refresh(phone);
      if (!mounted) return;
      provider.reset();
      Navigator.of(context).popUntil((route) => route.isFirst);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Paiement effectué avec succès !'),
          backgroundColor: AppTheme.success,
        ),
      );
    }
  }

  String _formatAmount(double amount) {
    return NumberFormat.currency(
      locale: 'fr_FR',
      symbol: 'XOF',
      decimalDigits: 0,
    ).format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.service.name),
        actions: [
          TextButton(
            onPressed: () => context.read<BillsProvider>().selectAll(),
            child: const Text(
              'Tout sélectionner',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Consumer<BillsProvider>(
        builder: (context, provider, _) {
          if (provider.state == BillsState.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.state == BillsState.error) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: AppTheme.error),
                    const SizedBox(height: 16),
                    Text(
                      provider.errorMessage ?? 'Une erreur est survenue',
                      textAlign: TextAlign.center,
                      style:
                          const TextStyle(color: AppTheme.textSecondary),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _load,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (provider.factures.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline,
                      size: 64, color: AppTheme.success),
                  SizedBox(height: 16),
                  Text(
                    'Aucune facture impayée',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.factures.length,
                  itemBuilder: (context, index) {
                    final facture = provider.factures[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: facture.isSelected
                            ? Border.all(
                                color: widget.service.color, width: 1.5)
                            : null,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: CheckboxListTile(
                        value: facture.isSelected,
                        onChanged: (_) =>
                            provider.toggleSelection(facture.reference),
                        activeColor: widget.service.color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        title: Text(
                          facture.reference,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        subtitle: facture.periode.isNotEmpty
                            ? Text(
                                facture.periode,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.textSecondary,
                                ),
                              )
                            : null,
                        secondary: Text(
                          _formatAmount(facture.amount),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: widget.service.color,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Barre du bas
              if (provider.selectedFactures.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 12,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${provider.selectedFactures.length} facture(s)',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            Text(
                              _formatAmount(provider.totalSelected),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: provider.state == BillsState.paying
                            ? null
                            : _pay,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.service.color,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: provider.state == BillsState.paying
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Payer',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
