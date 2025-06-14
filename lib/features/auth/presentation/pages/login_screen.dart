import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tutor_app/core/constants/strings.dart';
import 'package:tutor_app/core/db/supabase_client.dart';
import 'package:tutor_app/core/utils/validator.dart';
import 'package:tutor_app/features/auth/data/models/user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isPasswordVisible = true;
  final _passwordController = TextEditingController();
  String _selectedRole = UserType.manager.label;
  // User role options with icons
  final List<UserTypeOption> _UserTypes = [
    UserTypeOption(
      role: UserType.manager.label,
      displayName: 'Manager',
      icon: Icons.admin_panel_settings,
      color: Colors.purple,
    ),
    UserTypeOption(
      role: UserType.teacher.label,
      displayName: 'Teacher',
      icon: Icons.school,
      color: Colors.blue,
    ),
    UserTypeOption(
      role: UserType.student.label,
      displayName: 'Student',
      icon: Icons.person,
      color: Colors.green,
    ),
  ];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildHeader(ColorScheme colorScheme) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.school,
            size: 48,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Welcome Back',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          AppConstants.appName,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Email Address',
        hintText: 'Enter your email',
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      ),
      validator: InputValidator.validateEmail,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _isPasswordVisible,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter your password',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      ),
      // validator: InputValidator.validatePassword,
    );
  }

  Widget _buildRoleDropdown(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Role',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.outline),
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedRole,
              isExpanded: true,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              borderRadius: BorderRadius.circular(12),
              items:
                  _UserTypes.map((roleOption) {
                    return DropdownMenuItem<String>(
                      value: roleOption.role,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: roleOption.color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              roleOption.icon,
                              color: roleOption.color,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(roleOption.displayName),
                        ],
                      ),
                    );
                  }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedRole = newValue;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(ColorScheme colorScheme) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child:
            _isLoading
                ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      colorScheme.onPrimary,
                    ),
                  ),
                )
                : const Text(
                  'Sign In',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
      ),
    );
  }

  Widget _buildForgotPasswordLink(ColorScheme colorScheme) {
    return TextButton(
      onPressed: () {
        // TODO: Implement forgot password functionality
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Forgot password functionality coming soon!'),
          ),
        );
      },
      child: Text(
        'Forgot Password?',
        style: TextStyle(
          color: colorScheme.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildRegisterLink(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don\'t have an account? ',
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
        TextButton(
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          onPressed: () {
            GoRouter.of(context).go('/register');
          },
          child: Text(
            'Sign In',
            style: TextStyle(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Update user metadata with selected role before signing in
      await SupabaseClientService().signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      // Update user role in metadata after successful login
      await SupabaseClientService().updateUserMetadata(
        data: {'role': _selectedRole},
      );

      // Router will automatically handle navigation based on auth state
      // No need for manual navigation as the router redirect will handle it
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Card(
                elevation: 8,
                shadowColor: colorScheme.shadow.withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildHeader(colorScheme),
                        const SizedBox(height: 40),
                        _buildEmailField(),
                        const SizedBox(height: 20),
                        _buildPasswordField(),
                        const SizedBox(height: 24),
                        _buildRoleDropdown(colorScheme),
                        const SizedBox(height: 32),
                        _buildLoginButton(colorScheme),
                        const SizedBox(height: 16),
                        _buildForgotPasswordLink(colorScheme),
                        const SizedBox(height: 16),
                        _buildRegisterLink(colorScheme),
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

// Helper class for user role options
class UserTypeOption {
  UserTypeOption({
    required this.role,
    required this.displayName,
    required this.icon,
    required this.color,
  });

  final Color color;
  final String displayName;
  final IconData icon;
  final String role;
}
