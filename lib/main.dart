import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app.dart';
import 'services/service_locator.dart';

/// Ponto de entrada: tudo o que precisa acontecer **antes** da primeira tela
/// fica aqui. A árvore de widgets em si fica em `app.dart`.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Sem isso, formatações em pt_BR (moeda, datas) podem lançar exceção.
  await initializeDateFormatting('pt_BR');

  // Carrinho salvo no aparelho e login restaurado (se houver token válido).
  await cartService.load();
  await authService.restoreSession();

  runApp(const JoModasApp());
}
