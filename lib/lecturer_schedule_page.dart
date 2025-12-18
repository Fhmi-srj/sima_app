import 'package:flutter/material.dart';
import 'data/lecturer_data.dart';
import 'data/user_data.dart';
import 'data/attendance_data.dart';
import 'data/krs_data.dart';
import 'widgets/custom_top_bar.dart';
import 'widgets/custom_toast.dart';

class LecturerSchedulePageContent extends StatefulWidget {
  final VoidCallback onNavigateToProfile;
  final VoidCallback onNavigateToSettings;
  final String userNip;

  const LecturerSchedulePageContent({
    super.key,
    required this.onNavigateToProfile,
    required this.onNavigateToSettings,
    required this.userNip,
  });

  @override
  State<LecturerSchedulePageContent> createState() =>
      _LecturerSchedulePageContentState();
}

class _LecturerSchedulePageContentState
    extends State<LecturerSchedulePageContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat'];
  static const Color primaryBlue = Color(0xFF4A90E2);

  // Track attended classes for today
  final Set<String> _attendedClasses = {};

  @override
  void initState() {
    super.initState();
    int initialIndex = DateTime.now().weekday - 1;
    if (initialIndex < 0 || initialIndex > 4) initialIndex = 0;
    _tabController = TabController(
      length: 5,
      vsync: this,
      initialIndex: initialIndex,
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
          // Tab Content
          Expanded(
            child: Container(
              color: Colors.grey[100],
              child: TabBarView(
                controller: _tabController,
                children: _days.map((day) => _buildDaySchedule(day)).toList(),
              ),
            ),
          ),
        ],
      ),
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
          color: isSelected ? primaryBlue : Colors.white,
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
            color: isSelected ? Colors.white : primaryBlue,
          ),
        ),
      ),
    );
  }

  Widget _buildDaySchedule(String day) {
    final schedule = LecturerData.getTeachingSchedule(
      widget.userNip,
    ).where((s) => s['day'] == day).toList();
    if (schedule.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_available, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'Tidak ada jadwal mengajar',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            Text(
              'Hari $day',
              style: TextStyle(fontSize: 14, color: Colors.grey[400]),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: schedule.length,
      itemBuilder: (context, index) => _buildScheduleCard(schedule[index], day),
    );
  }

  Widget _buildScheduleCard(Map<String, dynamic> schedule, String day) {
    return GestureDetector(
      onTap: () => _handleScheduleTap(schedule, day),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 6,
                decoration: const BoxDecoration(
                  color: primaryBlue,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              schedule['subject'] ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: primaryBlue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              schedule['kelas'] ?? 'IM23C',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: primaryBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildInfoChip(
                            Icons.access_time,
                            schedule['time'] ?? '',
                          ),
                          const SizedBox(width: 12),
                          _buildInfoChip(
                            Icons.room_outlined,
                            schedule['room'] ?? '',
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInfoChip(
                            Icons.people_outline,
                            // Only count students with approved KRS
                            '${KrsData.getApprovedStudentsForClass(schedule['kelas'] ?? '', 5).length} Mahasiswa',
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.touch_app,
                                  size: 14,
                                  color: Colors.green,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Tap untuk absensi',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
      ],
    );
  }

  void _handleScheduleTap(Map<String, dynamic> schedule, String day) {
    final dayToWeekday = {
      'Senin': 1,
      'Selasa': 2,
      'Rabu': 3,
      'Kamis': 4,
      'Jumat': 5,
    };
    final now = DateTime.now();
    final currentWeekday = now.weekday;
    final scheduleDayNum = dayToWeekday[day] ?? 1;

    // Parse time (e.g., "08:00 - 10:30")
    final time = schedule['time'] ?? '08:00 - 10:30';
    final timeParts = time.split(' - ');
    final startTime = timeParts[0].split(':');
    final endTime = timeParts.length > 1 ? timeParts[1].split(':') : startTime;

    final startHour = int.parse(startTime[0]);
    final startMinute = int.parse(startTime[1]);
    final endHour = int.parse(endTime[0]);
    final endMinute = int.parse(endTime[1]);

    // Check if today is the schedule day
    if (currentWeekday != scheduleDayNum) {
      // Calculate next occurrence
      int daysUntil = scheduleDayNum - currentWeekday;
      if (daysUntil <= 0) daysUntil += 7;
      final nextDate = now.add(Duration(days: daysUntil));
      final startDateTime = DateTime(
        nextDate.year,
        nextDate.month,
        nextDate.day,
        startHour,
        startMinute,
      );

      _showNotStartedModal(
        subject: schedule['subject'] ?? '',
        kelas: schedule['kelas'] ?? '',
        time: time,
        room: schedule['room'] ?? '',
        startTime: startDateTime,
        dayName: day,
      );
      return;
    }

    // Check if course time has passed (current time > end time)
    final currentMinutes = now.hour * 60 + now.minute;
    final startMinutes = startHour * 60 + startMinute;
    final endMinutes = endHour * 60 + endMinute;

    // If current time is before start time - course hasn't started yet
    if (currentMinutes < startMinutes) {
      final startDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        startHour,
        startMinute,
      );

      _showNotStartedModal(
        subject: schedule['subject'] ?? '',
        kelas: schedule['kelas'] ?? '',
        time: time,
        room: schedule['room'] ?? '',
        startTime: startDateTime,
        dayName: day,
      );
      return;
    }

    // If current time is after end time - course has ended, mark as alpha
    if (currentMinutes > endMinutes) {
      // Check if already attended
      final scheduleId = '${schedule['subject']}_${schedule['kelas']}_$day';
      if (_attendedClasses.contains(scheduleId)) {
        _showAlreadyAttendedModal(
          subject: schedule['subject'] ?? '',
          kelas: schedule['kelas'] ?? '',
          time: time,
        );
        return;
      }

      _showAlphaModal(
        subject: schedule['subject'] ?? '',
        kelas: schedule['kelas'] ?? '',
        time: time,
        room: schedule['room'] ?? '',
      );
      return;
    }

    // Check if already attended today
    final scheduleId = '${schedule['subject']}_${schedule['kelas']}_$day';
    if (_attendedClasses.contains(scheduleId)) {
      _showAlreadyAttendedModal(
        subject: schedule['subject'] ?? '',
        kelas: schedule['kelas'] ?? '',
        time: time,
      );
      return;
    }

    // Course is today and within valid time range - show attendance input
    _showAttendanceModal(schedule, day);
  }

  void _showNotStartedModal({
    required String subject,
    required String kelas,
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

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.schedule, color: primaryBlue, size: 48),
              ),
              const SizedBox(height: 20),
              const Text(
                'Mata Kuliah Belum Dimulai',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '$subject - $kelas',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildModalInfoRow(
                      Icons.calendar_today,
                      '$dayName, $formattedDate',
                    ),
                    const SizedBox(height: 8),
                    _buildModalInfoRow(Icons.access_time, time),
                    const SizedBox(height: 8),
                    _buildModalInfoRow(Icons.room, room),
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
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '⏰ Silakan kembali saat waktu kuliah dimulai',
                  style: TextStyle(fontSize: 12, color: primaryBlue),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Mengerti'),
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
    required String kelas,
    required String time,
    required String room,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red,
                  size: 48,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Waktu Kuliah Sudah Terlewat',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '$subject - $kelas',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Alpha status box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cancel, color: Colors.red, size: 24),
                        SizedBox(width: 8),
                        Text(
                          'Status Anda: ALPHA',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Anda tidak membuka absensi tepat waktu dan tidak ada konfirmasi izin ke Admin sebelum kuliah dimulai.',
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Warning about student attendance
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.group, color: Colors.orange, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Absensi Mahasiswa',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Mahasiswa di kelas ini belum diabsen. Silakan hubungi Admin untuk menginput absensi mahasiswa secara manual.',
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Contact admin info
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.phone, color: primaryBlue, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Hubungi Admin: (021) 123-4567',
                        style: TextStyle(fontSize: 12, color: primaryBlue),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Mengerti'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModalInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Text(text, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
      ],
    );
  }

  void _showAttendanceModal(Map<String, dynamic> schedule, String day) {
    final kelasCode = schedule['kelas'] ?? 'IM23C';
    // Only show students with approved KRS for current semester
    const currentSemester = 5;
    final students = KrsData.getApprovedStudentsForClass(
      kelasCode,
      currentSemester,
    );
    final scheduleId = '${schedule['subject']}_${schedule['kelas']}_$day';

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Attendance Modal',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (ctx, anim1, anim2) => _SimpleAttendanceModal(
        courseName: schedule['subject'] ?? '',
        courseCode: schedule['courseCode'] ?? '',
        kelasCode: kelasCode,
        students: students,
        onAttendanceSaved: () {
          setState(() {
            _attendedClasses.add(scheduleId);
          });
        },
      ),
      transitionBuilder: (ctx, anim1, anim2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim1, curve: Curves.easeOut)),
          child: child,
        );
      },
    );
  }

  void _showAlreadyAttendedModal({
    required String subject,
    required String kelas,
    required String time,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 48,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Absensi Sudah Dilakukan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '$subject - $kelas',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.verified, color: Colors.green, size: 24),
                        SizedBox(width: 8),
                        Text(
                          'Status Anda: HADIR',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Anda sudah membuka absensi dan tercatat hadir di kelas ini hari ini.',
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey[500]),
                  const SizedBox(width: 8),
                  Text(
                    'Jadwal: $time',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SimpleAttendanceModal extends StatefulWidget {
  final String courseName;
  final String courseCode;
  final String kelasCode;
  final List<AppUser> students;
  final VoidCallback? onAttendanceSaved;

  const _SimpleAttendanceModal({
    required this.courseName,
    required this.courseCode,
    required this.kelasCode,
    required this.students,
    this.onAttendanceSaved,
  });

  @override
  State<_SimpleAttendanceModal> createState() => _SimpleAttendanceModalState();
}

class _SimpleAttendanceModalState extends State<_SimpleAttendanceModal> {
  static const Color primaryBlue = Color(0xFF4A90E2);
  late Map<String, String> _attendance;

  @override
  void initState() {
    super.initState();
    _attendance = {for (var s in widget.students) s.id: 'H'};
  }

  @override
  Widget build(BuildContext context) {
    final hadir = _attendance.values.where((v) => v == 'H').length;
    final izin = _attendance.values.where((v) => v == 'I').length;
    final alpha = _attendance.values.where((v) => v == 'A').length;

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
                // Header
                Container(
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
                        child: const Icon(
                          Icons.assignment,
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
                              'Input Absensi Mahasiswa',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${widget.courseName} • ${widget.kelasCode}',
                              style: TextStyle(
                                fontSize: 13,
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
                ),
                // Summary
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey[50],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStat('Hadir', hadir, Colors.green),
                      _buildStat('Izin', izin, Colors.orange),
                      _buildStat('Alpha', alpha, Colors.red),
                    ],
                  ),
                ),
                // Info note
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Dengan menyimpan absensi, Anda tercatat HADIR di kelas ini',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.green[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Student List (or Empty State)
                Flexible(
                  child: widget.students.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.person_off,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Belum Ada Mahasiswa',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Mahasiswa akan muncul setelah KRS mereka di-approve oleh Dosen Wali',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[500],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: widget.students.length,
                          itemBuilder: (context, index) {
                            final student = widget.students[index];
                            final status = _attendance[student.id] ?? 'H';
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: primaryBlue.withOpacity(
                                      0.1,
                                    ),
                                    child: Text(
                                      student.name[0],
                                      style: const TextStyle(
                                        color: primaryBlue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
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
                                          student.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                        Text(
                                          student.id,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: ['H', 'I', 'A'].map((label) {
                                      final color = label == 'H'
                                          ? Colors.green
                                          : (label == 'I'
                                                ? Colors.orange
                                                : Colors.red);
                                      final isSelected = status == label;
                                      return Padding(
                                        padding: const EdgeInsets.only(left: 4),
                                        child: GestureDetector(
                                          onTap: () => setState(
                                            () =>
                                                _attendance[student.id] = label,
                                          ),
                                          child: Container(
                                            width: 32,
                                            height: 32,
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? color
                                                  : color.withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Center(
                                              child: Text(
                                                label,
                                                style: TextStyle(
                                                  color: isSelected
                                                      ? Colors.white
                                                      : color,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                // Footer
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
                          child: const Text('Batal'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Save attendance for each student to AttendanceData
                            for (final student in widget.students) {
                              final status = _attendance[student.id] ?? 'H';
                              final type = status == 'H'
                                  ? 'hadir'
                                  : (status == 'I' ? 'izin' : 'alpha');
                              AttendanceData.recordAttendance(
                                studentId: student.id,
                                courseCode: widget.courseCode,
                                courseName: widget.courseName,
                                date: AttendanceData.getTodayFormatted(),
                                type: type,
                              );
                            }
                            Navigator.pop(context);
                            widget.onAttendanceSaved?.call();
                            CustomToast.success(
                              context,
                              'Absensi ${widget.students.length} mahasiswa berhasil disimpan!',
                            );
                          },
                          icon: const Icon(Icons.save),
                          label: const Text('Simpan Absensi'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
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

  Widget _buildStat(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: color)),
      ],
    );
  }
}
