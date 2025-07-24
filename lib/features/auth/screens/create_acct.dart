import 'package:flutter/material.dart';
import '../../../core/widget/app_textfields.dart';
import '../data/model/create_acct_params.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  String _selectedRole = 'passenger';

  void _register() {
    if (_formKey.currentState!.validate()) {
      final user = RegistrationModel(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text.trim(),
        role: _selectedRole,
      );

      print(user.toJson());
      // TODO: Send data to backend
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              AppTextField(
                controller: _nameController,
                label: 'Full Name',
                validator: (val) => val!.isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator:
                    (val) => val!.contains('@') ? null : 'Enter valid email',
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _phoneController,
                label: 'Phone',
                keyboardType: TextInputType.phone,
                validator:
                    (val) => val!.length >= 10 ? null : 'Invalid phone number',
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _passwordController,
                label: 'Password',
                isPassword: true,
                validator:
                    (val) => val!.length >= 6 ? null : 'Min 6 characters',
              ),
              const SizedBox(height: 12),
              AppDropdown(
                label: 'Select Role',
                value: _selectedRole,
                items: ['passenger', 'driver'],
                onChanged: (val) => setState(() => _selectedRole = val!),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                child: const Text('Create Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
