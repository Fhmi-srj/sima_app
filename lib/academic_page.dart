import 'package:flutter/material.dart';
import 'widgets/custom_bottom_nav_bar.dart';
import 'widgets/custom_top_bar.dart';
import 'widgets/krs_detail_modal.dart';
import 'widgets/khs_detail_modal.dart';
import 'widgets/exam_card_detail_modal.dart';
import 'widgets/submit_krs_modal.dart';
import 'data/krs_data.dart';
import 'data/class_data.dart';

// Content widget for use in MainContainer
class AcademicPageContent extends StatefulWidget {
  final int initialTab;
  final VoidCallback? onNavigateToProfile;
  final VoidCallback? onNavigateToSettings;
  final String userName;
  final String userNim;
  final String userProdi;
  final String userFakultas;
  final String userKelas;

  const AcademicPageContent({
    super.key,
    this.initialTab = 0,
    this.onNavigateToProfile,
    this.onNavigateToSettings,
    required this.userName,
    required this.userNim,
    required this.userProdi,
    this.userFakultas = 'SAINTEK',
    this.userKelas = 'IM23C',
  });

  @override
  State<AcademicPageContent> createState() => _AcademicPageContentState();
}

class _AcademicPageContentState extends State<AcademicPageContent>
    with TickerProviderStateMixin {
  late TabController _mainTabController;
  late TabController _krsFilterController;

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab,
    );
    _krsFilterController = TabController(
      length: 4,
      vsync: this,
      initialIndex: 2, // Default to "Approved"
    );
    _mainTabController.addListener(() {
      setState(() {});
    });
    _krsFilterController.addListener(() {
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(AcademicPageContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTab != widget.initialTab) {
      _mainTabController.animateTo(widget.initialTab);
    }
  }

  @override
  void dispose() {
    _mainTabController.dispose();
    _krsFilterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            // Fixed Header with Tabs
            Container(
              decoration: const BoxDecoration(color: Color(0xFF4A90E2)),
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    // Header Row
                    CustomTopBar(
                      onProfileTap: widget.onNavigateToProfile,
                      onSettingsTap: widget.onNavigateToSettings,
                    ),

                    // Tab Bar
                    Container(
                      color: Colors.white,
                      child: TabBar(
                        controller: _mainTabController,
                        labelColor: const Color(0xFF4A90E2),
                        unselectedLabelColor: Colors.grey[600],
                        labelStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        indicatorColor: const Color(0xFF4A90E2),
                        indicatorWeight: 3,
                        tabs: const [
                          Tab(text: 'KRS'),
                          Tab(text: 'KHS'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _mainTabController,
                children: [_buildKRSTab(), _buildKHSTab()],
              ),
            ),
          ],
        ),
        // FAB removed - KRS now published by admin
      ],
    );
  }

  Widget _buildKRSTab() {
    return Container(
      color: Colors.grey[50],
      child: Column(
        children: [
          const SizedBox(height: 20),

          // Profile Card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4A90E2), Color(0xFF5BA3F5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4A90E2).withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 40,
                    color: Color(0xFF4A90E2),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.userName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.userNim,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.userProdi,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Kartu Rencana Studi Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: const [
                Icon(Icons.credit_card, color: Color(0xFF4A90E2), size: 22),
                SizedBox(width: 8),
                Text(
                  'Kartu Rencana Studi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Filter Tabs
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
                _buildFilterTab('Draft', 0),
                const SizedBox(width: 6),
                _buildFilterTab('Pending', 1),
                const SizedBox(width: 6),
                _buildFilterTab('Approved', 2),
                const SizedBox(width: 6),
                _buildFilterTab('History', 3),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Content based on selected filter
          Expanded(
            child: TabBarView(
              controller: _krsFilterController,
              children: [
                _buildDraftContent(),
                _buildPendingContent(),
                _buildApprovedContent(),
                _buildHistoryContent(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(String label, int index) {
    final isSelected = _krsFilterController.index == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _krsFilterController.animateTo(index);
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

  Widget _buildDraftContent() {
    // Get draft KRS published by admin for current student
    final draftKrsList = KrsData.getKrsByStudent(
      widget.userNim,
    ).where((krs) => krs.status == KrsStatus.draft).toList();

    if (draftKrsList.isEmpty) {
      // No draft KRS - show waiting message
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            // Periode KRS Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF4A90E2), width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.alarm, color: Color(0xFF4A90E2), size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Menunggu KRS dari Admin',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'KRS untuk semester ini belum dipublish oleh admin. Silakan tunggu notifikasi dari admin.',
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '💡 Tips: Siapkan daftar mata kuliah yang ingin diambil dan konsultasikan dengan dosen wali Anda terlebih dahulu.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Dosen Wali Card
            _buildDosenWaliCard(),
          ],
        ),
      );
    }

    // Show draft KRS cards - same design as approved
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: draftKrsList.map((krs) {
          final deadlineText = krs.deadline != null
              ? '${krs.deadline!.day}/${krs.deadline!.month}/${krs.deadline!.year}'
              : 'Tidak ditentukan';

          return Column(
            children: [
              // Use same card style as approved
              _buildSemesterCard(
                semester: 'Semester ${krs.semester}',
                tahun: 'Tahun ${krs.academicYear}',
                mataKuliah: '${krs.courseCodes.length} Mata Kuliah',
                kelas: widget.userKelas,
                sks: krs.totalSks.toString(),
                status: 'Draft',
                statusColor: Colors.grey,
                onTap: () => _showSubmitKrsModal(krs, deadlineText),
              ),
              const SizedBox(height: 12),
            ],
          );
        }).toList(),
      ),
    );
  }

  void _showSubmitKrsModal(KrsEntry krs, String deadlineText) {
    showDialog(
      context: context,
      builder: (context) => SubmitKRSModal(
        semester: 'Semester ${krs.semester}',
        kelas: widget.userKelas,
        totalMataKuliah: krs.courseCodes.length,
        totalSKS: krs.totalSks,
        dosenWaliName: krs.dosenPa?.name ?? 'Dosen PA',
        dosenWaliNIP: krs.dosenPaId,
        deadline: deadlineText,
        onSubmit: () {
          Navigator.of(context).pop();
          _submitDraftKrs(krs.id);
        },
      ),
    );
  }

  void _submitDraftKrs(String krsId) {
    final success = KrsData.submitDraftKrs(krsId);
    if (success) {
      // Show success modal
      _showSubmitSuccessModal();
      setState(() {}); // Refresh UI
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal mengajukan KRS'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSubmitSuccessModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Success Icon
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFFD1FAE5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Color(0xFF10B981),
                  size: 48,
                ),
              ),
              const SizedBox(height: 20),

              // Title
              const Text(
                'KRS Berhasil Di-Submit!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),

              // Subtitle
              Text(
                'KRS Anda telah berhasil diajukan dan sedang menunggu persetujuan dari Dosen Wali.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),

              // Status info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.pending_actions,
                      color: Colors.orange[400],
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Status',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Menunggu Persetujuan Dosen Wali',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFF59E0B),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Close Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A90E2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    shadowColor: const Color(0xFF4A90E2).withValues(alpha: 0.3),
                  ),
                  child: const Text(
                    'Tutup',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPendingContent() {
    // Get dynamic pending KRS for current student
    final pendingKrsList = KrsData.getKrsByStudent(
      widget.userNim,
    ).where((krs) => krs.status == KrsStatus.pending).toList();

    if (pendingKrsList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.hourglass_empty, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'Tidak ada KRS pending',
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: pendingKrsList.map((krs) {
          return Column(
            children: [
              _buildSemesterCard(
                semester: 'Semester ${krs.semester}',
                tahun: 'Tahun ${krs.academicYear}',
                mataKuliah: '${krs.courseCodes.length} Mata Kuliah',
                kelas: 'IM23C',
                sks: krs.totalSks.toString(),
                status: 'Pending',
                statusColor: Colors.orange,
                onTap: () => _showKrsDetailModal(
                  semester: 'Semester ${krs.semester}',
                  tahunAjaran: '${krs.period} ${krs.academicYear}',
                  kelas: 'IM23C',
                  sks: krs.totalSks.toString(),
                  mataKuliahCount: krs.courseCodes.length.toString(),
                  status: 'pending',

                  timeline: [
                    {
                      'title': 'KRS Diajukan',
                      'date': krs.submittedAt != null
                          ? '${krs.submittedAt!.day}/${krs.submittedAt!.month}/${krs.submittedAt!.year}'
                          : '-',
                      'time': krs.submittedAt != null
                          ? '${krs.submittedAt!.hour}:${krs.submittedAt!.minute.toString().padLeft(2, '0')} WIB'
                          : '-',
                      'by': widget.userName,
                      'type': 'submitted',
                      'status': 'Selesai',
                      'completed': true,
                    },
                    {
                      'title': 'Menunggu Persetujuan',
                      'date': '-',
                      'time': '-',
                      'by': krs.dosenPa?.name ?? 'Dosen PA',
                      'type': 'pending',
                      'status': 'Menunggu',
                      'completed': false,
                    },
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          );
        }).toList(),
      ),
    );
  }

  void _showKrsDetailModal({
    required String semester,
    required String tahunAjaran,
    required String kelas,
    required String sks,
    required String mataKuliahCount,
    required String status,
    List<Map<String, dynamic>>? timeline,
  }) {
    // Default timeline for approved
    final defaultApprovedTimeline = [
      {
        'title': 'KRS Diajukan',
        'date': '08 Desember 2024',
        'time': '14:30 WIB',
        'by': 'Ahmad Rizky (102260011)',
        'type': 'submitted',
        'status': 'Selesai',
        'completed': true,
      },
      {
        'title': 'Ditinjau Dosen Wali',
        'date': '09 Desember 2024',
        'time': '09:15 WIB',
        'by': 'Dr. Ahmad Hidayat, M.Kom',
        'type': 'reviewed',
        'status': 'Selesai',
        'completed': true,
      },
      {
        'title': 'KRS Disetujui',
        'date': '09 Desember 2024',
        'time': '09:20 WIB',
        'by': 'Dr. Ahmad Hidayat, M.Kom',
        'type': 'approved',
        'status': 'Selesai',
        'completed': true,
      },
    ];

    // Get mata kuliah list from ClassData schedule
    final courses = ClassData.getCoursesByKelas(kelas);
    final mataKuliahList = courses
        .map(
          (c) => {
            'kode': c.courseCode,
            'nama': c.courseName,
            'hari': c.day,
            'jam': c.time,
            'dosen': c.lecturerName,
            'sks': c.sks.toString(),
          },
        )
        .toList();

    KrsDetailModal.show(
      context,
      semester: semester,
      tahunAjaran: tahunAjaran,
      kelas: kelas,
      sks: sks,
      mataKuliahCount: mataKuliahCount,
      status: status,
      mataKuliahList: mataKuliahList,
      timeline: timeline ?? defaultApprovedTimeline,
      dosenWaliName: 'Dr. Ahmad Hidayat, M.Kom',
      dosenWaliNip: '198506152010121002',
      dosenWaliProdi: 'Prodi Informatika',
    );
  }

  Widget _buildApprovedContent() {
    // Get dynamic approved KRS for current student
    final approvedKrsList = KrsData.getKrsByStudent(
      widget.userNim,
    ).where((krs) => krs.status == KrsStatus.approved).toList();

    if (approvedKrsList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'Belum ada KRS yang disetujui',
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: approvedKrsList.map((krs) {
          return Column(
            children: [
              _buildSemesterCard(
                semester: 'Semester ${krs.semester}',
                tahun: 'Tahun ${krs.academicYear}',
                mataKuliah: '${krs.courseCodes.length} Mata Kuliah',
                kelas: widget.userKelas,
                sks: krs.totalSks.toString(),
                status: 'Approved',
                statusColor: Colors.green,
                onTap: () => _showKrsDetailModal(
                  semester: 'Semester ${krs.semester}',
                  tahunAjaran: '${krs.period} ${krs.academicYear}',
                  kelas: widget.userKelas,
                  sks: krs.totalSks.toString(),
                  mataKuliahCount: krs.courseCodes.length.toString(),
                  status: 'approved',
                ),
              ),
              const SizedBox(height: 12),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHistoryContent() {
    // Get newly approved KRS from dynamic data (semester 5+)
    final newApprovedKrs = KrsData.getKrsByStudent(
      widget.userNim,
    ).where((krs) => krs.status == KrsStatus.approved).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Static history - semesters 1-4 (always shown)
          _buildSemesterCard(
            semester: 'Semester 1',
            tahun: 'Tahun 2023',
            mataKuliah: '5 Mata Kuliah',
            kelas: 'IM23C',
            sks: '20',
            status: 'Approved',
            statusColor: Colors.green,
            onTap: () => _showKrsDetailModal(
              semester: 'Semester 1',
              tahunAjaran: 'Semester Ganjil 2023/2024',
              kelas: 'IM23C',
              sks: '20',
              mataKuliahCount: '5',
              status: 'approved',
            ),
          ),
          const SizedBox(height: 12),
          _buildSemesterCard(
            semester: 'Semester 2',
            tahun: 'Tahun 2023',
            mataKuliah: '7 Mata Kuliah',
            kelas: 'IM23C',
            sks: '17',
            status: 'Approved',
            statusColor: Colors.green,
            onTap: () => _showKrsDetailModal(
              semester: 'Semester 2',
              tahunAjaran: 'Semester Genap 2023/2024',
              kelas: 'IM23C',
              sks: '17',
              mataKuliahCount: '7',
              status: 'approved',
            ),
          ),
          const SizedBox(height: 12),
          _buildSemesterCard(
            semester: 'Semester 3',
            tahun: 'Tahun 2024',
            mataKuliah: '6 Mata Kuliah',
            kelas: 'IM23C',
            sks: '15',
            status: 'Approved',
            statusColor: Colors.green,
            onTap: () => _showKrsDetailModal(
              semester: 'Semester 3',
              tahunAjaran: 'Semester Ganjil 2024/2025',
              kelas: 'IM23C',
              sks: '15',
              mataKuliahCount: '6',
              status: 'approved',
            ),
          ),
          const SizedBox(height: 12),
          _buildSemesterCard(
            semester: 'Semester 4',
            tahun: 'Tahun 2024',
            mataKuliah: '6 Mata Kuliah',
            kelas: 'IM23C',
            sks: '19',
            status: 'Approved',
            statusColor: Colors.green,
            onTap: () => _showKrsDetailModal(
              semester: 'Semester 4',
              tahunAjaran: 'Semester Genap 2024/2025',
              kelas: 'IM23C',
              sks: '19',
              mataKuliahCount: '6',
              status: 'approved',
            ),
          ),
          // Add newly approved KRS from dynamic data
          ...newApprovedKrs.map((krs) {
            return Column(
              children: [
                const SizedBox(height: 12),
                _buildSemesterCard(
                  semester: 'Semester ${krs.semester}',
                  tahun: 'Tahun ${krs.academicYear}',
                  mataKuliah: '${krs.courseCodes.length} Mata Kuliah',
                  kelas: widget.userKelas,
                  sks: krs.totalSks.toString(),
                  status: 'Approved',
                  statusColor: Colors.green,
                  onTap: () => _showKrsDetailModal(
                    semester: 'Semester ${krs.semester}',
                    tahunAjaran: '${krs.period} ${krs.academicYear}',
                    kelas: widget.userKelas,
                    sks: krs.totalSks.toString(),
                    mataKuliahCount: krs.courseCodes.length.toString(),
                    status: 'approved',
                  ),
                ),
              ],
            );
          }),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSemesterCard({
    required String semester,
    required String tahun,
    required String mataKuliah,
    required String kelas,
    required String sks,
    required String status,
    required Color statusColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4A90E2), Color(0xFF5BA3F5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4A90E2).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    semester,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tahun,
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$mataKuliah  |  $kelas',
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'SKS',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4A90E2),
                        ),
                      ),
                      Text(
                        sks,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A90E2),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
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
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFF4A90E2),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDosenWaliCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF4A90E2).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: Color(0xFF4A90E2), size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Dosen Wali',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Dr. Ahmad Hidayat, M.Kom',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'NIP: 198504032010121002',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
                Text(
                  'Email: ahmad.hidayat@university.ac.id',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF4A90E2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.phone, color: Colors.white, size: 16),
                SizedBox(width: 4),
                Text(
                  'Hubungi',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKHSTab() {
    return Container(
      color: Colors.grey[50],
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Kartu Ujian Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: const [
                  Icon(Icons.credit_card, color: Color(0xFF4A90E2), size: 22),
                  SizedBox(width: 8),
                  Text(
                    'Kartu Ujian',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Profile Card
            GestureDetector(
              onTap: () => ExamCardDetailModal.show(
                context,
                studentName: widget.userName,
                studentNim: widget.userNim,
                studentClass: 'IM23C',
                studentSemester: '5 (Ganjil)',
                studentProdi: widget.userProdi,
                studentFakultas: widget.userFakultas,
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4A90E2), Color(0xFF5BA3F5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4A90E2).withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 40,
                        color: Color(0xFF4A90E2),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.userName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.userNim,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'informatika',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    // Tap indicator
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Hasil Studi Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: const [
                  Icon(Icons.credit_card, color: Color(0xFF4A90E2), size: 22),
                  SizedBox(width: 8),
                  Text(
                    'Hasil Studi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Latest KHS Summary Card
            _buildLatestKhsSummaryCard(),
            const SizedBox(height: 16),

            // Grid of Semester Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildKHSSemesterCard(
                          semester: 'Semester 1',
                          tahun: 'Tahun 2023',
                          sks: '20',
                          kelas: 'IM23C',
                          onTap: () => _showKhsDetailModal(
                            semester: 'Semester 1',
                            tahunAjaran: 'Semester Ganjil 2023/2024',
                            kelas: 'IM23C',
                            sks: '20',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildKHSSemesterCard(
                          semester: 'Semester 2',
                          tahun: 'Tahun 2023',
                          sks: '17',
                          kelas: 'IM23C',
                          onTap: () => _showKhsDetailModal(
                            semester: 'Semester 2',
                            tahunAjaran: 'Semester Genap 2023/2024',
                            kelas: 'IM23C',
                            sks: '17',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildKHSSemesterCard(
                          semester: 'Semester 3',
                          tahun: 'Tahun 2024',
                          sks: '15',
                          kelas: 'IM23C',
                          onTap: () => _showKhsDetailModal(
                            semester: 'Semester 3',
                            tahunAjaran: 'Semester Ganjil 2024/2025',
                            kelas: 'IM23C',
                            sks: '15',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildKHSSemesterCard(
                          semester: 'Semester 4',
                          tahun: 'Tahun 2024',
                          sks: '18',
                          kelas: 'IM23C',
                          onTap: () => _showKhsDetailModal(
                            semester: 'Semester 4',
                            tahunAjaran: 'Semester Genap 2024/2025',
                            kelas: 'IM23C',
                            sks: '18',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildKHSSemesterCard(
                          semester: 'Semester 5',
                          tahun: 'Tahun 2025',
                          sks: '20',
                          kelas: 'IM23C',
                          onTap: () => _showKhsDetailModal(
                            semester: 'Semester 5',
                            tahunAjaran: 'Semester Ganjil 2025/2026',
                            kelas: 'IM23C',
                            sks: '20',
                          ),
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKHSSemesterCard({
    required String semester,
    required String tahun,
    required String sks,
    required String kelas,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4A90E2), Color(0xFF5BA3F5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4A90E2).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              semester,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              tahun,
              style: const TextStyle(fontSize: 13, color: Colors.white),
            ),
            const SizedBox(height: 4),
            Text(
              '$sks SKS  |  $kelas',
              style: const TextStyle(fontSize: 13, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  void _showKhsDetailModal({
    required String semester,
    required String tahunAjaran,
    required String kelas,
    required String sks,
  }) {
    // Sample data for KHS
    final nilaiList = [
      {
        'kode': 'PM',
        'nama': 'Pemrograman Mobile',
        'sks': 3,
        'nilai': 'A',
        'mutu': 12.00,
      },
      {
        'kode': 'BD',
        'nama': 'Basis Data',
        'sks': 3,
        'nilai': 'A-',
        'mutu': 11.25,
      },
      {
        'kode': 'JK',
        'nama': 'Jaringan Komputer',
        'sks': 3,
        'nilai': 'B+',
        'mutu': 10.50,
      },
      {
        'kode': 'ASD',
        'nama': 'Algoritma & Strukt Data',
        'sks': 3,
        'nilai': 'A',
        'mutu': 12.00,
      },
      {
        'kode': 'SO',
        'nama': 'Sistem Operasi',
        'sks': 3,
        'nilai': 'B+',
        'mutu': 10.50,
      },
      {
        'kode': 'PKN',
        'nama': 'Pancasila',
        'sks': 2,
        'nilai': 'A-',
        'mutu': 7.50,
      },
      {
        'kode': 'ML',
        'nama': 'Machine Learning',
        'sks': 3,
        'nilai': 'A',
        'mutu': 12.00,
      },
      {
        'kode': 'CC',
        'nama': 'Cloud Computing',
        'sks': 2,
        'nilai': 'B',
        'mutu': 6.00,
      },
    ];

    KhsDetailModal.show(
      context,
      semester: semester,
      tahunAjaran: tahunAjaran,
      kelas: kelas,
      sks: sks,
      mataKuliahCount: '${nilaiList.length}',
      ips: '3.78',
      ipk: '3.65',
      sksLulus: sks,
      sksKumulatif: '91',
      predikat: 'Pujian',
      nilaiList: nilaiList,
      dosenWaliName: 'Dr. Ahmad Hidayat, M.Kom',
      dosenWaliNip: '198506152010121002',
      dosenWaliProdi: 'Prodi Informatika',
      catatan:
          'Prestasi akademik semester ini sangat baik. Pertahankan konsistensi belajar dan tingkatkan partisipasi dalam kegiatan penelitian.',
    );
  }

  Widget _buildLatestKhsSummaryCard() {
    // Get latest KHS data (semester 4 in this case)
    final latestKHS = {
      'semester': 4,
      'period': 'Genap 2023/2024',
      'ips': 3.78,
      'ipk': 3.65,
      'sksLulus': 24,
      'sksTempuh': 91,
      'predikat': 'Pujian',
    };

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4A90E2), Color(0xFF5BA3F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A90E2).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.star, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'KHS Terakhir',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Semester ${latestKHS['semester']} - ${latestKHS['period']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${latestKHS['predikat']}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Stats Row
          Row(
            children: [
              _buildKhsStat('IPS', '${latestKHS['ips']}'),
              const SizedBox(width: 12),
              _buildKhsStat('IPK', '${latestKHS['ipk']}'),
              const SizedBox(width: 12),
              _buildKhsStat('SKS Lulus', '${latestKHS['sksLulus']}'),
              const SizedBox(width: 12),
              _buildKhsStat('SKS Total', '${latestKHS['sksTempuh']}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKhsStat(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: Colors.white.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Standalone Academic Page (for navigation)
class AcademicPage extends StatelessWidget {
  final int initialTab;

  const AcademicPage({super.key, this.initialTab = 0});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AcademicPageContent(
        initialTab: initialTab,
        userName: 'Ahmad Rizky',
        userNim: '102260011',
        userProdi: 'Informatika',
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 4,
        onItemTapped: (index) {
          if (index != 4) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}
