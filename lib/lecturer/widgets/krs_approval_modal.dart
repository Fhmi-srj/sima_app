import 'package:flutter/material.dart';
import '../../shared/data/user_data.dart';
import '../../shared/data/krs_data.dart';
import '../../shared/data/class_data.dart';
import '../../shared/widgets/custom_toast.dart';

class KrsApprovalModal extends StatelessWidget {
  final AppUser student;
  final int totalSks;
  final List<Map<String, dynamic>> mataKuliahList;
  final KrsEntry? krsEntry;
  final String? dosenPaId;
  final VoidCallback? onApproved;
  final VoidCallback? onRejected;

  const KrsApprovalModal({
    super.key,
    required this.student,
    required this.totalSks,
    required this.mataKuliahList,
    this.krsEntry,
    this.dosenPaId,
    this.onApproved,
    this.onRejected,
  });

  static Future<void> show(
    BuildContext context, {
    required AppUser student,
    required int totalSks,
    List<Map<String, dynamic>>? mataKuliahList,
    KrsEntry? krsEntry,
    String? dosenPaId,
    VoidCallback? onApproved,
    VoidCallback? onRejected,
  }) async {
    // Get mata kuliah from ClassData based on student's class
    final courses = ClassData.getCoursesByKelas(student.kelas ?? '');
    final defaultMataKuliah = courses
        .map(
          (c) => {
            'code': c.courseCode,
            'name': c.courseName,
            'day': c.day,
            'time': c.time,
            'lecturer': c.lecturerName,
            'sks': c.sks,
            'type': 'Wajib',
          },
        )
        .toList();

    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'KRS Approval Modal',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return KrsApprovalModal(
          student: student,
          totalSks: totalSks,
          mataKuliahList: mataKuliahList ?? defaultMataKuliah,
          krsEntry: krsEntry,
          dosenPaId: dosenPaId,
          onApproved: onApproved,
          onRejected: onRejected,
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

  static const Color primaryBlue = Color(0xFF4A90E2);

  @override
  Widget build(BuildContext context) {
    return Center(
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
                _buildHeader(context),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStudentCard(),
                        const SizedBox(height: 20),
                        _buildSummaryCard(),
                        const SizedBox(height: 20),
                        _buildMataKuliahList(),
                        const SizedBox(height: 20),
                        _buildNotesField(),
                      ],
                    ),
                  ),
                ),
                _buildFooter(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4A90E2), Color(0xFF5BA3F5)],
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.fact_check, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Persetujuan KRS',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Semester Ganjil 2024/2025',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
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
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.close, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryBlue.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: primaryBlue,
            child: Text(
              student.name[0],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'NIM: ${student.id}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                Text(
                  'Kelas: ${student.kelas ?? "-"}',
                  style: TextStyle(
                    fontSize: 13,
                    color: primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  student.prodi,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    final wajibCount = mataKuliahList.where((m) => m['type'] == 'Wajib').length;
    final pilihanCount = mataKuliahList
        .where((m) => m['type'] == 'Pilihan')
        .length;

    return Row(
      children: [
        _buildSummaryItem('Total SKS', '$totalSks', primaryBlue),
        const SizedBox(width: 12),
        _buildSummaryItem('MK Wajib', '$wajibCount', Colors.green),
        const SizedBox(width: 12),
        _buildSummaryItem('MK Pilihan', '$pilihanCount', Colors.orange),
      ],
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(label, style: TextStyle(fontSize: 11, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildMataKuliahList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mata Kuliah Diambil',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 16,
              headingRowColor: WidgetStateProperty.all(
                primaryBlue.withOpacity(0.1),
              ),
              headingTextStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Color(0xFF4A90E2),
              ),
              dataTextStyle: TextStyle(fontSize: 12, color: Colors.grey[800]),
              columns: const [
                DataColumn(label: Text('Kode')),
                DataColumn(label: Text('Mata Kuliah')),
                DataColumn(label: Text('Hari')),
                DataColumn(label: Text('Jam')),
                DataColumn(label: Text('Dosen')),
                DataColumn(label: Text('SKS'), numeric: true),
              ],
              rows: mataKuliahList
                  .map(
                    (mk) => DataRow(
                      cells: [
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  (mk['type'] == 'Wajib'
                                          ? Colors.green
                                          : Colors.orange)
                                      .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              mk['code'] ?? '',
                              style: TextStyle(
                                fontSize: 11,
                                color: mk['type'] == 'Wajib'
                                    ? Colors.green
                                    : Colors.orange,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            mk['name'] ?? '',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        DataCell(Text(mk['day'] ?? '-')),
                        DataCell(Text(mk['time'] ?? '-')),
                        DataCell(Text(mk['lecturer'] ?? '-')),
                        DataCell(
                          Text(
                            '${mk['sks']}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Catatan (Opsional)',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Tambahkan catatan untuk mahasiswa...',
            hintStyle: TextStyle(color: Colors.grey[400]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: primaryBlue, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                // Show rejection reason dialog
                _showRejectDialog(context);
              },
              icon: const Icon(Icons.close),
              label: const Text('Tolak'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: () {
                // Call dynamic approve method
                if (krsEntry != null && dosenPaId != null) {
                  final success = KrsData.approveKrs(krsEntry!.id, dosenPaId!);
                  if (success) {
                    Navigator.pop(context);
                    CustomToast.success(
                      context,
                      'KRS ${student.name} berhasil disetujui!',
                    );
                    onApproved?.call();
                  } else {
                    CustomToast.error(context, 'Gagal menyetujui KRS');
                  }
                } else {
                  Navigator.pop(context);
                  CustomToast.success(context, 'KRS berhasil disetujui!');
                }
              },
              icon: const Icon(Icons.check),
              label: const Text('Setujui KRS'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRejectDialog(BuildContext context) {
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Alasan Penolakan'),
        content: TextField(
          controller: reasonController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Masukkan alasan penolakan KRS...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final reason = reasonController.text.trim();
              if (reason.isEmpty) {
                CustomToast.error(dialogContext, 'Alasan tidak boleh kosong');
                return;
              }

              Navigator.pop(dialogContext); // Close dialog

              if (krsEntry != null && dosenPaId != null) {
                final success = KrsData.rejectKrs(
                  krsEntry!.id,
                  dosenPaId!,
                  reason,
                );
                if (success) {
                  Navigator.pop(context); // Close modal
                  CustomToast.error(context, 'KRS ${student.name} ditolak');
                  onRejected?.call();
                } else {
                  CustomToast.error(context, 'Gagal menolak KRS');
                }
              } else {
                Navigator.pop(context);
                CustomToast.error(context, 'KRS ditolak');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Tolak', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// Modal for viewing approved KRS details
class KrsApprovedDetailModal extends StatelessWidget {
  final AppUser student;
  final int totalSks;
  final List<Map<String, dynamic>> mataKuliahList;
  final String approvedDate;
  final String semesterInfo;

  const KrsApprovedDetailModal({
    super.key,
    required this.student,
    required this.totalSks,
    required this.mataKuliahList,
    required this.approvedDate,
    required this.semesterInfo,
  });

  static void show(
    BuildContext context, {
    required AppUser student,
    required int totalSks,
    List<Map<String, dynamic>>? mataKuliahList,
    String? approvedDate,
    String? semesterInfo,
  }) {
    // Get mata kuliah from ClassData based on student's class
    final courses = ClassData.getCoursesByKelas(student.kelas ?? '');
    final defaultMataKuliah = courses
        .map(
          (c) => {
            'code': c.courseCode,
            'name': c.courseName,
            'day': c.day,
            'time': c.time,
            'lecturer': c.lecturerName,
            'sks': c.sks,
            'type': 'Wajib',
          },
        )
        .toList();

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'KRS Approved Detail Modal',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return KrsApprovedDetailModal(
          student: student,
          totalSks: totalSks,
          mataKuliahList: mataKuliahList ?? defaultMataKuliah,
          approvedDate: approvedDate ?? '10 Desember 2024',
          semesterInfo: semesterInfo ?? 'Semester Ganjil 2024/2025',
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

  static const Color primaryGreen = Colors.green;
  static const Color primaryBlue = Color(0xFF4A90E2);

  @override
  Widget build(BuildContext context) {
    final wajibCount = mataKuliahList.where((m) => m['type'] == 'Wajib').length;
    final pilihanCount = mataKuliahList
        .where((m) => m['type'] == 'Pilihan')
        .length;

    return Center(
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
                // Header with green gradient
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.verified,
                            color: Colors.white,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'KRS Disetujui',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  semesterInfo,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.9),
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
                    ],
                  ),
                ),

                // Scrollable content
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Student info card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: primaryGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: primaryGreen.withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: primaryGreen,
                                child: Text(
                                  student.name[0],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      student.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'NIM: ${student.id}',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      'Kelas: ${student.kelas ?? "-"}',
                                      style: TextStyle(
                                        color: primaryGreen,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      student.prodi,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Approval info
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
                              const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Disetujui pada: ',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                approvedDate,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Summary cards
                        Row(
                          children: [
                            _buildSummaryItem(
                              'Total SKS',
                              '$totalSks',
                              primaryGreen,
                            ),
                            const SizedBox(width: 8),
                            _buildSummaryItem(
                              'MK Wajib',
                              '$wajibCount',
                              primaryBlue,
                            ),
                            const SizedBox(width: 8),
                            _buildSummaryItem(
                              'MK Pilihan',
                              '$pilihanCount',
                              Colors.orange,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Mata Kuliah Header
                        Row(
                          children: [
                            const Text(
                              'Mata Kuliah Diambil',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${mataKuliahList.length} MK',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Mata Kuliah Table
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columnSpacing: 16,
                              headingRowColor: WidgetStateProperty.all(
                                Colors.green.withOpacity(0.1),
                              ),
                              headingTextStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.green,
                              ),
                              dataTextStyle: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[800],
                              ),
                              columns: const [
                                DataColumn(label: Text('Kode')),
                                DataColumn(label: Text('Mata Kuliah')),
                                DataColumn(label: Text('Hari')),
                                DataColumn(label: Text('Jam')),
                                DataColumn(label: Text('Dosen')),
                                DataColumn(label: Text('SKS'), numeric: true),
                              ],
                              rows: mataKuliahList
                                  .map(
                                    (mk) => DataRow(
                                      cells: [
                                        DataCell(
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  (mk['type'] == 'Wajib'
                                                          ? Colors.green
                                                          : Colors.orange)
                                                      .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              mk['code'] ?? '',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: mk['type'] == 'Wajib'
                                                    ? Colors.green
                                                    : Colors.orange,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            mk['name'] ?? '',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        DataCell(Text(mk['day'] ?? '-')),
                                        DataCell(Text(mk['time'] ?? '-')),
                                        DataCell(Text(mk['lecturer'] ?? '-')),
                                        DataCell(
                                          Text(
                                            '${mk['sks']}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Footer
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    border: Border(top: BorderSide(color: Colors.grey[200]!)),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      label: const Text('Tutup'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(label, style: TextStyle(fontSize: 11, color: color)),
          ],
        ),
      ),
    );
  }
}

// Modal for viewing rejected KRS details with approve option
class KrsRejectedDetailModal extends StatelessWidget {
  final AppUser student;
  final int totalSks;
  final List<Map<String, dynamic>> mataKuliahList;
  final String? rejectedDate;
  final String? rejectedReason;
  final String? semesterInfo;
  final VoidCallback? onApproved;

  static const Color primaryRed = Color(0xFFE74C3C);
  static const Color primaryBlue = Color(0xFF4A90E2);

  const KrsRejectedDetailModal({
    super.key,
    required this.student,
    required this.totalSks,
    this.mataKuliahList = const [],
    this.rejectedDate,
    this.rejectedReason,
    this.semesterInfo,
    this.onApproved,
  });

  static void show(
    BuildContext context, {
    required AppUser student,
    required int totalSks,
    List<Map<String, dynamic>>? mataKuliahList,
    String? rejectedDate,
    String? rejectedReason,
    String? semesterInfo,
    VoidCallback? onApproved,
  }) {
    // Get mata kuliah from ClassData based on student's class
    final courses = ClassData.getCoursesByKelas(student.kelas ?? '');
    final defaultMataKuliah = courses
        .map(
          (c) => {
            'code': c.courseCode,
            'name': c.courseName,
            'day': c.day,
            'time': c.time,
            'lecturer': c.lecturerName,
            'sks': c.sks,
            'type': 'Wajib',
          },
        )
        .toList();

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Rejected KRS Detail',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (ctx, anim1, anim2) => KrsRejectedDetailModal(
        student: student,
        totalSks: totalSks,
        mataKuliahList: mataKuliahList ?? defaultMataKuliah,
        rejectedDate: rejectedDate,
        rejectedReason: rejectedReason,
        semesterInfo: semesterInfo,
        onApproved: onApproved,
      ),
      transitionBuilder: (ctx, anim1, anim2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final wajibCount = mataKuliahList.where((m) => m['type'] == 'Wajib').length;
    final pilihanCount = mataKuliahList
        .where((m) => m['type'] == 'Pilihan')
        .length;

    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
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
                // Header with red gradient
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFE74C3C), Color(0xFFE57373)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.cancel,
                            color: Colors.white,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'KRS Ditolak',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                if (semesterInfo != null) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    semesterInfo!,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                ],
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
                    ],
                  ),
                ),

                // Scrollable content
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Student info card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: primaryRed.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: primaryRed.withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: primaryRed,
                                child: Text(
                                  student.name[0],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      student.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'NIM: ${student.id}',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      'Kelas: ${student.kelas ?? "-"}',
                                      style: TextStyle(
                                        color: primaryRed,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      student.prodi,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Rejection info
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.red.withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.info,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Ditolak pada: ${rejectedDate ?? "-"}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              if (rejectedReason != null &&
                                  rejectedReason!.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(
                                  'Alasan: $rejectedReason',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Summary cards
                        Row(
                          children: [
                            _buildSummaryItem(
                              'Total SKS',
                              '$totalSks',
                              primaryRed,
                            ),
                            const SizedBox(width: 8),
                            _buildSummaryItem(
                              'MK Wajib',
                              '$wajibCount',
                              primaryBlue,
                            ),
                            const SizedBox(width: 8),
                            _buildSummaryItem(
                              'MK Pilihan',
                              '$pilihanCount',
                              Colors.orange,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Mata Kuliah Header
                        Row(
                          children: [
                            const Text(
                              'Mata Kuliah Diambil',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${mataKuliahList.length} MK',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Mata Kuliah Table
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columnSpacing: 16,
                              headingRowColor: WidgetStateProperty.all(
                                Colors.red.withOpacity(0.1),
                              ),
                              headingTextStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: primaryRed,
                              ),
                              dataTextStyle: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[800],
                              ),
                              columns: const [
                                DataColumn(label: Text('Kode')),
                                DataColumn(label: Text('Mata Kuliah')),
                                DataColumn(label: Text('Hari')),
                                DataColumn(label: Text('Jam')),
                                DataColumn(label: Text('Dosen')),
                                DataColumn(label: Text('SKS'), numeric: true),
                              ],
                              rows: mataKuliahList
                                  .map(
                                    (mk) => DataRow(
                                      cells: [
                                        DataCell(
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  (mk['type'] == 'Wajib'
                                                          ? Colors.green
                                                          : Colors.orange)
                                                      .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              mk['code'] ?? '',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: mk['type'] == 'Wajib'
                                                    ? Colors.green
                                                    : Colors.orange,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                        DataCell(
                                          Text(
                                            mk['name'] ?? '',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        DataCell(Text(mk['day'] ?? '-')),
                                        DataCell(Text(mk['time'] ?? '-')),
                                        DataCell(Text(mk['lecturer'] ?? '-')),
                                        DataCell(
                                          Text(
                                            '${mk['sks']}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Footer with Approve button
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    border: Border(top: BorderSide(color: Colors.grey[200]!)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey[600],
                            side: BorderSide(color: Colors.grey[300]!),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('Tutup'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            onApproved?.call();
                          },
                          icon: const Icon(Icons.check, size: 18),
                          label: const Text('Setujui KRS'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
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
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(label, style: TextStyle(fontSize: 11, color: color)),
          ],
        ),
      ),
    );
  }
}




