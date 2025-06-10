import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tutor_app/core/utils/utils.dart';
import 'package:tutor_app/features/student/data/models/session.dart';
import 'package:tutor_app/features/student/presentation/widgets/info_chip.dart';

class SessionCard extends StatelessWidget {
  final Session session;
  const SessionCard({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Container(
            color:
                session.isLive
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                    : null,
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
                      ).colorScheme.primary.withOpacity(0.2),
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
                    if (session.isLive)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.circle, color: Colors.white, size: 8),
                            SizedBox(width: 4),
                            Text(
                              'LIVE',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
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
                    InfoChip(
                      icon: Icons.timelapse,
                      text: '${session.duration} min',
                    ),
                  ],
                ),
              ],
            ),
          ),
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
                if (session.isLive)
                  ElevatedButton.icon(
                    onPressed: () {
                      showTimeCompletionDialog(context, session);
                    },
                    icon: const Icon(Icons.timer, color: Colors.white),
                    label: const Text('Update Time'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                if (session.isLive) const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        session.isLive
                            ? Colors.red
                            : Theme.of(context).colorScheme.primary,
                  ),
                  child: Text(session.isLive ? 'Join Live' : 'View Session'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
