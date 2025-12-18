// Activity log data - tracks activities across all roles for Riwayat tab
// DYNAMIC: Logs can be added when actions happen across roles
import 'user_data.dart';

enum ActivityType {
  login,
  logout,
  krsSubmit,
  krsApprove,
  krsReject,
  paymentSubmit,
  paymentVerify,
  paymentReject,
  attendanceRecord,
  gradeSubmit,
  profileUpdate,
  passwordChange,
  scheduleView,
  documentDownload,
  notification, // for system notifications
  dataUpdate, // for admin data updates
}

class ActivityLog {
  final String id;
  final String userId;
  final ActivityType type;
  final String title;
  final String description;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  ActivityLog({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.description,
    required this.timestamp,
    this.metadata,
  });

  AppUser? get user => UserData.getUserById(userId);

  String get icon {
    switch (type) {
      case ActivityType.login:
        return 'login';
      case ActivityType.logout:
        return 'logout';
      case ActivityType.krsSubmit:
        return 'assignment';
      case ActivityType.krsApprove:
        return 'check_circle';
      case ActivityType.krsReject:
        return 'cancel';
      case ActivityType.paymentSubmit:
        return 'payment';
      case ActivityType.paymentVerify:
        return 'verified';
      case ActivityType.paymentReject:
        return 'money_off';
      case ActivityType.attendanceRecord:
        return 'how_to_reg';
      case ActivityType.gradeSubmit:
        return 'grade';
      case ActivityType.profileUpdate:
        return 'person';
      case ActivityType.passwordChange:
        return 'lock';
      case ActivityType.scheduleView:
        return 'calendar_today';
      case ActivityType.documentDownload:
        return 'download';
      case ActivityType.notification:
        return 'notifications';
      case ActivityType.dataUpdate:
        return 'update';
    }
  }

  String get category {
    switch (type) {
      case ActivityType.login:
      case ActivityType.logout:
      case ActivityType.passwordChange:
        return 'Keamanan';
      case ActivityType.krsSubmit:
      case ActivityType.krsApprove:
      case ActivityType.krsReject:
        return 'Akademik';
      case ActivityType.paymentSubmit:
      case ActivityType.paymentVerify:
      case ActivityType.paymentReject:
        return 'Keuangan';
      case ActivityType.attendanceRecord:
        return 'Presensi';
      case ActivityType.gradeSubmit:
        return 'Nilai';
      case ActivityType.profileUpdate:
        return 'Profil';
      case ActivityType.scheduleView:
      case ActivityType.documentDownload:
      case ActivityType.notification:
      case ActivityType.dataUpdate:
        return 'Lainnya';
    }
  }
}

class ActivityLogData {
  // Counter for generating unique log IDs
  static int _logCounter = 500;

