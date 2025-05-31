import 'package:flutter/material.dart';
import 'package:tutor_app/core/common_widget/custom_appbar.dart';
import 'package:tutor_app/features/student/data/models/booking_model.dart';
import 'package:tutor_app/features/teacher/data/models/leave_request.dart';
import 'package:tutor_app/features/teacher/presentation/widgets/booking_card.dart';
import 'package:tutor_app/features/teacher/presentation/widgets/leave_request_card.dart';
import 'package:tutor_app/features/teacher/presentation/widgets/action_card.dart';

class DashboardHome extends StatelessWidget {
  final List<Booking> bookings;
  final List<LeaveRequest> pendingLeaveRequests;
  final ValueChanged<int> onNavigateToTab;

  const DashboardHome({
    super.key,
    required this.bookings,
    required this.pendingLeaveRequests,
    required this.onNavigateToTab,
  });

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayBookings =
        bookings
            .where(
              (booking) =>
                  booking.date.day == today.day &&
                  booking.date.month == today.month &&
                  booking.date.year == today.year,
            )
            .toList();
    final nextBooking =
        bookings.isNotEmpty &&
                bookings.any(
                  (booking) =>
                      booking.date.isAfter(today) ||
                      (booking.date.day == today.day &&
                          booking.date.month == today.month &&
                          booking.date.year == today.year &&
                          booking.startTime.hour >= TimeOfDay.now().hour),
                )
            ? bookings.firstWhere(
              (booking) =>
                  booking.date.isAfter(today) ||
                  (booking.date.day == today.day &&
                      booking.date.month == today.month &&
                      booking.date.year == today.year &&
                      booking.startTime.hour >= TimeOfDay.now().hour),
            )
            : null;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Dashboard',
        profileName: 'Jane Smith',
        leadingIcon: Icons.menu,
        onLeadingPressed: () {
          // Open drawer or perform action
        },
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications
            },
            tooltip: 'Notifications',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back,',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              'Emma Rodriguez',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildNextSessionCard(context, nextBooking),
            if (pendingLeaveRequests.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text(
                'Pending Leave Requests',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount:
                    pendingLeaveRequests.length > 2
                        ? 2
                        : pendingLeaveRequests.length,
                itemBuilder: (context, index) {
                  return LeaveRequestCard(
                    request: pendingLeaveRequests[index],
                    onCancel: () {},
                  );
                },
              ),
              if (pendingLeaveRequests.length > 2)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextButton(
                    onPressed: () => onNavigateToTab(3),
                    child: Text(
                      'View all ${pendingLeaveRequests.length} pending requests',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
            ],
            const SizedBox(height: 24),
            Text(
              'Today\'s Schedule',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            todayBookings.isEmpty
                ? _buildEmptySchedule(context)
                : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: todayBookings.length,
                  itemBuilder: (context, index) {
                    return BookingCard(
                      booking: todayBookings[index],
                      isUpcoming:
                          todayBookings[index].startTime.hour >=
                          TimeOfDay.now().hour,
                    );
                  },
                ),
            const SizedBox(height: 24),
            Text(
              'Quick Actions',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ActionCard(
                    icon: Icons.add_circle,
                    title: 'Add Availability',
                    onTap: () => onNavigateToTab(2),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ActionCard(
                    icon: Icons.schedule,
                    title: 'View Schedule',
                    onTap: () => onNavigateToTab(1),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ActionCard(
                    icon: Icons.timer,
                    title: 'Request Leave',
                    onTap: () => onNavigateToTab(3),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ActionCard(
                    icon: Icons.person,
                    title: 'Edit Profile',
                    onTap: () => onNavigateToTab(4),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextSessionCard(BuildContext context, Booking? nextBooking) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child:
            nextBooking != null
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Next Session',
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Chip(
                          label: Text(nextBooking.subject),
                          backgroundColor: Colors.white.withOpacity(0.2),
                          labelStyle: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      context,
                      icon: Icons.person,
                      text: nextBooking.studentName,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      context,
                      icon: Icons.calendar_today,
                      text: nextBooking.formattedDate,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      context,
                      icon: Icons.access_time,
                      text:
                          '${nextBooking.formattedTime} (${nextBooking.durationMinutes ~/ 60}h)',
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text('View Details'),
                      ),
                    ),
                  ],
                )
                : Column(
                  children: [
                    const Icon(
                      Icons.event_available,
                      color: Colors.white,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No upcoming sessions',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enjoy your free time!',
                      style: TextStyle(color: Colors.white.withOpacity(0.7)),
                    ),
                  ],
                ),
      ),
    );
  }

  Widget _buildEmptySchedule(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(
                Icons.free_cancellation,
                size: 48,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 16),
              Text(
                'No sessions scheduled for today',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(width: 8),
        Text(
          text,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: Colors.white),
        ),
      ],
    );
  }
}
