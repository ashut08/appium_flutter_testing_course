import 'package:appiumtesting/appium_key.dart';
import 'package:appiumtesting/shop/shop_product_detail_page.dart';
import 'package:flutter/material.dart';

import 'shop_store.dart';

/// Covers: loading, a scrolling list, opening a product, the cart badge,
/// an alert (tap the cart) and a popup menu (Clear cart, Logout).
class ShopProductsPage extends StatefulWidget {
  const ShopProductsPage({super.key});

  @override
  State<ShopProductsPage> createState() => _ShopProductsPageState();
}

class _ShopProductsPageState extends State<ShopProductsPage> {
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    // Simulated network load
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    setState(() => _loaded = true);
  }

  // ALERT: a dialog with a message and one OK button.
  void _showCartAlert(int count) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        key: const ValueKey('cart_dialog'),
        title: const Text('Your cart'),
        content: Text(
          'You have $count ${count == 1 ? 'item' : 'items'} in your cart.',
          key: const ValueKey('cart_dialog_message'),
        ),
        actions: [
          TextButton(
            key: const ValueKey('cart_dialog_ok'),
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // POPUP: what happens when an item in the menu is chosen.
  void _onMenuSelected(String value) {
    switch (value) {
      case 'clear_cart':
        ShopStore.clearCart();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products', key: ValueKey('products_title')),
        actions: [
          // Tap the cart to open the ALERT.
          ValueListenableBuilder<int>(
            valueListenable: ShopStore.cartCount,
            builder: (context, count, _) => IconButton(
              key: const ValueKey('cart_button'),
              tooltip: 'Cart',
              onPressed: () => _showCartAlert(count),
              icon: Badge(
                label: Text('$count', key: const ValueKey('cart_count')),
                child: const Icon(Icons.shopping_cart),
              ),
            ),
          ),
          // The three-dot menu is the POPUP.
          PopupMenuButton<String>(
            key: const ValueKey('menu_button'),
            tooltip: 'Menu',
            onSelected: _onMenuSelected,
            itemBuilder: (context) => const [
              PopupMenuItem<String>(
                key: ValueKey('menu_clear_cart'),
                value: 'clear_cart',
                child: Text('Clear cart'),
              ),
              PopupMenuItem<String>(
                key: ValueKey('menu_logout'),
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
          ),
        ],
      ),
      body: !_loaded
          ? const Center(
              child: CircularProgressIndicator(
                key: ValueKey('products_loading'),
              ),
            )
          : _productList(),
    );
  }

  Widget _productList() {
    return ValueListenableBuilder<List<ShopProduct>>(
      valueListenable: ShopStore.products,
      builder: (context, products, _) => ListView.builder(
        key: const ValueKey(AppiumKey.productList),
        itemCount: products.length,
        itemBuilder: (context, i) {
          final p = products[i];
          return ListTile(
            key: ValueKey('product_${p.id}'),
            leading: CircleAvatar(child: Text('${p.id}')),
            title: Text(p.name),
            subtitle: Text('₹${p.price}'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ShopProductDetailsPage(product: p),
              ),
            ),
          );
        },
      ),
    );
  }
}
