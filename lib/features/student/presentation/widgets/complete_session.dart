import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tutor_app/core/utils/utils.dart';
import 'package:tutor_app/features/student/data/models/session.dart';
import 'package:tutor_app/features/student/presentation/widgets/info_chip.dart';
import 'package:tutor_app/features/student/presentation/widgets/review_section.dart';

class CompleteSessionWidget extends StatelessWidget {
  final CompletedSession session;
  const CompleteSessionWidget({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final completionPercent =
        (session.completedMinutes / session.duration) * 100;
    final completionStatus =
        completionPercent >= 100
            ? 'Completed'
            : '${completionPercent.toInt()}% Completed';

    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(session.teacherImage),
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.2),
                      radius: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            session.subject,
                            style: Theme.of(context).textTheme.bodyLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            session.teacherName,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    InfoChip(
                      icon: Icons.calendar_today,
                      text: DateFormat('E, MMM d').format(session.date),
                    ),
                    InfoChip(
                      icon: Icons.access_time,
                      text: '${session.startTime} - ${session.endTime}',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Completion: ',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                completionStatus,
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium!.copyWith(
                                  color: getCompletionColor(completionPercent),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Stack(
                            children: [
                              Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor: completionPercent / 100,
                                child: Container(
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: getCompletionColor(
                                      completionPercent,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                    gradient: LinearGradient(
                                      colors: [
                                        getCompletionColor(
                                          completionPercent,
                                        ).withValues(alpha: 0.7),
                                        getCompletionColor(completionPercent),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${session.completedMinutes}/${session.duration} minutes',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    if (session.completedMinutes == 0)
                      IconButton(
                        onPressed: () {
                          showTimeCompletionDialog(context, session);
                        },
                        icon: const Icon(Icons.edit_rounded),
                        tooltip: 'Update completed time',
                        color: Theme.of(context).colorScheme.primary,
                      ),
                  ],
                ),
              ],
            ),
          ),
          if (session.reviewed)
            ReviewSection(session: session)
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      showReviewDialog(context, session);
                    },
                    icon: const Icon(
                      Icons.rate_review_rounded,
                      color: Colors.white,
                    ),
                    label: const Text('Submit Review'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
