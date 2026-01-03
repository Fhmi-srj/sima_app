import 'package:flutter/material.dart';
import '../shared/data/class_data.dart';
import '../shared/data/user_data.dart';
import '../shared/widgets/custom_top_bar.dart';

class AttendanceManagementPageContent extends StatefulWidget {
  final VoidCallback onNavigateToProfile;
  final VoidCallback onNavigateToSettings;
  final String userNip;

  const AttendanceManagementPageContent({
    super.key,
    required this.onNavigateToProfile,
    required this.onNavigateToSettings,
    required this.userNip,
  });

  @override
  State<AttendanceManagementPageContent> createState() =>
      _AttendanceManagementPageContentState();
}

class _AttendanceManagementPageContentState
    extends State<AttendanceManagementPageContent> {
  static const Color primaryBlue = Color(0xFF4A90E2);
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
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
          // Search Bar
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Cari kelas atau mata kuliah...',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                        color: Colors.grey[400],
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          // Header
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryBlue,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.history, color: Colors.white, size: 24),
                SizedBox(width: 12),
                Text(
                  'Riwayat Absensi Kelas',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // Content
          Expanded(child: _buildRiwayatTab()),
        ],
      ),
    );
  }

  Widget _buildRiwayatTab() {
    final allClasses = ClassData.getClassesByLecturer(widget.userNip);

    // Filter by search query
    final classes = allClasses.where((c) {
      if (_searchQuery.isEmpty) return true;
      final query = _searchQuery.toLowerCase();
      return c.subject.toLowerCase().contains(query) ||
          c.name.toLowerCase().contains(query) ||
          c.code.toLowerCase().contains(query);
    }).toList();

    if (classes.isEmpty && _searchQuery.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Tidak ditemukan kelas dengan "$_searchQuery"',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: classes.length,
      itemBuilder: (context, index) => _buildCourseCard(classes[index]),
    );
  }

  Widget _buildCourseCard(ClassInfo classInfo) {
    final students = ClassData.getStudentsInClass(classInfo.code);
    return GestureDetector(
      onTap: () => _showMeetingHistoryModal(classInfo),
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
                color: primaryBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.book, color: Colors.white, size: 24),
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
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${classInfo.name} • ${students.length} mahasiswa',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildInfoChip('14 Pertemuan', Colors.green),
                      const SizedBox(width: 8),
                      _buildInfoChip(classInfo.day, Colors.blue),
                    ],
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

  Widget _buildInfoChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showMeetingHistoryModal(ClassInfo classInfo) {
    final students = ClassData.getStudentsInClass(classInfo.code);

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Meeting History Modal',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return _MeetingHistoryModal(classInfo: classInfo, students: students);
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

class _MeetingHistoryModal extends StatefulWidget {
  final ClassInfo classInfo;
  final List<AppUser> students;

  const _MeetingHistoryModal({required this.classInfo, required this.students});

  @override
  State<_MeetingHistoryModal> createState() => _MeetingHistoryModalState();
}

class _MeetingHistoryModalState extends State<_MeetingHistoryModal> {
  static const Color primaryBlue = Color(0xFF4A90E2);
  int? _selectedMeeting;
  AppUser? _selectedIzinStudent;

  final List<Map<String, dynamic>> _meetings = List.generate(14, (index) {
    final weekNum = index + 1;
    final date = DateTime(2024, 9, 2).add(Duration(days: index * 7));
    return {
      'week': weekNum,
      'date': '${date.day}/${date.month}/${date.year}',
      'hadir': 25 - (index % 3),
      'izin': index % 3,
      'alpha': index % 2,
      'status': weekNum <= 12 ? 'done' : 'upcoming',
    };
  });

  @override
  Widget build(BuildContext context) {
    if (_selectedIzinStudent != null) return _buildIzinApprovalOverlay();
    if (_selectedMeeting != null) return _buildMeetingDetailOverlay();
    return _buildMeetingListModal();
  }

  Widget _buildMeetingListModal() {
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
                _buildHeader(),
                Flexible(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _meetings.length,
                    itemBuilder: (context, index) =>
                        _buildMeetingCard(_meetings[index], index),
                  ),
                ),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
            child: const Icon(Icons.history, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Riwayat Pertemuan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.classInfo.subject,
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

  Widget _buildMeetingCard(Map<String, dynamic> meeting, int index) {
    final isDone = meeting['status'] == 'done';
    return GestureDetector(
      onTap: isDone ? () => setState(() => _selectedMeeting = index) : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDone ? Colors.white : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDone ? primaryBlue.withOpacity(0.3) : Colors.grey[300]!,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isDone ? primaryBlue : Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  '${meeting['week']}',
                  style: TextStyle(
                    color: isDone ? Colors.white : Colors.grey[600],
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pertemuan ${meeting['week']}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDone ? Colors.black : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    meeting['date'],
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            if (isDone) ...[
              Row(
                children: [
                  _buildMiniStat('H', meeting['hadir'], Colors.green),
                  const SizedBox(width: 4),
                  _buildMiniStat('I', meeting['izin'], Colors.orange),
                  const SizedBox(width: 4),
                  _buildMiniStat('A', meeting['alpha'], Colors.red),
                ],
              ),
              const SizedBox(width: 8),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ] else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Belum',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '$label:$count',
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text('Tutup'),
      ),
    );
  }

  Widget _buildMeetingDetailOverlay() {
    final meeting = _meetings[_selectedMeeting!];
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
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF4A90E2), Color(0xFF5BA3F5)],
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () =>
                                setState(() => _selectedMeeting = null),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pertemuan ${meeting['week']}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  meeting['date'],
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
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildDetailStat(
                            'Hadir',
                            meeting['hadir'],
                            Colors.green,
                          ),
                          _buildDetailStat(
                            'Izin',
                            meeting['izin'],
                            Colors.orange,
                          ),
                          _buildDetailStat(
                            'Alpha',
                            meeting['alpha'],
                            Colors.red,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: widget.students.length,
                    itemBuilder: (context, index) {
                      final student = widget.students[index];
                      final status = index % 10 < 8
                          ? 'H'
                          : (index % 10 == 8 ? 'I' : 'A');
                      return _buildStudentDetailRow(student, status);
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    border: Border(top: BorderSide(color: Colors.grey[200]!)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              setState(() => _selectedMeeting = null),
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Kembali'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: primaryBlue,
                            side: const BorderSide(color: primaryBlue),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.download),
                          label: const Text('Export'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
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

  Widget _buildDetailStat(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            '$count',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentDetailRow(AppUser student, String status) {
    Color statusColor;
    String statusText;
    switch (status) {
      case 'H':
        statusColor = Colors.green;
        statusText = 'Hadir';
        break;
      case 'I':
        statusColor = Colors.orange;
        statusText = 'Izin';
        break;
      case 'A':
        statusColor = Colors.red;
        statusText = 'Alpha';
        break;
      default:
        statusColor = Colors.grey;
        statusText = '-';
    }

    final isTappable = status == 'I';

    return GestureDetector(
      onTap: isTappable
          ? () => setState(() => _selectedIzinStudent = student)
          : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isTappable ? Colors.orange : Colors.grey[200]!,
            width: isTappable ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: statusColor.withOpacity(0.1),
              child: Text(
                student.name[0],
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
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
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    student.id,
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                statusText,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIzinApprovalOverlay() {
    final student = _selectedIzinStudent!;
    final meeting = _meetings[_selectedMeeting!];

    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        constraints: const BoxConstraints(maxWidth: 400),
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
                      colors: [Colors.orange, Color(0xFFFF9800)],
                    ),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () =>
                            setState(() => _selectedIzinStudent = null),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Detail Permohonan Izin',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Riwayat Pertemuan',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
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
                // Content
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Student Info
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.orange.withOpacity(0.1),
                            child: Text(
                              student.name[0],
                              style: const TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
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
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  student.id,
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Details
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            _buildInfoRow(
                              Icons.calendar_today,
                              'Tanggal',
                              meeting['date'],
                            ),
                            const Divider(height: 20),
                            _buildInfoRow(
                              Icons.school,
                              'Pertemuan',
                              'Minggu ${meeting['week']}',
                            ),
                            const Divider(height: 20),
                            _buildInfoRow(
                              Icons.description,
                              'Alasan',
                              'Izin keperluan',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Proof placeholder
                      Container(
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image,
                              size: 32,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Bukti / Surat Keterangan',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Close Button only (approve/reject is in attendance modal)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() => _selectedIzinStudent = null);
                          },
                          icon: const Icon(Icons.close),
                          label: const Text(
                            'Tutup',
                            style: TextStyle(fontSize: 14),
                          ),
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

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.orange),
        const SizedBox(width: 12),
        Text(label, style: TextStyle(color: Colors.grey[600])),
        const Spacer(),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
