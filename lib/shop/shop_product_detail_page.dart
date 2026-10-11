import 'package:flutter/material.dart';

import 'shop_store.dart';

/// Covers: reading exact text, a quantity stepper (the counter, now with a
/// purpose), and a confirmation dialog with Cancel and Delete.
class ShopProductDetailsPage extends StatefulWidget {
  const ShopProductDetailsPage({super.key, required this.product});

  final ShopProduct product;

  @override
  State<ShopProductDetailsPage> createState() => _ShopProductDetailsPageState();
}

class _ShopProductDetailsPageState extends State<ShopProductDetailsPage> {
  int _quantity = 1;

  void _addToCart() {
    ShopStore.addToCart(_quantity);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Added $_quantity × ${widget.product.name} to cart'),
        ),
      );
  }

  Future<void> _confirmDelete() async {
    final product = widget.product;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        key: const ValueKey('delete_dialog'),
        title: Text('Delete ${product.name}?'),
        content: const Text('This removes the product from the list.'),
        actions: [
          TextButton(
            key: const ValueKey('cancel_button'),
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            key: const ValueKey('confirm_delete_button'),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      ShopStore.remove(product);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              p.name,
              key: const ValueKey('product_name'),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text('Product ID: ${p.id}', key: const ValueKey('product_code')),
            const SizedBox(height: 8),
            Text(
              '₹${p.price}',
              key: const ValueKey('product_price'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filledTonal(
                  key: const ValueKey('qty_decrement'),
                  tooltip: 'Decrease quantity',
                  onPressed: _quantity > 1
                      ? () => setState(() => _quantity--)
                      : null,
                  icon: const Icon(Icons.remove),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    '$_quantity',
                    key: const ValueKey('quantity'),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                IconButton.filledTonal(
                  key: const ValueKey('qty_increment'),
                  tooltip: 'Increase quantity',
                  onPressed: () => setState(() => _quantity++),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              key: const ValueKey('add_to_cart'),
              onPressed: _addToCart,
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Add to cart'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              key: const ValueKey('delete_button'),
              onPressed: _confirmDelete,
              icon: const Icon(Icons.delete_outline),
              label: const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}
