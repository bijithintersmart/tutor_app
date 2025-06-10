import 'package:flutter/material.dart';

class BookSessionScreen extends StatelessWidget {
  const BookSessionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book a Class'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CategoryFilterWidget(),
          const SizedBox(height: 16),
          SearchBarWidget(),
          const SizedBox(height: 24),
          FeaturedTeachersWidget(),
          const SizedBox(height: 24),
          PopularClassesWidget(),
        ],
      ),
    );
  }
}

class CategoryFilterWidget extends StatelessWidget {
  final List<String> categories = [
    'All Subjects',
    'Mathematics',
    'Science',
    'Languages',
    'Arts',
    'Programming',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            categories
                .asMap()
                .entries
                .map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(entry.value),
                      selected: entry.key == 0,
                      onSelected: (selected) {},
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }
}

class SearchBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: Theme.of(context).textTheme.bodyMedium!.color,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search teachers or subjects',
                border: InputBorder.none,
                hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).textTheme.bodySmall!.color,
                ),
              ),
            ),
          ),
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
        ],
      ),
    );
  }
}

class FeaturedTeachersWidget extends StatelessWidget {
  final List<Map<String, dynamic>> teachers = [
    {
      'name': 'Dr. Sarah Chen',
      'subject': 'Mathematics',
      'rating': 4.9,
      'image': 'https://randomuser.me/api/portraits/women/44.jpg',
    },
    {
      'name': 'Prof. Michael',
      'subject': 'Physics',
      'rating': 4.7,
      'image': 'https://randomuser.me/api/portraits/men/32.jpg',
    },
    {
      'name': 'Dr. Emma Wilson',
      'subject': 'Literature',
      'rating': 4.8,
      'image': 'https://randomuser.me/api/portraits/women/68.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Featured Teachers',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children:
                teachers
                    .map(
                      (teacher) => Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: TeacherCard(
                          name: teacher['name'],
                          subject: teacher['subject'],
                          rating: teacher['rating'],
                          imageUrl: teacher['image'],
                        ),
                      ),
                    )
                    .toList(),
          ),
        ),
      ],
    );
  }
}

class TeacherCard extends StatelessWidget {
  final String name;
  final String subject;
  final double rating;
  final String imageUrl;

  const TeacherCard({
    Key? key,
    required this.name,
    required this.subject,
    required this.rating,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.network(
                imageUrl,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      height: 100,
                      color: Colors.grey[300],
                      child: const Icon(Icons.person, size: 40),
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(subject, style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PopularClassesWidget extends StatelessWidget {
  final List<Map<String, dynamic>> classes = [
    {
      'title': 'Advanced Calculus',
      'teacher': 'Dr. Sarah Chen',
      'description': 'Learn advanced calculus concepts and applications',
      'image': 'https://randomuser.me/api/portraits/women/44.jpg',
      'time': '10:00 AM - 11:30 AM',
      'seats': '2 Seats Left',
    },
    {
      'title': 'Quantum Physics',
      'teacher': 'Prof. Michael',
      'description': 'Introduction to quantum mechanics and particle physics',
      'image': 'https://randomuser.me/api/portraits/men/32.jpg',
      'time': '2:00 PM - 4:00 PM',
      'seats': '5 Seats Left',
    },
    {
      'title': 'World Literature',
      'teacher': 'Dr. Emma Wilson',
      'description':
          'Explore classic and contemporary literature from around the world',
      'image': 'https://randomuser.me/api/portraits/women/68.jpg',
      'time': '3:30 PM - 5:00 PM',
      'seats': '3 Seats Left',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Popular Classes',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'See All',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Column(
          children:
              classes
                  .map(
                    (cls) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: ClassCard(
                        title: cls['title'],
                        teacher: cls['teacher'],
                        description: cls['description'],
                        imageUrl: cls['image'],
                        time: cls['time'],
                        seats: cls['seats'],
                      ),
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }
}

class ClassCard extends StatelessWidget {
  final String title;
  final String teacher;
  final String description;
  final String imageUrl;
  final String time;
  final String seats;

  const ClassCard({
    Key? key,
    required this.title,
    required this.teacher,
    required this.description,
    required this.imageUrl,
    required this.time,
    required this.seats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(imageUrl),
                  radius: 24,
                  backgroundColor: Colors.grey[300],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        teacher,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Theme.of(context).textTheme.bodySmall!.color,
                    ),
                    const SizedBox(width: 4),
                    Text(time, style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        seats,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Colors.orange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(onPressed: () {}, child: const Text('Book')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
