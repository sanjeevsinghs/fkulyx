import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kulyx/network/network_api_services.dart';
import 'package:kulyx/network/api_endpoints.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({super.key});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  late String productId;
  Map<String, dynamic>? productData;
  bool isLoading = true;
  String? errorMessage;
  int selectedQuantity = 1;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    productId =
        (args is Map<String, dynamic> ? args['productId'] : null)?.toString() ??
        '';
    _fetchProductDetails();
  }

  Future<void> _fetchProductDetails() async {
    try {
      final response = await NetworkApiServices().getApi(
        '${ApiEndpoints.base}/products/$productId',
      );

      setState(() {
        if (response is Map<String, dynamic> && response['success'] == true) {
          productData = response['data'];
          isLoading = false;
        } else {
          errorMessage = response is Map
              ? response['message']
              : 'Failed to load product';
          isLoading = false;
        }
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag, color: Color(0xFFFF6A00)),
            onPressed: () {},
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text('Error: $errorMessage'))
          : productData == null
          ? const Center(child: Text('Product not found'))
          : _buildProductDetails(),
    );
  }

  Widget _buildProductDetails() {
    final name = productData?['name']?.toString() ?? '';
    final description = productData?['description']?.toString() ?? '';
    final avgRating =
        (productData?['averageRating'] as num?)?.toDouble() ?? 0.0;
    final reviewCount = productData?['reviewCount'] as int? ?? 0;
    final categoryName = productData?['category']?['name']?.toString() ?? '';

    final defaultVariant = productData?['variantSummary']?['defaultVariant'];
    final price = (defaultVariant?['price'] as num?)?.toDouble() ?? 0.0;
    final mrp = (defaultVariant?['mrp'] as num?)?.toDouble() ?? price;
    final stock = defaultVariant?['stock'] as int? ?? 0;
    final imageUrl = (defaultVariant?['images'] as List?)?.isNotEmpty == true
        ? defaultVariant?['images'][0]?['url']?.toString() ?? ''
        : '';
    final soldCount = defaultVariant?['soldCount'] as int? ?? 0;

    final seller = productData?['seller'];
    final sellerName = seller?['username']?.toString() ?? 'Seller';

    final discount = mrp > price ? ((1 - (price / mrp)) * 100).toInt() : 0;

    return ListView(
      children: [
        // Image Section
        if (imageUrl.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imageUrl,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 250,
                color: Colors.grey[200],
                child: const Center(child: Icon(Icons.image_not_supported)),
              ),
            ),
          ),

        // Image Thumbnails placeholder
        if (imageUrl.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                for (int i = 0; i < 3; i++)
                  Container(
                    width: 60,
                    height: 60,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Container(color: Colors.grey[200]),
                      ),
                    ),
                  ),
              ],
            ),
          ),

        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title & Category
              Text(
                categoryName,
                style: const TextStyle(fontSize: 13, color: Color(0xFF585757)),
              ),
              const SizedBox(height: 6),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),

              // Sold Count & Share
              Row(
                children: [
                  Text(
                    '$soldCount units sold',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFF15B2A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    '👉 Share',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFF15B2A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Rating
              Row(
                children: [
                  Row(
                    children: List.generate(5, (index) {
                      final isFilled = index < avgRating.floor();
                      final isHalf =
                          index == avgRating.floor() && avgRating % 1 >= 0.5;
                      return Icon(
                        isFilled
                            ? Icons.star
                            : isHalf
                            ? Icons.star_half
                            : Icons.star_outline,
                        size: 14,
                        color: isFilled || isHalf
                            ? const Color(0xFFFFBF00)
                            : const Color(0xFFFFBF00),
                      );
                    }),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$avgRating ($reviewCount reviews)',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF8D8D8D),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Price Section
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'DA${price.toStringAsFixed(price % 1 == 0 ? 0 : 2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'DA${mrp.toStringAsFixed(mrp % 1 == 0 ? 0 : 2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$discount%',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Stock Status
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: stock > 0 ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  stock > 0 ? '✓ In Stock' : 'Out of Stock',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Seller Info
              Row(
                children: [
                  const Text(
                    'Seller: ',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  Text(
                    sellerName,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Product ID: $productId',
                    style: const TextStyle(fontSize: 11, color: Colors.black54),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Quantity Selector
              const Text(
                'Quantity',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: selectedQuantity > 1
                          ? () => setState(() => selectedQuantity--)
                          : null,
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          selectedQuantity.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => setState(() => selectedQuantity++),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6A00),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Get.snackbar(
                      'Added',
                      '$name added to cart (Qty: $selectedQuantity)',
                    );
                  },
                  child: const Text(
                    'Add to Cart',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFFF6A00)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Buy Now',
                    style: TextStyle(
                      color: Color(0xFFFF6A00),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Chat with Seller',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Product Description
              if (description.isNotEmpty) ...[
                const Text(
                  'Product Description',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