  // MUTABLE activity logs
  static final List<ActivityLog> _logs = [
    // ===== AHMAD RIZKY (102230039) - Student =====
    ActivityLog(
      id: 'LOG-001',
      userId: '102230039',
      type: ActivityType.login,
      title: 'Login Berhasil',
      description: 'Login dari perangkat Android',
      timestamp: DateTime(2024, 12, 17, 2, 30),
      metadata: {'device': 'Android', 'ip': '192.168.1.100'},
    ),
    ActivityLog(
      id: 'LOG-002',
      userId: '102230039',
      type: ActivityType.scheduleView,
      title: 'Melihat Jadwal',
      description: 'Melihat jadwal hari Rabu',
      timestamp: DateTime(2024, 12, 16, 14, 20),
    ),
    ActivityLog(
      id: 'LOG-003',
      userId: '102230039',
      type: ActivityType.attendanceRecord,
      title: 'Presensi Tercatat',
      description: 'Presensi Basis Data - Hadir',
      timestamp: DateTime(2024, 12, 16, 8, 15),
      metadata: {'course': 'Basis Data', 'status': 'hadir'},
    ),
    ActivityLog(
      id: 'LOG-004',
      userId: '102230039',
      type: ActivityType.krsSubmit,
      title: 'KRS Diajukan',
      description: 'KRS Semester 5 diajukan untuk persetujuan',
      timestamp: DateTime(2024, 8, 15, 9, 30),
      metadata: {'semester': 5, 'totalSks': 23},
    ),
    ActivityLog(
      id: 'LOG-005',
      userId: '102230039',
      type: ActivityType.krsApprove,
      title: 'KRS Disetujui',
      description: 'KRS Semester 5 disetujui oleh Dosen PA',
      timestamp: DateTime(2024, 8, 16, 10, 0),
      metadata: {'semester': 5, 'approvedBy': 'Bu Mega Nindityawati'},
    ),
    ActivityLog(
      id: 'LOG-006',
      userId: '102230039',
      type: ActivityType.paymentSubmit,
      title: 'Bukti Pembayaran',
      description: 'Upload bukti pembayaran UKT Semester 4',
      timestamp: DateTime(2024, 6, 2, 14, 28),
      metadata: {'billId': 'BILL-2024-039-002', 'amount': 7500000},
    ),
    ActivityLog(
      id: 'LOG-007',
      userId: '102230039',
      type: ActivityType.paymentVerify,
      title: 'Pembayaran Terverifikasi',
      description: 'Pembayaran UKT Semester 4 telah diverifikasi',
      timestamp: DateTime(2024, 6, 3, 9, 0),
      metadata: {'billId': 'BILL-2024-039-002', 'verifiedBy': 'Administrator'},
    ),

    // ===== BU MEGA NINDITYAWATI (198712202015042001) - Lecturer =====
    ActivityLog(
      id: 'LOG-101',
      userId: '198712202015042001',
      type: ActivityType.login,
      title: 'Login Berhasil',
      description: 'Login dari perangkat Windows',
      timestamp: DateTime(2024, 12, 17, 7, 45),
      metadata: {'device': 'Windows', 'ip': '192.168.1.50'},
    ),
    ActivityLog(
      id: 'LOG-102',
      userId: '198712202015042001',
      type: ActivityType.krsApprove,
      title: 'KRS Disetujui',
      description: 'Menyetujui KRS Ahmad Rizky',
      timestamp: DateTime(2024, 8, 16, 10, 0),
      metadata: {'studentId': '102230039', 'studentName': 'Ahmad Rizky'},
    ),
    ActivityLog(
      id: 'LOG-103',
      userId: '198712202015042001',
      type: ActivityType.krsApprove,
      title: 'KRS Disetujui',
      description: 'Menyetujui KRS Siti Nurhaliza',
      timestamp: DateTime(2024, 8, 15, 8, 30),
      metadata: {'studentId': '102230040', 'studentName': 'Siti Nurhaliza'},
    ),
    ActivityLog(
      id: 'LOG-104',
      userId: '198712202015042001',
      type: ActivityType.krsReject,
      title: 'KRS Ditolak',
      description: 'Menolak KRS Gina Lolita - SKS melebihi batas',
      timestamp: DateTime(2024, 8, 14, 11, 0),
      metadata: {
        'studentId': '102230054',
        'reason': 'SKS melebihi batas maksimal',
      },
    ),

    // ===== ADMIN =====
    ActivityLog(
      id: 'LOG-201',
      userId: 'admin@sima.ac.id',
      type: ActivityType.login,
      title: 'Login Berhasil',
      description: 'Login dari panel admin',
      timestamp: DateTime(2024, 12, 17, 8, 0),
      metadata: {'device': 'Windows', 'browser': 'Chrome'},
    ),
    ActivityLog(
      id: 'LOG-202',
      userId: 'admin@sima.ac.id',
      type: ActivityType.paymentVerify,
      title: 'Pembayaran Diverifikasi',
      description: 'Verifikasi pembayaran Ahmad Rizky',
      timestamp: DateTime(2024, 6, 3, 9, 0),
      metadata: {'studentId': '102230039', 'amount': 7500000},
    ),
    ActivityLog(
      id: 'LOG-203',
      userId: 'admin@sima.ac.id',
      type: ActivityType.paymentReject,
      title: 'Pembayaran Ditolak',
      description: 'Menolak pembayaran Andi Pratama - bukti blur',
      timestamp: DateTime(2024, 12, 9, 10, 0),
      metadata: {
        'studentId': '102230043',
        'reason': 'Bukti transfer tidak jelas',
      },
    ),

    // ===== SITI NURHALIZA (102230040) =====
    ActivityLog(
      id: 'LOG-301',
      userId: '102230040',
      type: ActivityType.login,
      title: 'Login Berhasil',
      description: 'Login dari perangkat iOS',
      timestamp: DateTime(2024, 12, 16, 10, 0),
      metadata: {'device': 'iOS', 'ip': '192.168.1.120'},
    ),
    ActivityLog(
      id: 'LOG-302',
      userId: '102230040',
      type: ActivityType.paymentSubmit,
      title: 'Bukti Pembayaran',
      description: 'Upload bukti pembayaran SPP Semester 5',
      timestamp: DateTime(2024, 12, 10, 16, 45),
      metadata: {'billId': 'BILL-2024-040-001', 'amount': 7500000},
    ),
  ];

