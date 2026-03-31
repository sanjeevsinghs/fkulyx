class Pagination {
  Pagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrev,
  });

  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrev;

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: ((json['page'] ?? 1) as num).toInt(),
      limit: ((json['limit'] ?? 20) as num).toInt(),
      total: ((json['total'] ?? 0) as num).toInt(),
      totalPages: ((json['totalPages'] ?? 0) as num).toInt(),
      hasNext: json['hasNext'] == true,
      hasPrev: json['hasPrev'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'page': page,
      'limit': limit,
      'total': total,
      'totalPages': totalPages,
      'hasNext': hasNext,
      'hasPrev': hasPrev,
    };
  }

  /// Empty/default pagination
  factory Pagination.empty() {
    return Pagination(
      page: 1,
      limit: 20,
      total: 0,
      totalPages: 0,
      hasNext: false,
      hasPrev: false,
    );
  }
}
