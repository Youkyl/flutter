import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class QuickActions extends StatelessWidget {
  final VoidCallback onTransfer;
  final VoidCallback onPay;
  final VoidCallback onHistory;

  const QuickActions({
    super.key,
    required this.onTransfer,
    required this.onPay,
    required this.onHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ActionButton(
          icon: Icons.send,
          label: 'Transférer',
          onTap: onTransfer,
        ),
        _ActionButton(
          icon: Icons.receipt_long,
          label: 'Payer',
          onTap: onPay,
        ),
        _ActionButton(
          icon: Icons.history,
          label: 'Historique',
          onTap: onHistory,
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: AppTheme.primary, size: 26),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppTheme.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
