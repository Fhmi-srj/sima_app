import 'package:flutter/material.dart';
import 'data/schedule_data.dart';
import 'data/finance_data.dart';
import 'data/attendance_data.dart';
import 'widgets/custom_top_bar.dart';
import 'widgets/attendance_modal.dart';
import 'widgets/payment_detail_modal.dart';
import 'widgets/paid_payment_modal.dart';

class HomeContent extends StatefulWidget {
  final Function(int)? onNavigateToAcademic;
  final VoidCallback? onNavigateToCertificate;
  final VoidCallback? onNavigateToFinance;
  final VoidCallback? onNavigateToProfile;
  final VoidCallback? onNavigateToSettings;
  final String userName;
  final String userNim;
  final String userProdi;
  final String userAngkatan;
  final String userInstitusi;
  final String userSemester;
  final String? studentId; // For KRS-filtered schedule

  const HomeContent({
    super.key,
    this.onNavigateToAcademic,
    this.onNavigateToCertificate,
    this.onNavigateToFinance,
    this.onNavigateToProfile,
    this.onNavigateToSettings,
    required this.userName,
    required this.userNim,
    required this.userProdi,
    required this.userAngkatan,
    this.userInstitusi = 'Institut Teknologi dan Sains Pekalongan',
    this.userSemester = '5',
    this.studentId,
  });

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  // Get today's schedule filtered by approved KRS
  List<Map<String, String>> _getTodaySchedule() {
    if (widget.studentId != null) {
      return ScheduleData.getTodayScheduleByKrs(studentId: widget.studentId!);
    }
    // Fallback for backward compatibility
    return ScheduleData.getTodaySchedule();
  }

  // Check if student has approved KRS
  bool _hasApprovedKrs() {
    if (widget.studentId == null) return true; // Legacy mode
    return ScheduleData.hasApprovedKrs(widget.studentId!);
  }

