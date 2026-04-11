class ForumEvent {
  final String id;
  final String name;
  final String coverImage;
  final String eventType;
  final String eventFormat;
  final ForumEventLocation location;
  final String timezone;
  final DateTime? startDateTime;
  final String description;
  final int attendeeCount;
  final int shares;
  final bool isActive;
  final bool isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ForumEvent({
    required this.id,
    required this.name,
    required this.coverImage,
    required this.eventType,
    required this.eventFormat,
    required this.location,
    required this.timezone,
    required this.startDateTime,
    required this.description,
    required this.attendeeCount,
    required this.shares,
    required this.isActive,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ForumEvent.fromJson(Map<String, dynamic> json) {
    return ForumEvent(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      coverImage: json['coverImage']?.toString() ?? '',
      eventType: json['eventType']?.toString() ?? '',
      eventFormat: json['eventFormat']?.toString() ?? '',
      location: ForumEventLocation.fromJson(
        (json['location'] as Map<String, dynamic>?) ??
            const <String, dynamic>{},
      ),
      timezone: json['timezone']?.toString() ?? '',
      startDateTime: _parseDateTime(json['startDateTime']),
      description: json['description']?.toString() ?? '',
      attendeeCount: (json['attendeeCount'] as num?)?.toInt() ?? 0,
      shares: (json['shares'] as num?)?.toInt() ?? 0,
      isActive: json['isActive'] == true,
      isDeleted: json['isDeleted'] == true,
      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
    );
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) {
      return null;
    }

    return DateTime.tryParse(value.toString());
  }

  String get locationText => location.displayText;

  String get startLabel {
    final dateTime = startDateTime?.toLocal();
    if (dateTime == null) {
      return 'Date not available';
    }

    final now = DateTime.now();
    final sameDay =
        now.year == dateTime.year &&
        now.month == dateTime.month &&
        now.day == dateTime.day;
    final yesterday = now.subtract(const Duration(days: 1));
    final tomorrow = now.add(const Duration(days: 1));

    final dayLabel = sameDay
        ? 'Today'
        : (yesterday.year == dateTime.year &&
              yesterday.month == dateTime.month &&
              yesterday.day == dateTime.day)
        ? 'Yesterday'
        : (tomorrow.year == dateTime.year &&
              tomorrow.month == dateTime.month &&
              tomorrow.day == dateTime.day)
        ? 'Tomorrow'
        : '${_monthName(dateTime.month)} ${dateTime.day}, ${dateTime.year}';

    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';

    return '$dayLabel, $hour:$minute $period';
  }

  static String _monthName(int month) {
    const months = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    if (month < 1 || month > 12) {
      return 'Date';
    }

    return months[month - 1];
  }
}

class ForumEventLocation {
  final String city;
  final String address;
  final String pincode;
  final String state;

  const ForumEventLocation({
    required this.city,
    required this.address,
    required this.pincode,
    required this.state,
  });

  factory ForumEventLocation.fromJson(Map<String, dynamic> json) {
    return ForumEventLocation(
      city: json['city']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      pincode: json['pincode']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
    );
  }

  String get displayText {
    final parts = <String>[
      city,
      address,
      state,
      pincode,
    ].where((part) => part.trim().isNotEmpty).toList();

    if (parts.isEmpty) {
      return 'Online Event';
    }

    return parts.join(' ');
  }
}
