import 'package:flutter/material.dart';
import 'package:tutor_app/core/utils/utils.dart';
import 'package:tutor_app/features/student/data/models/session.dart';

class ReviewSection extends StatelessWidget {
  final CompletedSession session;

  const ReviewSection({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: getQualityColor(
                    session.quality,
                  ).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  session.quality,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: getQualityColor(session.quality),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < session.rating
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    color: index < session.rating ? Colors.amber : Colors.grey,
                    size: 20,
                  );
                }),
              ),
            ],
          ),
          if (session.feedback.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Your feedback:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!, width: 1),
              ),
              child: Text(
                session.feedback,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