  @override
  Widget build(BuildContext context) {
    final todaySchedule = _getTodaySchedule();
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          // Fixed Header - Always visible
          CustomTopBar(
            onProfileTap: widget.onNavigateToProfile,
            onSettingsTap: widget.onNavigateToSettings,
          ),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Card
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4A90E2), Color(0xFF5BA3F5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(35),
                              ),
                              child: const Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Selamat Datang',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    widget.userName,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'NIM : ${widget.userNim}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoItem(
                                Icons.book,
                                'Semester ${widget.userSemester}',
                              ),
                            ),
                            Expanded(
                              child: _buildInfoItem(
                                Icons.school,
                                widget.userInstitusi,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildInfoItem(
                                Icons.info_outline,
                                widget.userProdi,
                              ),
                            ),
                            Expanded(
                              child: _buildInfoItem(
                                Icons.calendar_today,
                                'Angkatan ${widget.userAngkatan}',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Jadwal Hari Ini
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: Color(0xFF4A90E2),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Jadwal Hari Ini (${ScheduleData.getCurrentDay()})',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Schedule Cards - Horizontal Carousel
                  SizedBox(
                    height: 155,
                    child: !_hasApprovedKrs()
                        ? _buildNoApprovedKrsState()
                        : todaySchedule.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'Tidak ada jadwal hari ini',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : ListView.separated(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: todaySchedule.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final schedule = todaySchedule[index];
                              return _buildScheduleCard(schedule);
                            },
                          ),
                  ),
                  const SizedBox(height: 20),

                  // Status Singkat
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.bar_chart,
                          color: Color(0xFF4A90E2),
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Status Singkat',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Status Cards
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(child: _buildStatusCard('85%', 'Absensi')),
                        const SizedBox(width: 12),
                        Expanded(child: _buildStatusCard('18/20', 'SKS')),
                        const SizedBox(width: 12),
                        Expanded(child: _buildStatusCard('3.75', 'IPK')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Menu Cepat
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.dashboard,
                          color: Color(0xFF4A90E2),
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Menu Cepat',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Quick Menu Grid
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildQuickMenuItem(
                            Icons.description,
                            'KRS',
                            'Lihat',
                            onTap: () {
                              // Switch to Academic tab with KRS (index 0)
                              widget.onNavigateToAcademic?.call(0);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildQuickMenuItem(
                            Icons.edit_note,
                            'KHS',
                            'Lihat',
                            onTap: () {
                              // Switch to Academic tab with KHS (index 1)
                              widget.onNavigateToAcademic?.call(1);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildQuickMenuItem(
                            Icons.emoji_events,
                            'Sertifikat',
                            'Lihat',
                            onTap: () {
                              // Navigate to Certificate page
                              widget.onNavigateToCertificate?.call();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Pengingat Penting
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.warning_amber,
                              color: Color(0xFF4A90E2),
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Pengingat Penting',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: widget.onNavigateToFinance,
                          child: const Text(
                            'Lihat Semua',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF4A90E2),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Dynamic Reminder Cards from FinanceData
                  ...FinanceData.getNotifications().take(2).map((notif) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 10,
                      ),
                      child: _buildReminderCard(notif),
                    );
                  }),
                  const SizedBox(height: 90),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderCard(Map<String, dynamic> notif) {
    IconData icon;
    Color iconColor;
    Color bgColor;

    switch (notif['type']) {
      case 'warning':
        icon = Icons.warning;
        iconColor = const Color(0xFFFFA726);
        bgColor = const Color(0xFFFFF3E0);
        break;
      case 'info':
        icon = Icons.info;
        iconColor = const Color(0xFF42A5F5);
        bgColor = const Color(0xFFE3F2FD);
        break;
      case 'success':
        icon = Icons.check_circle;
        iconColor = const Color(0xFF66BB6A);
        bgColor = const Color(0xFFE8F5E9);
        break;
      default:
        icon = Icons.notifications;
        iconColor = const Color(0xFF4A90E2);
        bgColor = const Color(0xFFE3F2FD);
    }

    return GestureDetector(
      onTap: () => _handleReminderTap(notif),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
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
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notif['title'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    notif['subtitle'].toString().replaceAll('\n', ' '),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (notif['amount'] != null)
              Text(
                notif['amount'],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: iconColor,
                ),
              ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }

  void _handleReminderTap(Map<String, dynamic> notif) {
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

  // Build empty state for when KRS is not approved
  Widget _buildNoApprovedKrsState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.assignment_late, color: Colors.orange, size: 24),
              const SizedBox(width: 12),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'KRS Belum Disetujui',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Submit KRS di menu Akademik',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleCard(Map<String, String> schedule) {
    final title = schedule['subject'] ?? '';
    final time = schedule['time'] ?? '';
    final room = schedule['room'] ?? '';
    final lecturer = schedule['lecturer'] ?? 'Dosen';
    final session = schedule['session'] ?? '1';

    return Container(
      width: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A90E2),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$time  |  $room',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 36,
            child: ElevatedButton(
              onPressed: () => _handleScheduleTap(
                subject: title,
                lecturer: lecturer,
                time: time,
                room: room,
                session: session,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4A90E2),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Lihat Detail',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleScheduleTap({
    required String subject,
    required String lecturer,
    required String time,
    required String room,
    required String session,
  }) {
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

    final now = DateTime.now();
    final courseStartTime = DateTime(
      now.year,
      now.month,
      now.day,
      startHour,
      startMinute,
    );

    // Check if course time has started
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
      now.year,
      now.month,
      now.day,
      endHour,
      endMinute,
    );

    // Check if attendance has been recorded for this course today
    final attendanceRecord = AttendanceData.getAttendanceByCourseName(subject);

    if (now.isBefore(courseStartTime)) {
      // Show "not started yet" modal
      _showNotStartedModal(
        subject: subject,
        lecturer: lecturer,
        time: time,
        room: room,
        startTime: courseStartTime,
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

    if (attendanceRecord != null) {
      // Show "already attended" modal
      _showAlreadyAttendedModal(
        subject: subject,
        lecturer: lecturer,
        time: time,
        room: room,
        attendanceType: attendanceRecord.type,
        reason: attendanceRecord.reason,
      );
    } else {
      // Show attendance form modal
      showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: AttendanceModal(
            subject: subject,
            lecturer: lecturer,
            time: time,
            room: room,
            session: session,
            date: _getCurrentDate(),
          ),
        ),
      );
    }
  }

  void _showNotStartedModal({
    required String subject,
    required String lecturer,
    required String time,
    required String room,
    required DateTime startTime,
  }) {
    // Format day name
    final days = [
      'Minggu',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
    ];
    final dayName = days[startTime.weekday % 7];

    // Format date
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

    // Format time
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
              // Clock Icon
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

              // Title
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

              // Subject
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

              // Schedule Info Card
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
                    _buildScheduleInfoRow(
                      Icons.calendar_today,
                      'Hari',
                      dayName,
                    ),
                    const SizedBox(height: 12),
                    _buildScheduleInfoRow(
                      Icons.event,
                      'Tanggal',
                      formattedDate,
                    ),
                    const SizedBox(height: 12),
                    _buildScheduleInfoRow(
                      Icons.access_time,
                      'Waktu Mulai',
                      formattedTime,
                    ),
                    const SizedBox(height: 12),
                    _buildScheduleInfoRow(Icons.room, 'Ruangan', room),
                    const SizedBox(height: 12),
                    _buildScheduleInfoRow(Icons.person, 'Dosen', lecturer),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Info Badge
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

              // Close Button
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
                      _buildScheduleInfoRow(
                        Icons.person_outline,
                        'Dosen',
                        lecturer,
                      ),
                      const SizedBox(height: 8),
                      _buildScheduleInfoRow(
                        Icons.access_time_outlined,
                        'Waktu',
                        time,
                      ),
                      const SizedBox(height: 8),
                      _buildScheduleInfoRow(Icons.room_outlined, 'Ruang', room),
                      const SizedBox(height: 8),
                      _buildScheduleInfoRow(
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

  Widget _buildScheduleInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF3B82F6)),
        const SizedBox(width: 10),
        Text(
          '$label:',
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
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
              // Success Icon
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

              // Title
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

              // Subject
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

              // Info Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    _buildInfoRow(Icons.access_time, time),
                    const SizedBox(height: 8),
                    _buildInfoRow(Icons.room, room),
                    const SizedBox(height: 8),
                    _buildInfoRow(Icons.person, lecturer),
                    if (reason != null) ...[
                      const SizedBox(height: 8),
                      _buildInfoRow(Icons.note, 'Alasan: $reason'),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Status Badge
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

              // Close Button
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

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
        ),
      ],
    );
  }

  String _getCurrentDate() {
    final now = DateTime.now();
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
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${days[now.weekday % 7]}, ${now.day} ${months[now.month - 1]} ${now.year}';
  }

  Widget _buildStatusCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickMenuItem(
    IconData icon,
    String title,
    String action, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(
                  0xFF4A90E2,
                ).withOpacity(onTap == null ? 0.05 : 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Color(0xFF4A90E2).withOpacity(onTap == null ? 0.3 : 1.0),
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: onTap == null ? Colors.grey : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Color(0xFF4A90E2).withOpacity(onTap == null ? 0.3 : 1.0),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                action,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
