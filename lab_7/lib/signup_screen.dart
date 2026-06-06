import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';

  bool _isCheckingEmail = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value
        .trim()
        .isEmpty) {
      return 'Full name is required';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value
        .trim()
        .isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address (e.g., name@example.com)';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least 1 digit';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _password) {
      return 'Passwords do not match';
    }
    return null;
  }

  String _checkPasswordStrength(String password) {
    if (password.isEmpty) return '';
    if (password.length < 6) return 'Weak 🔴';
    if (password.length >= 8 && RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[0-9]').hasMatch(password)) {
      return 'Strong 🟢';
    }
    return 'Medium 🟡';
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must accept the Terms & Conditions to proceed.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    _formKey.currentState!.save();
    setState(() {
      _isCheckingEmail = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isCheckingEmail = false;
    });
    if (_email.trim().toLowerCase().startsWith('taken')) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This email is already taken. Please try another one.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 28),
                SizedBox(width: 8),
                Text('Success'),
              ],
            ),
            content: Text(
                'Account successfully created for $_name!\nEmail: $_email'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _formKey.currentState!.reset();
                  setState(() {
                    _password = '';
                    _agreeToTerms = false;
                  });
                },
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
              'Signup', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Create New Account',
                          style: TextStyle(fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        const SizedBox(height: 4),
                        Text('Please fill in the form below to register',
                            style: TextStyle(color: Colors.grey[600])),
                        const Divider(height: 32),
                        TextFormField(
                          focusNode: _nameFocusNode,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                            prefixIcon: Icon(Icons.person_outline),
                            border: OutlineInputBorder(),
                          ),
                          validator: _validateName,
                          onSaved: (value) => _name = value ?? '',
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).requestFocus(
                                  _emailFocusNode),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          focusNode: _emailFocusNode,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Email Address',
                            prefixIcon: Icon(Icons.email_outlined),
                            border: OutlineInputBorder(),
                            helperText: 'Avoid emails starting with "taken" to test API check.',
                          ),
                          validator: _validateEmail,
                          onSaved: (value) => _email = value ?? '',
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).requestFocus(
                                  _passwordFocusNode),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          focusNode: _passwordFocusNode,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () =>
                                  setState(() =>
                                  _obscurePassword = !_obscurePassword),
                            ),
                          ),
                          validator: _validatePassword,
                          onChanged: (value) =>
                              setState(() => _password = value),
                          onSaved: (value) => _password = value ?? '',
                          onFieldSubmitted: (_) =>
                              FocusScope.of(context).requestFocus(
                                  _confirmPasswordFocusNode),
                        ),
                        if (_password.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Row(
                              children: [
                                const Text('Password Strength: ',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.black54)),
                                Text(_checkPasswordStrength(_password),
                                    style: const TextStyle(fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),
                        TextFormField(
                          focusNode: _confirmPasswordFocusNode,
                          obscureText: _obscureConfirmPassword,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            prefixIcon: const Icon(Icons.lock_clock_outlined),
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(_obscureConfirmPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () =>
                                  setState(() =>
                                  _obscureConfirmPassword =
                                  !_obscureConfirmPassword),
                            ),
                          ),
                          validator: _validateConfirmPassword,
                          onSaved: (value) => _confirmPassword = value ?? '',
                          onFieldSubmitted: (_) => _submitForm(),
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Checkbox(
                              value: _agreeToTerms,
                              onChanged: (value) =>
                                  setState(() =>
                                  _agreeToTerms = value ?? false),
                            ),
                            const Expanded(
                              child: Text(
                                'I read and agree to the Terms & Conditions',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isCheckingEmail ? null : _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.teal.withOpacity(
                                  0.4),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            child: _isCheckingEmail
                                ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2),
                                ),
                                SizedBox(width: 12),
                                Text('Checking Email availability...',
                                    style: TextStyle(fontSize: 16)),
                              ],
                            )
                                : const Text('Sign Up', style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}