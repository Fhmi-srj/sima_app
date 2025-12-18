// Class data - links classes with courses and lecturers
import 'user_data.dart';

// Represents a class cohort (e.g., IM23C)
class KelasInfo {
  final String code; // IM23A, IM23B, IM23C, IM23D
  final String prodi;
  final String angkatan;
  final bool isPagi; // true = morning, false = evening
  final int semester;

  const KelasInfo({
    required this.code,
    required this.prodi,
    required this.angkatan,
    required this.isPagi,
    required this.semester,
  });

  String get shift => isPagi ? 'Pagi' : 'Malam';
}

// Represents a course assignment for a class
class CourseAssignment {
  final String courseCode;
  final String courseName;
  final String kelasCode; // Which class takes this course
  final String lecturerId;
  final String lecturerName;
  final String day;
  final String time;
  final String room;
  final int sks;

  const CourseAssignment({
    required this.courseCode,
    required this.courseName,
    required this.kelasCode,
    required this.lecturerId,
    required this.lecturerName,
    required this.day,
    required this.time,
    required this.room,
    required this.sks,
  });
}

// Legacy ClassInfo for backward compatibility
class ClassInfo {
  final String code;
  final String name;
  final String subject;
  final String lecturerId;
  final String lecturerName;
  final String day;
  final String time;
  final String room;
  final int semester;
  final List<String> studentIds;

  const ClassInfo({
    required this.code,
    required this.name,
    required this.subject,
    required this.lecturerId,
    required this.lecturerName,
    required this.day,
    required this.time,
    required this.room,
    required this.semester,
    required this.studentIds,
  });
}

class ClassData {
  // All class cohorts
  static final List<KelasInfo> _kelasList = [
    const KelasInfo(
      code: 'IM23A',
      prodi: 'Informatika',
      angkatan: '2023',
      isPagi: true,
      semester: 5,
    ),
    const KelasInfo(
      code: 'IM23B',
      prodi: 'Informatika',
      angkatan: '2023',
      isPagi: true,
      semester: 5,
    ),
    const KelasInfo(
      code: 'IM23C',
      prodi: 'Informatika',
      angkatan: '2023',
      isPagi: true,
      semester: 5,
    ),
    const KelasInfo(
      code: 'IM23D',
      prodi: 'Informatika',
      angkatan: '2023',
      isPagi: false,
      semester: 5,
    ),
  ];

