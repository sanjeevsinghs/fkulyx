import 'package:get/get.dart';
import 'package:kulyx/features/marketplace/models/product_model.dart';

class MarketplaceViewModel extends GetxController {
  final RxList<Product> products = RxList<Product>([]);
  final RxBool isLoading = RxBool(false);
  final RxString searchQuery = RxString('');
  final RxString error = RxString('');

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      error.value = '';

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock data
      products.value = [
        Product(id: '1', name: 'Simmer Pot', price: 'DA129'),
        Product(id: '2', name: 'Steel Pan', price: 'DA198'),
        Product(id: '3', name: 'Chef Knife', price: 'DA315'),
        Product(id: '4', name: 'Spice Set', price: 'DA89'),
      ];
    } catch (e) {
      error.value = 'Failed to load products: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void search(String query) {
    searchQuery.value = query;
  }

  List<Product> get filteredProducts {
    if (searchQuery.isEmpty) return products;
    return products
        .where((p) => p.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
  }
}
