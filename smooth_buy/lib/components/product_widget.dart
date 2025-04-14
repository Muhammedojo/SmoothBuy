import 'package:flutter/material.dart';
import '../model/cart_item.dart';

class ProductItem extends StatelessWidget {
  final CartItem item;
  final VoidCallback onRemove;
  final ValueChanged<int> onQuantityChanged;

  const ProductItem({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),)
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              color: Colors.grey[200],
              image: item.product.imageUrl != null 
                  ? DecorationImage(
                      image: NetworkImage(item.product.imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: item.product.imageUrl == null
                ? const Center(child: Icon(Icons.shopping_bag, size: 50, color: Colors.grey))
                : null,
          ),
          
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${item.product.name}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '\$${item.product.price?.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
               
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove, size: 20),
                            color: item.quantity > 1 ? Colors.black87 : Colors.grey,
                            onPressed: () {
                              if (item.quantity > 1) {
                                onQuantityChanged(item.quantity - 1);
                              }
                            },
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              item.quantity.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add, size: 20),
                            color: Colors.black87,
                            onPressed: () {
                              onQuantityChanged(item.quantity + 1);
                            },
                          ),
                        ],
                      ),
                    ),
                    
                    const Spacer(),
                    
                 
                    InkWell(
                      onTap: onRemove,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.delete_outline, 
                                size: 20, color: Colors.red),
                            const SizedBox(width: 4),
                            Text(
                              'Remove',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.red[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5,),
                Row(children: [
                  Text('Total Price : \$${item.totalPrice.toStringAsFixed(2)}',  style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),)
                ],)
              ],
            ),
          ),
        ],
      ),
    );
  }
}