  // Course assignments for each class
  static final List<CourseAssignment> _courseAssignments = [
    // ===== KELAS IM23C - Semester 5 =====
    const CourseAssignment(
      courseCode: 'IF501',
      courseName: 'Matematika Diskrit',
      kelasCode: 'IM23C',
      lecturerId: '198712202015042001',
      lecturerName: 'Bu Mega Nindityawati',
      day: 'Senin',
      time: '10:30 - 13:00',
      room: 'Ruang B3.2',
      sks: 3,
    ),
    const CourseAssignment(
      courseCode: 'IF502',
      courseName: 'Desain Grafis',
      kelasCode: 'IM23C',
      lecturerId: '198805102012121001',
      lecturerName: "Pak M. Al'Amin",
      day: 'Senin',
      time: '08:30 - 10:30',
      room: 'Ruang Media',
      sks: 2,
    ),
    const CourseAssignment(
      courseCode: 'IF503',
      courseName: 'Pemrograman Web I',
      kelasCode: 'IM23C',
      lecturerId: '199003152018031001',
      lecturerName: 'Pak Razak Naufal',
      day: 'Senin',
      time: '13:00 - 15:30',
      room: 'Ruang Media',
      sks: 3,
    ),
    const CourseAssignment(
      courseCode: 'IF504',
      courseName: 'Basis Data',
      kelasCode: 'IM23C',
      lecturerId: '199105202019032001',
      lecturerName: 'Bu Siti Aminah',
      day: 'Selasa',
      time: '08:00 - 10:30',
      room: 'Ruang Lab 1',
      sks: 3,
    ),
    const CourseAssignment(
      courseCode: 'IF505',
      courseName: 'Statistika dan Probabilitas',
      kelasCode: 'IM23C',
      lecturerId: '198712202015042001',
      lecturerName: 'Bu Mega Nindityawati',
      day: 'Rabu',
      time: '08:00 - 10:30',
      room: 'Ruang B3.2',
      sks: 3,
    ),
    const CourseAssignment(
      courseCode: 'IF506',
      courseName: 'Jaringan Komputer',
      kelasCode: 'IM23C',
      lecturerId: '198506152010121001',
      lecturerName: 'Pak Hendra Wijaya',
      day: 'Rabu',
      time: '10:30 - 13:00',
      room: 'Ruang Lab 2',
      sks: 3,
    ),
    const CourseAssignment(
      courseCode: 'IF507',
      courseName: 'Rekayasa Perangkat Lunak',
      kelasCode: 'IM23C',
      lecturerId: '198506152010121001',
      lecturerName: 'Pak Hendra Wijaya',
      day: 'Kamis',
      time: '08:30 - 11:00',
      room: 'Ruang B3.1',
      sks: 3,
    ),
    const CourseAssignment(
      courseCode: 'IF508',
      courseName: 'Kecerdasan Buatan',
      kelasCode: 'IM23C',
      lecturerId: '199003152018031001',
      lecturerName: 'Pak Razak Naufal',
      day: 'Jumat',
      time: '09:00 - 11:30',
      room: 'Ruang Lab 3',
      sks: 3,
    ),

    // ===== KELAS IM23A - Semester 5 =====
    const CourseAssignment(
      courseCode: 'IF501',
      courseName: 'Matematika Diskrit',
      kelasCode: 'IM23A',
      lecturerId: '198712202015042001',
      lecturerName: 'Bu Mega Nindityawati',
      day: 'Selasa',
      time: '10:30 - 13:00',
      room: 'Ruang B3.2',
      sks: 3,
    ),
    const CourseAssignment(
      courseCode: 'IF502',
      courseName: 'Desain Grafis',
      kelasCode: 'IM23A',
      lecturerId: '198805102012121001',
      lecturerName: "Pak M. Al'Amin",
      day: 'Selasa',
      time: '08:30 - 10:30',
      room: 'Ruang Media',
      sks: 2,
    ),
    const CourseAssignment(
      courseCode: 'IF503',
      courseName: 'Pemrograman Web I',
      kelasCode: 'IM23A',
      lecturerId: '199003152018031001',
      lecturerName: 'Pak Razak Naufal',
      day: 'Rabu',
      time: '13:00 - 15:30',
      room: 'Ruang Media',
      sks: 3,
    ),

    // ===== KELAS IM23D (Malam) - Semester 5 =====
    const CourseAssignment(
      courseCode: 'IF501',
      courseName: 'Matematika Diskrit',
      kelasCode: 'IM23D',
      lecturerId: '198712202015042001',
      lecturerName: 'Bu Mega Nindityawati',
      day: 'Senin',
      time: '18:30 - 21:00',
      room: 'Ruang B3.2',
      sks: 3,
    ),
    const CourseAssignment(
      courseCode: 'IF503',
      courseName: 'Pemrograman Web I',
      kelasCode: 'IM23D',
      lecturerId: '199003152018031001',
      lecturerName: 'Pak Razak Naufal',
      day: 'Selasa',
      time: '18:30 - 21:00',
      room: 'Ruang Media',
      sks: 3,
    ),
    // New schedule for testing - 17:00-18:00
    const CourseAssignment(
      courseCode: 'IF510',
      courseName: 'Konsultasi Akademik',
      kelasCode: 'IM23D',
      lecturerId: '198712202015042001',
      lecturerName: 'Bu Mega Nindityawati',
      day: 'Senin',
      time: '17:00 - 18:00',
      room: 'Ruang Konsultasi',
      sks: 1,
    ),
  ];

  // Get all kelas
  static List<KelasInfo> getAllKelas() => _kelasList;

  // Get kelas by code
  static KelasInfo? getKelasByCode(String code) {
    try {
      return _kelasList.firstWhere((k) => k.code == code);
    } catch (e) {
      return null;
    }
  }

  // Get students in a kelas
  static List<AppUser> getStudentsInKelas(String kelasCode) {
    return UserData.getStudentsByKelas(kelasCode);
  }

  // Get course assignments for a kelas
  static List<CourseAssignment> getCoursesByKelas(String kelasCode) {
    return _courseAssignments.where((c) => c.kelasCode == kelasCode).toList();
  }

  // Add a new course assignment to schedule (updates if already exists)
  static void addCourseAssignment(CourseAssignment assignment) {
    // Remove existing assignment for same course + class (if any)
    _courseAssignments.removeWhere(
      (c) =>
          c.courseCode == assignment.courseCode &&
          c.kelasCode == assignment.kelasCode,
    );
    // Add the new/updated assignment
    _courseAssignments.add(assignment);
  }

