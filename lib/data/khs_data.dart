// KHS (Kartu Hasil Studi) data - grades per student per semester
import 'user_data.dart';

class GradeEntry {
  final String courseCode;
  final String courseName;
  final int sks;
  final String grade; // A, A-, B+, B, B-, C+, C, D, E
  final double score; // 4.0, 3.7, 3.3, 3.0, 2.7, 2.3, 2.0, 1.0, 0.0
  final String lecturerId;

  const GradeEntry({
    required this.courseCode,
    required this.courseName,
    required this.sks,
    required this.grade,
    required this.score,
    required this.lecturerId,
  });

  AppUser? get lecturer => UserData.getUserById(lecturerId);
}

class KhsEntry {
  final String studentId;
  final int semester;
  final String academicYear;
  final String period; // 'Ganjil' or 'Genap'
  final List<GradeEntry> grades;
  final double ips; // Indeks Prestasi Semester
  final int totalSks;

  const KhsEntry({
    required this.studentId,
    required this.semester,
    required this.academicYear,
    required this.period,
    required this.grades,
    required this.ips,
    required this.totalSks,
  });

  AppUser? get student => UserData.getUserById(studentId);
}

class KhsData {
  // Grade conversion
  static double gradeToScore(String grade) {
    switch (grade) {
      case 'A':
        return 4.0;
      case 'A-':
        return 3.7;
      case 'B+':
        return 3.3;
      case 'B':
        return 3.0;
      case 'B-':
        return 2.7;
      case 'C+':
        return 2.3;
      case 'C':
        return 2.0;
      case 'D':
        return 1.0;
      case 'E':
        return 0.0;
      default:
        return 0.0;
    }
  }

  // Calculate IPS from grades
  static double calculateIps(List<GradeEntry> grades) {
    if (grades.isEmpty) return 0.0;
    double totalPoints = 0;
    int totalSks = 0;
    for (final g in grades) {
      totalPoints += g.score * g.sks;
      totalSks += g.sks;
    }
    return totalSks > 0 ? totalPoints / totalSks : 0.0;
  }

