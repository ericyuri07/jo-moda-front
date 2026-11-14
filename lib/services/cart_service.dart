import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_config.dart';
import '../models/cart_item.dart';

/// Carrinho local: guardado no aparelho (`shared_preferences`), sem passar
/// pelo back-end. É um `ChangeNotifier` para que cabeçalho, carrinho e demais
/// telas se atualizem sozinhos.
class CartService extends ChangeNotifier {
  static const String _storageKey = 'cart_items';

  final List<CartItem> _items = <CartItem>[];

  List<CartItem> get items => List<CartItem>.unmodifiable(_items);

  bool get isEmpty => _items.isEmpty;

  int get totalQuantity => _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => _items.fold(0, (sum, item) => sum + item.lineTotal);

  /// Lê o carrinho salvo. Chamado uma vez ao abrir o app.
  Future<void> load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(_storageKey);
    if (raw == null) return;

    try {
      final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
      _items
        ..clear()
        ..addAll(
          decoded.map((e) => CartItem.fromJson(e as Map<String, dynamic>)),
        );
    } on Object {
      _items.clear();
    }
    notifyListeners();
  }

  /// Adiciona ao carrinho. Se a variação já existe, soma as quantidades
  /// (respeitando o estoque).
  Future<void> add(CartItem item) async {
    final int index = _items.indexWhere((i) => i.variantId == item.variantId);

    if (index == -1) {
      _items.add(item.copyWith(quantity: _clamp(item.quantity, item.stock)));
    } else {
      final CartItem current = _items[index];
      _items[index] = current.copyWith(
        quantity: _clamp(current.quantity + item.quantity, item.stock),
      );
    }
    await _persist();
  }

  Future<void> setQuantity(String variantId, int quantity) async {
    final int index = _items.indexWhere((i) => i.variantId == variantId);
    if (index == -1) return;

    final CartItem current = _items[index];
    _items[index] = current.copyWith(quantity: _clamp(quantity, current.stock));
    await _persist();
  }

  Future<void> remove(String variantId) async {
    _items.removeWhere((i) => i.variantId == variantId);
    await _persist();
  }

  Future<void> clear() async {
    _items.clear();
    await _persist();
  }

  int _clamp(int quantity, int stock) {
    final int max = stock > 0 && stock < AppConfig.maxQuantity
        ? stock
        : AppConfig.maxQuantity;
    return quantity.clamp(1, max);
  }

  Future<void> _persist() async {
    notifyListeners();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _storageKey,
      jsonEncode(_items.map((i) => i.toJson()).toList()),
    );
  }
}
