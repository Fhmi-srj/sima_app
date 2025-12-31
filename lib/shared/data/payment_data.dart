// Payment data - student-specific billing and payments with admin verification
// DYNAMIC: Data changes persist across login sessions
import 'package:sima_app/shared/data/user_data.dart';
import 'activity_log_data.dart';

enum PaymentStatus { unpaid, pending, verified, rejected }

class BillEntry {
  final String id;
  final String studentId;
  final String title;
  final String type; // 'SPP', 'UKT', 'Praktikum', 'Wisuda', etc.
  final int semester;
  final String academicYear;
  final int amount;
  final DateTime dueDate;
  PaymentStatus status;
  final String? vaNumber;
  DateTime? paidAt;
  String? paymentMethod;
  String? proofFileName;
  String? verifiedBy; // Admin ID
  DateTime? verifiedAt;
  String? rejectionReason;

  BillEntry({
    required this.id,
    required this.studentId,
    required this.title,
    required this.type,
    required this.semester,
    required this.academicYear,
    required this.amount,
    required this.dueDate,
    required this.status,
    this.vaNumber,
    this.paidAt,
    this.paymentMethod,
    this.proofFileName,
    this.verifiedBy,
    this.verifiedAt,
    this.rejectionReason,
  });

  AppUser? get student => UserData.getUserById(studentId);
  AppUser? get verifier =>
      verifiedBy != null ? UserData.getUserById(verifiedBy!) : null;

  bool get isOverdue =>
      status == PaymentStatus.unpaid && DateTime.now().isAfter(dueDate);

  String get formattedAmount {
    String amountStr = amount.toString();
    String result = '';
    int count = 0;
    for (int i = amountStr.length - 1; i >= 0; i--) {
      count++;
      result = amountStr[i] + result;
      if (count % 3 == 0 && i != 0) {
        result = '.' + result;
      }
    }
    return 'Rp $result';
  }

  String get statusText {
    switch (status) {
      case PaymentStatus.unpaid:
        return 'Belum Lunas';
      case PaymentStatus.pending:
        return 'Menunggu Verifikasi';
      case PaymentStatus.verified:
        return 'Sudah Lunas';
      case PaymentStatus.rejected:
        return 'Ditolak';
    }
  }
}

class PaymentData {
  // Billing records - initialized lazily
  static List<BillEntry>? _billsCache;

  static List<BillEntry> get _bills {
    _billsCache ??= _generateAllBills();
    return _billsCache!;
  }

  // Payment amounts per semester type
  static const _sppAmountPagi = 7500000;
  static const _sppAmountMalam = 6500000;

  // Generate all billing records for all students
  static List<BillEntry> _generateAllBills() {
    final bills = <BillEntry>[];
    final allStudents = UserData.getAllStudents();

    for (final student in allStudents) {
      final studentIndex = int.tryParse(student.id.substring(6)) ?? 0;
      final isMalam = student.kelas == 'IM23D';
      final sppAmount = isMalam ? _sppAmountMalam : _sppAmountPagi;
      final vaNumber = '8888 0123 ${student.id}';

      // Generate verified SPP for Semester 1-4 (history)
      for (int sem = 1; sem <= 4; sem++) {
        final year = sem <= 2 ? '2022/2023' : '2023/2024';
        final period = sem.isOdd ? 'Ganjil' : 'Genap';
        final paidMonth = sem.isOdd ? 12 : 6;
        final paidYear = sem <= 2
            ? (sem == 1 ? 2022 : 2023)
            : (sem == 3 ? 2023 : 2024);

        bills.add(
          BillEntry(
            id: 'BILL-${year.substring(0, 4)}-${student.id}-$sem',
            studentId: student.id,
            title: 'SPP Semester $period $year',
            type: 'SPP',
            semester: sem,
            academicYear: year,
            amount:
                sppAmount -
                (sem <= 2 ? 500000 : 0), // Earlier semesters cheaper
            dueDate: DateTime(paidYear, paidMonth, 20),
            status: PaymentStatus.verified,
            vaNumber: vaNumber,
            paidAt: DateTime(
              paidYear,
              paidMonth,
              5 + (studentIndex % 10),
              10,
              0,
            ),
            paymentMethod: 'Virtual Account BCA',
            proofFileName: 'Bukti_SPP_${student.id}_Sem$sem.jpg',
            verifiedBy: 'admin@sima.ac.id',
            verifiedAt: DateTime(
              paidYear,
              paidMonth,
              6 + (studentIndex % 10),
              9,
              0,
            ),
          ),
        );
      }

      // Generate Semester 5 SPP with varied statuses
      PaymentStatus sem5Status;
      DateTime? paidAt;
      String? paymentMethod;
      String? proofFileName;
      String? verifiedBy;
      DateTime? verifiedAt;
      String? rejectionReason;

      // Distribute statuses: 40% unpaid, 30% pending, 20% verified, 10% rejected
      if (studentIndex % 10 < 4) {
        sem5Status = PaymentStatus.unpaid;
      } else if (studentIndex % 10 < 7) {
        sem5Status = PaymentStatus.pending;
        paidAt = DateTime(2024, 12, 10 + (studentIndex % 10), 10, 0);
        paymentMethod = 'Virtual Account BCA';
        proofFileName = 'Bukti_SPP_${student.id}_Sem5.jpg';
      } else if (studentIndex % 10 < 9) {
        sem5Status = PaymentStatus.verified;
        paidAt = DateTime(2024, 11, 25 + (studentIndex % 5), 10, 0);
        paymentMethod = 'Transfer Bank Mandiri';
        proofFileName = 'Bukti_SPP_${student.id}_Sem5.jpg';
        verifiedBy = 'admin@sima.ac.id';
        verifiedAt = DateTime(2024, 11, 26 + (studentIndex % 5), 9, 0);
      } else {
        sem5Status = PaymentStatus.rejected;
        paidAt = DateTime(2024, 12, 8, 14, 0);
        paymentMethod = 'Transfer Bank BNI';
        proofFileName = 'Bukti_SPP_${student.id}_Sem5_blur.jpg';
        verifiedBy = 'admin@sima.ac.id';
        verifiedAt = DateTime(2024, 12, 9, 10, 0);
        rejectionReason = 'Bukti transfer tidak jelas. Silakan upload ulang.';
      }

      bills.add(
        BillEntry(
          id: 'BILL-2024-${student.id}-5',
          studentId: student.id,
          title: 'SPP Semester Ganjil 2024/2025',
          type: 'SPP',
          semester: 5,
          academicYear: '2024/2025',
          amount: sppAmount,
          dueDate: DateTime(2024, 12, 20),
          status: sem5Status,
          vaNumber: vaNumber,
          paidAt: paidAt,
          paymentMethod: paymentMethod,
          proofFileName: proofFileName,
          verifiedBy: verifiedBy,
          verifiedAt: verifiedAt,
          rejectionReason: rejectionReason,
        ),
      );
    }

    return bills;
  }