  // KHS records for students
  static final List<KhsEntry> _khsRecords = [
    // ===== AHMAD RIZKY (102230039) - IM23C =====
    // Semester 4
    KhsEntry(
      studentId: '102230039',
      semester: 4,
      academicYear: '2023/2024',
      period: 'Genap',
      grades: [
        const GradeEntry(
          courseCode: 'IF401',
          courseName: 'Struktur Data',
          sks: 3,
          grade: 'A',
          score: 4.0,
          lecturerId: '198506152010121001',
        ),
        const GradeEntry(
          courseCode: 'IF402',
          courseName: 'Algoritma',
          sks: 3,
          grade: 'A-',
          score: 3.7,
          lecturerId: '198712202015042001',
        ),
        const GradeEntry(
          courseCode: 'IF403',
          courseName: 'Basis Data',
          sks: 3,
          grade: 'A',
          score: 4.0,
          lecturerId: '199105202019032001',
        ),
        const GradeEntry(
          courseCode: 'IF404',
          courseName: 'Pemrograman OOP',
          sks: 3,
          grade: 'B+',
          score: 3.3,
          lecturerId: '199003152018031001',
        ),
        const GradeEntry(
          courseCode: 'IF405',
          courseName: 'Sistem Operasi',
          sks: 3,
          grade: 'A',
          score: 4.0,
          lecturerId: '198506152010121001',
        ),
        const GradeEntry(
          courseCode: 'IF406',
          courseName: 'Statistika',
          sks: 3,
          grade: 'A-',
          score: 3.7,
          lecturerId: '198712202015042001',
        ),
        const GradeEntry(
          courseCode: 'IF407',
          courseName: 'Bahasa Inggris',
          sks: 2,
          grade: 'A',
          score: 4.0,
          lecturerId: '198805102012121001',
        ),
        const GradeEntry(
          courseCode: 'IF408',
          courseName: 'Kewirausahaan',
          sks: 2,
          grade: 'A-',
          score: 3.7,
          lecturerId: '199105202019032001',
        ),
      ],
      ips: 3.80,
      totalSks: 22,
    ),
    // Semester 3
    KhsEntry(
      studentId: '102230039',
      semester: 3,
      academicYear: '2023/2024',
      period: 'Ganjil',
      grades: [
        const GradeEntry(
          courseCode: 'IF301',
          courseName: 'Pemrograman Dasar',
          sks: 3,
          grade: 'A',
          score: 4.0,
          lecturerId: '199003152018031001',
        ),
        const GradeEntry(
          courseCode: 'IF302',
          courseName: 'Logika Informatika',
          sks: 3,
          grade: 'B+',
          score: 3.3,
          lecturerId: '198712202015042001',
        ),
        const GradeEntry(
          courseCode: 'IF303',
          courseName: 'Matematika Dasar',
          sks: 3,
          grade: 'A-',
          score: 3.7,
          lecturerId: '198712202015042001',
        ),
        const GradeEntry(
          courseCode: 'IF304',
          courseName: 'Pengantar TI',
          sks: 3,
          grade: 'A',
          score: 4.0,
          lecturerId: '198506152010121001',
        ),
        const GradeEntry(
          courseCode: 'IF305',
          courseName: 'Fisika Dasar',
          sks: 3,
          grade: 'B+',
          score: 3.3,
          lecturerId: '199105202019032001',
        ),
        const GradeEntry(
          courseCode: 'IF306',
          courseName: 'Bahasa Indonesia',
          sks: 2,
          grade: 'A',
          score: 4.0,
          lecturerId: '198805102012121001',
        ),
        const GradeEntry(
          courseCode: 'IF307',
          courseName: 'Agama',
          sks: 2,
          grade: 'A',
          score: 4.0,
          lecturerId: '199105202019032001',
        ),
        const GradeEntry(
          courseCode: 'IF308',
          courseName: 'Pancasila',
          sks: 2,
          grade: 'B+',
          score: 3.3,
          lecturerId: '198805102012121001',
        ),
      ],
      ips: 3.65,
      totalSks: 21,
    ),
    // Semester 2
    KhsEntry(
      studentId: '102230039',
      semester: 2,
      academicYear: '2022/2023',
      period: 'Genap',
      grades: [
        const GradeEntry(
          courseCode: 'IF201',
          courseName: 'Kalkulus II',
          sks: 3,
          grade: 'A-',
          score: 3.7,
          lecturerId: '198712202015042001',
        ),
        const GradeEntry(
          courseCode: 'IF202',
          courseName: 'Pemrograman Prosedural',
          sks: 3,
          grade: 'A',
          score: 4.0,
          lecturerId: '199003152018031001',
        ),
        const GradeEntry(
          courseCode: 'IF203',
          courseName: 'Matematika Diskrit',
          sks: 3,
          grade: 'B+',
          score: 3.3,
          lecturerId: '198712202015042001',
        ),
        const GradeEntry(
          courseCode: 'IF204',
          courseName: 'Sistem Digital',
          sks: 3,
          grade: 'A',
          score: 4.0,
          lecturerId: '198506152010121001',
        ),
        const GradeEntry(
          courseCode: 'IF205',
          courseName: 'Komunikasi Data',
          sks: 3,
          grade: 'A-',
          score: 3.7,
          lecturerId: '198506152010121001',
        ),
        const GradeEntry(
          courseCode: 'IF206',
          courseName: 'Etika Profesi',
          sks: 2,
          grade: 'A',
          score: 4.0,
          lecturerId: '198805102012121001',
        ),
      ],
      ips: 3.78,
      totalSks: 17,
    ),
    // Semester 1
    KhsEntry(
      studentId: '102230039',
      semester: 1,
      academicYear: '2022/2023',
      period: 'Ganjil',
      grades: [
        const GradeEntry(
          courseCode: 'IF101',
          courseName: 'Kalkulus I',
          sks: 3,
          grade: 'B+',
          score: 3.3,
          lecturerId: '198712202015042001',
        ),
        const GradeEntry(
          courseCode: 'IF102',
          courseName: 'Pengantar Komputer',
          sks: 3,
          grade: 'A',
          score: 4.0,
          lecturerId: '199003152018031001',
        ),
        const GradeEntry(
          courseCode: 'IF103',
          courseName: 'Aljabar Linear',
          sks: 3,
          grade: 'A-',
          score: 3.7,
          lecturerId: '198712202015042001',
        ),
        const GradeEntry(
          courseCode: 'IF104',
          courseName: 'Pengantar Informatika',
          sks: 3,
          grade: 'A',
          score: 4.0,
          lecturerId: '198506152010121001',
        ),
        const GradeEntry(
          courseCode: 'IF105',
          courseName: 'Pendidikan Kewarganegaraan',
          sks: 2,
          grade: 'A',
          score: 4.0,
          lecturerId: '198805102012121001',
        ),
      ],
      ips: 3.74,
      totalSks: 14,
    ),

    // ===== SITI NURHALIZA (102230040) - IM23C =====
    KhsEntry(
      studentId: '102230040',
      semester: 4,
      academicYear: '2023/2024',
      period: 'Genap',
      grades: [
        const GradeEntry(
          courseCode: 'IF401',
          courseName: 'Struktur Data',
          sks: 3,
          grade: 'A',
          score: 4.0,
          lecturerId: '198506152010121001',
        ),
        const GradeEntry(
          courseCode: 'IF402',
          courseName: 'Algoritma',
          sks: 3,
          grade: 'A',
          score: 4.0,
          lecturerId: '198712202015042001',
        ),
        const GradeEntry(
          courseCode: 'IF403',
          courseName: 'Basis Data',
          sks: 3,
          grade: 'A-',
          score: 3.7,
          lecturerId: '199105202019032001',
        ),
        const GradeEntry(
          courseCode: 'IF404',
          courseName: 'Pemrograman OOP',
          sks: 3,
          grade: 'A',
          score: 4.0,
          lecturerId: '199003152018031001',
        ),
        const GradeEntry(
          courseCode: 'IF405',
          courseName: 'Sistem Operasi',
          sks: 3,
          grade: 'A-',
          score: 3.7,
          lecturerId: '198506152010121001',
        ),
        const GradeEntry(
          courseCode: 'IF406',
          courseName: 'Statistika',
          sks: 3,
          grade: 'A',
          score: 4.0,
          lecturerId: '198712202015042001',
        ),
      ],
      ips: 3.90,
      totalSks: 18,
    ),

    // ===== BUDI SANTOSO (102230041) - IM23C =====
    KhsEntry(
      studentId: '102230041',
      semester: 4,
      academicYear: '2023/2024',
      period: 'Genap',
      grades: [
        const GradeEntry(
          courseCode: 'IF401',
          courseName: 'Struktur Data',
          sks: 3,
          grade: 'B+',
          score: 3.3,
          lecturerId: '198506152010121001',
        ),
        const GradeEntry(
          courseCode: 'IF402',
          courseName: 'Algoritma',
          sks: 3,
          grade: 'B',
          score: 3.0,
          lecturerId: '198712202015042001',
        ),
        const GradeEntry(
          courseCode: 'IF403',
          courseName: 'Basis Data',
          sks: 3,
          grade: 'A-',
          score: 3.7,
          lecturerId: '199105202019032001',
        ),
        const GradeEntry(
          courseCode: 'IF404',
          courseName: 'Pemrograman OOP',
          sks: 3,
          grade: 'B+',
          score: 3.3,
          lecturerId: '199003152018031001',
        ),
        const GradeEntry(
          courseCode: 'IF405',
          courseName: 'Sistem Operasi',
          sks: 3,
          grade: 'B',
          score: 3.0,
          lecturerId: '198506152010121001',
        ),
        const GradeEntry(
          courseCode: 'IF406',
          courseName: 'Statistika',
          sks: 3,
          grade: 'B+',
          score: 3.3,
          lecturerId: '198712202015042001',
        ),
      ],
      ips: 3.27,
      totalSks: 18,
    ),

    // ===== EKO PRASETYO (102230001) - IM23A =====
    KhsEntry(
      studentId: '102230001',
      semester: 4,
      academicYear: '2023/2024',
      period: 'Genap',
      grades: [
        const GradeEntry(
          courseCode: 'IF401',
          courseName: 'Struktur Data',
          sks: 3,
          grade: 'A',
          score: 4.0,
          lecturerId: '198506152010121001',
        ),
        const GradeEntry(
          courseCode: 'IF402',
          courseName: 'Algoritma',
          sks: 3,
          grade: 'A-',
          score: 3.7,
          lecturerId: '198712202015042001',
        ),
        const GradeEntry(
          courseCode: 'IF403',
          courseName: 'Basis Data',
          sks: 3,
          grade: 'A',
          score: 4.0,
          lecturerId: '199105202019032001',
        ),
      ],
      ips: 3.90,
      totalSks: 9,
    ),

    // ===== DEDI SUPRIADI (102230076) - IM23D =====
    KhsEntry(
      studentId: '102230076',
      semester: 4,
      academicYear: '2023/2024',
      period: 'Genap',
      grades: [
        const GradeEntry(
          courseCode: 'IF401',
          courseName: 'Struktur Data',
          sks: 3,
          grade: 'B+',
          score: 3.3,
          lecturerId: '198506152010121001',
        ),
        const GradeEntry(
          courseCode: 'IF402',
          courseName: 'Algoritma',
          sks: 3,
          grade: 'B+',
          score: 3.3,
          lecturerId: '198712202015042001',
        ),
        const GradeEntry(
          courseCode: 'IF403',
          courseName: 'Basis Data',
          sks: 3,
          grade: 'A-',
          score: 3.7,
          lecturerId: '199105202019032001',
        ),
      ],
      ips: 3.43,
      totalSks: 9,
    ),
  ];

