// KRS (Kartu Rencana Studi) data - linked to students, courses, and lecturers
// DYNAMIC: Data changes persist across login sessions
import 'user_data.dart';
import 'class_data.dart';
import 'activity_log_data.dart';

enum KrsStatus { draft, pending, approved, rejected }

class KrsEntry {
  final String id;
  final String studentId;
  final int semester;
  final String academicYear;
  final String period; // 'Ganjil' or 'Genap'
  List<String> courseCodes;
  final String dosenPaId; // Dosen Pembimbing Akademik
  KrsStatus status;
  DateTime? submittedAt;
  DateTime? approvedAt;
  String? rejectionReason;
  int totalSks;

  // Admin publish fields
  final String? publishedBy; // Admin ID who published
  final DateTime? publishedAt; // When published by admin
  final DateTime? deadline; // Submission deadline

  KrsEntry({
    required this.id,
    required this.studentId,
    required this.semester,
    required this.academicYear,
    required this.period,
    required this.courseCodes,
    required this.dosenPaId,
    required this.status,
    this.submittedAt,
    this.approvedAt,
    this.rejectionReason,
    required this.totalSks,
    this.publishedBy,
    this.publishedAt,
    this.deadline,
  });

  // Get student info
  AppUser? get student => UserData.getUserById(studentId);

  // Get dosen PA info
  AppUser? get dosenPa => UserData.getUserById(dosenPaId);

  // Get course details
  List<CourseAssignment> get courses {
    final student = this.student;
    if (student == null) return [];
    return ClassData.getCoursesByKelas(
      student.kelas ?? '',
    ).where((c) => courseCodes.contains(c.courseCode)).toList();
  }

  // Status text for UI
  String get statusText {
    switch (status) {
      case KrsStatus.draft:
        return 'Draft';
      case KrsStatus.pending:
        return 'Menunggu Persetujuan';
      case KrsStatus.approved:
        return 'Disetujui';
      case KrsStatus.rejected:
        return 'Ditolak';
    }
  }

  // Check if deadline has passed
  bool get isDeadlinePassed =>
      deadline != null && DateTime.now().isAfter(deadline!);

  // Days until deadline
  int get daysUntilDeadline {
    if (deadline == null) return 999;
    return deadline!.difference(DateTime.now()).inDays;
  }
}

class KrsData {
  // Dosen PA assignments - which lecturer is PA for which class
  static final Map<String, String> _dosenPaAssignments = {
    'IM23A': '198506152010121001', // Dr. Hendra Wijaya
    'IM23B': '198712202015042001', // Bu Mega Nindityawati
    'IM23C': '198712202015042001', // Bu Mega Nindityawati
    'IM23D': '199003152018031001', // Pak Razak Naufal
  };

  // Get dosen PA for a class
  static String? getDosenPaForKelas(String kelasCode) {
    return _dosenPaAssignments[kelasCode];
  }

  // Get dosen PA for a student
  static AppUser? getDosenPaForStudent(String studentId) {
    final student = UserData.getUserById(studentId);
    if (student == null || student.kelas == null) return null;
    final dosenPaId = _dosenPaAssignments[student.kelas];
    if (dosenPaId == null) return null;
    return UserData.getUserById(dosenPaId);
  }

