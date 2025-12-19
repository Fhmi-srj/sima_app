// Centralized schedule data for the app
import 'class_data.dart';
import 'krs_data.dart';

class ScheduleData {
  // Get schedule for a specific day based on student's kelas
  static List<Map<String, String>> getScheduleForDay(
    String day, {
    String? kelasCode,
  }) {
    // If kelasCode provided, get schedule for that class
    if (kelasCode != null) {
      final courses = ClassData.getCoursesByKelasAndDay(kelasCode, day);
      return courses
          .map(
            (c) => {
              'subject': c.courseName,
              'lecturer': c.lecturerName,
              'time': c.time,
              'room': c.room,
              'session': _getSession(c.time),
              'kelas': c.kelasCode,
            },
          )
          .toList();
    }

    // Default: return IM23C schedule (for backward compatibility)
    return getScheduleForDay(day, kelasCode: 'IM23C');
  }

  // Get schedule filtered by APPROVED KRS for a student
  // Returns empty list if student has no approved KRS
  static List<Map<String, String>> getScheduleForDayByKrs(
    String day, {
    required String studentId,
    String? kelasCode,
  }) {
    // Check if student has approved KRS
    final approvedKrs = KrsData.getApprovedKrsForStudent(studentId);
    if (approvedKrs == null) {
      return []; // No approved KRS - return empty schedule
    }

    // Get approved course codes
    final approvedCourseCodes = approvedKrs.courseCodes;

    // Get kelas from student or use provided kelas
    final effectiveKelas = kelasCode ?? approvedKrs.student?.kelas ?? 'IM23C';

    // Get all courses for that day and filter by approved course codes
    final allCourses = ClassData.getCoursesByKelasAndDay(effectiveKelas, day);
    final filteredCourses = allCourses
        .where((c) => approvedCourseCodes.contains(c.courseCode))
        .toList();

    return filteredCourses
        .map(
          (c) => {
            'subject': c.courseName,
            'lecturer': c.lecturerName,
            'time': c.time,
            'room': c.room,
            'session': _getSession(c.time),
            'kelas': c.kelasCode,
            'courseCode': c.courseCode,
          },
        )
        .toList();
  }

  static String _getSession(String time) {
    // Parse time to determine session
    if (time.contains('08:') || time.contains('09:') || time.contains('10:')) {
      return 'AM';
    } else if (time.contains('13:') ||
        time.contains('14:') ||
        time.contains('15:')) {
      return 'MP';
    } else if (time.contains('18:') ||
        time.contains('19:') ||
        time.contains('20:')) {
      return 'ML'; // Malam
    }
    return 'AM';
  }

  // Get current day in Indonesian
  static String getCurrentDay() {
    final now = DateTime.now();
    final dayIndex = now.weekday; // 1 = Monday, 7 = Sunday

    switch (dayIndex) {
      case 1:
        return 'Senin';
      case 2:
        return 'Selasa';
      case 3:
        return 'Rabu';
      case 4:
        return 'Kamis';
      case 5:
        return 'Jum\'at';
      case 6:
        return 'Sabtu';
      case 7:
        return 'Minggu';
      default:
        return 'Senin';
    }
  }

  // Get today's schedule for a specific kelas
  static List<Map<String, String>> getTodaySchedule({String? kelasCode}) {
    return getScheduleForDay(getCurrentDay(), kelasCode: kelasCode);
  }

  // Get today's schedule filtered by APPROVED KRS for a student
  // Returns empty list if student has no approved KRS
  static List<Map<String, String>> getTodayScheduleByKrs({
    required String studentId,
    String? kelasCode,
  }) {
    return getScheduleForDayByKrs(
      getCurrentDay(),
      studentId: studentId,
      kelasCode: kelasCode,
    );
  }

  // Check if student has approved KRS
  static bool hasApprovedKrs(String studentId) {
    return KrsData.getApprovedKrsForStudent(studentId) != null;
  }

  // Get full week schedule for a kelas
  static Map<String, List<Map<String, String>>> getWeekSchedule(
    String kelasCode,
  ) {
    final days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat'];
    final schedule = <String, List<Map<String, String>>>{};

    for (final day in days) {
      schedule[day] = getScheduleForDay(day, kelasCode: kelasCode);
    }

    return schedule;
  }

  // Get all courses for a kelas (for the semester)
  static List<Map<String, dynamic>> getCoursesForKelas(String kelasCode) {
    final courses = ClassData.getCoursesByKelas(kelasCode);
    return courses
        .map(
          (c) => {
            'code': c.courseCode,
            'name': c.courseName,
            'lecturer': c.lecturerName,
            'day': c.day,
            'time': c.time,
            'room': c.room,
            'sks': c.sks,
          },
        )
        .toList();
  }
}
