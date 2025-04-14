import 'product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => (product.price ?? 0.0) * quantity;
  double get totalWeight => (product.weight ?? 0.0) * quantity;
}