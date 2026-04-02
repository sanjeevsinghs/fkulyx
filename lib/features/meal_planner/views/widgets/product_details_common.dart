import 'package:flutter/material.dart';

class ProductRatingStars extends StatelessWidget {
  const ProductRatingStars({required this.rating, this.size = 16, super.key});

  final double rating;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(5, (int index) {
        final bool full = index < rating.floor();
        final bool half =
            index == rating.floor() && (rating - rating.floor()) >= 0.5;
        return Icon(
          full
              ? Icons.star
              : half
              ? Icons.star_half
              : Icons.star_outline,
          size: size,
          color: const Color(0xFFE6B422),
        );
      }),
    );
  }
}

class ProductSpecRow extends StatelessWidget {
  const ProductSpecRow({required this.label, required this.value, super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 145,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black54, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
