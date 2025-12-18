// Central hub for student academic data - connects all data sources
import 'user_data.dart';
import 'class_data.dart';
import 'krs_data.dart';
import 'khs_data.dart';
import 'payment_data.dart';
import 'schedule_data.dart';

class StudentProfile {
  final AppUser user;
  final KelasInfo? kelasInfo;
  final KrsEntry? currentKrs;
  final List<KhsEntry> khsHistory;
  final Map<String, dynamic> academicSummary;
  final Map<String, dynamic> paymentSummary;
  final AppUser? dosenPa;

  const StudentProfile({
    required this.user,
    this.kelasInfo,
    this.currentKrs,
    required this.khsHistory,
    required this.academicSummary,
    required this.paymentSummary,
    this.dosenPa,
  });
}

class StudentAcademicData {
  // Get complete student profile
  static StudentProfile? getStudentProfile(String studentId) {
    final user = UserData.getUserById(studentId);
    if (user == null || user.role != UserRole.student) return null;

    final kelasInfo = user.kelas != null
        ? ClassData.getKelasByCode(user.kelas!)
        : null;

    final currentKrs = KrsData.getCurrentKrs(studentId);
    final khsHistory = KhsData.getKhsByStudent(studentId);
    final academicSummary = KhsData.getAcademicSummary(studentId);
    final paymentSummary = PaymentData.getPaymentSummary(studentId);
    final dosenPa = KrsData.getDosenPaForStudent(studentId);

    return StudentProfile(
      user: user,
      kelasInfo: kelasInfo,
      currentKrs: currentKrs,
      khsHistory: khsHistory,
      academicSummary: academicSummary,
      paymentSummary: paymentSummary,
      dosenPa: dosenPa,
    );
  }

  // Get current student (logged in)
  static StudentProfile? getCurrentStudent() {
    final currentUser = UserData.currentUser;
    if (currentUser == null || currentUser.role != UserRole.student)
      return null;
    return getStudentProfile(currentUser.id);
  }

  // Get schedule for student's class
  static List<Map<String, String>> getStudentSchedule(
    String studentId,
    String day,
  ) {
    final user = UserData.getUserById(studentId);
    if (user == null || user.kelas == null) return [];
    return ScheduleData.getScheduleForDay(day, kelasCode: user.kelas);
  }

  // Get week schedule for student
  static Map<String, List<Map<String, String>>> getStudentWeekSchedule(
    String studentId,
  ) {
    final user = UserData.getUserById(studentId);
    if (user == null || user.kelas == null) return {};
    return ScheduleData.getWeekSchedule(user.kelas!);
  }

  // Get student's enrolled courses
  static List<CourseAssignment> getStudentCourses(String studentId) {
    final user = UserData.getUserById(studentId);
    if (user == null || user.kelas == null) return [];
    return ClassData.getCoursesByKelas(user.kelas!);
  }

  // Get student's classmates
  static List<AppUser> getClassmates(String studentId) {
    final user = UserData.getUserById(studentId);
    if (user == null || user.kelas == null) return [];
    return ClassData.getStudentsInKelas(
      user.kelas!,
    ).where((s) => s.id != studentId).toList();
  }

  // Get student's lecturers (who teach their class)
  static List<AppUser> getStudentLecturers(String studentId) {
    final user = UserData.getUserById(studentId);
    if (user == null || user.kelas == null) return [];

    final courses = ClassData.getCoursesByKelas(user.kelas!);
    final lecturerIds = courses.map((c) => c.lecturerId).toSet();

    return lecturerIds
        .map((id) => UserData.getUserById(id))
        .where((l) => l != null)
        .cast<AppUser>()
        .toList();
  }

