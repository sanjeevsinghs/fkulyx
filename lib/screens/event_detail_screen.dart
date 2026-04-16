import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kulyx/network/respone_handler.dart';
import 'package:kulyx/screens/community_forum/event_detail_body.dart';
import 'package:kulyx/screens/community_forum/widgets/event_detail_state_widgets.dart';
import 'package:kulyx/view_model/Community_forum/event_details_viewmodel.dart';

class EventDetailScreen extends GetView<EventDetailsViewmodel> {
  const EventDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final response = controller.eventDetailsResponse.value;

      if (response.status == Status.LOADING) {
        return const EventDetailLoadingView();
      }

      if (response.status == Status.ERROR) {
        return EventDetailErrorView(
          message: response.message ?? 'Failed to load event details',
        );
      }

      if (controller.eventData == null) {
        return const EventDetailEmptyView();
      }

      return EventDetailBody(controller: controller);
    });
  }
}
