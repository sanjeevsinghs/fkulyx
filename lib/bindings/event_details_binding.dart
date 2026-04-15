import 'package:get/get.dart';
import 'package:kulyx/view_model/Community_forum/event_details_viewmodel.dart';

class EventDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EventDetailsViewmodel>(() => EventDetailsViewmodel());
  }
}
