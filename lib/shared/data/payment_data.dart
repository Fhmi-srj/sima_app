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
  // MUTABLE billing records
  static final List<BillEntry> _bills = [
    // ===== AHMAD RIZKY (102230039) =====
    // Current semester - unpaid
    BillEntry(
      id: 'BILL-2024-039-001',
      studentId: '102230039',
      title: 'SPP Semester Ganjil 2024/2025',
      type: 'SPP',
      semester: 5,
      academicYear: '2024/2025',
      amount: 7500000,
      dueDate: DateTime(2024, 12, 20),
      status: PaymentStatus.unpaid,
      vaNumber: '8888 0123 2023010239',
    ),
    // Previous - verified
    BillEntry(
      id: 'BILL-2024-039-002',
      studentId: '102230039',
      title: 'UKT Semester Genap 2023/2024',
      type: 'UKT',
      semester: 4,
      academicYear: '2023/2024',
      amount: 7500000,
      dueDate: DateTime(2024, 6, 15),
      status: PaymentStatus.verified,
      vaNumber: '8888 0123 2023010239',
      paidAt: DateTime(2024, 6, 2, 14, 28),
      paymentMethod: 'Virtual Account BCA',
      proofFileName: 'Bukti_Transfer_UKT_039.jpg',
      verifiedBy: 'admin@sima.ac.id',
      verifiedAt: DateTime(2024, 6, 3, 9, 0),
    ),
    // Previous - verified
    BillEntry(
      id: 'BILL-2023-039-003',
      studentId: '102230039',
      title: 'SPP Semester Ganjil 2023/2024',
      type: 'SPP',
      semester: 3,
      academicYear: '2023/2024',
      amount: 7000000,
      dueDate: DateTime(2023, 12, 15),
      status: PaymentStatus.verified,
      paidAt: DateTime(2023, 12, 10, 10, 30),
      paymentMethod: 'Transfer Bank Mandiri',
      proofFileName: 'Bukti_SPP_Sem3_039.jpg',
      verifiedBy: 'admin@sima.ac.id',
      verifiedAt: DateTime(2023, 12, 11, 8, 45),
    ),

    // ===== SITI NURHALIZA (102230040) =====
    BillEntry(
      id: 'BILL-2024-040-001',
      studentId: '102230040',
      title: 'SPP Semester Ganjil 2024/2025',
      type: 'SPP',
      semester: 5,
      academicYear: '2024/2025',
      amount: 7500000,
      dueDate: DateTime(2024, 12, 20),
      status: PaymentStatus.pending,
      vaNumber: '8888 0123 2023010240',
      paidAt: DateTime(2024, 12, 10, 16, 45),
      paymentMethod: 'Virtual Account BCA',
      proofFileName: 'Bukti_SPP_040.jpg',
    ),
    BillEntry(
      id: 'BILL-2024-040-002',
      studentId: '102230040',
      title: 'UKT Semester Genap 2023/2024',
      type: 'UKT',
      semester: 4,
      academicYear: '2023/2024',
      amount: 7500000,
      dueDate: DateTime(2024, 6, 15),
      status: PaymentStatus.verified,
      paidAt: DateTime(2024, 6, 5, 11, 30),
      paymentMethod: 'Virtual Account BNI',
      proofFileName: 'Bukti_UKT_040.jpg',
      verifiedBy: 'admin@sima.ac.id',
      verifiedAt: DateTime(2024, 6, 6, 9, 15),
    ),

    // ===== BUDI SANTOSO (102230041) =====
    BillEntry(
      id: 'BILL-2024-041-001',
      studentId: '102230041',
      title: 'SPP Semester Ganjil 2024/2025',
      type: 'SPP',
      semester: 5,
      academicYear: '2024/2025',
      amount: 7500000,
      dueDate: DateTime(2024, 12, 20),
      status: PaymentStatus.pending,
      vaNumber: '8888 0123 2023010241',
      paidAt: DateTime(2024, 12, 14, 9, 20),
      paymentMethod: 'Transfer Bank BRI',
      proofFileName: 'Bukti_SPP_041.jpg',
    ),

    // ===== DEWI LESTARI (102230042) =====
    BillEntry(
      id: 'BILL-2024-042-001',
      studentId: '102230042',
      title: 'SPP Semester Ganjil 2024/2025',
      type: 'SPP',
      semester: 5,
      academicYear: '2024/2025',
      amount: 7500000,
      dueDate: DateTime(2024, 12, 20),
      status: PaymentStatus.unpaid,
      vaNumber: '8888 0123 2023010242',
    ),

    // ===== ANDI PRATAMA (102230043) - rejected =====
    BillEntry(
      id: 'BILL-2024-043-001',
      studentId: '102230043',
      title: 'SPP Semester Ganjil 2024/2025',
      type: 'SPP',
      semester: 5,
      academicYear: '2024/2025',
      amount: 7500000,
      dueDate: DateTime(2024, 12, 20),
      status: PaymentStatus.rejected,
      vaNumber: '8888 0123 2023010243',
      paidAt: DateTime(2024, 12, 8, 14, 10),
      paymentMethod: 'Transfer Bank Mandiri',
      proofFileName: 'Bukti_SPP_043_blur.jpg',
      verifiedBy: 'admin@sima.ac.id',
      verifiedAt: DateTime(2024, 12, 9, 10, 0),
      rejectionReason: 'Bukti transfer tidak jelas/blur. Silakan upload ulang.',
    ),

    // ===== EKO PRASETYO (102230001) - IM23A =====
    BillEntry(
      id: 'BILL-2024-001-001',
      studentId: '102230001',
      title: 'SPP Semester Ganjil 2024/2025',
      type: 'SPP',
      semester: 5,
      academicYear: '2024/2025',
      amount: 7500000,
      dueDate: DateTime(2024, 12, 20),
      status: PaymentStatus.verified,
      paidAt: DateTime(2024, 11, 28, 10, 15),
      paymentMethod: 'Virtual Account BCA',
      proofFileName: 'Bukti_SPP_001.jpg',
      verifiedBy: 'admin@sima.ac.id',
      verifiedAt: DateTime(2024, 11, 29, 8, 30),
    ),

    // ===== DEDI SUPRIADI (102230076) - IM23D Malam =====
    BillEntry(
      id: 'BILL-2024-076-001',
      studentId: '102230076',
      title: 'SPP Semester Ganjil 2024/2025',
      type: 'SPP',
      semester: 5,
      academicYear: '2024/2025',
      amount: 6500000, // Kelas malam lebih murah
      dueDate: DateTime(2024, 12, 25),
      status: PaymentStatus.pending,
      vaNumber: '8888 0123 2023010276',
      paidAt: DateTime(2024, 12, 15, 20, 30),
      paymentMethod: 'Virtual Account Mandiri',
      proofFileName: 'Bukti_SPP_076.jpg',
    ),

    // ===== Additional pending payments for admin =====
    BillEntry(
      id: 'BILL-2024-053-001',
      studentId: '102230053',
      title: 'SPP Semester Ganjil 2024/2025',
      type: 'SPP',
      semester: 5,
      academicYear: '2024/2025',
      amount: 7500000,
      dueDate: DateTime(2024, 12, 20),
      status: PaymentStatus.pending,
      vaNumber: '8888 0123 2023010253',
      paidAt: DateTime(2024, 12, 12, 13, 45),
      paymentMethod: 'Transfer Bank BNI',
      proofFileName: 'Bukti_SPP_053.jpg',
    ),
    BillEntry(
      id: 'BILL-2024-054-001',
      studentId: '102230054',
      title: 'SPP Semester Ganjil 2024/2025',
      type: 'SPP',
      semester: 5,
      academicYear: '2024/2025',
      amount: 7500000,
      dueDate: DateTime(2024, 12, 20),
      status: PaymentStatus.pending,
      vaNumber: '8888 0123 2023010254',
      paidAt: DateTime(2024, 12, 13, 10, 20),
      paymentMethod: 'Virtual Account BCA',
      proofFileName: 'Bukti_SPP_054.jpg',
    ),
  ];

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

