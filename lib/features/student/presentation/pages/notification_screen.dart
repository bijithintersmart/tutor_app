import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Mark all as read',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          NotificationItem(
            title: 'Class Reminder',
            subtitle: 'Your Physics 101 class starts in 30 minutes',
            time: '5 min ago',
            icon: Icons.notifications_active,
            iconColor: Colors.red,
            isUnread: true,
          ),
          NotificationItem(
            title: 'New Review',
            subtitle: 'Prof. James Lee gave you feedback on your last session',
            time: '2 hours ago',
            icon: Icons.star,
            iconColor: Colors.amber,
            isUnread: true,
          ),
          NotificationItem(
            title: 'Session Completed',
            subtitle: 'You\'ve completed the Data Structures class',
            time: '1 day ago',
            icon: Icons.check_circle,
            iconColor: Colors.green,
          ),
          NotificationItem(
            title: 'Payment Successful',
            subtitle: 'Your subscription has been renewed successfully',
            time: '3 days ago',
            icon: Icons.payment,
            iconColor: Colors.blue,
          ),
          NotificationItem(
            title: 'New Class Available',
            subtitle: 'Advanced Machine Learning class is now available',
            time: '5 days ago',
            icon: Icons.class_rounded,
            iconColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color iconColor;
  final bool isUnread;

  const NotificationItem({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.iconColor,
    this.isUnread = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isUnread ? Colors.grey[50] : Colors.white,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.w600,
            color: isUnread ? Theme.of(context).colorScheme.primary : null,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(time, style: Theme.of(context).textTheme.bodySmall),
        onTap: () {},
      ),
    );
  }
}
/*
import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Mark all as read',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildNotificationItem(
            context,
            'Class Reminder',
            'Your Physics 101 class starts in 30 minutes',
            '5 min ago',
            Icons.notifications_active,
            Colors.red,
            isUnread: true,
          ),
          _buildNotificationItem(
            context,
            'New Review',
            'Prof. James Lee gave you feedback on your last session',
            '2 hours ago',
            Icons.star,
            Colors.amber,
            isUnread: true,
          ),
          _buildNotificationItem(
            context,
            'Session Completed',
            'You\'ve completed the Data Structures class',
            '1 day ago',
            Icons.check_circle,
            Colors.green,
          ),
          _buildNotificationItem(
            context,
            'Payment Successful',
            'Your subscription has been renewed successfully',
            '3 days ago',
            Icons.payment,
            Colors.blue,
          ),
          _buildNotificationItem(
            context,
            'New Class Available',
            'Advanced Machine Learning class is now available',
            '5 days ago',
            Icons.class_rounded,
            Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(
    BuildContext context,
    String title,
    String subtitle,
    String time,
    IconData icon,
    Color iconColor, {
    bool isUnread = false,
  }) {
    return Card(
      color: isUnread ? Colors.grey[50] : Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w600,
                color: isUnread ? Theme.of(context).colorScheme.primary : null,
              ),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          time,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        onTap: () {},
      ),
    );
  }
}
*/
