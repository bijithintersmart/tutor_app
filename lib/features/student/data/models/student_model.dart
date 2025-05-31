class Student {
  final String id;
  final String name;
  final String email;
  final List<String> subjects; 
  final String? profilePicture;
  final String grade; 

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.subjects,
    this.profilePicture,
    required this.grade,
  });
}
