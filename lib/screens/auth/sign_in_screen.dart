import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/validators.dart';
import '../../services/auth_exception.dart';
import '../../services/service_locator.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/auth_layout.dart';
import '../../widgets/primary_button.dart';

/// Tela de login (fluxograma: 1).
class SignInScreen extends StatefulWidget {
  const SignInScreen({this.returnPath, super.key});

  /// Tela da loja para onde voltar (ex.: o carrinho). Sem ela, vai à Home.
  final String? returnPath;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await authService.signIn(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (mounted) _backToShop();
    } on AuthException catch (e) {
      _showMessage(e.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _backToShop() => context.go(widget.returnPath ?? AppRoutes.homePath);

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: AppStrings.loginTitle,
      subtitle: widget.returnPath == AppRoutes.cartPath
          ? AppStrings.signInToOrder
          : AppStrings.signInSubtitle,
      onBack: _backToShop,
      children: <Widget>[
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AppTextField(
                controller: _emailController,
                hintText: AppStrings.emailHint,
                icon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: Validators.email,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                controller: _passwordController,
                hintText: AppStrings.passwordHint,
                icon: Icons.vpn_key_outlined,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _handleSignIn(),
                validator: (value) =>
                    Validators.required(value, field: AppStrings.fieldPassword),
                suffixIcon: IconButton(
                  tooltip: AppStrings.showPassword,
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: AppSizes.iconSm,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              GestureDetector(
                onTap: () => context.goNamed(
                  AppRoutes.signUp,
                  queryParameters: AppRoutes.returnTo(widget.returnPath),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
                  child: Text(
                    AppStrings.noAccountLink,
                    style: AppTextStyles.linkStrong,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              PrimaryButton(
                label: AppStrings.signInButton,
                isLoading: _isLoading,
                onPressed: _handleSignIn,
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                height: AppSizes.buttonHeight,
                child: OutlinedButton.icon(
                  onPressed: _isLoading
                      ? null
                      : () => context.goNamed(AppRoutes.adminSignIn),
                  icon: const Icon(
                    Icons.admin_panel_settings_outlined,
                    size: AppSizes.iconSm,
                  ),
                  label: const Text(AppStrings.adminAccessButton),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
