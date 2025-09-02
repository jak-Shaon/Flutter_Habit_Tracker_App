import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../home_screen.dart';
import '../../widgets/custom_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _displayName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _dob = TextEditingController();
  final _height = TextEditingController();
  String? _gender;
  bool _agreed = false;
  bool _showPassword = false;

  @override
  void dispose() {
    _displayName.dispose();
    _email.dispose();
    _password.dispose();
    _dob.dispose();
    _height.dispose();
    super.dispose();
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Enter password';
    if (v.length < 8) return 'Min 8 chars';
    if (!RegExp(r'[A-Z]').hasMatch(v)) return 'Must include uppercase letter';
    if (!RegExp(r'[a-z]').hasMatch(v)) return 'Must include lowercase letter';
    if (!RegExp(r'[0-9]').hasMatch(v)) return 'Must include number';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Create Account', style: theme.textTheme.headlineMedium),
                    const SizedBox(height: 8),
                    Text('Fill the form to register', style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 24),
                    // Display Name
                    TextFormField(
                      controller: _displayName,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    // Email
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      validator: (v) => (v == null || !v.contains('@')) ? 'Enter valid email' : null,
                    ),
                    const SizedBox(height: 16),
                    // Password
                    TextFormField(
                      controller: _password,
                      obscureText: !_showPassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPassword ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () => setState(() => _showPassword = !_showPassword),
                        ),
                      ),
                      validator: _validatePassword,
                    ),
                    const SizedBox(height: 16),
                    // Gender Dropdown
                    DropdownButtonFormField<String>(
                      value: _gender,
                      items: const [
                        DropdownMenuItem(value: 'Male', child: Text('Male')),
                        DropdownMenuItem(value: 'Female', child: Text('Female')),
                        DropdownMenuItem(value: 'Other', child: Text('Other')),
                      ],
                      onChanged: (v) => setState(() => _gender = v),
                      decoration: InputDecoration(
                        labelText: 'Gender',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // DOB
                    TextFormField(
                      controller: _dob,
                      decoration: InputDecoration(
                        labelText: 'Date of Birth (YYYY-MM-DD)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Height
                    TextFormField(
                      controller: _height,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Height (cm)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Terms & Conditions
                    Row(
                      children: [
                        Checkbox(value: _agreed, onChanged: (v) => setState(() => _agreed = v ?? false)),
                        const Expanded(child: Text('I agree to the Terms & Conditions')),
                      ],
                    ),
                    const SizedBox(height: 16),
                    PrimaryButton(
                      label: 'Register',
                      loading: auth.loading,
                      onPressed: () async {
                        if (!_agreed) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('You must agree to T&C')),
                          );
                          return;
                        }
                        if (!_formKey.currentState!.validate()) return;
                        await auth.register(
                          displayName: _displayName.text.trim(),
                          email: _email.text.trim(),
                          password: _password.text.trim(),
                          gender: _gender,
                          otherDetails: {
                            if (_dob.text.isNotEmpty) 'dob': _dob.text.trim(),
                            if (_height.text.isNotEmpty) 'height': _height.text.trim(),
                          },
                          agreedToTerms: _agreed,
                        );
                        if (auth.error != null) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(auth.error!)),
                            );
                          }
                        } else {
                          if (context.mounted) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => const HomeScreen()),
                                  (_) => false,
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
