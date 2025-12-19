import 'package:flutter/material.dart';
import 'widgets/custom_top_bar.dart';
import 'widgets/payment_detail_modal.dart';
import 'widgets/paid_payment_modal.dart';
import 'data/payment_data.dart';

class FinancePageContent extends StatefulWidget {
  final VoidCallback? onNavigateToProfile;
  final VoidCallback? onNavigateToSettings;
  final String? studentId;

  const FinancePageContent({
    super.key,
    this.onNavigateToProfile,
    this.onNavigateToSettings,
    this.studentId,
  });

  @override
  State<FinancePageContent> createState() => _FinancePageContentState();
}

class _FinancePageContentState extends State<FinancePageContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Get bills for the current student
  List<BillEntry> _getBills() {
    if (widget.studentId == null) return [];
    return PaymentData.getBillsByStudent(widget.studentId!);
  }

  // Get payment summary for the current student
  Map<String, dynamic> _getPaymentSummary() {
    if (widget.studentId == null) {
      return {
        'totalBills': 0,
        'totalPaid': 0,
        'totalUnpaid': 0,
        'paymentProgress': 0.0,
        'pendingCount': 0,
        'overdueCount': 0,
      };
    }
    return PaymentData.getPaymentSummary(widget.studentId!);
  }

  // Format currency
  String _formatCurrency(int value) {
    String valueStr = value.toString();
    String result = '';
    int count = 0;
    for (int i = valueStr.length - 1; i >= 0; i--) {
      count++;
      result = valueStr[i] + result;
      if (count % 3 == 0 && i != 0) {
        result = '.$result';
      }
    }
    return 'Rp $result';
  }

  // Generate notifications from bill statuses
  List<Map<String, dynamic>> _getNotifications() {
    final bills = _getBills();
    final notifications = <Map<String, dynamic>>[];

    for (final bill in bills) {
      // Overdue warning
      if (bill.isOverdue) {
        final daysOverdue = DateTime.now().difference(bill.dueDate).inDays;
        notifications.add({
          'id': 'NOTIF-${bill.id}-overdue',
          'type': 'warning',
          'title': 'Tagihan Terlambat',
          'subtitle': '${bill.title}\nTerlambat $daysOverdue hari',
          'amount': bill.formattedAmount,
          'billId': bill.id,
        });
      }
      // Pending verification
      else if (bill.status == PaymentStatus.pending) {
        notifications.add({
          'id': 'NOTIF-${bill.id}-pending',
          'type': 'info',
          'title': 'Menunggu Verifikasi',
          'subtitle': '${bill.title}\nSedang diproses admin',
          'amount': bill.formattedAmount,
          'billId': bill.id,
        });
      }
      // Rejected - needs resubmission
      else if (bill.status == PaymentStatus.rejected) {
        notifications.add({
          'id': 'NOTIF-${bill.id}-rejected',
          'type': 'warning',
          'title': 'Pembayaran Ditolak',
          'subtitle':
              '${bill.title}\n${bill.rejectionReason ?? "Upload ulang bukti"}',
          'amount': bill.formattedAmount,
          'billId': bill.id,
        });
      }
      // Verified - success notification
      else if (bill.status == PaymentStatus.verified &&
          bill.verifiedAt != null) {
        final daysSinceVerified = DateTime.now()
            .difference(bill.verifiedAt!)
            .inDays;
        if (daysSinceVerified <= 7) {
          notifications.add({
            'id': 'NOTIF-${bill.id}-verified',
            'type': 'success',
            'title': 'Pembayaran Terverifikasi',
            'subtitle': '${bill.title}\n${_formatDate(bill.verifiedAt!)}',
            'amount': null,
            'billId': bill.id,
          });
        }
      }
      // Unpaid - upcoming due date warning
      else if (bill.status == PaymentStatus.unpaid) {
        final daysUntilDue = bill.dueDate.difference(DateTime.now()).inDays;
        if (daysUntilDue <= 7 && daysUntilDue >= 0) {
          notifications.add({
            'id': 'NOTIF-${bill.id}-upcoming',
            'type': 'warning',
            'title': 'Tagihan Akan Jatuh Tempo',
            'subtitle': '${bill.title}\nJatuh tempo dalam $daysUntilDue hari',
            'amount': bill.formattedAmount,
            'billId': bill.id,
          });
        }
      }
    }

    return notifications;
  }

  String _formatDate(DateTime date) {
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

  @override
  Widget build(BuildContext context) {
    final summary = _getPaymentSummary();
    final totalUnpaid = summary['totalUnpaid'] as int;
    final paymentProgress = summary['paymentProgress'] as double;
    final progressPercentage = (paymentProgress * 100).round();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Fixed Header
          Container(
            decoration: const BoxDecoration(color: Color(0xFF4A90E2)),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // Custom Top Bar
                  CustomTopBar(
                    onProfileTap: widget.onNavigateToProfile,
                    onSettingsTap: widget.onNavigateToSettings,
                  ),

                  // Status Pembayaran Section with White Background
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Status Pembayaran',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A90E2),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Total Tagihan Belum Lunas :',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF4A90E2),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatCurrency(totalUnpaid),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A90E2),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '$progressPercentage%',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4A90E2),
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Progress Bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: paymentProgress,
                            minHeight: 8,
                            backgroundColor: Colors.grey[300],
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF4A90E2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // White Background Section
          Expanded(
            child: Container(
              color: Colors.grey[50],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Tab Bar with White Background
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        _buildTab('Notifikasi', 0),
                        const SizedBox(width: 6),
                        _buildTab('Tagihan', 1),
                        const SizedBox(width: 6),
                        _buildTab('Riwayat', 2),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tab Content
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildNotifikasiTab(),
                        _buildTagihanTab(),
                        _buildRiwayatTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _tabController.index == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _tabController.animateTo(index);
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF4A90E2) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF4A90E2).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : const Color(0xFF4A90E2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotifikasiTab() {
    final notifications = _getNotifications();

    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Tidak ada notifikasi',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: notifications.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final notif = notifications[index];
        return _buildNotificationCard(
          icon: _getNotifIcon(notif['type']),
          iconColor: _getNotifColor(notif['type']),
          iconBgColor: _getNotifBgColor(notif['type']),
          title: notif['title'],
          subtitle: notif['subtitle'],
          amount: notif['amount'],
          onTap: () => _handleNotificationTap(notif),
        );
      },
    );
  }

  IconData _getNotifIcon(String type) {
    switch (type) {
      case 'warning':
        return Icons.warning;
      case 'info':
        return Icons.info;
      case 'success':
        return Icons.check_circle;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotifColor(String type) {
    switch (type) {
      case 'warning':
        return const Color(0xFFFFA726);
      case 'info':
        return const Color(0xFF42A5F5);
      case 'success':
        return const Color(0xFF66BB6A);
      default:
        return const Color(0xFF4A90E2);
    }
  }

  Color _getNotifBgColor(String type) {
    switch (type) {
      case 'warning':
        return const Color(0xFFFFF3E0);
      case 'info':
        return const Color(0xFFE3F2FD);
      case 'success':
        return const Color(0xFFE8F5E9);
      default:
        return const Color(0xFFE3F2FD);
    }
  }

  void _handleNotificationTap(Map<String, dynamic> notif) {
    if (notif['billId'] != null) {
      final bill = PaymentData.getBillById(notif['billId']);
      if (bill != null) {
        _showBillDetail(bill);
      }
    }
  }

  void _showBillDetail(BillEntry bill) {
    if (bill.status == PaymentStatus.verified) {
      PaidPaymentModal.show(
        context,
        title: bill.title,
        subtitle: 'Tahun Akademik ${bill.academicYear}',
        billType: bill.title,
        semester: 'Semester ${bill.semester}',
        dueDate: _formatDate(bill.dueDate),
        totalAmount: bill.formattedAmount,
        paymentMethod: bill.paymentMethod ?? '',
        paymentDate: bill.paidAt != null ? _formatDate(bill.paidAt!) : '',
        referenceNumber: 'TRX-${bill.id}',
        proofFileName: bill.proofFileName ?? '',
        proofUploadDate: bill.paidAt != null ? _formatDate(bill.paidAt!) : '',
      );
    } else {
      PaymentDetailModal.show(
        context,
        title: 'Detail Pembayaran',
        subtitle: bill.title,
        billType: bill.type,
        semester: 'Semester ${bill.semester}',
        dueDate: _formatDate(bill.dueDate),
        totalAmount: bill.formattedAmount,
        vaNumber: bill.vaNumber ?? '',
        status: bill.status,
        rejectionReason: bill.rejectionReason,
        billId: bill.id,
        onPaymentSubmitted: () {
          setState(() {}); // Refresh the page
        },
      );
    }
  }

  Widget _buildTagihanTab() {
    final bills = _getBills();

    if (bills.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Tidak ada tagihan',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: bills.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final bill = bills[index];
        return _buildTagihanCard(
          icon: Icons.description,
          iconColor: _getStatusColor(bill.status),
          iconBgColor: _getStatusBgColor(bill.status),
          title: bill.title,
          status: 'Status : ${bill.statusText}',
          statusColor: _getStatusColor(bill.status),
          amount: bill.formattedAmount,
          onTap: () => _showBillDetail(bill),
        );
      },
    );
  }

  Color _getStatusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.verified:
        return const Color(0xFF66BB6A);
      case PaymentStatus.pending:
        return const Color(0xFF42A5F5);
      case PaymentStatus.rejected:
        return const Color(0xFFE57373);
      case PaymentStatus.unpaid:
        return const Color(0xFFFFA726);
    }
  }

  Color _getStatusBgColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.verified:
        return const Color(0xFFE8F5E9);
      case PaymentStatus.pending:
        return const Color(0xFFE3F2FD);
      case PaymentStatus.rejected:
        return const Color(0xFFFFEBEE);
      case PaymentStatus.unpaid:
        return const Color(0xFFFFF3E0);
    }
  }

  Widget _buildRiwayatTab() {
    final bills = _getBills();
    // Only show verified payments in history
    final history = bills
        .where((b) => b.status == PaymentStatus.verified)
        .toList();

    if (history.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Belum ada riwayat pembayaran',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: history.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final bill = history[index];
        return _buildRiwayatCard(
          icon: Icons.check_circle,
          iconColor: const Color(0xFF66BB6A),
          iconBgColor: const Color(0xFFE8F5E9),
          title: 'Pembayaran Berhasil',
          subtitle: bill.title,
          amount: bill.formattedAmount,
          onTap: () => _showBillDetail(bill),
        );
      },
    );
  }

  Widget _buildNotificationCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    String? amount,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF4A90E2).withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4A90E2).withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      height: 1.3,
                    ),
                  ),
                  if (amount != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      amount,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF4A90E2), size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTagihanCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String status,
    required Color statusColor,
    required String amount,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF4A90E2).withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4A90E2).withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        status,
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    amount,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF4A90E2), size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildRiwayatCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required String amount,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF4A90E2).withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4A90E2).withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    amount,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF4A90E2), size: 24),
          ],
        ),
      ),
    );
  }
}
