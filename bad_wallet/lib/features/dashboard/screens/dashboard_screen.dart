import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wallet_provider.dart';
import '../widgets/balance_card.dart';
import '../widgets/quick_actions.dart';
import '../widgets/transaction_tile.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/screens/login_screen.dart';
import '../../../core/theme/app_theme.dart';
import '../../transfers/screens/transfer_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  void _load() {
    final phone = context.read<AuthProvider>().phone!;
    context.read<WalletProvider>().loadDashboard(phone);
  }

  void _logout() {
    context.read<AuthProvider>().logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BadWallet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Déconnexion',
          ),
        ],
      ),
      body: Consumer<WalletProvider>(
        builder: (context, wallet, _) {
          if (wallet.state == WalletState.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (wallet.state == WalletState.error) {
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
                      wallet.errorMessage ?? 'Une erreur est survenue',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppTheme.textSecondary),
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

          final phone = context.read<AuthProvider>().phone!;

          return RefreshIndicator(
            onRefresh: () => wallet.refresh(phone),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BalanceCard(balance: wallet.balance, phone: phone),
                  const SizedBox(height: 28),
                  QuickActions(
                    onTransfer: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const TransferScreen()),
                    ),
                    onPay: () {},
                    onHistory: () {},
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Dernières transactions',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (wallet.lastFiveTransactions.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'Aucune transaction pour le moment',
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                      ),
                    )
                  else
                    ...wallet.lastFiveTransactions
                        .map((t) => TransactionTile(transaction: t)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