  // Get academic status text
  static String getAcademicStatus(String studentId) {
    final profile = getStudentProfile(studentId);
    if (profile == null) return 'Unknown';

    final ipk = profile.academicSummary['ipk'] as double? ?? 0.0;
    final krs = profile.currentKrs;

    if (krs == null || krs.status != KrsStatus.approved) {
      return 'KRS Belum Disetujui';
    }

    if (ipk >= 3.5) return 'Aktif - Berprestasi';
    if (ipk >= 2.75) return 'Aktif - Baik';
    if (ipk >= 2.0) return 'Aktif - Cukup';
    return 'Aktif - Perlu Perhatian';
  }

  // Check if student has financial issues
  static bool hasFinancialIssues(String studentId) {
    final summary = PaymentData.getPaymentSummary(studentId);
    return (summary['overdueCount'] as int? ?? 0) > 0;
  }

  // Get notification count for student
  static Map<String, int> getStudentNotifications(String studentId) {
    final krs = KrsData.getCurrentKrs(studentId);
    final unpaidBills = PaymentData.getUnpaidBills(studentId);
    final overdueBills = unpaidBills.where((b) => b.isOverdue).length;

    return {
      'krs': krs?.status == KrsStatus.pending
          ? 1
          : (krs?.status == KrsStatus.rejected ? 1 : 0),
      'payment': unpaidBills.length,
      'overdue': overdueBills,
      'total':
          (krs?.status == KrsStatus.pending || krs?.status == KrsStatus.rejected
              ? 1
              : 0) +
          unpaidBills.length,
    };
  }

  // Get home page quick stats for student
  static Map<String, dynamic> getHomeStats(String studentId) {
    final profile = getStudentProfile(studentId);
    if (profile == null) return {};

    final user = UserData.getUserById(studentId);
    final todaySchedule = user?.kelas != null
        ? ScheduleData.getTodaySchedule(kelasCode: user!.kelas)
        : <Map<String, String>>[];

    return {
      'name': profile.user.name,
      'nim': profile.user.id,
      'prodi': profile.user.prodi,
      'kelas': profile.user.kelas ?? '-',
      'semester': profile.academicSummary['currentSemester'] ?? 0,
      'ipk': profile.academicSummary['ipk'] ?? 0.0,
      'ips': profile.academicSummary['ips'] ?? 0.0,
      'totalSks': profile.academicSummary['totalSks'] ?? 0,
      'todayClasses': todaySchedule.length,
      'pendingPayments':
          (profile.paymentSummary['pendingCount'] as int? ?? 0) +
          PaymentData.getUnpaidBills(studentId).length,
      'krsStatus': profile.currentKrs?.status.name ?? 'none',
      'dosenPa': profile.dosenPa?.name ?? '-',
    };
  }
}

// Lecturer-specific academic data helpers
class LecturerAcademicData {
  // Get complete lecturer profile with stats
  static Map<String, dynamic> getLecturerProfile(String lecturerId) {
    final lecturer = UserData.getUserById(lecturerId);
    if (lecturer == null || lecturer.role != UserRole.lecturer) return {};

    final courses = ClassData.getCoursesByLecturer(lecturerId);
    final kelasList = ClassData.getKelasListByLecturer(lecturerId);
    final pendingKrs = KrsData.getPendingKrsForDosenPa(lecturerId);
    final studentsUnderPa = KrsData.getStudentsForDosenPa(lecturerId);

    int totalStudents = 0;
    for (final kelas in kelasList) {
      totalStudents += ClassData.getStudentsInKelas(kelas).length;
    }

    return {
      'id': lecturer.id,
      'name': lecturer.name,
      'email': lecturer.email,
      'prodi': lecturer.prodi,
      'faculty': lecturer.faculty,
      'totalCourses': courses.length,
      'totalKelas': kelasList.length,
      'totalStudents': totalStudents,
      'pendingKrsCount': pendingKrs.length,
      'studentsUnderPaCount': studentsUnderPa.length,
      'kelasList': kelasList,
    };
  }

