import 'package:flutter/material.dart';
import 'package:tutor_app/features/student/data/models/student_model.dart';

class StudentList extends StatefulWidget {
  final List<Student> students;
  final Function(Student) onEdit;
  final Function(Student) onDelete;

  const StudentList({
    super.key,
    required this.students,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  String _searchQuery = '';
  bool _sortAscending = true;

  List<Student> get _filteredStudents {
    var filtered =
        widget.students
            .where(
              (student) => student.name.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ),
            )
            .toList();
    filtered.sort(
      (a, b) =>
          _sortAscending ? a.name.compareTo(b.name) : b.name.compareTo(a.name),
    );
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Search Students',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
              ),
              IconButton(
                icon: Icon(
                  _sortAscending
                      ? Icons.sort_by_alpha
                      : Icons.sort_by_alpha_outlined,
                ),
                onPressed:
                    () => setState(() => _sortAscending = !_sortAscending),
              ),
            ],
          ),
        ),
        Expanded(
          child:
              _filteredStudents.isEmpty
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_off,
                          size: 64,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No students found',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                  : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredStudents.length,
                    itemBuilder: (context, index) {
                      final student = _filteredStudents[index];
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            child: Text(
                              student.name.substring(0, 1),
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                          ),
                          title: Text(
                            student.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          subtitle: Text(
                            'ID: ${student.id}',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => widget.onEdit(student),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                color: Theme.of(context).colorScheme.error,
                                onPressed: () => widget.onDelete(student),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
        ),
      ],
    );
  }
}