  // Get KHS for a student
  static List<KhsEntry> getKhsByStudent(String studentId) {
    return _khsRecords.where((k) => k.studentId == studentId).toList()
      ..sort((a, b) => b.semester.compareTo(a.semester)); // Latest first
  }

  // Get KHS for specific semester
  static KhsEntry? getKhsBySemester(String studentId, int semester) {
    final list = _khsRecords
        .where((k) => k.studentId == studentId && k.semester == semester)
        .toList();
    return list.isNotEmpty ? list.first : null;
  }

  // Calculate IPK (cumulative GPA)
  static double calculateIpk(String studentId) {
    final allKhs = getKhsByStudent(studentId);
    if (allKhs.isEmpty) return 0.0;

    double totalPoints = 0;
    int totalSks = 0;

    for (final khs in allKhs) {
      for (final grade in khs.grades) {
        totalPoints += grade.score * grade.sks;
        totalSks += grade.sks;
      }
    }

    return totalSks > 0 ? totalPoints / totalSks : 0.0;
  }

  // Get total completed SKS
  static int getTotalSks(String studentId) {
    final allKhs = getKhsByStudent(studentId);
    int total = 0;
    for (final khs in allKhs) {
      total += khs.totalSks;
    }
    return total;
  }

  // Get academic summary for student
  static Map<String, dynamic> getAcademicSummary(String studentId) {
    final allKhs = getKhsByStudent(studentId);
    final latestKhs = allKhs.isNotEmpty ? allKhs.first : null;

    return {
      'totalSemesters': allKhs.length,
      'currentSemester': 5, // Default to current
      'totalSks': getTotalSks(studentId),
      'ipk': calculateIpk(studentId),
      'ips': latestKhs?.ips ?? 0.0,
      'status': 'Aktif',
    };
  }

