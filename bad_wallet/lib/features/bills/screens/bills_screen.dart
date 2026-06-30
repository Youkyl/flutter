import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/theme/app_theme.dart';
import 'bills_detail_screen.dart';

class ServiceInfo {
  final String name;
  final String label;
  final FaIconData icon;
  final Color color;

  const ServiceInfo({
    required this.name,
    required this.label,
    required this.icon,
    required this.color,
  });
}

const _services = [
  ServiceInfo(
    name: 'SENELEC',
    label: 'Electricité',
    icon: FontAwesomeIcons.bolt,
    color: AppTheme.senelecColor,
  ),
  ServiceInfo(
    name: 'WOYAFAL',
    label: 'Gaz',
    icon: FontAwesomeIcons.fire,
    color: AppTheme.woyafalColor,
  ),
  ServiceInfo(
    name: 'ISM',
    label: 'Scolarité',
    icon: FontAwesomeIcons.graduationCap,
    color: AppTheme.ismColor,
  ),
  ServiceInfo(
    name: 'RAPIDO',
    label: 'Transport',
    icon: FontAwesomeIcons.car,
    color: AppTheme.rapidoColor,
  ),
];

class BillsScreen extends StatelessWidget {
  const BillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paiement de factures')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choisissez un fournisseur',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.3,
              ),
              itemCount: _services.length,
              itemBuilder: (context, index) {
                final service = _services[index];
                return _ServiceCard(service: service);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final ServiceInfo service;

  const _ServiceCard({required this.service});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BillsDetailScreen(service: service),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: service.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: FaIcon(service.icon, color: service.color, size: 22),
            ),
            const SizedBox(height: 12),
            Text(
              service.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              service.label,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