  // Remove a course assignment from schedule
  static bool removeCourseAssignment(String courseCode, String kelasCode) {
    final index = _courseAssignments.indexWhere(
      (c) => c.courseCode == courseCode && c.kelasCode == kelasCode,
    );
    if (index != -1) {
      _courseAssignments.removeAt(index);
      return true;
    }
    return false;
  }

  // Get course assignments by day for a kelas
  static List<CourseAssignment> getCoursesByKelasAndDay(
    String kelasCode,
    String day,
  ) {
    return _courseAssignments
        .where(
          (c) =>
              c.kelasCode == kelasCode &&
              c.day.toLowerCase() == day.toLowerCase(),
        )
        .toList();
  }

  // Get course assignments by lecturer
  static List<CourseAssignment> getCoursesByLecturer(String lecturerId) {
    return _courseAssignments.where((c) => c.lecturerId == lecturerId).toList();
  }

  // Get classes taught by lecturer (unique kelas codes)
  static List<String> getKelasListByLecturer(String lecturerId) {
    return _courseAssignments
        .where((c) => c.lecturerId == lecturerId)
        .map((c) => c.kelasCode)
        .toSet()
        .toList();
  }

  // ===== Legacy methods for backward compatibility =====

  // Get classes by lecturer (legacy format)
  static List<ClassInfo> getClassesByLecturer(String lecturerId) {
    final courses = getCoursesByLecturer(lecturerId);
    return courses.map((c) {
      final students = getStudentsInKelas(c.kelasCode);
      return ClassInfo(
        code: '${c.courseCode}-${c.kelasCode}',
        name: '${c.courseName} - ${c.kelasCode}',
        subject: c.courseName,
        lecturerId: c.lecturerId,
        lecturerName: c.lecturerName,
        day: c.day,
        time: c.time,
        room: c.room,
        semester: 5,
        studentIds: students.map((s) => s.id).toList(),
      );
    }).toList();
  }

  // Get class by code (legacy)
  static ClassInfo? getClassByCode(String code) {
    final classes = getClassesByLecturer(
      '198712202015042001',
    ); // Default lecturer
    try {
      return classes.firstWhere((c) => c.code == code);
    } catch (e) {
      // Try to find by course-kelas pattern
      final parts = code.split('-');
      if (parts.length == 2) {
        final courseCode = parts[0];
        final kelasCode = parts[1];
        final course = _courseAssignments.firstWhere(
          (c) => c.courseCode == courseCode && c.kelasCode == kelasCode,
          orElse: () => _courseAssignments.first,
        );
        final students = getStudentsInKelas(course.kelasCode);
        return ClassInfo(
          code: code,
          name: '${course.courseName} - Kelas ${course.kelasCode.substring(4)}',
          subject: course.courseName,
          lecturerId: course.lecturerId,
          lecturerName: course.lecturerName,
          day: course.day,
          time: course.time,
          room: course.room,
          semester: 5,
          studentIds: students.map((s) => s.id).toList(),
        );
      }
      return null;
    }
  }

  // Get students in class (legacy)
  static List<AppUser> getStudentsInClass(String classCode) {
    // Extract kelas code from class code (e.g., IF501-IM23C -> IM23C)
    final parts = classCode.split('-');
    if (parts.length == 2) {
      return getStudentsInKelas(parts[1]);
    }
    // Fallback: try to find kelas directly
    return getStudentsInKelas(classCode);
  }

  // Get total students for lecturer
  static int getTotalStudentsForLecturer(String lecturerId) {
    final kelasList = getKelasListByLecturer(lecturerId);
    final uniqueStudents = <String>{};
    for (final kelas in kelasList) {
      final students = getStudentsInKelas(kelas);
      for (final s in students) {
        uniqueStudents.add(s.id);
      }
    }
    return uniqueStudents.length;
  }

  // Get class count for lecturer
  static int getClassCountForLecturer(String lecturerId) {
    return getCoursesByLecturer(lecturerId).length;
  }

  // Get all course assignments
  static List<CourseAssignment> getAllCourseAssignments() {
    return _courseAssignments.toList();
  }

  // Get course assignments by kelas
  static List<CourseAssignment> getCourseAssignmentsByKelas(String kelasCode) {
    return _courseAssignments.where((ca) => ca.kelasCode == kelasCode).toList();
  }
}
