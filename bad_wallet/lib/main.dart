import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const BadWalletApp());
}

class BadWalletApp extends StatelessWidget {
  const BadWalletApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: const [],
      child: MaterialApp(
        title: 'BadWallet',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const Scaffold(
          body: Center(child: Text('BadWallet')),
        ),
      ),
    );
  }
}
