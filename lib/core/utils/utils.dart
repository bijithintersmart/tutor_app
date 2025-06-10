import 'package:flutter/material.dart';
import 'package:tutor_app/features/student/data/models/session.dart';

Color getCompletionColor(double percentage) {
  if (percentage >= 100) {
    return Colors.green;
  } else if (percentage >= 75) {
    return Colors.amber;
  } else if (percentage > 0) {
    return Colors.orange;
  } else {
    return Colors.redAccent;
  }
}

void showTimeCompletionDialog(BuildContext context, dynamic session) {
  int minutes = 0;
  if (session is CompletedSession) {
    minutes = session.completedMinutes;
  }
  int hours = minutes ~/ 60;
  int remainingMinutes = minutes % 60;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Update Completed Time',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  session.subject,
                  style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Total class duration: ${session.duration} minutes',
                  style: TextStyle(color: Colors.grey[300]),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Hours:'),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[850],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.grey[700]!,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed:
                                      hours > 0
                                          ? () {
                                            setState(() {
                                              hours--;
                                            });
                                          }
                                          : null,
                                ),
                                Expanded(
                                  child: Text(
                                    '$hours',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed:
                                      (hours * 60 + remainingMinutes <
                                              session.duration)
                                          ? () {
                                            setState(() {
                                              if ((hours + 1) * 60 +
                                                      remainingMinutes <=
                                                  session.duration) {
                                                hours++;
                                              }
                                            });
                                          }
                                          : null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Minutes:'),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[850],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.grey[700]!,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed:
                                      remainingMinutes > 0
                                          ? () {
                                            setState(() {
                                              remainingMinutes--;
                                            });
                                          }
                                          : null,
                                ),
                                Expanded(
                                  child: Text(
                                    '$remainingMinutes',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed:
                                      (hours * 60 + remainingMinutes <
                                              session.duration)
                                          ? () {
                                            setState(() {
                                              if (remainingMinutes < 59 &&
                                                  hours * 60 +
                                                          (remainingMinutes +
                                                              1) <=
                                                      session.duration) {
                                                remainingMinutes++;
                                              }
                                            });
                                          }
                                          : null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Completed: ${(hours * 60 + remainingMinutes)}/${session.duration} minutes',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: getCompletionColor(
                      (hours * 60 + remainingMinutes) / session.duration * 100,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Save the new completed time
                  final completedMinutes = hours * 60 + remainingMinutes;

                  setState(() {
                    if (session is CompletedSession) {
                      int index = pastSessions.indexOf(session);
                      pastSessions[index] = CompletedSession(
                        id: session.id,
                        subject: session.subject,
                        teacherName: session.teacherName,
                        teacherImage: session.teacherImage,
                        date: session.date,
                        startTime: session.startTime,
                        endTime: session.endTime,
                        duration: session.duration,
                        completedMinutes: completedMinutes,
                        reviewed: session.reviewed,
                        rating: session.rating,
                        quality: session.quality,
                        feedback: session.feedback,
                      );
                    } else {
                      // Handle live sessions that need to be moved to past sessions
                      // This would handle updating a live session's completion time
                    }
                  });

                  Navigator.pop(context);

                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Updated completion time for ${session.subject}',
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

void showReviewDialog(BuildContext context, CompletedSession session) {
  int rating = 0;
  String quality = 'Average';
  TextEditingController feedbackController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Theme.of(context).cardColor,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rate Your Experience',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${session.subject} with ${session.teacherName}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                ),
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('How would you rate this session?'),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        onPressed: () {
                          setState(() {
                            rating = index + 1;
                            if (rating >= 5) {
                              quality = 'Excellent';
                            } else if (rating >= 4) {
                              quality = 'Good';
                            } else if (rating >= 3) {
                              quality = 'Average';
                            } else if (rating >= 2) {
                              quality = 'Fair';
                            } else {
                              quality = 'Poor';
                            }
                          });
                        },
                        icon: Icon(
                          index < rating
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          color: index < rating ? Colors.amber : Colors.grey,
                          size: 32,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: getQualityColor(quality).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: getQualityColor(
                            quality,
                          ).withValues(alpha: 0.5),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        quality,
                        style: TextStyle(
                          color: getQualityColor(quality),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('Share your feedback (Optional):'),
                  const SizedBox(height: 12),
                  TextField(
                    controller: feedbackController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText:
                          'What did you like or dislike about this session?',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      filled: true,
                      fillColor: Colors.grey[850],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ),
              ElevatedButton(
                onPressed:
                    rating > 0
                        ? () {
                          // In a real app, you would send this data to your backend
                          setState(() {
                            int index = pastSessions.indexOf(session);
                            pastSessions[index] = CompletedSession(
                              id: session.id,
                              subject: session.subject,
                              teacherName: session.teacherName,
                              teacherImage: session.teacherImage,
                              date: session.date,
                              startTime: session.startTime,
                              endTime: session.endTime,
                              duration: session.duration,
                              completedMinutes: session.completedMinutes,
                              reviewed: true,
                              rating: rating,
                              quality: quality,
                              feedback: feedbackController.text,
                            );
                          });
                          Navigator.pop(context);

                          // Show success message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Thank you for your feedback!',
                              ),
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        }
                        : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  disabledBackgroundColor: Colors.grey,
                ),
                child: const Text(
                  'Submit Review',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

Color getQualityColor(String quality) {
  switch (quality) {
    case 'Excellent':
      return Colors.green;
    case 'Good':
      return Colors.lightGreen;
    case 'Average':
      return Colors.amber;
    case 'Fair':
      return Colors.orange;
    case 'Poor':
      return Colors.red;
    default:
      return Colors.grey;
  }
}
