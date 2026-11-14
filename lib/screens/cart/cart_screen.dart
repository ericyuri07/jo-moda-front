import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_sizes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/validators.dart';
import '../../models/cart_item.dart';
import '../../models/cep_address.dart';
import '../../models/delivery_address.dart';
import '../../services/api_exception.dart';
import '../../services/service_locator.dart';
import '../../widgets/app_card.dart';
import '../../widgets/cart_item_tile.dart';
import '../../widgets/delivery_toggle.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/gold_button.dart';
import '../../widgets/labeled_field.dart';
import '../../widgets/section_header.dart';
import '../../widgets/shop_scaffold.dart';
import '../../widgets/summary_row.dart';

/// Carrinho (fluxograma: 5 e 6): itens, Entrega/Retirada, endereço com busca
/// de CEP, resumo e envio do pedido por WhatsApp.
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _neighborhoodController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _complementController = TextEditingController();
  final TextEditingController _referenceController = TextEditingController();

  bool _isDelivery = true;
  bool _isLookingUpCep = false;
  String? _city;

  @override
  void dispose() {
    _cepController.dispose();
    _streetController.dispose();
    _numberController.dispose();
    _neighborhoodController.dispose();
    _stateController.dispose();
    _complementController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _onCepChanged(String value) {
    final String digits = Formatters.digitsOnly(value);
    if (digits.length == Validators.cepLength) _lookupCep(digits);
  }

  Future<void> _lookupCep(String digits) async {
    setState(() => _isLookingUpCep = true);

    try {
      final CepAddress address = await addressService.lookup(digits);
      if (!mounted) return;

      setState(() {
        _streetController.text = address.street;
        _neighborhoodController.text = address.neighborhood;
        _stateController.text = address.state;
        _city = address.city;
      });
    } on ApiException catch (e) {
      _showMessage(e.message);
    } finally {
      if (mounted) setState(() => _isLookingUpCep = false);
    }
  }

  String? _optional(TextEditingController controller) {
    final String text = controller.text.trim();
    return text.isEmpty ? null : text;
  }

  Future<void> _sendOrder() async {
    if (cartService.isEmpty) return;

    DeliveryAddress? address;
    if (_isDelivery) {
      if (!_formKey.currentState!.validate()) return;

      address = DeliveryAddress(
        cep: Formatters.cep(Formatters.digitsOnly(_cepController.text)),
        street: _streetController.text.trim(),
        number: _numberController.text.trim(),
        neighborhood: _neighborhoodController.text.trim(),
        state: _stateController.text.trim().toUpperCase(),
        city: _city,
        complement: _optional(_complementController),
        reference: _optional(_referenceController),
      );
    }

    final String message = whatsappService.buildMessage(
      customerName: authService.currentUser?.name ?? '',
      items: cartService.items,
      total: cartService.subtotal,
      address: address,
    );

    final bool opened = await whatsappService.send(message);
    if (!opened) _showMessage(AppStrings.whatsappError);
  }

  @override
  Widget build(BuildContext context) {
    return ShopScaffold(
      // Já estamos no carrinho: tocar no ícone não faz nada.
      onCartTap: () {},
      body: ListenableBuilder(
        listenable: cartService,
        builder: (context, _) {
          if (cartService.isEmpty) {
            return EmptyState(
              icon: Icons.shopping_bag_outlined,
              message: AppStrings.cartEmpty,
              actionLabel: AppStrings.continueShopping,
              onAction: () => context.goNamed(AppRoutes.home),
            );
          }
          return _buildContent();
        },
      ),
    );
  }

  Widget _buildContent() {
    final List<CartItem> items = cartService.items;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.xl,
        AppSpacing.screenPadding,
        AppSpacing.xxl,
      ),
      children: <Widget>[
        SectionHeader(
          AppStrings.cartTitle,
          trailing: AppStrings.cartItemsCount(cartService.totalQuantity),
        ),
        const SizedBox(height: AppSpacing.lg),
        for (final CartItem item in items) ...<Widget>[
          CartItemTile(
            item: item,
            onQuantityChanged: (quantity) =>
                cartService.setQuantity(item.variantId, quantity),
            onRemove: () => cartService.remove(item.variantId),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        const SizedBox(height: AppSpacing.md),
        DeliveryToggle(
          isDelivery: _isDelivery,
          onChanged: (value) => setState(() => _isDelivery = value),
        ),
        const SizedBox(height: AppSpacing.lg),
        if (_isDelivery) _buildAddressForm() else _buildPickupNotice(),
        const SizedBox(height: AppSpacing.xl),
        _buildSummary(),
        const SizedBox(height: AppSpacing.md),
        TextButton.icon(
          onPressed: () => context.goNamed(AppRoutes.home),
          icon: const Icon(Icons.arrow_back),
          label: const Text(AppStrings.continueShopping),
        ),
      ],
    );
  }

  /// Resumo em card escuro da marca, com o total em dourado e o envio.
  Widget _buildSummary() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.authBackground,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: AppShadows.raised,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppStrings.summary,
            style: AppTextStyles.sectionHeading.copyWith(
              color: AppColors.textOnDark,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SummaryRow(
            label: AppStrings.subtotal,
            value: Formatters.currency(cartService.subtotal),
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(color: AppColors.goldBorder),
          const SizedBox(height: AppSpacing.md),
          SummaryRow(
            label: AppStrings.total,
            value: Formatters.currency(cartService.subtotal),
            highlight: true,
          ),
          const SizedBox(height: AppSpacing.xl),
          GoldButton(label: AppStrings.sendWhatsapp, onPressed: _sendOrder),
        ],
      ),
    );
  }

  Widget _buildPickupNotice() {
    return const AppCard(
      color: AppColors.goldSoft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.storefront_outlined, color: AppColors.goldDark),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(AppStrings.pickupNotice, style: AppTextStyles.body),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressForm() {
    return AppCard(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Row(
              children: <Widget>[
                Icon(Icons.location_on_outlined, color: AppColors.goldDark),
                SizedBox(width: AppSpacing.sm),
                Text(
                  AppStrings.deliveryAddressTitle,
                  style: AppTextStyles.sectionTitle,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            LabeledField(
              label: AppStrings.cepLabel,
              hintText: AppStrings.cepHint,
              controller: _cepController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(Validators.cepLength),
              ],
              onChanged: _onCepChanged,
              validator: Validators.cep,
              suffix: _isLookingUpCep
                  ? const Padding(
                      padding: EdgeInsets.all(AppSpacing.md),
                      child: SizedBox(
                        width: AppSizes.spinner,
                        height: AppSizes.spinner,
                        child: CircularProgressIndicator(
                          strokeWidth: AppSizes.borderWidthSelected,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: AppSpacing.lg),
            LabeledField(
              label: AppStrings.streetLabel,
              hintText: AppStrings.streetHint,
              controller: _streetController,
              validator: (value) =>
                  Validators.required(value, field: AppStrings.fieldAddress),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: LabeledField(
                    label: AppStrings.numberLabel,
                    hintText: AppStrings.numberHint,
                    controller: _numberController,
                    validator: (value) => Validators.required(
                      value,
                      field: AppStrings.fieldNumber,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: LabeledField(
                    label: AppStrings.stateLabel,
                    hintText: AppStrings.stateHint,
                    controller: _stateController,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(Validators.ufLength),
                    ],
                    validator: Validators.uf,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            LabeledField(
              label: AppStrings.neighborhoodLabel,
              hintText: AppStrings.neighborhoodHint,
              controller: _neighborhoodController,
              validator: (value) => Validators.required(
                value,
                field: AppStrings.fieldNeighborhood,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            LabeledField(
              label: AppStrings.complementLabel,
              hintText: AppStrings.complementHint,
              controller: _complementController,
            ),
            const SizedBox(height: AppSpacing.lg),
            LabeledField(
              label: AppStrings.referenceLabel,
              controller: _referenceController,
            ),
          ],
        ),
      ),
    );
  }
}
