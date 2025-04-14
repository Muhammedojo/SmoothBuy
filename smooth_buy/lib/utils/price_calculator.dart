import '../model/cart_item.dart';

class PriceCalculator {
  static double calculateDiscount(double subtotal, List<CartItem?> items) {
   
    double discount = 0;
    
    if (subtotal >= 100 && subtotal < 500) {
      discount = subtotal * 0.05;
    } else if (subtotal >= 500 && subtotal < 1000) {
      discount = subtotal * 0.08;
    } else if (subtotal >= 1000) {
      discount = subtotal * 0.12;
    }

   
    bool hasLaptop = items.any((item) => item!.product.name!.toLowerCase().contains('laptop'));
    bool hasHeadphones = items.any((item) => item!.product.name!.toLowerCase().contains('headphones'));
    
    if (hasLaptop && hasHeadphones) {
      discount += subtotal * 0.10;
    }

    return discount;
  }

  static double calculateShipping(double totalWeight, String location) {
   
    double baseFee = 5.0;
    double weightFee = totalWeight * 0.5; // $0.5 per kg
    double locationMultiplier = location == 'remote' ? 1.5 : 1.0;
    
    return (baseFee + weightFee) * locationMultiplier;
  }
}