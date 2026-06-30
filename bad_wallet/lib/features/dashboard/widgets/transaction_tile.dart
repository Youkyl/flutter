import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/transaction_model.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionTile({super.key, required this.transaction});

  String get _formattedDate =>
      DateFormat('dd MMM yyyy', 'fr_FR').format(transaction.createdAt);

  String get _formattedAmount {
    final formatter = NumberFormat.currency(
      locale: 'fr_FR',
      symbol: 'XOF',
      decimalDigits: 0,
    );
    return '${transaction.isDebit ? '-' : '+'}${formatter.format(transaction.amount)}';
  }

  FaIconData get _icon {
    switch (transaction.type) {
      case 'TRANSFER':
        return FontAwesomeIcons.paperPlane;
      case 'DEPOSIT':
        return FontAwesomeIcons.arrowDown;
      case 'WITHDRAW':
        return FontAwesomeIcons.arrowUp;
      case 'PAYMENT':
        return FontAwesomeIcons.fileInvoiceDollar;
      default:
        return FontAwesomeIcons.arrowRightArrowLeft;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = transaction.isDebit ? AppTheme.error : AppTheme.success;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icône
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: FaIcon(_icon, color: color, size: 17),
            ),
          ),
          const SizedBox(width: 14),

          // Infos
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _formattedDate,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Montant
          Text(
            _formattedAmount,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