  // Get grades submitted by a lecturer
  static List<GradeEntry> getGradesByLecturer(String lecturerId) {
    final grades = <GradeEntry>[];
    for (final khs in _khsRecords) {
      grades.addAll(khs.grades.where((g) => g.lecturerId == lecturerId));
    }
    return grades;
  }

  // Statistics for admin
  static Map<String, dynamic> getGradeStats() {
    int totalGrades = 0;
    int aCount = 0;
    int bCount = 0;
    int cCount = 0;
    int dCount = 0;
    int eCount = 0;

    for (final khs in _khsRecords) {
      for (final grade in khs.grades) {
        totalGrades++;
        if (grade.grade.startsWith('A'))
          aCount++;
        else if (grade.grade.startsWith('B'))
          bCount++;
        else if (grade.grade.startsWith('C'))
          cCount++;
        else if (grade.grade == 'D')
          dCount++;
        else if (grade.grade == 'E')
          eCount++;
      }
    }

    return {
      'totalGrades': totalGrades,
      'aCount': aCount,
      'bCount': bCount,
      'cCount': cCount,
      'dCount': dCount,
      'eCount': eCount,
      'averageGpa': _calculateOverallAverage(),
    };
  }

  static double _calculateOverallAverage() {
    double total = 0;
    int count = 0;
    for (final khs in _khsRecords) {
      total += khs.ips;
      count++;
    }
    return count > 0 ? total / count : 0.0;
  }

  // All KHS records (for admin)
  static List<KhsEntry> getAllKhs() => _khsRecords.toList();
}