  // ============ QUERY METHODS ============

  // Get bill by ID
  static BillEntry? getBillById(String id) {
    try {
      return _bills.firstWhere((b) => b.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get bills for a student
  static List<BillEntry> getBillsByStudent(String studentId) {
    return _bills.where((b) => b.studentId == studentId).toList()
      ..sort((a, b) => b.dueDate.compareTo(a.dueDate)); // Latest first
  }

  // Get unpaid bills for student
  static List<BillEntry> getUnpaidBills(String studentId) {
    return _bills
        .where(
          (b) => b.studentId == studentId && b.status == PaymentStatus.unpaid,
        )
        .toList();
  }

  // Get pending verification (for admin)
  static List<BillEntry> getPendingVerification() {
    return _bills.where((b) => b.status == PaymentStatus.pending).toList()
      ..sort(
        (a, b) =>
            (a.paidAt ?? DateTime.now()).compareTo(b.paidAt ?? DateTime.now()),
      );
  }

  // Get verified payments (for admin)
  static List<BillEntry> getVerifiedPayments() {
    return _bills.where((b) => b.status == PaymentStatus.verified).toList()
      ..sort(
        (a, b) => (b.verifiedAt ?? DateTime.now()).compareTo(
          a.verifiedAt ?? DateTime.now(),
        ),
      );
  }

  // Get rejected payments (for admin)
  static List<BillEntry> getRejectedPayments() {
    return _bills.where((b) => b.status == PaymentStatus.rejected).toList();
  }

  // Get payment summary for student
  static Map<String, dynamic> getPaymentSummary(String studentId) {
    final bills = getBillsByStudent(studentId);
    int totalBills = 0;
    int totalPaid = 0;
    int totalUnpaid = 0;

    for (final bill in bills) {
      totalBills += bill.amount;
      if (bill.status == PaymentStatus.verified) {
        totalPaid += bill.amount;
      } else if (bill.status == PaymentStatus.unpaid ||
          bill.status == PaymentStatus.rejected) {
        totalUnpaid += bill.amount;
      }
    }

    return {
      'totalBills': totalBills,
      'totalPaid': totalPaid,
      'totalUnpaid': totalUnpaid,
      'paymentProgress': totalBills > 0 ? totalPaid / totalBills : 0.0,
      'pendingCount': bills
          .where((b) => b.status == PaymentStatus.pending)
          .length,
      'overdueCount': bills.where((b) => b.isOverdue).length,
    };
  }

  // Statistics for admin dashboard
  static Map<String, dynamic> getPaymentStats() {
    int totalAmount = 0;
    int paidAmount = 0;
    int unpaidAmount = 0;
    int pendingCount = 0;
    int verifiedCount = 0;
    int rejectedCount = 0;
    int overdueCount = 0;

    for (final bill in _bills) {
      totalAmount += bill.amount;

      switch (bill.status) {
        case PaymentStatus.verified:
          paidAmount += bill.amount;
          verifiedCount++;
          break;
        case PaymentStatus.pending:
          pendingCount++;
          break;
        case PaymentStatus.rejected:
          rejectedCount++;
          unpaidAmount += bill.amount;
          break;
        case PaymentStatus.unpaid:
          unpaidAmount += bill.amount;
          if (bill.isOverdue) overdueCount++;
          break;
      }
    }

    return {
      'totalBills': _bills.length,
      'totalAmount': totalAmount,
      'paidAmount': paidAmount,
      'unpaidAmount': unpaidAmount,
      'pendingCount': pendingCount,
      'verifiedCount': verifiedCount,
      'rejectedCount': rejectedCount,
      'overdueCount': overdueCount,
      'collectionRate': totalAmount > 0 ? paidAmount / totalAmount : 0.0,
    };
  }

  // Get all bills (for admin)
  static List<BillEntry> getAllBills() => _bills.toList();

  // Get overdue bills (for admin notification)
  static List<BillEntry> getOverdueBills() {
    return _bills.where((b) => b.isOverdue).toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate)); // Oldest overdue first
  }

  // ============ ACTION METHODS (Modify Data) ============

  // Student: Submit payment proof
  static bool submitPayment({
    required String billId,
    required String paymentMethod,
    required String proofFileName,
  }) {
    final bill = getBillById(billId);
    if (bill == null) return false;
    if (bill.status != PaymentStatus.unpaid &&
        bill.status != PaymentStatus.rejected) {
      return false;
    }

    bill.status = PaymentStatus.pending;
    bill.paidAt = DateTime.now();
    bill.paymentMethod = paymentMethod;
    bill.proofFileName = proofFileName;
    bill.rejectionReason = null;

    // Log activity
    ActivityLogData.addLog(
      userId: bill.studentId,
      type: ActivityType.paymentSubmit,
      title: 'Bukti Pembayaran',
      description: 'Upload bukti pembayaran ${bill.title}',
      metadata: {'billId': billId, 'amount': bill.amount},
    );

    return true;
  }

  // Admin: Verify payment
  static bool verifyPayment(String billId, String adminId) {
    final bill = getBillById(billId);
    if (bill == null) return false;
    if (bill.status != PaymentStatus.pending) return false;

    bill.status = PaymentStatus.verified;
    bill.verifiedBy = adminId;
    bill.verifiedAt = DateTime.now();
    bill.rejectionReason = null;

    // Log activity for admin
    ActivityLogData.addLog(
      userId: adminId,
      type: ActivityType.paymentVerify,
      title: 'Pembayaran Diverifikasi',
      description: 'Verifikasi pembayaran ${bill.student?.name ?? "mahasiswa"}',
      metadata: {'studentId': bill.studentId, 'amount': bill.amount},
    );

    // Log activity for student
    ActivityLogData.addLog(
      userId: bill.studentId,
      type: ActivityType.paymentVerify,
      title: 'Pembayaran Terverifikasi',
      description: '${bill.title} telah diverifikasi',
      metadata: {'billId': billId, 'verifiedBy': 'Administrator'},
    );

    return true;
  }

  // Admin: Reject payment
  static bool rejectPayment(String billId, String adminId, String reason) {
    final bill = getBillById(billId);
    if (bill == null) return false;
    if (bill.status != PaymentStatus.pending) return false;

    bill.status = PaymentStatus.rejected;
    bill.verifiedBy = adminId;
    bill.verifiedAt = DateTime.now();
    bill.rejectionReason = reason;

    // Log activity for admin
    ActivityLogData.addLog(
      userId: adminId,
      type: ActivityType.paymentReject,
      title: 'Pembayaran Ditolak',
      description:
          'Menolak pembayaran ${bill.student?.name ?? "mahasiswa"} - $reason',
      metadata: {'studentId': bill.studentId, 'reason': reason},
    );

    // Log activity for student
    ActivityLogData.addLog(
      userId: bill.studentId,
      type: ActivityType.paymentReject,
      title: 'Pembayaran Ditolak',
      description: '${bill.title} ditolak. Alasan: $reason',
      metadata: {'billId': billId, 'reason': reason},
    );

    return true;
  }

  // Student: Resubmit rejected payment
  static bool resubmitPayment({
    required String billId,
    required String paymentMethod,
    required String proofFileName,
  }) {
    final bill = getBillById(billId);
    if (bill == null) return false;
    if (bill.status != PaymentStatus.rejected) return false;

    bill.status = PaymentStatus.pending;
    bill.paidAt = DateTime.now();
    bill.paymentMethod = paymentMethod;
    bill.proofFileName = proofFileName;
    bill.rejectionReason = null;
    bill.verifiedBy = null;
    bill.verifiedAt = null;

    ActivityLogData.addLog(
      userId: bill.studentId,
      type: ActivityType.paymentSubmit,
      title: 'Bukti Pembayaran (Ulang)',
      description: 'Upload ulang bukti pembayaran ${bill.title}',
      metadata: {'billId': billId, 'amount': bill.amount, 'resubmit': true},
    );

    return true;
  }
}
