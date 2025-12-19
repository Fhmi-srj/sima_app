import 'package:flutter/material.dart';
import 'data/schedule_data.dart';
import 'data/attendance_data.dart';
import 'data/krs_data.dart';
import 'widgets/custom_top_bar.dart';
import 'widgets/attendance_modal.dart';

// Content widget for use in MainContainer
class SchedulePageContent extends StatefulWidget {
  final VoidCallback? onNavigateToProfile;
  final VoidCallback? onNavigateToSettings;
  final String? studentId; // Student ID for KRS-based schedule

  const SchedulePageContent({
    super.key,
    this.onNavigateToProfile,
    this.onNavigateToSettings,
    this.studentId,
  });

  @override
  State<SchedulePageContent> createState() => _SchedulePageContentState();
}

class _SchedulePageContentState extends State<SchedulePageContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Fixed Header with Tabs
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

                // Day Tabs with white background and shadow
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    top: 16,
                  ),
                  child: Row(
                    children: [
                      _buildDayTab('Senin', 0),
                      const SizedBox(width: 12),
                      _buildDayTab('Selasa', 1),
                      const SizedBox(width: 12),
                      _buildDayTab('Rabu', 2),
                      const SizedBox(width: 12),
                      _buildDayTab('Kamis', 3),
                      const SizedBox(width: 12),
                      _buildDayTab('Jum\'at', 4),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Tab Content
        Expanded(
          child: Container(
            color: Colors.grey[100],
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildScheduleList(_getScheduleForDay('Senin')),
                _buildScheduleList(_getScheduleForDay('Selasa')),
                _buildScheduleList(_getScheduleForDay('Rabu')),
                _buildScheduleList(_getScheduleForDay('Kamis')),
                _buildScheduleList(_getScheduleForDay('Jum\'at')),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDayTab(String day, int index) {
    final isSelected = _tabController.index == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _tabController.animateTo(index);
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4A90E2) : Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          day,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF4A90E2),
          ),
        ),
      ),
    );
  }

  // Helper method to get schedule based on KRS status
  List<Map<String, String>> _getScheduleForDay(String day) {
    // If studentId provided, use KRS-filtered schedule
    if (widget.studentId != null) {
      return ScheduleData.getScheduleForDayByKrs(
        day,
        studentId: widget.studentId!,
      );
    }
    // Fallback to original method (for backward compatibility)
    return ScheduleData.getScheduleForDay(day);
  }

  // Check if student has approved KRS
  bool _hasApprovedKrs() {
    if (widget.studentId == null) return true; // Legacy mode - show all
    final approvedKrs = KrsData.getApprovedKrsForStudent(widget.studentId!);
    return approvedKrs != null;
  }

  Widget _buildScheduleList(List<Map<String, String>> schedules) {
    // Check if no approved KRS - show empty state
    if (widget.studentId != null && !_hasApprovedKrs()) {
      return _buildNoApprovedKrsState();
    }

    // If no schedules for this day but has approved KRS
    if (schedules.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_available, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'Tidak ada jadwal hari ini',
              style: TextStyle(fontSize: 16, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: schedules.length,
      itemBuilder: (context, index) {
        final schedule = schedules[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildScheduleCard(
            subject: schedule['subject']!,
            lecturer: schedule['lecturer']!,
            time: schedule['time']!,
            room: schedule['room']!,
            session: schedule['session']!,
          ),
        );
      },
    );
  }

  Widget _buildNoApprovedKrsState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.assignment_late,
                size: 50,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Jadwal Belum Tersedia',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'KRS Anda belum diajukan atau disetujui\noleh Dosen Pembimbing Akademik.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.info_outline, size: 20, color: Color(0xFF4A90E2)),
                  SizedBox(width: 8),
                  Text(
                    'Submit KRS di menu Akademik',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF4A90E2),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleCard({
    required String subject,
    required String lecturer,
    required String time,
    required String room,
    required String session,
  }) {
    return GestureDetector(
      onTap: () => _showAttendanceModal(
        subject: subject,
        lecturer: lecturer,
        time: time,
        room: room,
        session: session,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF5B9FED),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
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
                    subject,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Dosen : $lecturer',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        time,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        room,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Icon(Icons.info, color: Colors.white, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        session,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.chevron_right, color: Colors.white, size: 32),
          ],
        ),
      ),
    );
  }

  void _showAttendanceModal({
    required String subject,
    required String lecturer,
    required String time,
    required String room,
    required String session,
  }) {
    // Get the selected day from tab controller
    final dayNames = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat'];
    final selectedDayName = dayNames[_tabController.index];

    // Map day names to weekday numbers (Monday=1, ..., Friday=5)
    final dayToWeekday = {
      'Senin': 1,
      'Selasa': 2,
      'Rabu': 3,
      'Kamis': 4,
      'Jumat': 5,
    };

    final now = DateTime.now();
    final currentWeekday = now.weekday;
    final selectedWeekday = dayToWeekday[selectedDayName] ?? 1;

    // Calculate the date for the selected day
    final dayDifference = selectedWeekday - currentWeekday;
    final scheduleDate = now.add(Duration(days: dayDifference));

    // Parse the course start time (handle both "08:00" and "08.00" formats)
    final startTimeStr = time.split(' - ').first.trim();
    // Replace dot with colon for consistent parsing
    final normalizedTime = startTimeStr.replaceAll('.', ':');
    final startTimeParts = normalizedTime.split(':');
    final startHour = startTimeParts.isNotEmpty
        ? (int.tryParse(startTimeParts[0]) ?? 0)
        : 0;
    final startMinute = startTimeParts.length > 1
        ? (int.tryParse(startTimeParts[1]) ?? 0)
        : 0;

    final courseStartTime = DateTime(
      scheduleDate.year,
      scheduleDate.month,
      scheduleDate.day,
      startHour,
      startMinute,
    );

    // Parse the course end time
    final endTimeStr = time.split(' - ').last.trim();
    final normalizedEndTime = endTimeStr.replaceAll('.', ':');
    final endTimeParts = normalizedEndTime.split(':');
    final endHour = endTimeParts.isNotEmpty
        ? (int.tryParse(endTimeParts[0]) ?? 0)
        : 0;
    final endMinute = endTimeParts.length > 1
        ? (int.tryParse(endTimeParts[1]) ?? 0)
        : 0;

    final courseEndTime = DateTime(
      scheduleDate.year,
      scheduleDate.month,
      scheduleDate.day,
      endHour,
      endMinute,
    );

    // Check if already attended
    final attendanceRecord = AttendanceData.getAttendanceByCourseName(subject);

    // Check if it's not today or before course start time
    if (selectedWeekday != currentWeekday || now.isBefore(courseStartTime)) {
      // Show "not started yet" modal
      _showNotStartedModal(
        subject: subject,
        lecturer: lecturer,
        time: time,
        room: room,
        startTime: courseStartTime,
        dayName: selectedDayName,
      );
      return;
    }

    // Check if class has ended without attendance (Alpha)
    if (now.isAfter(courseEndTime) && attendanceRecord == null) {
      _showAlphaModal(
        subject: subject,
        lecturer: lecturer,
        time: time,
        room: room,
        endTime: courseEndTime,
      );
      return;
    }

    // Check if already attended
    if (attendanceRecord != null) {
      _showAlreadyAttendedModal(
        subject: subject,
        lecturer: lecturer,
        time: time,
        room: room,
        attendanceType: attendanceRecord.type,
        reason: attendanceRecord.reason,
      );
      return;
    }

    // Show attendance form
    final days = [
      'Minggu',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
    ];
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
    final date =
        '${days[now.weekday % 7]}, ${now.day} ${months[now.month - 1]} ${now.year}';

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: AttendanceModal(
          subject: subject,
          lecturer: lecturer,
          time: time,
          room: room,
          session: session,
          date: date,
        ),
      ),
    );
  }

  void _showNotStartedModal({
    required String subject,
    required String lecturer,
    required String time,
    required String room,
    required DateTime startTime,
    required String dayName,
  }) {
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
    final formattedDate =
        '${startTime.day} ${months[startTime.month - 1]} ${startTime.year}';
    final formattedTime =
        '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.schedule,
                  size: 48,
                  color: Color(0xFF3B82F6),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Mata Kuliah Belum Dimulai',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                subject,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF3B82F6).withOpacity(0.2),
                  ),
                ),
                child: Column(
                  children: [
                    _buildInfoRow(Icons.calendar_today, 'Hari', dayName),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.event, 'Tanggal', formattedDate),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      Icons.access_time,
                      'Waktu Mulai',
                      formattedTime,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.room, 'Ruangan', room),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.person, 'Dosen', lecturer),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '⏰ Silakan kembali saat waktu kuliah dimulai',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF3B82F6),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A90E2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Mengerti',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAlphaModal({
    required String subject,
    required String lecturer,
    required String time,
    required String room,
    required DateTime endTime,
  }) {
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
    final formattedDate =
        '${endTime.day} ${months[endTime.month - 1]} ${endTime.year}';
    final formattedTime =
        '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 360),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFEF4444), Color(0xFFF87171)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFEF4444).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                const Text(
                  'Absensi Terlewat',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFEF4444),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Waktu kuliah sudah berakhir dan\nAnda tidak melakukan absensi',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),

                // Course Info
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subject,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(Icons.person_outline, 'Dosen', lecturer),
                      const SizedBox(height: 8),
                      _buildInfoRow(Icons.access_time_outlined, 'Waktu', time),
                      const SizedBox(height: 8),
                      _buildInfoRow(Icons.room_outlined, 'Ruang', room),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        Icons.calendar_today_outlined,
                        'Berakhir',
                        '$formattedDate, $formattedTime',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Alpha Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFEF4444).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.cancel_outlined,
                        size: 18,
                        color: Color(0xFFEF4444),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Status: ALPHA',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFEF4444),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Close Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF4444),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Mengerti',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
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

  void _showAlreadyAttendedModal({
    required String subject,
    required String lecturer,
    required String time,
    required String room,
    required String attendanceType,
    String? reason,
  }) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: attendanceType == 'hadir'
                      ? const Color(0xFF10B981).withOpacity(0.1)
                      : const Color(0xFFF59E0B).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  attendanceType == 'hadir'
                      ? Icons.check_circle
                      : Icons.event_busy,
                  size: 48,
                  color: attendanceType == 'hadir'
                      ? const Color(0xFF10B981)
                      : const Color(0xFFF59E0B),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                attendanceType == 'hadir'
                    ? 'Anda Sudah Absen Hadir!'
                    : 'Anda Sudah Izin!',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                subject,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    _buildInfoRow(Icons.access_time, 'Waktu', time),
                    const SizedBox(height: 8),
                    _buildInfoRow(Icons.room, 'Ruangan', room),
                    const SizedBox(height: 8),
                    _buildInfoRow(Icons.person, 'Dosen', lecturer),
                    if (reason != null) ...[
                      const SizedBox(height: 8),
                      _buildInfoRow(Icons.note, 'Alasan', reason),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: attendanceType == 'hadir'
                      ? const Color(0xFF10B981).withOpacity(0.1)
                      : const Color(0xFFF59E0B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  attendanceType == 'hadir'
                      ? '✓ Kehadiran Tercatat'
                      : '⚠ Izin Tercatat',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: attendanceType == 'hadir'
                        ? const Color(0xFF10B981)
                        : const Color(0xFFF59E0B),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A90E2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Tutup',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF3B82F6)),
        const SizedBox(width: 10),
        Text(
          '$label:',
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// Standalone Schedule Page (kept for compatibility)
class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SchedulePageContent(),
    );
  }
}
