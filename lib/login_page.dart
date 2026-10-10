import 'package:appiumtesting/welcomepage.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.name});

  final String name;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _passwordController = TextEditingController();
  String? error;
  bool loading = false;

  bool _showPassword = false;

  String? _error;
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  void login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final user = _email.text;

    setState(() {
      _loading = true;
      _error = null;
    });
    await Future.delayed(Duration(seconds: 2));

    if (_email.text == "student@test.com" &&
        _passwordController.text == "password123") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WelcomePage(name: user)),
      );
    } else {
      setState(() {
        _loading = false;
        _error = "Invalid email or password";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("login")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                key: const ValueKey('email_field'),
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Email is required';
                  if (!v.contains('@')) return 'Enter a valid email';
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                key: const ValueKey('password_field'),
                controller: _passwordController,
                obscureText: !_showPassword,
                decoration: InputDecoration(
                  labelText: 'password',
                  suffixIcon: IconButton(
                    tooltip: _showPassword ? 'Hide password' : 'Show password',
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                    icon: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                ),

                validator: (v) => (v == null || v.length < 6)
                    ? "Password must be at least 6 characters"
                    : null,
              ),

              if (_error != null) Text(_error!, key: ValueKey('login_error')),
              SizedBox(height: 20),
              _loading
                  ? Center(
                      key: ValueKey('loading_indicator'),

                      child: CircularProgressIndicator(),
                    )
                  : FilledButton(
                      key: const ValueKey('login_button'),
                      onPressed: () {
                        login();
                      },
                      child: Text("Login"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
