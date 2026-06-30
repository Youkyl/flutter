import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../dashboard/providers/wallet_provider.dart';
import '../../dashboard/widgets/transaction_tile.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/transaction_model.dart';

enum HistoryFilter { all, debits, credits }

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  HistoryFilter _filter = HistoryFilter.all;

  List<TransactionModel> _filtered(List<TransactionModel> all) {
    switch (_filter) {
      case HistoryFilter.debits:
        return all.where((t) => t.isDebit).toList();
      case HistoryFilter.credits:
        return all.where((t) => !t.isDebit).toList();
      case HistoryFilter.all:
        return all;
    }
  }

  /// Groupe les transactions par date (jour)
  Map<String, List<TransactionModel>> _groupByDate(
      List<TransactionModel> transactions) {
    final Map<String, List<TransactionModel>> grouped = {};
    final now = DateTime.now();

    for (final t in transactions) {
      final String label;
      final date = t.createdAt;

      if (date.year == now.year &&
          date.month == now.month &&
          date.day == now.day) {
        label = "Aujourd'hui";
      } else if (date.year == now.year &&
          date.month == now.month &&
          date.day == now.day - 1) {
        label = 'Hier';
      } else {
        label = DateFormat('dd MMMM yyyy', 'fr_FR').format(date);
      }

      grouped.putIfAbsent(label, () => []).add(t);
    }

    return grouped;
  }

  Future<void> _refresh() async {
    final phone = context.read<AuthProvider>().phone!;
    await context.read<WalletProvider>().refresh(phone);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historique')),
      body: Consumer<WalletProvider>(
        builder: (context, wallet, _) {
          if (wallet.state == WalletState.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final filtered = _filtered(wallet.transactions);
          final grouped = _groupByDate(filtered);

          return Column(
            children: [
              // Filtres
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'Tout',
                      selected: _filter == HistoryFilter.all,
                      onTap: () =>
                          setState(() => _filter = HistoryFilter.all),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Débits',
                      selected: _filter == HistoryFilter.debits,
                      onTap: () =>
                          setState(() => _filter = HistoryFilter.debits),
                      color: AppTheme.error,
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Crédits',
                      selected: _filter == HistoryFilter.credits,
                      onTap: () =>
                          setState(() => _filter = HistoryFilter.credits),
                      color: AppTheme.success,
                    ),
                  ],
                ),
              ),

              // Liste groupée
              Expanded(
                child: filtered.isEmpty
                    ? const Center(
                        child: Text(
                          'Aucune transaction',
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _refresh,
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          itemCount: grouped.length,
                          itemBuilder: (context, index) {
                            final dateLabel =
                                grouped.keys.elementAt(index);
                            final items = grouped[dateLabel]!;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: Text(
                                    dateLabel,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                ),
                                ...items.map(
                                    (t) => TransactionTile(transaction: t)),
                              ],
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color color;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.color = AppTheme.primary,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? color : color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : color,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
