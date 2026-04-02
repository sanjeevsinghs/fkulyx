import 'package:get/get.dart';
import 'package:kulyx/network/api_endpoints.dart';
import 'package:kulyx/network/network_api_services.dart';
import 'package:kulyx/widgets/app_snackbar.dart';

class ProductDetailsController extends GetxController {
  final NetworkApiServices _api = NetworkApiServices();

  final Rxn<Map<String, dynamic>> product = Rxn<Map<String, dynamic>>();
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;
  final RxInt selectedImageIndex = 0.obs;
  final RxInt selectedQuantity = 1.obs;
  final RxString selectedSize = ''.obs;

  late final Map<String, dynamic> _args;

  @override
  void onInit() {
    super.onInit();
    final dynamic args = Get.arguments;
    _args = args is Map<String, dynamic> ? args : <String, dynamic>{};
    _loadProduct();
  }

  String _asString(dynamic value, {String fallback = ''}) {
    final String text = value?.toString() ?? '';
    return text.isEmpty ? fallback : text;
  }

  int _asInt(dynamic value, {int fallback = 0}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  double _asDouble(dynamic value, {double fallback = 0}) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? fallback;
  }

  List<dynamic> _asList(dynamic value) {
    return value is List ? value : <dynamic>[];
  }

  Map<String, dynamic> _asMap(dynamic value) {
    return value is Map<String, dynamic> ? value : <String, dynamic>{};
  }

  Map<String, dynamic> _findVariantGroup(String keyword) {
    final List<dynamic> attributes = _asList(productData['variantAttributes']);
    final dynamic match = attributes.firstWhere((dynamic entry) {
      final Map<String, dynamic> map = _asMap(entry);
      return _asString(map['attributeName']).toLowerCase().contains(keyword);
    }, orElse: () => <String, dynamic>{});
    return _asMap(match);
  }

  Future<void> _loadProduct() async {
    final String productId = _asString(_args['productId']);

    if (productId.isEmpty) {
      error.value = 'Missing product id';
      isLoading.value = false;
      return;
    }

    try {
      final dynamic response = await _api.getApi(
        '${ApiEndpoints.base}/products/$productId',
      );

      if (response is Map<String, dynamic> && response['success'] == true) {
        final Map<String, dynamic> parsed = _asMap(response['data']);
        product.value = parsed;
        final List<dynamic> sizes = _asList(
          _findVariantGroup('size')['values'],
        );
        selectedSize.value = sizes.isNotEmpty
            ? _asString(_asMap(sizes.first)['displayValue'])
            : '';
      } else {
        error.value = response is Map<String, dynamic>
            ? _asString(response['message'], fallback: 'Failed to load product')
            : 'Failed to load product';
      }
    } catch (e) {
      error.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, dynamic> get productData => product.value ?? <String, dynamic>{};

  List<Map<String, dynamic>> get images {
    final Map<String, dynamic> defaultVariant = _asMap(
      _asMap(productData['variantSummary'])['defaultVariant'],
    );
    final List<dynamic> variantImages = _asList(defaultVariant['images']);
    return variantImages
        .map(_asMap)
        .where((Map<String, dynamic> map) => map.isNotEmpty)
        .toList();
  }

  String get displayImage {
    if (images.isNotEmpty && selectedImageIndex.value < images.length) {
      return _asString(images[selectedImageIndex.value]['url']);
    }
    return _asString(_args['imageUrl']);
  }

  String get name => _asString(productData['name'], fallback: 'Product');

  int get soldCount => _asInt(
    productData['totalUnitsSold'],
    fallback: _asInt(productData['soldCount']),
  );

  double get avgRating => _asDouble(productData['averageRating']);

  int get reviewCount => _asInt(productData['reviewCount']);

  Map<String, dynamic> get seller => _asMap(productData['seller']);

  String get sellerName {
    if (productData['sellerName'] != null) {
      return _asString(productData['sellerName']);
    }
    return _asString(
      seller['username'] ?? seller['firstName'],
      fallback: 'Culinary Store',
    );
  }

  String get productId => _asString(productData['_id']);

  Map<String, dynamic> get defaultVariant {
    return _asMap(_asMap(productData['variantSummary'])['defaultVariant']);
  }

  double get price => _asDouble(defaultVariant['price']);

  double get mrp => _asDouble(defaultVariant['mrp'], fallback: price);

  int get stock => _asInt(defaultVariant['stock']);

  int get discount {
    if (mrp > 0 && mrp > price) {
      return ((mrp - price) / mrp * 100).round();
    }
    return 0;
  }

  List<dynamic> get colorValues =>
      _asList(_findVariantGroup('color')['values']);

  List<dynamic> get sizeValues => _asList(_findVariantGroup('size')['values']);

  List<dynamic> get variantAttrs => _asList(defaultVariant['attributes']);

  List<dynamic> get specifications => _asList(defaultVariant['specifications']);

  List<dynamic> get aboutList => _asList(productData['aboutDescription']);

  Map<String, dynamic> get breakdown =>
      _asMap(_asMap(productData['ratingSummary'])['breakdown']);

  List<dynamic> get reviews => _asList(productData['reviews']);

  List<List<dynamic>> get ratingRows => <List<dynamic>>[
    <dynamic>['5', _asInt(breakdown['fiveStar'])],
    <dynamic>['4', _asInt(breakdown['fourStar'])],
    <dynamic>['3', _asInt(breakdown['threeStar'])],
    <dynamic>['2', _asInt(breakdown['twoStar'])],
    <dynamic>['1', _asInt(breakdown['oneStar'])],
  ];

  String valueAsString(dynamic value, {String fallback = ''}) {
    return _asString(value, fallback: fallback);
  }

  int valueAsInt(dynamic value, {int fallback = 0}) {
    return _asInt(value, fallback: fallback);
  }

  double valueAsDouble(dynamic value, {double fallback = 0}) {
    return _asDouble(value, fallback: fallback);
  }

  void selectImage(int index) {
    selectedImageIndex.value = index;
  }

  void selectQuantity(int quantity) {
    selectedQuantity.value = quantity;
  }

  void selectSize(String size) {
    selectedSize.value = size;
  }

  void addToCart() {
    AppSnackbar.show('$name x${selectedQuantity.value} added to cart');
  }
}
