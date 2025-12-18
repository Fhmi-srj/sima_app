// Centralized attendance data for the app
import 'user_data.dart';
import 'class_data.dart';

class AttendanceData {
  // Store attendance records (in-memory, simulating database)
  // Key format: studentId_courseCode_date
  static final Map<String, AttendanceRecord> _attendanceRecords = {};

  // Pre-populate with some historical attendance data
  static bool _initialized = false;

  static void _initializeData() {
    if (_initialized) return;
    _initialized = true;

    // Sample attendance for Ahmad Rizky (102230039) - IM23C
    final courses = [
      'IF501',
      'IF502',
      'IF503',
      'IF504',
      'IF505',
      'IF506',
      'IF507',
      'IF508',
    ];
    final courseNames = [
      'Matematika Diskrit',
      'Desain Grafis',
      'Pemrograman Web I',
      'Basis Data',
      'Statistika dan Probabilitas',
      'Jaringan Komputer',
      'Rekayasa Perangkat Lunak',
      'Kecerdasan Buatan',
    ];

    // Generate attendance for past 2 weeks for demo student
    for (int week = 0; week < 14; week++) {
      for (int i = 0; i < courses.length; i++) {
        final date = DateTime.now().subtract(Duration(days: week * 7 + i));
        final dateStr = _formatDate(date);

        // 85% attendance rate simulation
        final isPresent = (week * 8 + i) % 7 != 0;

        _attendanceRecords['102230039_${courses[i]}_$dateStr'] =
            AttendanceRecord(
              studentId: '102230039',
              courseCode: courses[i],
              courseName: courseNames[i],
              date: dateStr,
              type: isPresent ? 'hadir' : 'izin',
              reason: isPresent ? null : 'Sakit',
              timestamp: date.toString(),
            );
      }
    }

    // Add attendance for other students in IM23C
    final otherStudents = ['102230040', '102230041', '102230042', '102230043'];
    for (final studentId in otherStudents) {
      for (int week = 0; week < 10; week++) {
        for (int i = 0; i < courses.length; i++) {
          final date = DateTime.now().subtract(Duration(days: week * 7 + i));
          final dateStr = _formatDate(date);
          final isPresent = (week * 8 + i + studentId.hashCode) % 8 != 0;

          _attendanceRecords['${studentId}_${courses[i]}_$dateStr'] =
              AttendanceRecord(
                studentId: studentId,
                courseCode: courses[i],
                courseName: courseNames[i],
                date: dateStr,
                type: isPresent ? 'hadir' : 'izin',
                reason: isPresent ? null : 'Keperluan keluarga',
                timestamp: date.toString(),
              );
        }
      }
    }
  }

  // Record attendance for a course (with student ID)
  static void recordAttendance({
    required String studentId,
    required String courseCode,
    required String courseName,
    required String date,
    required String type, // 'hadir' or 'izin'
    String? reason, // For 'izin' type
  }) {
    _initializeData();
    final key = '${studentId}_${courseCode}_$date';
    _attendanceRecords[key] = AttendanceRecord(
      studentId: studentId,
      courseCode: courseCode,
      courseName: courseName,
      date: date,
      type: type,
      reason: reason,
      timestamp: DateTime.now().toString(),
    );
  }

  // Legacy method - record for current user
  static void recordAttendanceLegacy({
    required String courseCode,
    required String courseName,
    required String date,
    required String type,
    String? reason,
  }) {
    final currentUser = UserData.currentUser;
    if (currentUser == null) return;

    recordAttendance(
      studentId: currentUser.id,
      courseCode: courseCode,
      courseName: courseName,
      date: date,
      type: type,
      reason: reason,
    );
  }

  // Check if attendance has been recorded for a course today
  static bool hasAttendedToday(String courseCode, {String? studentId}) {
    _initializeData();
    final today = _formatDate(DateTime.now());
    final sid = studentId ?? UserData.currentUser?.id ?? '';
    final key = '${sid}_${courseCode}_$today';
    return _attendanceRecords.containsKey(key);
  }

  // Get attendance record for a course today
  static AttendanceRecord? getAttendanceToday(
    String courseCode, {
    String? studentId,
  }) {
    _initializeData();
    final today = _formatDate(DateTime.now());
    final sid = studentId ?? UserData.currentUser?.id ?? '';
    final key = '${sid}_${courseCode}_$today';
    return _attendanceRecords[key];
  }

  // Get attendance record by course name (for matching from schedule)
  static AttendanceRecord? getAttendanceByCourseName(
    String courseName, {
    String? studentId,
  }) {
    _initializeData();
    final today = _formatDate(DateTime.now());
    final sid = studentId ?? UserData.currentUser?.id ?? '';

    for (final record in _attendanceRecords.values) {
      if (record.studentId == sid &&
          record.courseName == courseName &&
          record.date == today) {
        return record;
      }
    }
    return null;
  }

