import 'package:flutter/material.dart';
import 'widgets/custom_top_bar.dart';
import 'widgets/payment_detail_modal.dart';
import 'widgets/paid_payment_modal.dart';
import 'data/finance_data.dart';

class FinancePageContent extends StatefulWidget {
  final VoidCallback? onNavigateToProfile;
  final VoidCallback? onNavigateToSettings;

  const FinancePageContent({
    super.key,
    this.onNavigateToProfile,
    this.onNavigateToSettings,
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

  @override
  Widget build(BuildContext context) {
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
                          FinanceData.getSummary()['totalUnpaid'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A90E2),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          FinanceData.getSummary()['progressPercentage'],
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
                            value: FinanceData.getSummary()['paymentProgress'],
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
    final notifications = FinanceData.getNotifications();
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
      // Show unpaid payment modal
      final bill = FinanceData.getBillById(notif['billId']);
      if (bill != null && bill.isNotEmpty) {
        PaymentDetailModal.show(
          context,
          title: 'Detail Pembayaran',
          subtitle: bill['title'],
          billType: bill['type'],
          semester: bill['semester'],
          dueDate: bill['dueDate'],
          totalAmount: bill['amount'],
          vaNumber: bill['vaNumber'] ?? '',
        );
      }
    } else if (notif['paymentId'] != null) {
      // Show paid payment modal
      final payment = FinanceData.getPaymentById(notif['paymentId']);
      if (payment != null && payment.isNotEmpty) {
        PaidPaymentModal.show(
          context,
          title: payment['subtitle'],
          subtitle: 'Tahun Akademik 2024/2025',
          billType: payment['billType'],
          semester: payment['semester'],
          dueDate: payment['dueDate'],
          totalAmount: payment['amount'],
          paymentMethod: payment['paymentMethod'] ?? '',
          paymentDate: payment['paymentDate'] ?? '',
          referenceNumber: payment['referenceNumber'] ?? '',
          proofFileName: payment['proofFileName'] ?? '',
          proofUploadDate: payment['proofUploadDate'] ?? '',
        );
      }
    }
  }

  Widget _buildTagihanTab() {
    final bills = FinanceData.getBills();
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: bills.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final bill = bills[index];
        final isLunas = bill['status'] == 'lunas';
        return _buildTagihanCard(
          icon: Icons.description,
          iconColor: const Color(0xFF4A90E2),
          iconBgColor: const Color(0xFFE3F2FD),
          title: bill['title'],
          status: 'Status : ${bill['statusText']}',
          statusColor: isLunas ? const Color(0xFF66BB6A) : Colors.red,
          amount: bill['amount'],
          onTap: () => _handleBillTap(bill),
        );
      },
    );
  }

  void _handleBillTap(Map<String, dynamic> bill) {
    if (bill['status'] == 'lunas') {
      PaidPaymentModal.show(
        context,
        title: bill['title'],
        subtitle: 'Tahun Akademik 2024/2025',
        billType: bill['title'],
        semester: bill['semester'],
        dueDate: bill['dueDate'],
        totalAmount: bill['amount'],
        paymentMethod: bill['paymentMethod'] ?? '',
        paymentDate: bill['paymentDate'] ?? '',
        referenceNumber: bill['referenceNumber'] ?? '',
        proofFileName: bill['proofFileName'] ?? '',
        proofUploadDate: bill['proofUploadDate'] ?? '',
      );
    } else {
      PaymentDetailModal.show(
        context,
        title: 'Detail Pembayaran',
        subtitle: bill['title'],
        billType: bill['type'],
        semester: bill['semester'],
        dueDate: bill['dueDate'],
        totalAmount: bill['amount'],
        vaNumber: bill['vaNumber'] ?? '',
      );
    }
  }

  Widget _buildRiwayatTab() {
    final history = FinanceData.getPaymentHistory();
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: history.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final payment = history[index];
        final isSuccess = payment['status'] == 'success';
        return _buildRiwayatCard(
          icon: isSuccess ? Icons.check_circle : Icons.access_time,
          iconColor: isSuccess
              ? const Color(0xFF66BB6A)
              : const Color(0xFF42A5F5),
          iconBgColor: isSuccess
              ? const Color(0xFFE8F5E9)
              : const Color(0xFFE3F2FD),
          title: payment['title'],
          subtitle: payment['subtitle'],
          amount: payment['amount'],
          onTap: () => _handlePaymentHistoryTap(payment),
        );
      },
    );
  }

  void _handlePaymentHistoryTap(Map<String, dynamic> payment) {
    if (payment['status'] == 'success') {
      PaidPaymentModal.show(
        context,
        title: payment['subtitle'],
        subtitle: 'Tahun Akademik 2024/2025',
        billType: payment['billType'],
        semester: payment['semester'],
        dueDate: payment['dueDate'],
        totalAmount: payment['amount'],
        paymentMethod: payment['paymentMethod'] ?? '',
        paymentDate: payment['paymentDate'] ?? '',
        referenceNumber: payment['referenceNumber'] ?? '',
        proofFileName: payment['proofFileName'] ?? '',
        proofUploadDate: payment['proofUploadDate'] ?? '',
      );
    } else {
      PaymentDetailModal.show(
        context,
        title: 'Detail Pembayaran',
        subtitle: payment['subtitle'],
        billType: payment['billType'],
        semester: payment['semester'],
        dueDate: payment['dueDate'],
        totalAmount: payment['amount'],
        vaNumber: payment['vaNumber'] ?? '',
      );
    }
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
