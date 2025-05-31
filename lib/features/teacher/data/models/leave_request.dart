class LeaveRequest {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final LeaveStatus status;
  final String? comment;

  LeaveRequest({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
    this.comment,
  });

  String get formattedDateRange {
    final startFormatted =
        '${startDate.day}/${startDate.month}/${startDate.year}';
    final endFormatted = '${endDate.day}/${endDate.month}/${endDate.year}';
    return '$startFormatted - $endFormatted';
  }

  int get durationInDays {
    return endDate.difference(startDate).inDays + 1;
  }
}

enum LeaveStatus { pending, approved, rejected }
