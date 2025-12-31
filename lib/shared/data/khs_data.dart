// KHS (Kartu Hasil Studi) data - grades per student per semester
import 'package:sima_app/shared/data/user_data.dart';

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

  // KHS records - initialized lazily
  static List<KhsEntry>? _khsRecordsCache;

  static List<KhsEntry> get _khsRecords {
    _khsRecordsCache ??= _generateAllKhsRecords();
    return _khsRecordsCache!;
  }

  // Course definitions per semester
  static const _semesterCoursesDef = {
    1: [
      {
        'code': 'IF101',
        'name': 'Kalkulus I',
        'sks': 3,
        'lecId': '198712202015042001',
      },
      {
        'code': 'IF102',
        'name': 'Pengantar Komputer',
        'sks': 3,
        'lecId': '199003152018031001',
      },
      {
        'code': 'IF103',
        'name': 'Aljabar Linear',
        'sks': 3,
        'lecId': '198712202015042001',
      },
      {
        'code': 'IF104',
        'name': 'Pengantar Informatika',
        'sks': 3,
        'lecId': '198506152010121001',
      },
      {
        'code': 'IF105',
        'name': 'Pendidikan Kewarganegaraan',
        'sks': 2,
        'lecId': '198805102012121001',
      },
      {
        'code': 'IF106',
        'name': 'Agama',
        'sks': 2,
        'lecId': '199105202019032001',
      },
    ],
    2: [
      {
        'code': 'IF201',
        'name': 'Kalkulus II',
        'sks': 3,
        'lecId': '198712202015042001',
      },
      {
        'code': 'IF202',
        'name': 'Pemrograman Prosedural',
        'sks': 3,
        'lecId': '199003152018031001',
      },
      {
        'code': 'IF203',
        'name': 'Matematika Diskrit',
        'sks': 3,
        'lecId': '198712202015042001',
      },
      {
        'code': 'IF204',
        'name': 'Sistem Digital',
        'sks': 3,
        'lecId': '198506152010121001',
      },
      {
        'code': 'IF205',
        'name': 'Komunikasi Data',
        'sks': 3,
        'lecId': '198506152010121001',
      },
      {
        'code': 'IF206',
        'name': 'Etika Profesi',
        'sks': 2,
        'lecId': '198805102012121001',
      },
    ],
    3: [
      {
        'code': 'IF301',
        'name': 'Pemrograman Dasar',
        'sks': 3,
        'lecId': '199003152018031001',
      },
      {
        'code': 'IF302',
        'name': 'Logika Informatika',
        'sks': 3,
        'lecId': '198712202015042001',
      },
      {
        'code': 'IF303',
        'name': 'Matematika Dasar',
        'sks': 3,
        'lecId': '198712202015042001',
      },
      {
        'code': 'IF304',
        'name': 'Pengantar TI',
        'sks': 3,
        'lecId': '198506152010121001',
      },
      {
        'code': 'IF305',
        'name': 'Fisika Dasar',
        'sks': 3,
        'lecId': '199105202019032001',
      },
      {
        'code': 'IF306',
        'name': 'Bahasa Indonesia',
        'sks': 2,
        'lecId': '198805102012121001',
      },
      {
        'code': 'IF307',
        'name': 'Agama',
        'sks': 2,
        'lecId': '199105202019032001',
      },
      {
        'code': 'IF308',
        'name': 'Pancasila',
        'sks': 2,
        'lecId': '198805102012121001',
      },
    ],
    4: [
      {
        'code': 'IF401',
        'name': 'Struktur Data',
        'sks': 3,
        'lecId': '198506152010121001',
      },
      {
        'code': 'IF402',
        'name': 'Algoritma',
        'sks': 3,
        'lecId': '198712202015042001',
      },
      {
        'code': 'IF403',
        'name': 'Basis Data',
        'sks': 3,
        'lecId': '199105202019032001',
      },
      {
        'code': 'IF404',
        'name': 'Pemrograman OOP',
        'sks': 3,
        'lecId': '199003152018031001',
      },
      {
        'code': 'IF405',
        'name': 'Sistem Operasi',
        'sks': 3,
        'lecId': '198506152010121001',
      },
      {
        'code': 'IF406',
        'name': 'Statistika',
        'sks': 3,
        'lecId': '198712202015042001',
      },
      {
        'code': 'IF407',
        'name': 'Bahasa Inggris',
        'sks': 2,
        'lecId': '198805102012121001',
      },
      {
        'code': 'IF408',
        'name': 'Kewirausahaan',
        'sks': 2,
        'lecId': '199105202019032001',
      },
    ],
  };

  static const _khsAcademicYears = {
    1: '2022/2023',
    2: '2022/2023',
    3: '2023/2024',
    4: '2023/2024',
  };
  static const _khsPeriods = {1: 'Ganjil', 2: 'Genap', 3: 'Ganjil', 4: 'Genap'};
  static const _gradeList = ['A', 'A-', 'B+', 'B', 'B-', 'C+', 'C'];
  static const _gradeScores = {
    'A': 4.0,
    'A-': 3.7,
    'B+': 3.3,
    'B': 3.0,
    'B-': 2.7,
    'C+': 2.3,
    'C': 2.0,
  };

  // Generate all KHS records for all students
  static List<KhsEntry> _generateAllKhsRecords() {
    final records = <KhsEntry>[];
    final allStudents = UserData.getAllStudents();

    for (final student in allStudents) {
      final studentSeed = student.id.hashCode;

      // Generate KHS for semester 1-4
      for (int sem = 1; sem <= 4; sem++) {
        final courseDefs = _semesterCoursesDef[sem]!;
        final grades = <GradeEntry>[];
        int totalSks = 0;
        double totalPoints = 0;

        for (int i = 0; i < courseDefs.length; i++) {
          final course = courseDefs[i];
          // Vary grades based on student ID and course index
          final gradeIndex = ((studentSeed + i + sem) % 7).abs();
          final grade =
              _gradeList[gradeIndex < _gradeList.length ? gradeIndex : 0];
          final score = _gradeScores[grade]!;
          final sks = course['sks'] as int;

          grades.add(
            GradeEntry(
              courseCode: course['code'] as String,
              courseName: course['name'] as String,
              sks: sks,
              grade: grade,
              score: score,
              lecturerId: course['lecId'] as String,
            ),
          );

          totalSks += sks;
          totalPoints += score * sks;
        }

        final ips = totalSks > 0 ? totalPoints / totalSks : 0.0;

        records.add(
          KhsEntry(
            studentId: student.id,
            semester: sem,
            academicYear: _khsAcademicYears[sem]!,
            period: _khsPeriods[sem]!,
            grades: grades,
            ips: double.parse(ips.toStringAsFixed(2)),
            totalSks: totalSks,
          ),
        );
      }
    }

    return records;
  }

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
