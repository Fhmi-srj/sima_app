// Lecturer-specific data for teaching schedule, classes, etc.
import 'user_data.dart';
import 'class_data.dart';

class LecturerData {
  // Get teaching schedule for a lecturer
  static List<Map<String, dynamic>> getTeachingSchedule(String lecturerId) {
    final courses = ClassData.getCoursesByLecturer(lecturerId);

    return courses.map((c) {
      final students = ClassData.getStudentsInKelas(c.kelasCode);
      return {
        'courseCode': c.courseCode,
        'subject': c.courseName,
        'kelas': c.kelasCode,
        'day': c.day,
        'time': c.time,
        'room': c.room,
        'sks': c.sks,
        'studentCount': students.length,
        'lecturer': c.lecturerName,
      };
    }).toList();
  }

  // Get teaching schedule for today
  static List<Map<String, dynamic>> getTodayTeachingSchedule(
    String lecturerId,
  ) {
    final today = _getCurrentDay();
    return getTeachingSchedule(lecturerId)
        .where((s) => s['day'].toString().toLowerCase() == today.toLowerCase())
        .toList();
  }

  static String _getCurrentDay() {
    final now = DateTime.now();
    final dayIndex = now.weekday;
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
        return 'Jumat';
      case 6:
        return 'Sabtu';
      case 7:
        return 'Minggu';
      default:
        return 'Senin';
    }
  }

  // Get classes taught by lecturer (unique courses)
  static List<Map<String, dynamic>> getClassesTaught(String lecturerId) {
    final courses = ClassData.getCoursesByLecturer(lecturerId);
    final classMap = <String, Map<String, dynamic>>{};

    for (final c in courses) {
      final key = '${c.courseCode}-${c.kelasCode}';
      if (!classMap.containsKey(key)) {
        final students = ClassData.getStudentsInKelas(c.kelasCode);
        classMap[key] = {
          'courseCode': c.courseCode,
          'subject': c.courseName,
          'kelas': c.kelasCode,
          'room': c.room,
          'day': c.day,
          'time': c.time,
          'sks': c.sks,
          'studentCount': students.length,
          'students': students,
        };
      }
    }

    return classMap.values.toList();
  }

  // Get all kelas taught by lecturer
  static List<String> getKelasListTaught(String lecturerId) {
    return ClassData.getKelasListByLecturer(lecturerId);
  }

  // Get lecturer profile summary
  static Map<String, dynamic> getLecturerProfile(String lecturerId) {
    final lecturer = UserData.getUserById(lecturerId);
    if (lecturer == null) return {};

    final classes = getClassesTaught(lecturerId);
    final kelasList = getKelasListTaught(lecturerId);

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
      'institusi': lecturer.institusi,
      'totalCourses': classes.length,
      'totalKelas': kelasList.length,
      'totalStudents': totalStudents,
      'todayClasses': getTodayTeachingSchedule(lecturerId).length,
    };
  }

  // Get pending tasks for lecturer (notifications) - DYNAMIC
  static List<Map<String, dynamic>> getPendingTasks(String lecturerId) {
    final tasks = <Map<String, dynamic>>[];
    final todaySchedule = getTodayTeachingSchedule(lecturerId);
    final classes = getClassesTaught(lecturerId);

    // Today's classes reminder
    if (todaySchedule.isNotEmpty) {
      tasks.add({
        'type': 'schedule',
        'title': '${todaySchedule.length} Jadwal Hari Ini',
        'subtitle': todaySchedule.map((s) => s['subject']).join(', '),
        'priority': 'high',
        'icon': 'calendar',
      });
    }

    // KRS approval reminder (dummy count based on classes)
    final krsCount = (classes.length * 2) % 5 + 1; // Simulate pending KRS
    if (krsCount > 0) {
      tasks.add({
        'type': 'approval',
        'title': '$krsCount KRS Menunggu Persetujuan',
        'subtitle': 'Dari mahasiswa bimbingan',
        'priority': 'medium',
        'icon': 'fact_check',
      });
    }

    // Izin mahasiswa pending (simulate based on total students)
    int totalStudents = 0;
    for (final c in classes) {
      totalStudents += (c['studentCount'] as int?) ?? 0;
    }
    final izinCount =
        (totalStudents ~/ 20) + 1; // Simulate: 1 izin per 20 students
    if (izinCount > 0) {
      tasks.add({
        'type': 'izin',
        'title': '$izinCount Izin Menunggu Persetujuan',
        'subtitle': 'Tap untuk melihat detail',
        'priority': 'low',
        'icon': 'pending_actions',
      });
    }

    // Grade input reminder if any class exists
    if (classes.isNotEmpty) {
      final randomClass = classes.first;
      tasks.add({
        'type': 'grade',
        'title': 'Input Nilai Semester',
        'subtitle': '${randomClass['subject']} - ${randomClass['kelas']}',
        'deadline': '20 Des 2024',
        'priority': 'high',
        'icon': 'grade',
      });
    }

    return tasks;
  }
}
