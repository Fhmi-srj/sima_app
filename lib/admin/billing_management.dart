import 'package:flutter/material.dart';
import '../shared/data/user_data.dart';
import '../shared/widgets/custom_toast.dart';

class BillingManagement extends StatefulWidget {
  const BillingManagement({super.key});

  @override
  State<BillingManagement> createState() => _BillingManagementState();
}

class _BillingManagementState extends State<BillingManagement> {
  static const Color primaryBlue = Color(0xFF4A90E2);
  String _searchQuery = '';
  String _selectedStatus = 'Semua';
  String _selectedType = 'Semua';

  // Sample billing data for all students
  final List<Map<String, dynamic>> _allBills = [
    {
      'id': 'BILL001',
      'studentId': '102230001',
      'studentName': 'Eko Prasetyo',
      'kelas': 'IM23A',
      'title': 'SPP Semester Ganjil 2024/2025',
      'type': 'SPP',
      'semester': '5 (Ganjil)',
      'dueDate': '15 Des 2024',
      'amount': 'Rp 7.500.000',
      'amountValue': 7500000,
      'status': 'belum_lunas',
    },
    {
      'id': 'BILL002',
      'studentId': '102230001',
      'studentName': 'Eko Prasetyo',
      'kelas': 'IM23A',
      'title': 'UKT Semester Genap 2023/2024',
      'type': 'UKT',
      'semester': '4 (Genap)',
      'dueDate': '02 Des 2024',
      'amount': 'Rp 7.500.000',
      'amountValue': 7500000,
      'status': 'lunas',
    },
    {
      'id': 'BILL003',
      'studentId': '102230002',
      'studentName': 'Fitri Handayani',
      'kelas': 'IM23A',
      'title': 'SPP Semester Ganjil 2024/2025',
      'type': 'SPP',
      'semester': '5 (Ganjil)',
      'dueDate': '15 Des 2024',
      'amount': 'Rp 7.500.000',
      'amountValue': 7500000,
      'status': 'belum_lunas',
    },
    {
      'id': 'BILL004',
      'studentId': '102230003',
      'studentName': 'Gunawan Wibowo',
      'kelas': 'IM23A',
      'title': 'SPP Semester Ganjil 2024/2025',
      'type': 'SPP',
      'semester': '5 (Ganjil)',
      'dueDate': '15 Des 2024',
      'amount': 'Rp 7.500.000',
      'amountValue': 7500000,
      'status': 'lunas',
    },
    {
      'id': 'BILL005',
      'studentId': '102230039',
      'studentName': 'Ahmad Rizky',
      'kelas': 'IM23C',
      'title': 'SPP Semester Ganjil 2024/2025',
      'type': 'SPP',
      'semester': '5 (Ganjil)',
      'dueDate': '15 Des 2024',
      'amount': 'Rp 7.500.000',
      'amountValue': 7500000,
      'status': 'belum_lunas',
    },
    {
      'id': 'BILL006',
      'studentId': '102230040',
      'studentName': 'Budi Santoso',
      'kelas': 'IM23C',
      'title': 'Praktikum Semester Ganjil 2024/2025',
      'type': 'Praktikum',
      'semester': '5 (Ganjil)',
      'dueDate': '20 Des 2024',
      'amount': 'Rp 1.500.000',
      'amountValue': 1500000,
      'status': 'belum_lunas',
    },
  ];

  List<Map<String, dynamic>> get _filteredBills {
    var bills = List<Map<String, dynamic>>.from(_allBills);

    if (_selectedStatus != 'Semua') {
      final statusKey = _selectedStatus == 'Lunas' ? 'lunas' : 'belum_lunas';
      bills = bills.where((b) => b['status'] == statusKey).toList();
    }

    if (_selectedType != 'Semua') {
      bills = bills.where((b) => b['type'] == _selectedType).toList();
    }

    if (_searchQuery.isNotEmpty) {
      bills = bills
          .where(
            (b) =>
                (b['studentName'] as String).toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                (b['studentId'] as String).contains(_searchQuery) ||
                (b['title'] as String).toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ),
          )
          .toList();
    }