  // Check if attendance exists by course name
  static bool hasAttendedByCourseName(String courseName, {String? studentId}) {
    return getAttendanceByCourseName(courseName, studentId: studentId) != null;
  }

  // Get all attendance for a student
  static List<AttendanceRecord> getAttendanceByStudent(String studentId) {
    _initializeData();
    return _attendanceRecords.values
        .where((r) => r.studentId == studentId)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // Get attendance for a course (for lecturer view)
  static List<AttendanceRecord> getAttendanceByCourse(String courseCode) {
    _initializeData();
    return _attendanceRecords.values
        .where((r) => r.courseCode == courseCode)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  // Get attendance summary for a student
  static Map<String, dynamic> getStudentAttendanceSummary(String studentId) {
    _initializeData();
    final records = getAttendanceByStudent(studentId);
    final hadir = records.where((r) => r.type == 'hadir').length;
    final izin = records.where((r) => r.type == 'izin').length;
    final total = records.length;

    return {
      'total': total,
      'hadir': hadir,
      'izin': izin,
      'percentage': total > 0 ? (hadir / total * 100).round() : 0,
    };
  }

  // Get attendance summary per course for student
  static List<Map<String, dynamic>> getStudentAttendancePerCourse(
    String studentId,
  ) {
    _initializeData();
    final records = getAttendanceByStudent(studentId);
    final courseMap = <String, Map<String, dynamic>>{};

    for (final record in records) {
      if (!courseMap.containsKey(record.courseCode)) {
        courseMap[record.courseCode] = {
          'courseCode': record.courseCode,
          'courseName': record.courseName,
          'hadir': 0,
          'izin': 0,
          'total': 0,
        };
      }

      courseMap[record.courseCode]!['total'] =
          (courseMap[record.courseCode]!['total'] as int) + 1;

      if (record.type == 'hadir') {
        courseMap[record.courseCode]!['hadir'] =
            (courseMap[record.courseCode]!['hadir'] as int) + 1;
      } else {
        courseMap[record.courseCode]!['izin'] =
            (courseMap[record.courseCode]!['izin'] as int) + 1;
      }
    }

    // Calculate percentage
    for (final course in courseMap.values) {
      final total = course['total'] as int;
      final hadir = course['hadir'] as int;
      course['percentage'] = total > 0 ? (hadir / total * 100).round() : 0;
    }

    return courseMap.values.toList();
  }

  // Get class attendance summary (for lecturer)
  static Map<String, dynamic> getClassAttendanceSummary(
    String courseCode,
    String date,
  ) {
    _initializeData();
    final records = _attendanceRecords.values
        .where((r) => r.courseCode == courseCode && r.date == date)
        .toList();

    final hadir = records.where((r) => r.type == 'hadir').length;
    final izin = records.where((r) => r.type == 'izin').length;

    return {
      'date': date,
      'courseCode': courseCode,
      'hadir': hadir,
      'izin': izin,
      'total': records.length,
    };
  }

  // Get attendance for a class on a date (for lecturer)
  static List<Map<String, dynamic>> getClassAttendanceList(
    String courseCode,
    String kelasCode,
    String date,
  ) {
    _initializeData();
    final students = ClassData.getStudentsInKelas(kelasCode);
    final result = <Map<String, dynamic>>[];

    for (final student in students) {
      final key = '${student.id}_${courseCode}_$date';
      final record = _attendanceRecords[key];

      result.add({
        'student': student,
        'status': record?.type ?? 'belum',
        'reason': record?.reason,
      });
    }

    return result;
  }

  // Format date as string (DD/MM/YYYY)
  static String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  // Get today's formatted date
  static String getTodayFormatted() {
    return _formatDate(DateTime.now());
  }

  // Clear all records (for testing)
  static void clearAll() {
    _attendanceRecords.clear();
    _initialized = false;
  }

  // Get all attendance records (for debugging)
  static Map<String, AttendanceRecord> getAllRecords() {
    _initializeData();
    return Map.from(_attendanceRecords);
  }
}

// Enhanced attendance record model with student ID
class AttendanceRecord {
  final String studentId;
  final String courseCode;
  final String courseName;
  final String date;
  final String type; // 'hadir' or 'izin'
  final String? reason;
  final String timestamp;

  const AttendanceRecord({
    required this.studentId,
    required this.courseCode,
    required this.courseName,
    required this.date,
    required this.type,
    this.reason,
    required this.timestamp,
  });

  AppUser? get student => UserData.getUserById(studentId);
}
