import 'package:flutter/material.dart';
import '../model/cart_item.dart';
import '../model/product.dart';
import '../screen_views/checkout_view.dart';
import '../utils/price_calculator.dart';

class Checkout extends StatefulWidget {
  

  const Checkout({super.key});

  @override
  CheckoutController createState() => CheckoutController();
}

class CheckoutController extends State<Checkout> {

  //... //Initialization code, state vars etc, all go here
  
 List<CartItem> cartItems = [
    CartItem(
      product:  Product(
        id: '1',
        name: 'Laptop',
        price: 899.99,
        weight: 2.5,
        category: 'Electronics',
      ),
    ),
    CartItem(
      product:  Product(
        id: '2',
        name: 'Headphones',
        price: 99.99,
        weight: 0.3,
        category: 'Electronics',
      ),
    ),
    CartItem(
      product:  Product(
        id: '3',
        name: 'T-Shirt',
        price: 19.99,
        weight: 0.2,
        category: 'Clothing',
      ),
      quantity: 2,
    ),
  ];

 
  double get subtotal =>
      cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get totalWeight =>
      cartItems.fold(0.0, (sum, item) => sum + item.totalWeight);

  double get discount => PriceCalculator.calculateDiscount(subtotal, cartItems);

  double get shipping =>
      PriceCalculator.calculateShipping(totalWeight, selectedLocation);

  double get total => subtotal - discount + shipping;
  

    void removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  setLocation(String location) {
    setState(() {
      selectedLocation = location;
    });
  }
  

  String selectedLocation = 'local';

  void updateQuantity(int index, int newQuantity) {
    setState(() {
      cartItems[index].quantity = newQuantity;
    });
  }

  

  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CheckoutView(this);


}