    return bills;
  }

  int get _totalUnpaid {
    return _allBills
        .where((b) => b['status'] == 'belum_lunas')
        .fold(0, (sum, b) => sum + (b['amountValue'] as int));
  }

  int get _totalPaid {
    return _allBills
        .where((b) => b['status'] == 'lunas')
        .fold(0, (sum, b) => sum + (b['amountValue'] as int));
  }

  String _formatCurrency(int value) {
    String valueStr = value.toString();
    String result = '';
    int count = 0;
    for (int i = valueStr.length - 1; i >= 0; i--) {
      count++;
      result = valueStr[i] + result;
      if (count % 3 == 0 && i != 0) result = '.$result';
    }
    return 'Rp $result';
  }

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
                  'Belum Lunas',
                  _formatCurrency(_totalUnpaid),
                  Colors.red,
                  Icons.warning,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  'Sudah Lunas',
                  _formatCurrency(_totalPaid),
                  Colors.green,
                  Icons.check_circle,
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
                  hintText: 'Cari tagihan (nama/NIM/judul)...',
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
                    _buildFilterChip('Semua', isStatus: true),
                    _buildFilterChip('Lunas', isStatus: true),
                    _buildFilterChip('Belum Lunas', isStatus: true),
                    const SizedBox(width: 16),
                    _buildFilterChip('Semua', isStatus: false),
                    _buildFilterChip('SPP', isStatus: false),
                    _buildFilterChip('UKT', isStatus: false),
                    _buildFilterChip('Praktikum', isStatus: false),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Stats & Add Button
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: primaryBlue.withOpacity(0.1),
          child: Row(
            children: [
              Icon(Icons.receipt_long, size: 18, color: primaryBlue),
              const SizedBox(width: 8),
              Text(
                '${_filteredBills.length} tagihan',
                style: TextStyle(fontSize: 13, color: primaryBlue),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => _showAddBillModal(),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Buat Tagihan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Bill List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _filteredBills.length,
            itemBuilder: (context, index) =>
                _buildBillCard(_filteredBills[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String title,
    String amount,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 11, color: color)),
                const SizedBox(height: 2),
                Text(
                  amount,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, {required bool isStatus}) {
    final isSelected = isStatus
        ? _selectedStatus == label
        : _selectedType == label;
    final chipColor = isStatus ? primaryBlue : Colors.purple;

    return GestureDetector(
      onTap: () => setState(() {
        if (isStatus) {
          _selectedStatus = label;
        } else {
          _selectedType = label;
        }
      }),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? chipColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildBillCard(Map<String, dynamic> bill) {
    final isLunas = bill['status'] == 'lunas';
    final statusColor = isLunas ? Colors.green : Colors.red;

    return GestureDetector(
      onTap: () => _showBillDetailModal(bill),
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
                    color: _getTypeColor(bill['type']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    bill['type'],
                    style: TextStyle(
                      fontSize: 10,
                      color: _getTypeColor(bill['type']),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    isLunas ? 'Lunas' : 'Belum Lunas',
                    style: TextStyle(
                      fontSize: 10,
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
              ],
            ),
            const SizedBox(height: 12),

            // Title
            Text(
              bill['title'],
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 8),

            // Student Info
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: primaryBlue.withOpacity(0.1),
                  child: Text(
                    bill['studentName'][0],
                    style: const TextStyle(
                      color: primaryBlue,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bill['studentName'],
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${bill['studentId']} • ${bill['kelas']}',
                        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Amount & Due Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nominal',
                      style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                    ),
                    Text(
                      bill['amount'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Jatuh Tempo',
                      style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                    ),
                    Text(
                      bill['dueDate'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isLunas ? Colors.grey : Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'SPP':
        return Colors.blue;
      case 'UKT':
        return Colors.purple;
      case 'Praktikum':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _showBillDetailModal(Map<String, dynamic> bill) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Bill Detail Modal',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return _BillDetailModal(
          bill: bill,
          onMarkPaid: () {
            setState(() {
              final index = _allBills.indexWhere((b) => b['id'] == bill['id']);
              if (index != -1) {
                _allBills[index]['status'] = 'lunas';
              }
            });
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

  void _showAddBillModal() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Add Bill Modal',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return _BillFormModal(
          title: 'Buat Tagihan Baru',
          onSave: (data) {
            CustomToast.success(context, 'Tagihan berhasil dibuat');
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

// Bill Detail Modal with Edit Swipe
class _BillDetailModal extends StatefulWidget {
  final Map<String, dynamic> bill;
  final VoidCallback onMarkPaid;

  const _BillDetailModal({required this.bill, required this.onMarkPaid});

  @override
  State<_BillDetailModal> createState() => _BillDetailModalState();
}

class _BillDetailModalState extends State<_BillDetailModal> {
  static const Color primaryBlue = Color(0xFF4A90E2);
  bool _isEditing = false;

  // Edit form controllers
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  late TextEditingController _dueDateController;
  late String _selectedType;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.bill['title']);
    _amountController = TextEditingController(
      text: widget.bill['amountValue'].toString(),
    );
    _dueDateController = TextEditingController(text: widget.bill['dueDate']);
    _selectedType = widget.bill['type'];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(_isEditing ? 1 : -1, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
                child: _isEditing ? _buildEditView() : _buildDetailView(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailView() {
    final isLunas = widget.bill['status'] == 'lunas';
    final statusColor = isLunas ? Colors.green : Colors.red;

    return Column(
      key: const ValueKey('detail'),
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
                  isLunas ? Icons.check_circle : Icons.warning,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.bill['type'],
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isLunas ? 'Sudah Lunas' : 'Belum Lunas',
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
                  child: const Icon(Icons.close, color: Colors.white, size: 20),
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
              children: [
                _buildDetailRow('Judul', widget.bill['title']),
                _buildDetailRow('Mahasiswa', widget.bill['studentName']),
                _buildDetailRow('NIM', widget.bill['studentId']),
                _buildDetailRow('Kelas', widget.bill['kelas']),
                _buildDetailRow('Semester', widget.bill['semester']),
                _buildDetailRow('Jatuh Tempo', widget.bill['dueDate']),
                const SizedBox(height: 16),
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
                        'Total Tagihan',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        widget.bill['amount'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Action Buttons
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            border: Border(top: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => setState(() => _isEditing = true),
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Edit'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryBlue,
                    side: BorderSide(color: primaryBlue),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: isLunas
                      ? null
                      : () {
                          widget.onMarkPaid();
                          Navigator.pop(context);
                          CustomToast.success(
                            context,
                            'Tagihan ditandai lunas',
                          );
                        },
                  icon: const Icon(Icons.check, size: 18),
                  label: Text(isLunas ? 'Sudah Lunas' : 'Tandai Lunas'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey[300],
                    disabledForegroundColor: Colors.grey[500],
                    padding: const EdgeInsets.symmetric(vertical: 12),
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
    );
  }

  Widget _buildEditView() {
    return Column(
      key: const ValueKey('edit'),
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4A90E2), Color(0xFF5B9FED)],
            ),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => _isEditing = false),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Edit Tagihan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
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
                  child: const Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ),

        // Form
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Student (readonly)
                const Text(
                  'Mahasiswa',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: primaryBlue.withOpacity(0.1),
                        child: Text(
                          widget.bill['studentName'][0],
                          style: const TextStyle(
                            color: primaryBlue,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.bill['studentName'],
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '${widget.bill['studentId']} • ${widget.bill['kelas']}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Type
                const Text(
                  'Jenis Tagihan',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: ['SPP', 'UKT', 'Praktikum', 'Lainnya'].map((type) {
                    final isSelected = _selectedType == type;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedType = type),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? primaryBlue : Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          type,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey[700],
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                _buildFormField(
                  'Judul Tagihan',
                  _titleController,
                  Icons.description,
                ),
                const SizedBox(height: 16),
                _buildFormField(
                  'Nominal (Rp)',
                  _amountController,
                  Icons.payments,
                  isNumber: true,
                ),
                const SizedBox(height: 16),
                _buildFormField(
                  'Jatuh Tempo',
                  _dueDateController,
                  Icons.calendar_today,
                ),
              ],
            ),
          ),
        ),

        // Save Button
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            border: Border(top: BorderSide(color: Colors.grey.shade200)),
          ),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                CustomToast.success(context, 'Tagihan berhasil diupdate');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Simpan Perubahan',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool isNumber = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

// Bill Form Modal (Add New) with Live Search Student
class _BillFormModal extends StatefulWidget {
  final String title;
  final Function(Map<String, dynamic>) onSave;

  const _BillFormModal({required this.title, required this.onSave});

  @override
  State<_BillFormModal> createState() => _BillFormModalState();
}

class _BillFormModalState extends State<_BillFormModal> {
  static const Color primaryBlue = Color(0xFF4A90E2);
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _studentSearchController =
      TextEditingController();

  String _selectedType = 'SPP';
  AppUser? _selectedStudent;
  bool _showStudentList = false;

  List<AppUser> get _filteredStudents {
    final query = _studentSearchController.text.toLowerCase();
    if (query.isEmpty) return [];
    return UserData.getAllStudents()
        .where(
          (s) => s.name.toLowerCase().contains(query) || s.id.contains(query),
        )
        .take(5)
        .toList();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _dueDateController.dispose();
    _studentSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF4A90E2), Color(0xFF5B9FED)],
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.receipt_long,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            widget.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
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

                  // Form
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Student Search
                          const Text(
                            'Mahasiswa',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (_selectedStudent != null)
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.green.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: primaryBlue.withOpacity(
                                      0.1,
                                    ),
                                    child: Text(
                                      _selectedStudent!.name[0],
                                      style: const TextStyle(
                                        color: primaryBlue,
                                        fontSize: 12,
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
                                          _selectedStudent!.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          '${_selectedStudent!.id} • ${_selectedStudent!.kelas}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () =>
                                        setState(() => _selectedStudent = null),
                                    child: const Icon(
                                      Icons.close,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            Column(
                              children: [
                                TextField(
                                  controller: _studentSearchController,
                                  onChanged: (value) => setState(
                                    () => _showStudentList = value.isNotEmpty,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Ketik nama atau NIM...',
                                    hintStyle: TextStyle(
                                      color: Colors.grey[400],
                                    ),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Colors.grey[400],
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[100],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                                if (_showStudentList &&
                                    _filteredStudents.isNotEmpty)
                                  Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.grey.shade200,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: _filteredStudents
                                          .map(
                                            (student) => InkWell(
                                              onTap: () => setState(() {
                                                _selectedStudent = student;
                                                _showStudentList = false;
                                                _studentSearchController
                                                    .clear();
                                              }),
                                              child: Container(
                                                padding: const EdgeInsets.all(
                                                  12,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                      color:
                                                          Colors.grey.shade100,
                                                    ),
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 14,
                                                      backgroundColor:
                                                          primaryBlue
                                                              .withOpacity(0.1),
                                                      child: Text(
                                                        student.name[0],
                                                        style: const TextStyle(
                                                          color: primaryBlue,
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            student.name,
                                                            style:
                                                                const TextStyle(
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                          ),
                                                          Text(
                                                            '${student.id} • ${student.kelas}',
                                                            style: TextStyle(
                                                              fontSize: 11,
                                                              color: Colors
                                                                  .grey[600],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                              ],
                            ),
                          const SizedBox(height: 16),

                          // Type
                          const Text(
                            'Jenis Tagihan',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: ['SPP', 'UKT', 'Praktikum', 'Lainnya']
                                .map((type) {
                                  final isSelected = _selectedType == type;
                                  return GestureDetector(
                                    onTap: () =>
                                        setState(() => _selectedType = type),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? primaryBlue
                                            : Colors.grey[200],
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        type,
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : Colors.grey[700],
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  );
                                })
                                .toList(),
                          ),
                          const SizedBox(height: 16),

                          _buildFormField(
                            'Judul Tagihan',
                            _titleController,
                            Icons.description,
                          ),
                          const SizedBox(height: 16),
                          _buildFormField(
                            'Nominal (Rp)',
                            _amountController,
                            Icons.payments,
                            isNumber: true,
                          ),
                          const SizedBox(height: 16),
                          _buildFormField(
                            'Jatuh Tempo',
                            _dueDateController,
                            Icons.calendar_today,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Save Button
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _selectedStudent == null
                            ? null
                            : () {
                                Navigator.pop(context);
                                widget.onSave({
                                  'student': _selectedStudent,
                                  'type': _selectedType,
                                  'title': _titleController.text,
                                });
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBlue,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey[300],
                          disabledForegroundColor: Colors.grey[500],
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Buat Tagihan',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
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

  Widget _buildFormField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool isNumber = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}


