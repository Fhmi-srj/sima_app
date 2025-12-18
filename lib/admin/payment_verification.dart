import 'package:flutter/material.dart';
import '../data/payment_data.dart';
import '../widgets/custom_toast.dart';

class PaymentVerification extends StatefulWidget {
  const PaymentVerification({super.key});

  @override
  State<PaymentVerification> createState() => _PaymentVerificationState();
}

class _PaymentVerificationState extends State<PaymentVerification> {
  static const Color primaryBlue = Color(0xFF4A90E2);
  String _searchQuery = '';
  String _selectedStatus = 'Semua';

  // Use dynamic data from PaymentData
  List<BillEntry> get _allBills => PaymentData.getAllBills();

  List<BillEntry> get _pendingBills =>
      _allBills.where((b) => b.status == PaymentStatus.pending).toList();
  List<BillEntry> get _verifiedBills =>
      _allBills.where((b) => b.status == PaymentStatus.verified).toList();
  List<BillEntry> get _rejectedBills =>
      _allBills.where((b) => b.status == PaymentStatus.rejected).toList();

  List<Map<String, dynamic>> get _filteredPayments {
    List<BillEntry> bills;

    if (_selectedStatus == 'Menunggu') {
      bills = _pendingBills;
    } else if (_selectedStatus == 'Disetujui') {
      bills = _verifiedBills;
    } else if (_selectedStatus == 'Ditolak') {
      bills = _rejectedBills;
    } else {
      bills = _allBills;
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      bills = bills.where((b) {
        final student = b.student;
        return student != null &&
            (student.name.toLowerCase().contains(query) ||
                student.id.toLowerCase().contains(query) ||
                b.id.toLowerCase().contains(query));
      }).toList();
    }

    // Convert to Map format for compatibility with existing UI
    return bills.map((bill) {
      final student = bill.student;
      final statusStr = bill.status == PaymentStatus.verified
          ? 'approved'
          : bill.status == PaymentStatus.rejected
          ? 'rejected'
          : 'pending';
      return {
        'id': bill.id,
        'billEntry': bill,
        'studentId': bill.studentId,
        'studentName': student?.name ?? 'Unknown',
        'kelas': student?.prodi ?? '',
        'billTitle': bill.title,
        'billType': bill.type,
        'amount': 'Rp ${_formatCurrency(bill.amount)}',
        'amountValue': bill.amount,
        'paymentDate': bill.paidAt != null ? _formatDate(bill.paidAt!) : '-',
        'paymentMethod': 'Transfer Bank',
        'referenceNumber': bill.id,
        'proofFileName': 'bukti_transfer.jpg',
        'status': statusStr,
        'notes': bill.rejectionReason ?? '',
        'verifiedBy': bill.verifiedBy ?? '',
        'verifiedDate': bill.verifiedAt != null
            ? _formatDate(bill.verifiedAt!)
            : '',
      };
    }).toList();
  }

