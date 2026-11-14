import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/routes/app_routes.dart';
import '../services/service_locator.dart';
import 'shop_drawer.dart';
import 'shop_header.dart';

/// Estrutura das telas da loja (Home, Produto, Carrinho): menu lateral,
/// cabeçalho com busca e carrinho, e o conteúdo abaixo.
///
/// Na Home, a busca filtra a vitrine na hora (`onSearchChanged`). Nas outras
/// telas, ao enviar a busca o usuário volta à Home já filtrada.
class ShopScaffold extends StatefulWidget {
  const ShopScaffold({
    required this.body,
    this.searchController,
    this.onSearchChanged,
    this.onCartTap,
    super.key,
  });

  final Widget body;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onCartTap;

  @override
  State<ShopScaffold> createState() => _ShopScaffoldState();
}

class _ShopScaffoldState extends State<ShopScaffold> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final TextEditingController _controller;
  late final bool _ownsController;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.searchController == null;
    _controller = widget.searchController ?? TextEditingController();
  }

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  void _openCart() {
    final VoidCallback? custom = widget.onCartTap;
    if (custom != null) {
      custom();
    } else {
      context.pushNamed(AppRoutes.cart);
    }
  }

  void _submitSearch(String text) {
    context.goNamed(
      AppRoutes.home,
      queryParameters: <String, String>{'q': text.trim()},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const ShopDrawer(),
      // O cabeçalho escuro cuida da área da barra de status.
      body: SafeArea(
        top: false,
        child: Column(
          children: <Widget>[
            ListenableBuilder(
              listenable: cartService,
              builder: (context, _) => ShopHeader(
                onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
                onCartTap: _openCart,
                searchController: _controller,
                cartCount: cartService.totalQuantity,
                onSearchChanged: widget.onSearchChanged,
                onSearchSubmitted: widget.onSearchChanged == null
                    ? _submitSearch
                    : null,
              ),
            ),
            Expanded(child: widget.body),
          ],
        ),
      ),
    );
  }
}
