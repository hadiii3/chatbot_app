class StudentModel {
  final int id;
  final String studentIdNumber;
  final String fullName;
  final String email;
  final String faculty;
  final double gpa;
  final int creditsCompleted;
  final int creditsRequired;

  const StudentModel({
    required this.id,
    required this.studentIdNumber,
    required this.fullName,
    required this.email,
    required this.faculty,
    required this.gpa,
    required this.creditsCompleted,
    required this.creditsRequired,
  });

  String get firstName => fullName.split(' ').first;
  String get lastName {
    final parts = fullName.split(' ');
    if (parts.length > 1) {
      return parts.sublist(1).join(' ');
    }
    return '';
  }

  double get progressPercent =>
      creditsRequired == 0 ? 0 : creditsCompleted / creditsRequired;

  Map<String, dynamic> toMap() => {
        'id': id,
        'student_id': studentIdNumber,
        'full_name': fullName,
        'email': email,
        'faculty': {'name': faculty},
        'gpa': gpa,
        'credits_completed': creditsCompleted,
        'credits_required': creditsRequired,
      };

  factory StudentModel.fromMap(Map<dynamic, dynamic> map) {
    String facultyName = '';
    if (map['faculty'] is Map) {
      facultyName = map['faculty']['name'] as String? ?? '';
    } else if (map['faculty'] is String) {
      facultyName = map['faculty'] as String;
    }

    return StudentModel(
      id: map['id'] as int? ?? 0,
      studentIdNumber: map['student_id'] as String? ?? '',
      fullName: map['full_name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      faculty: facultyName,
      gpa: (map['gpa'] as num?)?.toDouble() ?? 0.0,
      creditsCompleted: map['credits_completed'] as int? ?? 0,
      creditsRequired: map['credits_required'] as int? ?? 0,
    );
  }
}
