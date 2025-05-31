import 'package:flutter/material.dart';
import 'package:tutor_app/core/common_widget/custom_appbar.dart';
import 'package:tutor_app/core/common_widget/custom_drawer.dart';
import 'package:tutor_app/features/manager/presentation/widgets/booking_card.dart';
import 'package:tutor_app/features/student/data/models/booking_model.dart';
import 'package:tutor_app/mock_data/mock_data.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  late List<Booking> bookings 
  ;
  late List<Booking> upcomingBookings;
  @override
  void initState() {
   bookings = MockDataService.getBookings();
     upcomingBookings =
        bookings
            .where(
              (b) => b.date.isAfter(
                DateTime.now().subtract(const Duration(days: 1)),
              ),
            )
            .toList();
    super.initState();
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(key:  _scaffoldKey,
      appBar: CustomAppBar(
        title: 'Booking',
        profileName: 'David Wilson',
        scaffoldKey: _scaffoldKey,
      ),
      drawer: const CustomDrawer(
        userName: 'David Wilson',
        userEmail: 'david.w@school.edu',
      ),
      body: 
 Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bookings',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child:
                upcomingBookings.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_busy,
                            size: 64,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No upcoming bookings',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      itemCount: upcomingBookings.length,
                      itemBuilder: (context, index) {
                        final booking = upcomingBookings[index];
                        return BookingCard(
                          booking: booking,
                          onReschedule: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(
                                content: Text('Reschedule not implemented'),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          },
                          onCancel: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(
                                content: Text('Cancel not implemented'),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
    ));
  }
}