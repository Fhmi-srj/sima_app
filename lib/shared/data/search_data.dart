// Centralized search data for the app
import 'schedule_data.dart';
import 'finance_data.dart';
import 'academic_data.dart';

class SearchableItem {
  final String title;
  final String subtitle;
  final String category;
  final Map<String, dynamic> data;

  SearchableItem({
    required this.title,
    required this.subtitle,
    required this.category,
    required this.data,
  });
}

class SearchData {
  // Get all searchable items
  static List<SearchableItem> getAllSearchableItems() {
    final List<SearchableItem> items = [];

    // Add schedule items
    items.addAll(_getScheduleItems());

    // Add academic items (KRS, KHS)
    items.addAll(_getAcademicItems());

    // Add finance items (bills, payments, notifications)
    items.addAll(_getFinanceItems());

    // Add certificate items
    items.addAll(_getCertificateItems());

    return items;
  }

  // Search items by query
  static List<SearchableItem> search(String query) {
    if (query.isEmpty) return [];

    final lowerQuery = query.toLowerCase();
    final allItems = getAllSearchableItems();

    return allItems.where((item) {
      return item.title.toLowerCase().contains(lowerQuery) ||
          item.subtitle.toLowerCase().contains(lowerQuery) ||
          item.category.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // Get schedule items from ScheduleData
  static List<SearchableItem> _getScheduleItems() {
    final items = <SearchableItem>[];
    final days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jum\'at'];

    for (final day in days) {
      final schedules = ScheduleData.getScheduleForDay(day);
      for (final schedule in schedules) {
        items.add(
          SearchableItem(
            title: schedule['subject']!,
            subtitle:
                '${schedule['lecturer']} • ${schedule['time']} • ${schedule['room']}',
            category: 'Jadwal - $day',
            data: {'type': 'schedule', 'day': day, ...schedule},
          ),
        );
      }
    }

    return items;
  }

  // Get academic items from AcademicData
  static List<SearchableItem> _getAcademicItems() {
    final items = <SearchableItem>[];

    // Current KRS courses from AcademicData
    final krsCourses = AcademicData.getCurrentKRS();
    final totalSks = krsCourses.fold<int>(
      0,
      (sum, c) => sum + (c['sks'] as int),
    );

    items.add(
      SearchableItem(
        title: 'KRS Semester 5 (Aktif)',
        subtitle:
            'Ganjil 2024/2025 • $totalSks SKS • ${krsCourses.length} Mata Kuliah',
        category: 'Akademik - KRS',
        data: {'type': 'krs', 'semester': 5, 'courses': krsCourses},
      ),
    );

    // Add individual KRS courses to search
    for (final course in krsCourses) {
      items.add(
        SearchableItem(
          title: course['name'] as String,
          subtitle:
              '${course['code']} • ${course['sks']} SKS • ${course['lecturer']}',
          category: 'Akademik - Mata Kuliah',
          data: {'type': 'krs_course', ...course},
        ),
      );
    }

    // KHS items from AcademicData
    final khsData = AcademicData.getAllKHS();
    for (final khs in khsData) {
      final semester = khs['semester'] as int;
      final year = khs['year'] as String;
      final period = khs['period'] as String;
      final ips = khs['ips'];
      final sks = khs['sks'] as int;

      items.add(
        SearchableItem(
          title: 'KHS Semester $semester',
          subtitle: '$period $year • IPS: $ips • $sks SKS',
          category: 'Akademik - KHS',
          data: {'type': 'khs', 'semester': semester, ...khs},
        ),
      );
    }

    // Exam Card
    final examCard = AcademicData.getExamCard();
    items.add(
      SearchableItem(
        title: 'Kartu Ujian',
        subtitle:
            'Semester ${examCard['semester']} • ${examCard['academicYear']}',
        category: 'Akademik - Kartu Ujian',
        data: {'type': 'exam_card', ...examCard},
      ),
    );

    // Attendance summary
    final attendance = AcademicData.getAttendanceSummary();
    items.add(
      SearchableItem(
        title: 'Rekap Kehadiran',
        subtitle:
            'Hadir: ${attendance['attended']} • Izin: ${attendance['permitted']} • Alpha: ${attendance['absent']}',
        category: 'Akademik - Kehadiran',
        data: {'type': 'attendance', ...attendance},
      ),
    );

    return items;
  }

  // Get finance items from FinanceData
  static List<SearchableItem> _getFinanceItems() {
    final items = <SearchableItem>[];

    // Bills (Tagihan)
    final bills = FinanceData.getBills();
    for (final bill in bills) {
      final status = bill['status'] == 'lunas' ? '✅ Lunas' : '⚠️ Belum Lunas';
      items.add(
        SearchableItem(
          title: bill['title'] as String,
          subtitle: '${bill['amount']} • ${bill['dueDate']} • $status',
          category: 'Keuangan - Tagihan',
          data: {'type': 'bill', ...bill},
        ),
      );
    }

    // Payment History
    final payments = FinanceData.getPaymentHistory();
    for (final payment in payments) {
      items.add(
        SearchableItem(
          title: payment['subtitle'] as String,
          subtitle:
              '${payment['amount']} • ${payment['paymentDate'] ?? payment['dueDate']}',
          category: 'Keuangan - Riwayat',
          data: {'type': 'payment', ...payment},
        ),
      );
    }

    // Summary info
    final summary = FinanceData.getSummary();
    items.add(
      SearchableItem(
        title: 'Status Pembayaran',
        subtitle:
            'Belum Lunas: ${summary['totalUnpaid']} • Progress: ${summary['progressPercentage']}',
        category: 'Keuangan - Status',
        data: {'type': 'finance_summary', ...summary},
      ),
    );

    return items;
  }

  // Get certificate items
  static List<SearchableItem> _getCertificateItems() {
    final items = <SearchableItem>[];

    // Certificate data (can be moved to separate data file later)
    final certificates = [
      {
        'title': 'Sertifikat Kompetensi',
        'subtitle': 'Web Development',
        'certId': 'CERT-2024-001',
        'issueDate': '15 Jan 2024',
        'expiryDate': '15 Jan 2027',
        'issuer': 'Kampus IT',
        'status': 'Aktif',
      },
      {
        'title': 'Lomba UI/UX Desain',
        'subtitle': 'Juara 1 Tingkat Nasional',
        'certId': 'LOMBA-2025-045',
        'issueDate': '05 Feb 2025',
        'expiryDate': 'Selamanya',
        'issuer': 'Dikti',
        'status': 'Aktif',
      },
      {
        'title': 'Pelatihan Database',
        'subtitle': 'MySQL & PostgreSQL',
        'certId': 'TRAIN-2024-089',
        'issueDate': '10 Maret 2024',
        'expiryDate': '10 Maret 2024',
        'issuer': 'Kampus IT',
        'status': 'Kadaluarsa',
      },
    ];

    for (final cert in certificates) {
      items.add(
        SearchableItem(
          title: cert['title']!,
          subtitle:
              '${cert['subtitle']} • ${cert['issuer']} • ${cert['status']}',
          category: 'Sertifikat',
          data: {'type': 'certificate', ...cert},
        ),
      );
    }

    return items;
  }
}