  // MUTABLE KRS records - changes persist in memory
  static final List<KrsEntry> _krsRecords = [
    // ===== DRAFT KRS - Published by admin, waiting for student to submit =====
    // Ahmad Rizky (logged in user) - draft (admin published)
    KrsEntry(
      id: 'KRS-2024-039-5',
      studentId: '102230039',
      semester: 5,
      academicYear: '2024/2025',
      period: 'Ganjil',
      courseCodes: [
        'IF501',
        'IF502',
        'IF503',
        'IF504',
        'IF505',
        'IF506',
        'IF507',
        'IF508',
      ],
      dosenPaId: '198712202015042001',
      status: KrsStatus.draft, // Changed to draft
      totalSks: 23,
      publishedBy: 'admin@sima.ac.id', // Published by admin
      publishedAt: DateTime(2024, 12, 10, 8, 0),
      deadline: DateTime(2025, 1, 5, 23, 59), // Deadline Jan 5, 2025
    ),
    KrsEntry(
      id: 'KRS-2024-040-5',
      studentId: '102230040',
      semester: 5,
      academicYear: '2024/2025',
      period: 'Ganjil',
      courseCodes: [
        'IF501',
        'IF502',
        'IF503',
        'IF504',
        'IF505',
        'IF506',
        'IF507',
        'IF508',
      ],
      dosenPaId: '198712202015042001',
      status: KrsStatus.approved,
      submittedAt: DateTime(2024, 8, 14, 11, 0),
      approvedAt: DateTime(2024, 8, 15, 8, 30),
      totalSks: 23,
    ),
    KrsEntry(
      id: 'KRS-2024-041-5',
      studentId: '102230041',
      semester: 5,
      academicYear: '2024/2025',
      period: 'Ganjil',
      courseCodes: [
        'IF501',
        'IF502',
        'IF503',
        'IF504',
        'IF505',
        'IF506',
        'IF507',
        'IF508',
      ],
      dosenPaId: '198712202015042001',
      status: KrsStatus.approved,
      submittedAt: DateTime(2024, 8, 14, 14, 20),
      approvedAt: DateTime(2024, 8, 15, 9, 0),
      totalSks: 23,
    ),

    // ===== PENDING KRS - waiting for approval =====
    KrsEntry(
      id: 'KRS-2024-042-5',
      studentId: '102230042',
      semester: 5,
      academicYear: '2024/2025',
      period: 'Ganjil',
      courseCodes: [
        'IF501',
        'IF502',
        'IF503',
        'IF504',
        'IF505',
        'IF506',
        'IF507',
        'IF508',
      ],
      dosenPaId: '198712202015042001',
      status: KrsStatus.pending,
      submittedAt: DateTime(2024, 12, 15, 10, 30),
      totalSks: 23,
    ),
    KrsEntry(
      id: 'KRS-2024-043-5',
      studentId: '102230043',
      semester: 5,
      academicYear: '2024/2025',
      period: 'Ganjil',
      courseCodes: [
        'IF501',
        'IF502',
        'IF503',
        'IF504',
        'IF505',
        'IF506',
        'IF507',
      ],
      dosenPaId: '198712202015042001',
      status: KrsStatus.pending,
      submittedAt: DateTime(2024, 12, 16, 8, 15),
      totalSks: 20,
    ),
    KrsEntry(
      id: 'KRS-2024-053-5',
      studentId: '102230053',
      semester: 5,
      academicYear: '2024/2025',
      period: 'Ganjil',
      courseCodes: [
        'IF501',
        'IF502',
        'IF503',
        'IF504',
        'IF505',
        'IF506',
        'IF507',
        'IF508',
      ],
      dosenPaId: '198712202015042001',
      status: KrsStatus.pending,
      submittedAt: DateTime(2024, 12, 16, 14, 45),
      totalSks: 23,
    ),

    // ===== REJECTED KRS =====
    KrsEntry(
      id: 'KRS-2024-054-5',
      studentId: '102230054',
      semester: 5,
      academicYear: '2024/2025',
      period: 'Ganjil',
      courseCodes: [
        'IF501',
        'IF502',
        'IF503',
        'IF504',
        'IF505',
        'IF506',
        'IF507',
        'IF508',
        'IF510',
      ],
      dosenPaId: '198712202015042001',
      status: KrsStatus.rejected,
      submittedAt: DateTime(2024, 8, 13, 9, 0),
      rejectionReason:
          'SKS melebihi batas maksimal. Silakan kurangi 1 mata kuliah.',
      totalSks: 24,
    ),

    // ===== KELAS IM23A =====
    KrsEntry(
      id: 'KRS-2024-001-5',
      studentId: '102230001',
      semester: 5,
      academicYear: '2024/2025',
      period: 'Ganjil',
      courseCodes: ['IF501', 'IF502', 'IF503'],
      dosenPaId: '198506152010121001',
      status: KrsStatus.approved,
      submittedAt: DateTime(2024, 8, 12, 10, 0),
      approvedAt: DateTime(2024, 8, 13, 9, 0),
      totalSks: 8,
    ),
    KrsEntry(
      id: 'KRS-2024-002-5',
      studentId: '102230002',
      semester: 5,
      academicYear: '2024/2025',
      period: 'Ganjil',
      courseCodes: ['IF501', 'IF502', 'IF503'],
      dosenPaId: '198506152010121001',
      status: KrsStatus.pending,
      submittedAt: DateTime(2024, 12, 16, 11, 30),
      totalSks: 8,
    ),

    // ===== KELAS IM23D (Malam) =====
    KrsEntry(
      id: 'KRS-2024-076-5',
      studentId: '102230076',
      semester: 5,
      academicYear: '2024/2025',
      period: 'Ganjil',
      courseCodes: ['IF501', 'IF503', 'IF510'],
      dosenPaId: '199003152018031001',
      status: KrsStatus.approved,
      submittedAt: DateTime(2024, 8, 14, 18, 0),
      approvedAt: DateTime(2024, 8, 15, 10, 0),
      totalSks: 7,
    ),
    KrsEntry(
      id: 'KRS-2024-077-5',
      studentId: '102230077',
      semester: 5,
      academicYear: '2024/2025',
      period: 'Ganjil',
      courseCodes: ['IF501', 'IF503', 'IF510'],
      dosenPaId: '199003152018031001',
      status: KrsStatus.pending,
      submittedAt: DateTime(2024, 12, 15, 19, 30),
      totalSks: 7,
    ),
  ];

