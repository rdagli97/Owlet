import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:owlet/core/constants/app_sizes.dart';
import 'package:owlet/core/constants/app_strings.dart';
import 'package:owlet/core/theme/app_colors.dart';
import 'package:owlet/core/theme/app_text_styles.dart';
import 'package:owlet/providers/auth_provider.dart';
import 'package:owlet/widgets/owlet_button.dart';
import 'package:owlet/widgets/owlet_text_field.dart';

class AuthScreen extends ConsumerStatefulWidget{
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoginMode = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) return;

    final controller = ref.read(authControllerProvider.notifier);
    if (_isLoginMode) {
      await controller.signIn(email, password);
    } else {
      await controller.signUp(email, password); 
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // logo title
              const Icon(
                Icons.nightlight_round,
                color: AppColors.primary,
                size: AppSizes.avatarLg,
              ),
              const SizedBox(height: AppSizes.md),
              // app name text
              Text(
                AppStrings.appName,
                style: AppTextStyles.heading,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSizes.md),
              // email tf
              OwletTextField(
                controller: _emailController,
                hint: AppStrings.email,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: AppSizes.md),
              // password tf
              OwletTextField(
                controller: _passwordController,
                hint: AppStrings.password,
                obscureText: true,
              ),
              const SizedBox(height: AppSizes.md),
              // Error message
              if (authState.errorMessage != null) ...[
                Text(
                  authState.errorMessage!,
                  style: AppTextStyles.caption.copyWith(color: AppColors.error),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: AppSizes.md),
              ],
              // login / signup button
              OwletButton(
                label: _isLoginMode ? AppStrings.login : AppStrings.signUp,
                isLoading: authState.isLoading,
                onPressed: _submit,
              ),
              const SizedBox(height: AppSizes.md),
              TextButton(
                onPressed: () => 
                setState(() => _isLoginMode = !_isLoginMode),
                child: Text(
                  _isLoginMode
                      ? AppStrings.noAccountSignUp
                      : AppStrings.haveAccountLogin,
                  style: AppTextStyles.caption.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}