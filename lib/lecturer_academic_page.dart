import 'package:flutter/material.dart';
import 'data/class_data.dart';
import 'data/krs_data.dart';
import 'widgets/custom_top_bar.dart';
import 'widgets/grade_input_modal.dart';
import 'widgets/krs_approval_modal.dart';

class LecturerAcademicPageContent extends StatefulWidget {
  final int initialTab;
  final VoidCallback onNavigateToProfile;
  final VoidCallback onNavigateToSettings;
  final String userName;
  final String userNip;
  final String userProdi;

  const LecturerAcademicPageContent({
    super.key,
    this.initialTab = 0,
    required this.onNavigateToProfile,
    required this.onNavigateToSettings,
    required this.userName,
    required this.userNip,
    required this.userProdi,
  });

  @override
  State<LecturerAcademicPageContent> createState() =>
      _LecturerAcademicPageContentState();
}

class _LecturerAcademicPageContentState
    extends State<LecturerAcademicPageContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  static const Color primaryBlue = Color(0xFF4A90E2);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2, // Nilai, KRS
      vsync: this,
      initialIndex: widget.initialTab.clamp(0, 1),
    );
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
          CustomTopBar(
            onProfileTap: widget.onNavigateToProfile,
            onSettingsTap: widget.onNavigateToSettings,
          ),
          // Tab Bar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: primaryBlue,
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: primaryBlue,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.label,
              dividerColor: Colors.grey[200],
              labelStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              tabs: const [
                Tab(text: 'Nilai'),
                Tab(text: 'KRS'),
              ],
            ),
          ),
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildNilaiTab(), _buildKrsTab()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNilaiTab() {
    final classes = ClassData.getClassesByLecturer(widget.userNip);

    if (classes.isEmpty) {
      return const Center(child: Text('Tidak ada mata kuliah'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: classes.length,
      itemBuilder: (context, index) {
        final classInfo = classes[index];
        return _buildNilaiCard(classInfo);
      },
    );
  }

  Widget _buildNilaiCard(ClassInfo classInfo) {
    final students = ClassData.getStudentsInClass(classInfo.code);
    return GestureDetector(
      onTap: () => GradeInputModal.show(context, classInfo: classInfo),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.grade, color: primaryBlue, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    classInfo.subject,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${classInfo.code} • ${students.length} mahasiswa',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildKrsTab() {
    // Get dynamic KRS data for this dosen PA
    final pendingKrs = KrsData.getPendingKrsForDosenPa(widget.userNip);
    final approvedKrs = KrsData.getApprovedKrsForDosenPa(widget.userNip);
    final rejectedKrs = KrsData.getRejectedKrsForDosenPa(widget.userNip);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: primaryBlue.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: primaryBlue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.fact_check, color: primaryBlue),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Persetujuan KRS',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: primaryBlue,
                        ),
                      ),
                      Text(
                        '${pendingKrs.length} pending • ${approvedKrs.length} disetujui • ${rejectedKrs.length} ditolak',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Pending Section
          if (pendingKrs.isNotEmpty) ...[
            const Text(
              'Menunggu Persetujuan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            ...pendingKrs.map((krs) => _buildKrsPendingCard(krs)),
          ],

          // Approved Section (show last 5)
          if (approvedKrs.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Text(
              'Sudah Disetujui',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            ...approvedKrs.take(5).map((krs) => _buildKrsApprovedCard(krs)),
          ],

          // Rejected Section
          if (rejectedKrs.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Text(
              'Ditolak',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 12),
            ...rejectedKrs.map((krs) => _buildKrsRejectedCard(krs)),
          ],

          // Empty state
          if (pendingKrs.isEmpty && approvedKrs.isEmpty && rejectedKrs.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    Icon(Icons.fact_check, size: 64, color: Colors.grey[300]),
                    const SizedBox(height: 16),
                    Text(
                      'Tidak ada pengajuan KRS',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildKrsPendingCard(KrsEntry krs) {
    final student = krs.student;
    if (student == null) return const SizedBox();

    return GestureDetector(
      onTap: () async {
        await KrsApprovalModal.show(
          context,
          student: student,
          totalSks: krs.totalSks,
          krsEntry: krs,
          dosenPaId: widget.userNip,
          onApproved: () {
            setState(() {}); // Refresh UI after approval
          },
          onRejected: () {
            setState(() {}); // Refresh UI after rejection
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: primaryBlue.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: primaryBlue.withOpacity(0.1),
              child: Text(
                student.name[0],
                style: const TextStyle(
                  color: primaryBlue,
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
                    student.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'NIM: ${student.id} • ${krs.totalSks} SKS',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Pending',
                style: TextStyle(
                  fontSize: 11,
                  color: primaryBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildKrsApprovedCard(KrsEntry krs) {
    final student = krs.student;
    if (student == null) return const SizedBox();

    final approvedDate = krs.approvedAt != null
        ? '${krs.approvedAt!.day}/${krs.approvedAt!.month}/${krs.approvedAt!.year}'
        : '';

    return GestureDetector(
      onTap: () {
        KrsApprovedDetailModal.show(
          context,
          student: student,
          totalSks: krs.totalSks,
          approvedDate: approvedDate,
          semesterInfo: '${krs.period} ${krs.academicYear}',
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.green.withOpacity(0.1),
              child: Text(
                student.name[0],
                style: const TextStyle(
                  color: Colors.green,
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
                    student.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'NIM: ${student.id} • ${krs.totalSks} SKS',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Approved',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKrsRejectedCard(KrsEntry krs) {
    final student = krs.student;
    if (student == null) return const SizedBox();

    // Note: rejectedAt field not in KrsEntry, use empty string
    const rejectedDate = '';

    return GestureDetector(
      onTap: () {
        KrsRejectedDetailModal.show(
          context,
          student: student,
          totalSks: krs.totalSks,
          rejectedDate: rejectedDate,
          rejectedReason: krs.rejectionReason,
          semesterInfo: '${krs.period} ${krs.academicYear}',
          onApproved: () {
            final success = KrsData.approveKrs(krs.id, widget.userNip);
            if (success) {
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('KRS berhasil disetujui'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.red.withOpacity(0.1),
              child: Text(
                student.name[0],
                style: const TextStyle(
                  color: Colors.red,
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
                    student.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'NIM: ${student.id} • Kelas: ${student.kelas ?? "-"}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  Text(
                    '${krs.totalSks} SKS',
                    style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Ditolak',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