  // ============ QUERY METHODS ============

  // Get KRS by ID
  static KrsEntry? getKrsById(String id) {
    try {
      return _krsRecords.firstWhere((k) => k.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get KRS for a student
  static List<KrsEntry> getKrsByStudent(String studentId) {
    return _krsRecords.where((k) => k.studentId == studentId).toList();
  }

  // Get current semester KRS for student
  static KrsEntry? getCurrentKrs(String studentId) {
    final list = _krsRecords
        .where((k) => k.studentId == studentId && k.semester == 5)
        .toList();
    return list.isNotEmpty ? list.first : null;
  }

  // Get pending KRS for a dosen PA
  static List<KrsEntry> getPendingKrsForDosenPa(String dosenPaId) {
    return _krsRecords
        .where((k) => k.dosenPaId == dosenPaId && k.status == KrsStatus.pending)
        .toList();
  }

  // Get approved KRS for a dosen PA
  static List<KrsEntry> getApprovedKrsForDosenPa(String dosenPaId) {
    return _krsRecords
        .where(
          (k) => k.dosenPaId == dosenPaId && k.status == KrsStatus.approved,
        )
        .toList();
  }

  // Get rejected KRS for a dosen PA
  static List<KrsEntry> getRejectedKrsForDosenPa(String dosenPaId) {
    return _krsRecords
        .where(
          (k) => k.dosenPaId == dosenPaId && k.status == KrsStatus.rejected,
        )
        .toList();
  }

  // Get all KRS by status
  static List<KrsEntry> getKrsByStatus(KrsStatus status) {
    return _krsRecords.where((k) => k.status == status).toList();
  }

  // Get students under a dosen PA (bimbingan)
  static List<AppUser> getStudentsForDosenPa(String dosenPaId) {
    final kelasList = _dosenPaAssignments.entries
        .where((e) => e.value == dosenPaId)
        .map((e) => e.key)
        .toList();

    final students = <AppUser>[];
    for (final kelas in kelasList) {
      students.addAll(UserData.getStudentsByKelas(kelas));
    }
    return students;
  }

  // Get total pending KRS count for dosen
  static int getPendingKrsCount(String dosenPaId) {
    return getPendingKrsForDosenPa(dosenPaId).length;
  }

  // All KRS records (for admin)
  static List<KrsEntry> getAllKrs() => _krsRecords.toList();

  // Statistics for admin dashboard
  static Map<String, int> getKrsStats() {
    return {
      'total': _krsRecords.length,
      'draft': _krsRecords.where((k) => k.status == KrsStatus.draft).length,
      'pending': _krsRecords.where((k) => k.status == KrsStatus.pending).length,
      'approved': _krsRecords
          .where((k) => k.status == KrsStatus.approved)
          .length,
      'rejected': _krsRecords
          .where((k) => k.status == KrsStatus.rejected)
          .length,
    };
  }

  /// Get students with approved KRS for a specific class and semester
  /// Used by lecturer to show only students who have approved KRS in attendance
  static List<AppUser> getApprovedStudentsForClass(
    String kelasCode,
    int semester,
  ) {
    final approvedKrs = _krsRecords
        .where((k) => k.status == KrsStatus.approved && k.semester == semester)
        .toList();

    final students = <AppUser>[];
    for (final krs in approvedKrs) {
      final student = UserData.getUserById(krs.studentId);
      if (student != null && student.kelas == kelasCode) {
        students.add(student);
      }
    }
    return students;
  }

  /// Check if a student has approved KRS for the current semester
  static bool hasApprovedKrs(String studentId, int semester) {
    return _krsRecords.any(
      (k) =>
          k.studentId == studentId &&
          k.semester == semester &&
          k.status == KrsStatus.approved,
    );
  }

  // ============ ACTION METHODS (Modify Data) ============

  // Student: Submit new KRS
  static KrsEntry submitKrs({
    required String studentId,
    required List<String> courseCodes,
    required int totalSks,
  }) {
    final student = UserData.getUserById(studentId);
    if (student == null) throw Exception('Student not found');

    final dosenPaId = _dosenPaAssignments[student.kelas];
    if (dosenPaId == null) throw Exception('Dosen PA not found for class');

    final id = 'KRS-${DateTime.now().year}-$studentId-5';

    // Check if KRS already exists for this semester
    final existing = _krsRecords
        .where((k) => k.studentId == studentId && k.semester == 5)
        .toList();

    if (existing.isNotEmpty) {
      // Update existing KRS
      final krs = existing.first;
      krs.courseCodes = courseCodes;
      krs.totalSks = totalSks;
      krs.status = KrsStatus.pending;
      krs.submittedAt = DateTime.now();
      krs.approvedAt = null;
      krs.rejectionReason = null;

      // Log activity
      ActivityLogData.addLog(
        userId: studentId,
        type: ActivityType.krsSubmit,
        title: 'KRS Diajukan',
        description: 'KRS Semester 5 diajukan untuk persetujuan',
        metadata: {'semester': 5, 'totalSks': totalSks},
      );

      return krs;
    }

    // Create new KRS
    final newKrs = KrsEntry(
      id: id,
      studentId: studentId,
      semester: 5,
      academicYear: '2024/2025',
      period: 'Ganjil',
      courseCodes: courseCodes,
      dosenPaId: dosenPaId,
      status: KrsStatus.pending,
      submittedAt: DateTime.now(),
      totalSks: totalSks,
    );

    _krsRecords.add(newKrs);

    // Log activity
    ActivityLogData.addLog(
      userId: studentId,
      type: ActivityType.krsSubmit,
      title: 'KRS Diajukan',
      description: 'KRS Semester 5 diajukan untuk persetujuan',
      metadata: {'semester': 5, 'totalSks': totalSks},
    );

    return newKrs;
  }

  // Dosen: Approve KRS
  static bool approveKrs(String krsId, String dosenPaId) {
    final krs = getKrsById(krsId);
    if (krs == null) return false;
    if (krs.dosenPaId != dosenPaId) return false;
    if (krs.status != KrsStatus.pending) return false;

    krs.status = KrsStatus.approved;
    krs.approvedAt = DateTime.now();
    krs.rejectionReason = null;

    // Log activity for dosen
    final dosenPa = UserData.getUserById(dosenPaId);
    ActivityLogData.addLog(
      userId: dosenPaId,
      type: ActivityType.krsApprove,
      title: 'KRS Disetujui',
      description: 'Menyetujui KRS ${krs.student?.name ?? "mahasiswa"}',
      metadata: {'studentId': krs.studentId, 'studentName': krs.student?.name},
    );

    // Log activity for student
    ActivityLogData.addLog(
      userId: krs.studentId,
      type: ActivityType.krsApprove,
      title: 'KRS Disetujui',
      description:
          'KRS Semester ${krs.semester} disetujui oleh ${dosenPa?.name ?? "Dosen PA"}',
      metadata: {'semester': krs.semester, 'approvedBy': dosenPa?.name},
    );

    return true;
  }

  // Dosen: Reject KRS
  static bool rejectKrs(String krsId, String dosenPaId, String reason) {
    final krs = getKrsById(krsId);
    if (krs == null) return false;
    if (krs.dosenPaId != dosenPaId) return false;
    if (krs.status != KrsStatus.pending) return false;

    krs.status = KrsStatus.rejected;
    krs.rejectionReason = reason;
    krs.approvedAt = null;

    // Log activity for dosen
    ActivityLogData.addLog(
      userId: dosenPaId,
      type: ActivityType.krsReject,
      title: 'KRS Ditolak',
      description: 'Menolak KRS ${krs.student?.name ?? "mahasiswa"} - $reason',
      metadata: {'studentId': krs.studentId, 'reason': reason},
    );

    // Log activity for student
    ActivityLogData.addLog(
      userId: krs.studentId,
      type: ActivityType.krsReject,
      title: 'KRS Ditolak',
      description: 'KRS Semester ${krs.semester} ditolak. Alasan: $reason',
      metadata: {'semester': krs.semester, 'reason': reason},
    );

    return true;
  }

  // ============ ADMIN PUBLISH METHODS ============

  // Publish schedule storage per class
  static final Map<String, Map<String, dynamic>> _publishSchedules = {};

  // Get publish schedule for a class
  static Map<String, dynamic>? getPublishSchedule(String kelasCode) {
    return _publishSchedules[kelasCode];
  }

  // Set publish schedule for a class
  static void setPublishSchedule({
    required String kelasCode,
    required DateTime publishDate,
    required DateTime deadline,
  }) {
    _publishSchedules[kelasCode] = {
      'publishDate': publishDate,
      'deadline': deadline,
      'notifiedStudents': <String>[],
    };
  }

  // Admin: Publish KRS for all students in a class
  static List<KrsEntry> publishKrsForClass({
    required String adminId,
    required String kelasCode,
    required int semester,
    required String academicYear,
    required String period,
    required DateTime deadline,
  }) {
    final publishedKrs = <KrsEntry>[];

    // Get all students in the class
    final students = UserData.getStudentsByKelas(kelasCode);
    if (students.isEmpty) return [];

    // Get course package for this class
    final courses = ClassData.getCoursesByKelas(kelasCode);
    final courseCodes = courses.map((c) => c.courseCode).toList();
    final totalSks = courses.fold<int>(0, (sum, c) => sum + c.sks);

    // Get dosen PA for this class
    final dosenPaId = _dosenPaAssignments[kelasCode];
    if (dosenPaId == null) return [];

    final now = DateTime.now();

    for (final student in students) {
      // Check if KRS already exists for this semester
      final existingKrs = _krsRecords
          .where((k) => k.studentId == student.id && k.semester == semester)
          .toList();

      if (existingKrs.isEmpty) {
        // Create new draft KRS for student
        final krsId = 'KRS-$academicYear-${student.id}-$semester';
        final newKrs = KrsEntry(
          id: krsId,
          studentId: student.id,
          semester: semester,
          academicYear: academicYear,
          period: period,
          courseCodes: courseCodes,
          dosenPaId: dosenPaId,
          status: KrsStatus.draft,
          totalSks: totalSks,
          publishedBy: adminId,
          publishedAt: now,
          deadline: deadline,
        );
        _krsRecords.add(newKrs);
        publishedKrs.add(newKrs);

        // Log activity for student
        ActivityLogData.addLog(
          userId: student.id,
          type: ActivityType.notification,
          title: 'KRS Tersedia',
          description:
              'KRS Semester $semester telah dipublish. Deadline: ${_formatDate(deadline)}',
          metadata: {
            'semester': semester,
            'deadline': deadline.toIso8601String(),
          },
        );
      }
    }

    // Log activity for admin
    ActivityLogData.addLog(
      userId: adminId,
      type: ActivityType.dataUpdate,
      title: 'KRS Dipublish',
      description:
          'Mempublish KRS Semester $semester untuk kelas $kelasCode (${publishedKrs.length} mahasiswa)',
      metadata: {'kelas': kelasCode, 'count': publishedKrs.length},
    );

    // Store publish schedule
    setPublishSchedule(
      kelasCode: kelasCode,
      publishDate: now,
      deadline: deadline,
    );

    return publishedKrs;
  }

  // Get students who haven't submitted KRS for a class
  static List<AppUser> getStudentsNotSubmitted(String kelasCode, int semester) {
    final students = UserData.getStudentsByKelas(kelasCode);
    final notSubmitted = <AppUser>[];

    for (final student in students) {
      final krs = _krsRecords
          .where((k) => k.studentId == student.id && k.semester == semester)
          .toList();

      if (krs.isEmpty || krs.first.status == KrsStatus.draft) {
        notSubmitted.add(student);
      }
    }

    return notSubmitted;
  }

  // Get class KRS status summary
  static Map<String, int> getClassKrsStats(String kelasCode, int semester) {
    final students = UserData.getStudentsByKelas(kelasCode);
    int draft = 0, pending = 0, approved = 0, rejected = 0, notPublished = 0;

    for (final student in students) {
      final krs = _krsRecords
          .where((k) => k.studentId == student.id && k.semester == semester)
          .toList();

      if (krs.isEmpty) {
        notPublished++;
      } else {
        switch (krs.first.status) {
          case KrsStatus.draft:
            draft++;
            break;
          case KrsStatus.pending:
            pending++;
            break;
          case KrsStatus.approved:
            approved++;
            break;
          case KrsStatus.rejected:
            rejected++;
            break;
        }
      }
    }

    return {
      'total': students.length,
      'notPublished': notPublished,
      'draft': draft,
      'pending': pending,
      'approved': approved,
      'rejected': rejected,
    };
  }

  // Send reminder notification to students who haven't submitted
  static int sendReminderNotifications(
    String kelasCode,
    int semester,
    String adminId,
  ) {
    final notSubmitted = getStudentsNotSubmitted(kelasCode, semester);

    for (final student in notSubmitted) {
      ActivityLogData.addLog(
        userId: student.id,
        type: ActivityType.notification,
        title: '⚠️ Peringatan KRS',
        description:
            'Segera submit KRS Anda! Deadline pengajuan KRS hampir berakhir.',
        metadata: {'semester': semester, 'type': 'reminder'},
      );
    }

    if (notSubmitted.isNotEmpty) {
      ActivityLogData.addLog(
        userId: adminId,
        type: ActivityType.notification,
        title: 'Notifikasi Terkirim',
        description:
            'Mengirim peringatan ke ${notSubmitted.length} mahasiswa kelas $kelasCode',
        metadata: {'kelas': kelasCode, 'count': notSubmitted.length},
      );
    }

    return notSubmitted.length;
  }

  // Helper: Format date for display
  static String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Ags',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  // Get draft KRS for a student (published by admin, not yet submitted)
  static KrsEntry? getDraftKrsForStudent(String studentId, int semester) {
    try {
      return _krsRecords.firstWhere(
        (k) =>
            k.studentId == studentId &&
            k.semester == semester &&
            k.status == KrsStatus.draft,
      );
    } catch (e) {
      return null;
    }
  }

  // Student: Submit draft KRS to Dosen Wali
  static bool submitDraftKrs(String krsId) {
    final krs = getKrsById(krsId);
    if (krs == null) return false;
    if (krs.status != KrsStatus.draft) return false;

    krs.status = KrsStatus.pending;
    krs.submittedAt = DateTime.now();

    // Log for student
    ActivityLogData.addLog(
      userId: krs.studentId,
      type: ActivityType.krsSubmit,
      title: 'KRS Diajukan',
      description: 'KRS Semester ${krs.semester} diajukan ke Dosen Wali',
      metadata: {'semester': krs.semester, 'totalSks': krs.totalSks},
    );

    // Log for dosen
    ActivityLogData.addLog(
      userId: krs.dosenPaId,
      type: ActivityType.notification,
      title: 'Persetujuan KRS Baru',
      description:
          '${krs.student?.name ?? "Mahasiswa"} mengajukan KRS untuk persetujuan',
      metadata: {'studentId': krs.studentId, 'studentName': krs.student?.name},
    );

    return true;
  }
}
