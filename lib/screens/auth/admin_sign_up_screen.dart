import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/validators.dart';
import '../../services/auth_service.dart';
import '../../services/service_locator.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/auth_layout.dart';
import '../../widgets/gold_button.dart';

/// Cadastro de administrador, aberto pelo botão "Entrar como ADM" do login.
///
/// Nome, e-mail, senha e o código de acesso de administrador. O usuário já é
/// criado como admin e entra direto no painel de produtos.
class AdminSignUpScreen extends StatefulWidget {
  const AdminSignUpScreen({super.key});

  @override
  State<AdminSignUpScreen> createState() => _AdminSignUpScreenState();
}

class _AdminSignUpScreenState extends State<AdminSignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await authService.signUpAdmin(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        adminCode: _codeController.text,
      );

      // O router também redireciona sozinho ao perceber o login.
      if (mounted) context.goNamed(AppRoutes.adminProducts);
    } on AuthException catch (e) {
      _showMessage(e.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: AppStrings.adminSignUpTitle,
      subtitle: AppStrings.adminSignUpSubtitle,
      badge: AppStrings.adminAreaBadge,
      children: <Widget>[
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AppTextField(
                controller: _nameController,
                hintText: AppStrings.nameHint,
                icon: Icons.person_outline,
                textInputAction: TextInputAction.next,
                validator: (value) =>
                    Validators.required(value, field: AppStrings.fieldName),
              ),
              const SizedBox(height: AppSpacing.lg),
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
                textInputAction: TextInputAction.next,
                validator: Validators.password,
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
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                controller: _codeController,
                hintText: AppStrings.adminCodeHint,
                icon: Icons.admin_panel_settings_outlined,
                obscureText: true,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _handleSignUp(),
                validator: (value) => Validators.required(
                  value,
                  field: AppStrings.fieldAdminCode,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              GestureDetector(
                onTap: () => context.goNamed(AppRoutes.adminSignIn),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
                  child: Text(
                    AppStrings.hasAdminAccountLink,
                    style: AppTextStyles.linkStrong,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              GoldButton(
                label: AppStrings.adminSignUpButton,
                isLoading: _isLoading,
                onPressed: _handleSignUp,
              ),
              const SizedBox(height: AppSpacing.md),
              Center(
                child: GestureDetector(
                  onTap: () => context.goNamed(AppRoutes.signIn),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
                    child: Text(
                      AppStrings.customerAreaLink,
                      style: AppTextStyles.link,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
