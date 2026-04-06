import 'package:flutter/material.dart';
import 'package:kulyx/features/meal_planner/models/index.dart';

class CartItemWidget extends StatelessWidget {
  const CartItemWidget({
    super.key,
    required this.item,
    required this.onRemove,
    required this.onQuantityChange,
  });

  final CartItem item;
  final VoidCallback onRemove;
  final Function(int) onQuantityChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFD3D3D3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: Container(
                  width: 76,
                  height: 76,
                  color: const Color(0xFFF0F0F0),
                  child: item.imageUrl.isNotEmpty
                      ? Image.network(
                          item.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.image_not_supported,
                              color: Colors.grey[400],
                            );
                          },
                        )
                      : Icon(
                          Icons.image_not_supported,
                          color: Colors.grey[400],
                        ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.productName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.2,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF181818),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'DA${item.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111111),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Text(
                          'In Stock',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF4CAF50),
                          ),
                        ),
                        const SizedBox(width: 7),
                        Text(
                          'Seller: Kuilyx',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Product ID: ${item.productId.length > 8 ? item.productId.substring(0, 8).toUpperCase() : item.productId.toUpperCase()}',
                      style: TextStyle(fontSize: 10, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Colour: Orange  |  Size: Small',
                      style: TextStyle(fontSize: 10, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: Color(0xFFE3E3E3)),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFD5D5D5)),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        if (item.quantity > 1) {
                          onQuantityChange(item.quantity - 1);
                        }
                      },
                      child: const SizedBox(
                        width: 28,
                        height: 28,
                        child: Icon(Icons.remove, size: 16),
                      ),
                    ),
                    Container(
                      width: 32,
                      height: 28,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        border: Border.symmetric(
                          vertical: BorderSide(color: Color(0xFFD5D5D5)),
                        ),
                      ),
                      child: Text(
                        '${item.quantity}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => onQuantityChange(item.quantity + 1),
                      child: const SizedBox(
                        width: 28,
                        height: 28,
                        child: Icon(Icons.add, size: 16),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              _ActionText(label: 'Save for later', onTap: () {}),
              const SizedBox(width: 8),
              Text(
                '|',
                style: TextStyle(color: Colors.grey[400], fontSize: 11),
              ),
              const SizedBox(width: 8),
              _ActionText(label: 'Remove', onTap: onRemove),
              const SizedBox(width: 8),
              Text(
                '|',
                style: TextStyle(color: Colors.grey[400], fontSize: 11),
              ),
              const SizedBox(width: 8),
              _ActionText(label: 'Share', onTap: () {}),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text(
                'Delivery by 10 June 2025, Tue',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF222222),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F4F4),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0xFFE2E2E2)),
                ),
                child: const Text(
                  'Save 10%  Change',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4B4B4B),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionText extends StatelessWidget {
  const _ActionText({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: Color(0xFF222222),
        ),
      ),
    );
  }
}
