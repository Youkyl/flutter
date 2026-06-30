import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../../dashboard/screens/dashboard_screen.dart';
import '../../../core/theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await context.read<AuthProvider>().savePhone('+221${_phoneController.text.trim()}');
    if (!mounted) return;
    setState(() => _isLoading = false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),
                const Icon(
                  Icons.account_balance_wallet,
                  size: 56,
                  color: AppTheme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  'Bienvenue sur BadWallet',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Entrez votre numéro de téléphone pour continuer',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(9),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Numéro de téléphone',
                    prefixText: '+221 ',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                    hintText: '7X XXX XX XX',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Veuillez entrer votre numéro';
                    }
                    if (value.trim().length < 9) {
                      return 'Le numéro doit contenir 9 chiffres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Continuer',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
