import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jo_modas/core/constants/app_strings.dart';
import 'package:jo_modas/core/theme/app_theme.dart';
import 'package:jo_modas/core/utils/validators.dart';
import 'package:jo_modas/screens/auth/sign_in_screen.dart';

void main() {
  Future<void> pumpSignIn(WidgetTester tester) {
    return tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: const SignInScreen()),
    );
  }

  testWidgets('Login mostra título, campos e botão', (tester) async {
    await pumpSignIn(tester);

    expect(find.text(AppStrings.loginTitle), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text(AppStrings.signInButton), findsOneWidget);
    expect(find.text(AppStrings.adminAccessButton), findsOneWidget);
  });

  testWidgets('Login vazio mostra os erros de validação', (tester) async {
    await pumpSignIn(tester);

    await tester.tap(find.text(AppStrings.signInButton));
    await tester.pump();

    expect(find.text(Validators.email('')!), findsOneWidget);
    expect(
      find.text(Validators.required('', field: AppStrings.fieldPassword)!),
      findsOneWidget,
    );
  });
}
