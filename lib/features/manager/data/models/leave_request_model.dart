class ManagerLeaveRequest {
  final String id;
  final String teacherName;
  final DateTime fromDate;
  final DateTime toDate;
  final String reason;
  String status;

  ManagerLeaveRequest({
    required this.id,
    required this.teacherName,
    required this.fromDate,
    required this.toDate,
    required this.reason,
    required this.status,
  });
}
