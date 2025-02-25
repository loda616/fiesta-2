import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/theme_provider.dart' show ThemeProvider;
import '../../../domain/entities/user.dart' show User;
import '../../cubit/auth_cubit.dart' show AuthCubit;
import '../../cubit/auth_states.dart' show AuthState, AuthSuccess;
import '../../widgets/custom_button.dart' show CustomButton;
import '../../widgets/error_snackbar.dart' show showErrorSnackBar;


class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final TextEditingController _usernameController = TextEditingController();
  bool _isEditingUsername = false;
  User? _currentUser;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthSuccess) {
      setState(() {
        _currentUser = authState.user;
        _usernameController.text = _currentUser?.username ?? '';
      });
    } else {
      context.read<AuthCubit>().checkAuthState();
    }
  }

  void _handleLogout() async {
    await context.read<AuthCubit>().signOut();
    if (!mounted) return;

    Navigator.pushReplacementNamed(context, '/login');
  }

  void _showResetPasswordDialog() {
    final email = _currentUser?.email ?? '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: Text(
            'We will send a password reset link to ${email.isNotEmpty ? email : "your email address"}. Would you like to continue?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (email.isNotEmpty) {
                context.read<AuthCubit>().resetPassword(email);
              }
              Navigator.pop(context);
              showErrorSnackBar(context, 'Password reset link sent to your email');
            },
            child: const Text('Send Link'),
          ),
        ],
      ),
    );
  }

  void _updateUsername() {
    if (_usernameController.text.trim().isEmpty) {
      showErrorSnackBar(context, 'Username cannot be empty');
      return;
    }

    context.read<AuthCubit>().updateUsername(_usernameController.text);

    setState(() {
      _isEditingUsername = false;
    });

    showErrorSnackBar(context, 'Username updated successfully');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          setState(() {
            _currentUser = state.user;
            _usernameController.text = _currentUser?.username ?? '';
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20.h),
              CircleAvatar(
                radius: 50.r,
                backgroundColor: theme.colorScheme.primary,
                child: Icon(Icons.person, size: 50.r, color: theme.colorScheme.onPrimary),
              ),
              SizedBox(height: 16.h),

              // Username section with edit option
              _isEditingUsername
                  ? Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: _updateUsername,
                    color: theme.colorScheme.primary,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _isEditingUsername = false;
                        _usernameController.text = _currentUser?.username ?? '';
                      });
                    },
                    color: theme.colorScheme.error,
                  ),
                ],
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _currentUser?.username ?? 'Username',
                    style: theme.textTheme.headlineSmall,
                  ),
                  SizedBox(width: 8.w),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      setState(() {
                        _isEditingUsername = true;
                      });
                    },
                    iconSize: 20.r,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ),

              SizedBox(height: 8.h),

              // Email display
              Text(
                _currentUser?.email ?? 'email@example.com',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.tertiary,
                ),
              ),

              SizedBox(height: 32.h),

              // Theme switcher
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Appearance',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Dark Theme',
                          style: theme.textTheme.bodyLarge,
                        ),
                        Switch(
                          value: themeProvider.isDarkMode,
                          onChanged: (value) {
                            themeProvider.toggleTheme();
                          },
                          activeColor: theme.colorScheme.primary,
                        ),
                      ],
                    ),
                    Text(
                      'Current theme: ${themeProvider.themeName}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // Profile menu items
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _ProfileMenuItem(
                      icon: Icons.movie_outlined,
                      title: 'Watched Movies',
                      onTap: () {},
                    ),
                    Divider(height: 1),
                    _ProfileMenuItem(
                      icon: Icons.star_outline,
                      title: 'My Ratings',
                      onTap: () {},
                    ),
                    Divider(height: 1),
                    _ProfileMenuItem(
                      icon: Icons.lock_outline,
                      title: 'Reset Password',
                      onTap: _showResetPasswordDialog,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // Logout button
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  label: 'Logout',
                  onPressed: _handleLogout,
                ),
              ),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}