  String _formatCurrency(int amount) {
    final str = amount.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(str[i]);
    }
    return buffer.toString();
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
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  int get _pendingCount => _pendingBills.length;
  int get _approvedCount => _verifiedBills.length;
  int get _rejectedCount => _rejectedBills.length;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Summary Cards
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Menunggu',
                  _pendingCount.toString(),
                  Colors.orange,
                  Icons.hourglass_empty,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSummaryCard(
                  'Disetujui',
                  _approvedCount.toString(),
                  Colors.green,
                  Icons.check_circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSummaryCard(
                  'Ditolak',
                  _rejectedCount.toString(),
                  Colors.red,
                  Icons.cancel,
                ),
              ),
            ],
          ),
        ),

        // Search & Filter
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            children: [
              TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: 'Cari pembayaran (nama/NIM/referensi)...',
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('Semua'),
                    _buildFilterChip('Menunggu'),
                    _buildFilterChip('Disetujui'),
                    _buildFilterChip('Ditolak'),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Stats
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: primaryBlue.withOpacity(0.1),
          child: Row(
            children: [
              Icon(Icons.receipt, size: 18, color: primaryBlue),
              const SizedBox(width: 8),
              Text(
                '${_filteredPayments.length} pembayaran',
                style: TextStyle(fontSize: 13, color: primaryBlue),
              ),
            ],
          ),
        ),

        // Payment List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _filteredPayments.length,
            itemBuilder: (context, index) =>
                _buildPaymentCard(_filteredPayments[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String title,
    String count,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 6),
          Text(
            count,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(title, style: TextStyle(fontSize: 10, color: color)),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedStatus == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedStatus = label),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryBlue : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentCard(Map<String, dynamic> payment) {
    final status = payment['status'] as String;
    final statusColor = status == 'approved'
        ? Colors.green
        : status == 'rejected'
        ? Colors.red
        : Colors.orange;
    final statusText = status == 'approved'
        ? 'Disetujui'
        : status == 'rejected'
        ? 'Ditolak'
        : 'Menunggu';
    final statusIcon = status == 'approved'
        ? Icons.check_circle
        : status == 'rejected'
        ? Icons.cancel
        : Icons.hourglass_empty;

    return GestureDetector(
      onTap: () => _showPaymentDetailModal(payment),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: statusColor.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 12, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 10,
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    payment['billType'],
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
              ],
            ),
            const SizedBox(height: 12),

            // Student Info
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: primaryBlue.withOpacity(0.1),
                  child: Text(
                    payment['studentName'][0],
                    style: const TextStyle(
                      color: primaryBlue,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        payment['studentName'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${payment['studentId']} • ${payment['kelas']}',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Bill Title
            Text(
              payment['billTitle'],
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
            const SizedBox(height: 8),

            // Amount & Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  payment['amount'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                Text(
                  payment['paymentDate'],
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentDetailModal(Map<String, dynamic> payment) {
    final billEntry = payment['billEntry'] as BillEntry?;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Payment Detail Modal',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return _PaymentDetailModal(
          payment: payment,
          onApprove: () {
            if (billEntry != null) {
              // Use dynamic PaymentData
              final success = PaymentData.verifyPayment(
                billEntry.id,
                'admin@sima.ac.id',
              );
              if (success) {
                setState(() {});
              }
            }
          },
          onReject: (String reason) {
            if (billEntry != null) {
              // Use dynamic PaymentData
              final success = PaymentData.rejectPayment(
                billEntry.id,
                'admin@sima.ac.id',
                reason,
              );
              if (success) {
                setState(() {});
              }
            }
          },
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: child,
        );
      },
    );
  }
}

// Payment Detail Modal
class _PaymentDetailModal extends StatefulWidget {
  final Map<String, dynamic> payment;
  final VoidCallback onApprove;
  final Function(String) onReject;

  const _PaymentDetailModal({
    required this.payment,
    required this.onApprove,
    required this.onReject,
  });

  @override
  State<_PaymentDetailModal> createState() => _PaymentDetailModalState();
}

class _PaymentDetailModalState extends State<_PaymentDetailModal> {
  static const Color primaryBlue = Color(0xFF4A90E2);
  bool _showRejectForm = false;
  final TextEditingController _rejectReasonController = TextEditingController();

  @override
  void dispose() {
    _rejectReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final status = widget.payment['status'] as String;
    final statusColor = status == 'approved'
        ? Colors.green
        : status == 'rejected'
        ? Colors.red
        : Colors.orange;
    final statusText = status == 'approved'
        ? 'Disetujui'
        : status == 'rejected'
        ? 'Ditolak'
        : 'Menunggu Verifikasi';
    final isPending = status == 'pending';

    return DefaultTextStyle(
      style: const TextStyle(
        decoration: TextDecoration.none,
        color: Color(0xFF333333),
        fontFamily: 'Roboto',
      ),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          constraints: BoxConstraints(
            maxWidth: 420,
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [statusColor, statusColor.withOpacity(0.8)],
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            status == 'approved'
                                ? Icons.check_circle
                                : status == 'rejected'
                                ? Icons.cancel
                                : Icons.hourglass_empty,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Status Pembayaran',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                statusText,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Details
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Student Info Card
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: primaryBlue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: primaryBlue,
                                  child: Text(
                                    widget.payment['studentName'][0],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.payment['studentName'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        '${widget.payment['studentId']} • ${widget.payment['kelas']}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Payment Details
                          const Text(
                            'Detail Pembayaran',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildDetailRow(
                            'Tagihan',
                            widget.payment['billTitle'],
                          ),
                          _buildDetailRow('Jenis', widget.payment['billType']),
                          _buildDetailRow(
                            'Metode',
                            widget.payment['paymentMethod'],
                          ),
                          _buildDetailRow(
                            'Tanggal',
                            widget.payment['paymentDate'],
                          ),
                          _buildDetailRow(
                            'No. Referensi',
                            widget.payment['referenceNumber'],
                          ),
                          const SizedBox(height: 16),

                          // Amount
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Nominal',
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  widget.payment['amount'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Proof
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.image,
                                    color: Colors.blue,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Bukti Pembayaran',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Text(
                                        widget.payment['proofFileName'],
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => CustomToast.info(
                                    context,
                                    'Membuka bukti...',
                                  ),
                                  child: const Text(
                                    'Lihat',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Verification Info (if not pending)
                          if (!isPending) ...[
                            const SizedBox(height: 20),
                            const Text(
                              'Info Verifikasi',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildDetailRow(
                              'Diverifikasi oleh',
                              widget.payment['verifiedBy'] ?? '-',
                            ),
                            _buildDetailRow(
                              'Tanggal',
                              widget.payment['verifiedDate'] ?? '-',
                            ),
                            if ((widget.payment['notes'] as String).isNotEmpty)
                              _buildDetailRow(
                                'Catatan',
                                widget.payment['notes'],
                              ),
                          ],

                          // Reject Reason Form
                          if (_showRejectForm) ...[
                            const SizedBox(height: 20),
                            const Text(
                              'Alasan Penolakan',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _rejectReasonController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: 'Masukkan alasan penolakan...',
                                filled: true,
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  // Action Buttons
                  if (isPending)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        border: Border(
                          top: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                      child: _showRejectForm
                          ? Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () =>
                                        setState(() => _showRejectForm = false),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.grey,
                                      side: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text('Batal'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_rejectReasonController
                                          .text
                                          .isEmpty) {
                                        CustomToast.error(
                                          context,
                                          'Masukkan alasan penolakan',
                                        );
                                        return;
                                      }
                                      widget.onReject(
                                        _rejectReasonController.text,
                                      );
                                      Navigator.pop(context);
                                      CustomToast.success(
                                        context,
                                        'Pembayaran ditolak',
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text('Konfirmasi Tolak'),
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () =>
                                        setState(() => _showRejectForm = true),
                                    icon: const Icon(Icons.close, size: 18),
                                    label: const Text('Tolak'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.red,
                                      side: const BorderSide(color: Colors.red),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      widget.onApprove();
                                      Navigator.pop(context);
                                      CustomToast.success(
                                        context,
                                        'Pembayaran disetujui',
                                      );
                                    },
                                    icon: const Icon(Icons.check, size: 18),
                                    label: const Text('Setujui'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
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
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