  // Get all students taught by lecturer
  static List<AppUser> getStudentsTaught(String lecturerId) {
    final kelasList = ClassData.getKelasListByLecturer(lecturerId);
    final students = <String, AppUser>{};

    for (final kelas in kelasList) {
      for (final student in ClassData.getStudentsInKelas(kelas)) {
        students[student.id] = student;
      }
    }

    return students.values.toList();
  }

  // Get home page quick stats for lecturer
  static Map<String, dynamic> getHomeStats(String lecturerId) {
    final profile = getLecturerProfile(lecturerId);
    final todaySchedule = _getTodaySchedule(lecturerId);

    return {
      'name': profile['name'] ?? '-',
      'nip': lecturerId,
      'prodi': profile['prodi'] ?? '-',
      'totalCourses': profile['totalCourses'] ?? 0,
      'totalKelas': profile['totalKelas'] ?? 0,
      'totalStudents': profile['totalStudents'] ?? 0,
      'todayClasses': todaySchedule.length,
      'pendingKrs': profile['pendingKrsCount'] ?? 0,
      'studentsUnderPa': profile['studentsUnderPaCount'] ?? 0,
    };
  }

  static List<CourseAssignment> _getTodaySchedule(String lecturerId) {
    final today = _getCurrentDay();
    return ClassData.getCoursesByLecturer(
      lecturerId,
    ).where((c) => c.day.toLowerCase() == today.toLowerCase()).toList();
  }

  static String _getCurrentDay() {
    final now = DateTime.now();
    switch (now.weekday) {
      case 1:
        return 'Senin';
      case 2:
        return 'Selasa';
      case 3:
        return 'Rabu';
      case 4:
        return 'Kamis';
      case 5:
        return 'Jumat';
      case 6:
        return 'Sabtu';
      case 7:
        return 'Minggu';
      default:
        return 'Senin';
    }
  }
}

// Admin-specific data helpers
class AdminAcademicData {
  // Get dashboard statistics
  static Map<String, dynamic> getDashboardStats() {
    final allStudents = UserData.getAllStudents();
    final allLecturers = UserData.getAllLecturers();
    final krsStats = KrsData.getKrsStats();
    final paymentStats = PaymentData.getPaymentStats();
    final gradeStats = KhsData.getGradeStats();

    return {
      'totalStudents': allStudents.length,
      'totalLecturers': allLecturers.length,
      'totalKelas': ClassData.getAllKelas().length,
      'totalCourses': ClassData.getAllCourseAssignments().length,

      // KRS stats
      'pendingKrs': krsStats['pending'] ?? 0,
      'approvedKrs': krsStats['approved'] ?? 0,
      'rejectedKrs': krsStats['rejected'] ?? 0,

      // Payment stats
      'pendingPayments': paymentStats['pendingCount'] ?? 0,
      'overduePayments': paymentStats['overdueCount'] ?? 0,
      'collectionRate': paymentStats['collectionRate'] ?? 0.0,
      'totalRevenue': paymentStats['paidAmount'] ?? 0,

      // Academic stats
      'averageGpa': gradeStats['averageGpa'] ?? 0.0,
      'totalGrades': gradeStats['totalGrades'] ?? 0,
    };
  }

  // Get students by kelas with details
  static List<Map<String, dynamic>> getStudentsByKelasWithDetails(
    String kelasCode,
  ) {
    final students = ClassData.getStudentsInKelas(kelasCode);
    return students.map((s) {
      final profile = StudentAcademicData.getStudentProfile(s.id);
      return {
        'student': s,
        'ipk': profile?.academicSummary['ipk'] ?? 0.0,
        'krsStatus': profile?.currentKrs?.status.name ?? 'none',
        'hasFinancialIssues': StudentAcademicData.hasFinancialIssues(s.id),
      };
    }).toList();
  }

  // Get all pending items for admin
  static Map<String, int> getPendingItems() {
    return {
      'krs': KrsData.getKrsByStatus(KrsStatus.pending).length,
      'payments': PaymentData.getPendingVerification().length,
      'overdue': PaymentData.getOverdueBills().length,
    };
  }
}
