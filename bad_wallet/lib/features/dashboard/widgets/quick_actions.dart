import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
          icon: FontAwesomeIcons.paperPlane,
          label: 'Transférer',
          color: AppTheme.primary,
          onTap: onTransfer,
        ),
        _ActionButton(
          icon: FontAwesomeIcons.fileInvoiceDollar,
          label: 'Payer',
          color: AppTheme.accent,
          onTap: onPay,
        ),
        _ActionButton(
          icon: FontAwesomeIcons.clockRotateLeft,
          label: 'Historique',
          color: const Color(0xFF8B5CF6),
          onTap: onHistory,
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: color.withValues(alpha: 0.15),
                width: 1,
              ),
            ),
            child: Center(
              child: FaIcon(icon, color: color, size: 22),
            ),
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
