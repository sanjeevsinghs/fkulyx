import 'package:get/get.dart';
import 'package:kulyx/features/marketplace/viewmodels/marketplace_viewmodel.dart';

class MarketplaceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MarketplaceViewModel>(() => MarketplaceViewModel());
  }
}