  // ============ ADD LOG METHODS ============

  // Add new activity log dynamically
  static void addLog({
    required String userId,
    required ActivityType type,
    required String title,
    required String description,
    Map<String, dynamic>? metadata,
  }) {
    _logCounter++;
    _logs.insert(
      0,
      ActivityLog(
        id: 'LOG-$_logCounter',
        userId: userId,
        type: type,
        title: title,
        description: description,
        timestamp: DateTime.now(),
        metadata: metadata,
      ),
    );
  }

  // Log login activity
  static void logLogin(String userId, {String? device}) {
    addLog(
      userId: userId,
      type: ActivityType.login,
      title: 'Login Berhasil',
      description: 'Login dari perangkat ${device ?? "Unknown"}',
      metadata: {
        'device': device ?? 'Unknown',
        'time': DateTime.now().toString(),
      },
    );
  }

  // Log logout activity
  static void logLogout(String userId) {
    addLog(
      userId: userId,
      type: ActivityType.logout,
      title: 'Logout',
      description: 'Berhasil keluar dari aplikasi',
    );
  }

  // ============ QUERY METHODS ============

  // Get logs for a user
  static List<ActivityLog> getLogsByUser(String userId) {
    return _logs.where((l) => l.userId == userId).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  // Get recent logs for a user (limit)
  static List<ActivityLog> getRecentLogs(String userId, {int limit = 10}) {
    return getLogsByUser(userId).take(limit).toList();
  }

  // Get logs by type
  static List<ActivityLog> getLogsByType(String userId, ActivityType type) {
    return _logs.where((l) => l.userId == userId && l.type == type).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  // Get logs by category
  static List<ActivityLog> getLogsByCategory(String userId, String category) {
    return _logs
        .where((l) => l.userId == userId && l.category == category)
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  // Get all logs (for admin)
  static List<ActivityLog> getAllLogs() {
    return _logs.toList()..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  // Get recent system activity (for admin dashboard)
  static List<ActivityLog> getRecentSystemActivity({int limit = 20}) {
    return getAllLogs().take(limit).toList();
  }

  // Get login history for user
  static List<ActivityLog> getLoginHistory(String userId) {
    return getLogsByType(userId, ActivityType.login);
  }

  // Get KRS activity for user
  static List<ActivityLog> getKrsActivity(String userId) {
    return _logs
        .where(
          (l) =>
              l.userId == userId &&
              (l.type == ActivityType.krsSubmit ||
                  l.type == ActivityType.krsApprove ||
                  l.type == ActivityType.krsReject),
        )
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  // Get payment activity for user
  static List<ActivityLog> getPaymentActivity(String userId) {
    return _logs
        .where(
          (l) =>
              l.userId == userId &&
              (l.type == ActivityType.paymentSubmit ||
                  l.type == ActivityType.paymentVerify ||
                  l.type == ActivityType.paymentReject),
        )
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  // Statistics
  static Map<String, int> getUserActivityStats(String userId) {
    final logs = getLogsByUser(userId);
    final categoryCount = <String, int>{};

    for (final log in logs) {
      categoryCount[log.category] = (categoryCount[log.category] ?? 0) + 1;
    }

    return {
      'total': logs.length,
      'akademik': categoryCount['Akademik'] ?? 0,
      'keuangan': categoryCount['Keuangan'] ?? 0,
      'presensi': categoryCount['Presensi'] ?? 0,
      'keamanan': categoryCount['Keamanan'] ?? 0,
    };
  }

  // Format timestamp to Indonesian date string
  static String formatTimestamp(DateTime timestamp) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];

    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 1) {
      return 'Baru saja';
    } else if (diff.inHours < 1) {
      return '${diff.inMinutes} menit lalu';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} jam lalu';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} hari lalu';
    } else {
      return '${timestamp.day} ${months[timestamp.month - 1]} ${timestamp.year}';
    }
  }
}
