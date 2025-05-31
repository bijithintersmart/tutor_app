import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tutor_app/features/student/data/models/booking_model.dart';

class BookingList extends StatelessWidget {
  final List<Booking> bookings;

  const BookingList({super.key, required this.bookings});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upcoming Bookings',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            bookings.isEmpty
                ? Text(
                  'No upcoming bookings',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                )
                : Column(
                  children:
                      bookings
                          .map(
                            (booking) => ListTile(
                              leading: const Icon(Icons.event),
                              title: Text(
                                '${booking.studentName} - ${booking.subject}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              subtitle: Text(
                                '${DateFormat('MMM dd, yyyy').format(booking.date)} at ${booking.formattedTime}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          )
                          .toList(),
                ),
          ],
        ),
      ),
    );
  }
}
