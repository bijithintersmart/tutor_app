import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tutor_app/core/constants/strings.dart';
import 'package:tutor_app/core/db/supabase_client.dart';
import 'package:tutor_app/core/utils/validator.dart';
import 'package:tutor_app/features/auth/data/models/user.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  // Role-specific controllers
  final _employeeIdController = TextEditingController();
  final _qualificationController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _institutionController = TextEditingController();

  String _selectedRole = UserType.student.label;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;

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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _employeeIdController.dispose();
    _qualificationController.dispose();
    _studentIdController.dispose();
    _institutionController.dispose();
    super.dispose();
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
                        const SizedBox(height: 32),
                        _buildNameField(),
                        const SizedBox(height: 20),
                        _buildEmailField(),
                        const SizedBox(height: 20),
                        _buildPasswordField(),
                        const SizedBox(height: 20),
                        _buildConfirmPasswordField(),
                        const SizedBox(height: 20),
                        _buildPhoneField(),
                        const SizedBox(height: 24),
                        _buildRoleDropdown(colorScheme),
                        const SizedBox(height: 20),
                        _buildRoleSpecificFields(),
                        const SizedBox(height: 32),
                        _buildSignupButton(colorScheme),
                        const SizedBox(height: 16),
                        _buildLoginLink(colorScheme),
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
            Icons.person_add,
            size: 48,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Create Account',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Join ${AppConstants.appName}',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: 'Full Name',
        hintText: 'Enter your full name',
        prefixIcon: const Icon(Icons.person_outline),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your full name';
        }
        if (value.trim().length < 2) {
          return 'Name must be at least 2 characters';
        }
        return null;
      },
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
      obscureText: !_isPasswordVisible,
      textInputAction: TextInputAction.next,
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
      validator: InputValidator.validatePassword,
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: !_isConfirmPasswordVisible,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        hintText: 'Re-enter your password',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            _isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
            });
          },
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your password';
        }
        if (value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Phone Number (Optional)',
        hintText: 'Enter your phone number',
        prefixIcon: const Icon(Icons.phone_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      ),
      validator: (value) {
        if (value != null && value.trim().isNotEmpty) {
          if (value.trim().length < 10) {
            return 'Please enter a valid phone number';
          }
        }
        return null;
      },
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
                    // Clear role-specific fields when role changes
                    _employeeIdController.clear();
                    _qualificationController.clear();
                    _studentIdController.clear();
                    _institutionController.clear();
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleSpecificFields() {
    switch (_selectedRole) {
      case 'manager':
        return Column(
          children: [
            _buildEmployeeIdField(),
            const SizedBox(height: 20),
            _buildDepartmentField(),
          ],
        );
      case 'teacher':
        return Column(
          children: [
            _buildEmployeeIdField(),
            const SizedBox(height: 20),
            _buildQualificationField(),
            const SizedBox(height: 20),
            _buildSubjectField(),
          ],
        );
      case 'student':
        return Column(
          children: [
            _buildStudentIdField(),
            const SizedBox(height: 20),
            _buildInstitutionField(),
            const SizedBox(height: 20),
            _buildGradeField(),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildEmployeeIdField() {
    return TextFormField(
      controller: _employeeIdController,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Employee ID',
        hintText: 'Enter your employee ID',
        prefixIcon: const Icon(Icons.badge_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your employee ID';
        }
        return null;
      },
    );
  }

  Widget _buildDepartmentField() {
    return TextFormField(
      controller: _qualificationController,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Department',
        hintText: 'Enter your department',
        prefixIcon: const Icon(Icons.business_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your department';
        }
        return null;
      },
    );
  }

  Widget _buildQualificationField() {
    return TextFormField(
      controller: _qualificationController,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: 'Qualification',
        hintText: 'Enter your highest qualification',
        prefixIcon: const Icon(Icons.school_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your qualification';
        }
        return null;
      },
    );
  }

  Widget _buildSubjectField() {
    return TextFormField(
      controller: _institutionController,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: 'Subject Specialization',
        hintText: 'Enter your subject specialization',
        prefixIcon: const Icon(Icons.book_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your subject specialization';
        }
        return null;
      },
    );
  }

  Widget _buildStudentIdField() {
    return TextFormField(
      controller: _studentIdController,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Student ID',
        hintText: 'Enter your student ID',
        prefixIcon: const Icon(Icons.school_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your student ID';
        }
        return null;
      },
    );
  }

  Widget _buildInstitutionField() {
    return TextFormField(
      controller: _institutionController,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: 'Institution',
        hintText: 'Enter your institution name',
        prefixIcon: const Icon(Icons.location_city_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your institution name';
        }
        return null;
      },
    );
  }

  Widget _buildGradeField() {
    return TextFormField(
      controller: _employeeIdController, // Reusing for grade
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: 'Grade/Class',
        hintText: 'Enter your current grade/class',
        prefixIcon: const Icon(Icons.grade_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your grade/class';
        }
        return null;
      },
    );
  }

  Widget _buildSignupButton(ColorScheme colorScheme) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleSignup,
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
                  'Create Account',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
      ),
    );
  }

  Widget _buildLoginLink(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
        TextButton(style: TextButton.styleFrom(padding: EdgeInsets.zero,),
          onPressed: () {
           GoRouter.of(context).go('/login');
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

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Prepare user metadata based on role
      Map<String, dynamic> metadata = {
        'name': _nameController.text.trim(),
        'role': _selectedRole,
        'phone':
            _phoneController.text.trim().isNotEmpty
                ? _phoneController.text.trim()
                : null,
      };

      // Add role-specific data
      switch (_selectedRole) {
        case 'manager':
          metadata.addAll({
            'employee_id': _employeeIdController.text.trim(),
            'department': _qualificationController.text.trim(),
          });
          break;
        case 'teacher':
          metadata.addAll({
            'employee_id': _employeeIdController.text.trim(),
            'qualification': _qualificationController.text.trim(),
            'subject_specialization': _institutionController.text.trim(),
          });
          break;
        case 'student':
          metadata.addAll({
            'student_id': _studentIdController.text.trim(),
            'institution': _institutionController.text.trim(),
            'grade':
                _employeeIdController.text
                    .trim(), // Reused controller for grade
          });
          break;
      }

      // Create account with Supabase
      // await SupabaseClientService().signUp(
      //   email: _emailController.text.trim(),
      //   password: _passwordController.text.trim(),
      //   role: UserType.student,
      //   additionalData: metadata,
      // );

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Account created successfully! Please check your email for verification.',
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
          ),
        );

        // Navigate back to login
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Signup failed: ${e.toString()}'),
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
}

// Helper class for user role options (same as login screen)
class UserTypeOption {
  final String role;
  final String displayName;
  final IconData icon;
  final Color color;

  UserTypeOption({
    required this.role,
    required this.displayName,
    required this.icon,
    required this.color,
  });
}
