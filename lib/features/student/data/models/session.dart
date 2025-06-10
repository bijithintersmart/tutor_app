class Session {
  final int id;
  final String subject;
  final String teacherName;
  final DateTime date;
  final String startTime;
  final String teacherImage;
  final String endTime;
  final int duration; // in minutes
  final bool isLive;

  Session({
    required this.id,
    required this.subject,
    required this.teacherName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.teacherImage,
    required this.duration,
    required this.isLive,
  });
}

class CompletedSession extends Session {
  final int completedMinutes;
  final bool reviewed;
  final int rating;
  final String quality;
  final String feedback;
  final String teacherImage;
  final bool isLive;
  CompletedSession({
    required super.id,
    required super.subject,
    required super.teacherName,
    required super.date,
    required super.startTime,
    required this.teacherImage,
    required super.endTime,
    required super.duration,
    required this.completedMinutes,
    required this.reviewed,
    this.isLive = false,
    this.rating = 0,
    this.quality = '',
    this.feedback = '',
  }) : super(teacherImage: teacherImage, isLive: isLive);
}

// Example data
final List<Session> upcomingSessions = [
  Session(
    id: 1,
    subject: 'Advanced Mathematics',
    teacherName: 'Dr. Sarah Chen',
    teacherImage: 'https://randomuser.me/api/portraits/women/44.jpg',
    date: DateTime.now().add(const Duration(days: 2)),
    startTime: '10:00 AM',
    endTime: '11:30 AM',
    duration: 90,
    isLive: false,
  ),
  Session(
    id: 2,
    subject: 'Physics 101',
    teacherName: 'Prof. Michael Reynolds',
    teacherImage: 'https://randomuser.me/api/portraits/men/32.jpg',
    date: DateTime.now().add(const Duration(days: 4)),
    startTime: '2:00 PM',
    endTime: '4:00 PM',
    duration: 120,
    isLive: false,
  ),
  Session(
    id: 3,
    subject: 'Literature Analysis',
    teacherName: 'Dr. Emma Wilson',
    teacherImage: 'https://randomuser.me/api/portraits/women/68.jpg',
    date: DateTime.now().add(const Duration(days: 8)),
    startTime: '3:30 PM',
    endTime: '5:00 PM',
    duration: 90,
    isLive: false,
  ),
];

final List<CompletedSession> pastSessions = [
  CompletedSession(
    id: 4,
    subject: 'Programming Fundamentals',
    teacherName: 'Prof. James Lee',
    teacherImage: 'https://randomuser.me/api/portraits/men/67.jpg',
    date: DateTime.now().subtract(const Duration(days: 3)),
    startTime: '9:00 AM',
    endTime: '11:00 AM',
    duration: 120,
    completedMinutes: 120,
    reviewed: true,
    rating: 5,
    quality: 'Excellent',
    feedback:
        'Very engaging session that covered all the planned topics. The professor explained complex concepts with clarity.',
  ),
  CompletedSession(
    id: 5,
    subject: 'Data Structures',
    teacherName: 'Dr. Lisa Wang',
    teacherImage: 'https://randomuser.me/api/portraits/women/79.jpg',
    date: DateTime.now().subtract(const Duration(days: 5)),
    startTime: '1:00 PM',
    endTime: '3:00 PM',
    duration: 120,
    completedMinutes: 100,
    reviewed: true,
    rating: 3,
    quality: 'Average',
    feedback:
        'The content was good but the session ended early. Would appreciate more practical examples.',
  ),
  CompletedSession(
    id: 6,
    subject: 'Economics 201',
    teacherName: 'Prof. Robert Smith',
    teacherImage: 'https://randomuser.me/api/portraits/men/54.jpg',
    date: DateTime.now().subtract(const Duration(days: 10)),
    startTime: '2:30 PM',
    endTime: '4:00 PM',
    duration: 90,
    completedMinutes: 0, // Student hasn't entered completion time yet
    reviewed: false,
  ),
  CompletedSession(
    id: 7,
    subject: 'AI & Machine Learning',
    teacherName: 'Dr. Sophia Chen',
    teacherImage: 'https://randomuser.me/api/portraits/women/33.jpg',
    date: DateTime.now().subtract(const Duration(days: 2)),
    startTime: '10:00 AM',
    endTime: '12:00 PM',
    duration: 120,
    completedMinutes: 60, // Only half the class was completed
    reviewed: false,
  ),
];
