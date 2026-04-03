import 'package:get/get.dart';
import 'package:kulyx/features/lms/models/treding_product_dataModel.dart';
import 'package:kulyx/network/api_endpoints.dart';
import 'package:kulyx/network/network_api_services.dart';

class TrendingProductsViewModel extends GetxController {
  static const int _firstLoadCount = 6;
  static const int _showMoreStep = 20;
  static const int _apiPageSize = 20;
  static const int _minPrice = 10;
  static const int _maxPrice = 500;
  static const int _minRating = 4;
  static const String _sortOrder = 'asc';

  final NetworkApiServices _api = NetworkApiServices();

  final RxBool isLoading = RxBool(true);
  final RxString error = RxString('');
  final RxInt displayLimit = RxInt(_firstLoadCount);
  final RxInt currentPage = RxInt(1);
  final Rxn<TrendingProductsDataModel> responseModel =
      Rxn<TrendingProductsDataModel>();
  final Rxn<Data> dataModel = Rxn<Data>();
  final Rxn<Pagination> pagination = Rxn<Pagination>();
  final RxList<Product> allProducts = <Product>[].obs;
  final RxList<Product> products = <Product>[].obs;

  bool get hasNextPage => pagination.value?.hasNext ?? false;

  @override
  void onInit() {
    super.onInit();
    loadFirstPage();
  }

  Future<void> loadFirstPage() async {
    currentPage.value = 1;
    displayLimit.value = _firstLoadCount;
    allProducts.clear();
    await fetchTrendingProducts(page: 1);
  }

  Future<void> fetchTrendingProducts({int page = 1}) async {
    isLoading.value = true;
    error.value = '';

    try {
      final url = Uri.parse(ApiEndpoints.products)
          .replace(
            queryParameters: <String, String>{
              'minPrice': '$_minPrice',
              'maxPrice': '$_maxPrice',
              'minRating': '$_minRating',
              'sortOrder': _sortOrder,
              'limit': '$_apiPageSize',
              'page': '$page',
              'isTrending': 'true',
            },
          )
          .toString();

      final response = await _api.getApi(url);

      if (response is! Map<String, dynamic>) {
        throw Exception('Invalid response format: ${response.runtimeType}');
      }

      final model = TrendingProductsDataModel.fromJson(response);

      if (model.success != true) {
        throw Exception(model.message ?? 'Failed to load data');
      }

      responseModel.value = model;
      dataModel.value = model.data;
      pagination.value = model.data?.pagination;

      final newProducts = model.data?.products ?? <Product>[];
      allProducts.addAll(newProducts);
      updateDisplayedProducts();
    } catch (e) {
      error.value = e.toString();
      responseModel.value = null;
      dataModel.value = null;
      pagination.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  void updateDisplayedProducts() {
    if (allProducts.length <= displayLimit.value) {
      products.value = allProducts;
    } else {
      products.value = allProducts.sublist(0, displayLimit.value);
    }
  }

  Future<void> refreshPage() async {
    await loadFirstPage();
  }

  Future<void> loadMoreTrendingProducts() async {
    if (isLoading.value) return;

    displayLimit.value += _showMoreStep;

    while (allProducts.length < displayLimit.value && hasNextPage) {
      currentPage.value += 1;
      await fetchTrendingProducts(page: currentPage.value);

      if (error.value.isNotEmpty) {
        break;
      }
    }

    updateDisplayedProducts();
  }
}
