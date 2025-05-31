import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '/presentation/providers/auth_provider.dart';
import '/routes/app_router.dart'; // BARU

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController =
      TextEditingController(text: 'employee@example.com'); // DEBUG
  final _passwordController = TextEditingController(text: 'password'); // DEBUG
  // bool _isLoading = false; // Diganti dengan AuthStatus.loading
  bool _obscurePassword = true;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      // setState(() => _isLoading = true); // Tidak perlu lagi
      final success = await ref.read(authNotifierProvider.notifier).login(
            _identifierController.text.trim(),
            _passwordController.text.trim(),
          );

      final authState = ref.read(authNotifierProvider); // Baca state terbaru
      if (mounted) {
        if (success) {
          // Navigasi ditangani oleh GoRouter redirect
          // if (authState.user?.group == 'admin' || authState.user?.group == 'superadmin') {
          //   context.go(AppRoute.adminDashboard.path);
          // } else {
          //   context.go(AppRoute.employeeDashboard.path);
          // }
          print("Login successful, GoRouter should redirect.");
        } else if (authState.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authState.errorMessage!),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
      // setState(() => _isLoading = false); // Tidak perlu lagi
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Icon(Icons.lock_open_outlined,
                    size: 80, color: Theme.of(context).primaryColor),
                const SizedBox(height: 24),
                Text(
                  'Selamat Datang!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: Theme.of(context).primaryColor, fontSize: 26),
                ),
                Text(
                  'Silakan masuk untuk melanjutkan',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _identifierController,
                  decoration: const InputDecoration(
                    labelText: 'NIP / Email',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'NIP atau Email tidak boleh kosong';
                    }
                    // if (!value.contains('@')) return 'Email tidak valid'; // Contoh validasi email
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      )),
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Fitur Lupa Password belum tersedia.')),
                      );
                    },
                    child: Text('Lupa Password?',
                        style:
                            TextStyle(color: Theme.of(context).primaryColor)),
                  ),
                ),
                const SizedBox(height: 24),
                authState.status == AuthStatus.loading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _login,
                        child: const Text('MASUK'),
                      ),
                // Pesan error sudah ditampilkan via SnackBar dari method _login
              ],
            ),
          ),
        ),
      ),
    );
  }
}
