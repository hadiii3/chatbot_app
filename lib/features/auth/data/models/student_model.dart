// Student model — mirrors backend_specs.md Student table
class StudentModel {
  final String id;
  final String studentIdNumber;
  final String firstName;
  final String lastName;
  final String email;
  final String faculty;
  final String major;
  final int enrollmentYear;
  final double gpa;
  final int creditsCompleted;
  final int creditsRequired;

  const StudentModel({
    required this.id,
    required this.studentIdNumber,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.faculty,
    required this.major,
    required this.enrollmentYear,
    required this.gpa,
    required this.creditsCompleted,
    required this.creditsRequired,
  });

  String get fullName => '$firstName $lastName';
  double get progressPercent => creditsCompleted / creditsRequired;

  Map<String, dynamic> toMap() => {
        'id': id,
        'studentIdNumber': studentIdNumber,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'faculty': faculty,
        'major': major,
        'enrollmentYear': enrollmentYear,
        'gpa': gpa,
        'creditsCompleted': creditsCompleted,
        'creditsRequired': creditsRequired,
      };

  factory StudentModel.fromMap(Map<dynamic, dynamic> map) => StudentModel(
        id: map['id'] as String,
        studentIdNumber: map['studentIdNumber'] as String,
        firstName: map['firstName'] as String,
        lastName: map['lastName'] as String,
        email: map['email'] as String,
        faculty: map['faculty'] as String,
        major: map['major'] as String,
        enrollmentYear: map['enrollmentYear'] as int,
        gpa: (map['gpa'] as num).toDouble(),
        creditsCompleted: map['creditsCompleted'] as int,
        creditsRequired: map['creditsRequired'] as int,
      );
}

// ── Mock Students ─────────────────────────────────────────────────────────────
class MockStudents {
  static const List<StudentModel> _students = [
    StudentModel(
      id: '1',
      studentIdNumber: '221101678',
      firstName: 'Hadi',
      lastName: 'Abdelaziz',
      email: 'hadi.abdelaziz@gu.edu.eg',
      faculty: 'Engineering',
      major: 'Cyber Security',
      enrollmentYear: 2022,
      gpa: 2.90,
      creditsCompleted: 104,
      creditsRequired: 128,
    ),
    StudentModel(
      id: '2',
      studentIdNumber: '221102345',
      firstName: 'Sara',
      lastName: 'Hassan',
      email: 'student@gu.edu.eg',
      faculty: 'Engineering',
      major: 'Software Engineering',
      enrollmentYear: 2022,
      gpa: 3.45,
      creditsCompleted: 96,
      creditsRequired: 128,
    ),
  ];

  /// Lookup by student ID number (e.g. "221101678")
  static StudentModel? getById(String studentId) {
    try {
      return _students.firstWhere(
        (s) => s.studentIdNumber == studentId.trim(),
      );
    } catch (_) {
      return null;
    }
  }

  /// Legacy: lookup by email
  static StudentModel? getByEmail(String email) {
    try {
      return _students.firstWhere(
        (s) => s.email.toLowerCase() == email.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }
}
