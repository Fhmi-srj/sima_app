import 'package:flutter/material.dart';
import '../shared/data/class_data.dart';
import '../shared/data/user_data.dart';
import '../shared/data/room_data.dart';
import '../shared/widgets/custom_toast.dart';

class ScheduleManagement extends StatefulWidget {
  const ScheduleManagement({super.key});

  @override
  State<ScheduleManagement> createState() => _ScheduleManagementState();
}

class _ScheduleManagementState extends State<ScheduleManagement>
    with SingleTickerProviderStateMixin {
  static const Color primaryBlue = Color(0xFF4A90E2);
  late TabController _tabController;
  String _selectedDay = 'Senin';
  String _selectedKelas = 'Semua';

  final List<String> _days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat'];

  List<CourseAssignment> get _filteredSchedules {
    var schedules = ClassData.getAllCourseAssignments();

    schedules = schedules.where((s) => s.day == _selectedDay).toList();

    if (_selectedKelas != 'Semua') {
      schedules = schedules
          .where((s) => s.kelasCode == _selectedKelas)
          .toList();
    }

    // Sort by time
    schedules.sort((a, b) => a.time.compareTo(b.time));

    return schedules;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _days.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _selectedDay = _days[_tabController.index]);
      }
    });
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
        // Day Tabs
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: primaryBlue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: primaryBlue,
            indicatorWeight: 3,
            tabs: _days.map((day) => Tab(text: day)).toList(),
          ),
        ),

        // Filter Bar
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              const Icon(Icons.filter_list, size: 18, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('Semua'),
                      ...UserData.getAllKelas().map((k) => _buildFilterChip(k)),
                    ],
                  ),
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
              Icon(Icons.schedule, size: 18, color: primaryBlue),
              const SizedBox(width: 8),
              Text(
                '${_filteredSchedules.length} jadwal',
                style: TextStyle(fontSize: 13, color: primaryBlue),
              ),
              const Spacer(),
              Text(
                'Tambah jadwal via Mata Kuliah → Assign',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),

        // Schedule List
        Expanded(
          child: _filteredSchedules.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.event_busy, size: 64, color: Colors.grey[300]),
                      const SizedBox(height: 16),
                      Text(
                        'Tidak ada jadwal pada hari $_selectedDay',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _filteredSchedules.length,
                  itemBuilder: (context, index) =>
                      _buildScheduleCard(_filteredSchedules[index]),
                ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedKelas == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedKelas = label),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? primaryBlue : Colors.grey[200],
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

  Widget _buildScheduleCard(CourseAssignment schedule) {
    return GestureDetector(
      onTap: () => _showScheduleDetailModal(schedule),
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
            // Time Column
            Container(
              width: 70,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    schedule.time.split(' - ')[0],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: primaryBlue,
                    ),
                  ),
                  const Text(
                    '-',
                    style: TextStyle(fontSize: 10, color: primaryBlue),
                  ),
                  Text(
                    schedule.time.split(' - ')[1],
                    style: const TextStyle(fontSize: 12, color: primaryBlue),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          schedule.courseCode,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          schedule.kelasCode,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.purple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${schedule.sks} SKS',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    schedule.courseName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.person, size: 12, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          schedule.lecturerName,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 12,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        schedule.room,
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
          ],
        ),
      ),
    );
  }

  void _showScheduleDetailModal(CourseAssignment schedule) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Schedule Detail',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return _ScheduleDetailModal(
          schedule: schedule,
          onDelete: () {
            Navigator.pop(context);
            CustomToast.success(context, 'Jadwal berhasil dihapus');
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

// Schedule Detail Modal
class _ScheduleDetailModal extends StatelessWidget {
  final CourseAssignment schedule;
  final VoidCallback onDelete;
  static const Color primaryBlue = Color(0xFF4A90E2);

  const _ScheduleDetailModal({required this.schedule, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final students = ClassData.getStudentsInKelas(schedule.kelasCode);

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
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.schedule,
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
                                schedule.day,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                schedule.time,
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
                          // Course Info Card
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    _buildBadge(
                                      schedule.courseCode,
                                      Colors.blue,
                                    ),
                                    const SizedBox(width: 8),
                                    _buildBadge(
                                      '${schedule.sks} SKS',
                                      Colors.orange,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  schedule.courseName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          _buildDetailRow(
                            Icons.class_,
                            'Kelas',
                            schedule.kelasCode,
                          ),
                          _buildDetailRow(
                            Icons.person,
                            'Dosen',
                            schedule.lecturerName,
                          ),
                          _buildDetailRow(
                            Icons.location_on,
                            'Ruangan',
                            schedule.room,
                          ),
                          _buildDetailRow(
                            Icons.people,
                            'Jumlah Mahasiswa',
                            '${students.length} orang',
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
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                    child: Center(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _showDeleteConfirm(context);
                        },
                        icon: const Icon(Icons.delete, size: 18),
                        label: const Text('Hapus dari Jadwal'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 24,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
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
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Jadwal?'),
        content: Text(
          'Hapus jadwal ${schedule.courseName} - ${schedule.kelasCode}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              onDelete();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 20, color: primaryBlue),
          const SizedBox(width: 12),
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
}

// Schedule Form Modal
class _ScheduleFormModal extends StatefulWidget {
  final String title;
  final CourseAssignment? schedule;
  final Function(Map<String, dynamic>) onSave;

  const _ScheduleFormModal({
    required this.title,
    this.schedule,
    required this.onSave,
  });

  @override
  State<_ScheduleFormModal> createState() => _ScheduleFormModalState();
}

class _ScheduleFormModalState extends State<_ScheduleFormModal> {
  static const Color primaryBlue = Color(0xFF4A90E2);
  final List<String> _days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat'];

  late TextEditingController _timeStartController;
  late TextEditingController _timeEndController;
  late TextEditingController _roomController;

  String? _selectedCourseCode;
  String? _selectedKelas;
  String? _selectedLecturerId;
  String _selectedDay = 'Senin';
  Room? _selectedRoom;
  bool _showRoomList = false;

  @override
  void initState() {
    super.initState();
    _timeStartController = TextEditingController(
      text: widget.schedule?.time.split(' - ')[0] ?? '',
    );
    _timeEndController = TextEditingController(
      text: widget.schedule?.time.split(' - ')[1] ?? '',
    );
    _roomController = TextEditingController(text: widget.schedule?.room ?? '');
    _selectedDay = widget.schedule?.day ?? 'Senin';
    _selectedCourseCode = widget.schedule?.courseCode;
    _selectedKelas = widget.schedule?.kelasCode;
    _selectedLecturerId = widget.schedule?.lecturerId;
    // Try to find existing room
    if (widget.schedule?.room != null) {
      final rooms = RoomData.getAllRooms();
      for (final r in rooms) {
        if (r.name == widget.schedule!.room) {
          _selectedRoom = r;
          break;
        }
      }
    }
  }

  @override
  void dispose() {
    _timeStartController.dispose();
    _timeEndController.dispose();
    _roomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get unique courses from assignments
    final allAssignments = ClassData.getAllCourseAssignments();
    final uniqueCourses = <String, String>{}; // code -> name
    for (final a in allAssignments) {
      uniqueCourses[a.courseCode] = a.courseName;
    }
    final lecturers = UserData.getAllLecturers();
    final kelasList = UserData.getAllKelas();

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
                            Icons.schedule,
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
                          // Course
                          _buildDropdown(
                            'Mata Kuliah',
                            _selectedCourseCode,
                            uniqueCourses.entries
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e.key,
                                    child: Text(
                                      '${e.key} - ${e.value}',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                                .toList(),
                            (v) => setState(() => _selectedCourseCode = v),
                          ),
                          const SizedBox(height: 16),

                          // Kelas
                          _buildDropdown(
                            'Kelas',
                            _selectedKelas,
                            kelasList
                                .map(
                                  (k) => DropdownMenuItem(
                                    value: k,
                                    child: Text(k),
                                  ),
                                )
                                .toList(),
                            (v) => setState(() => _selectedKelas = v),
                          ),
                          const SizedBox(height: 16),

                          // Lecturer
                          _buildDropdown(
                            'Dosen',
                            _selectedLecturerId,
                            lecturers
                                .map(
                                  (l) => DropdownMenuItem(
                                    value: l.id,
                                    child: Text(
                                      l.name,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                                .toList(),
                            (v) => setState(() => _selectedLecturerId = v),
                          ),
                          const SizedBox(height: 16),

                          // Day
                          const Text(
                            'Hari',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: _days.map((day) {
                              final isSelected = _selectedDay == day;
                              return GestureDetector(
                                onTap: () => setState(() => _selectedDay = day),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? primaryBlue
                                        : Colors.grey[200],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    day,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.grey[700],
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 16),

                          // Time
                          const Text(
                            'Waktu',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTimeField(
                                  _timeStartController,
                                  'Mulai',
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Text('-'),
                              ),
                              Expanded(
                                child: _buildTimeField(
                                  _timeEndController,
                                  'Selesai',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Room with live search
                          _buildRoomSearchField(),
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
                        onPressed: () {
                          Navigator.pop(context);
                          widget.onSave({
                            'course': _selectedCourseCode,
                            'kelas': _selectedKelas,
                            'day': _selectedDay,
                          });
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
                          'Simpan',
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

  Widget _buildDropdown(
    String label,
    String? value,
    List<DropdownMenuItem<String>> items,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              hint: Text('Pilih $label'),
              value: value,
              items: items,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(Icons.access_time, color: Colors.grey[400], size: 20),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
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

  Widget _buildRoomSearchField() {
    final filteredRooms = RoomData.searchRooms(_roomController.text);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ruangan',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        if (_selectedRoom != null)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.location_on,
                    color: primaryBlue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedRoom!.name,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '${_selectedRoom!.building} • Kapasitas ${_selectedRoom!.capacity}',
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() {
                    _selectedRoom = null;
                    _roomController.clear();
                  }),
                  child: const Icon(Icons.close, size: 18, color: Colors.grey),
                ),
              ],
            ),
          )
        else
          Column(
            children: [
              TextField(
                controller: _roomController,
                onChanged: (value) =>
                    setState(() => _showRoomList = value.isNotEmpty),
                decoration: InputDecoration(
                  hintText: 'Ketik nama ruangan...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              if (_showRoomList && filteredRooms.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    children: filteredRooms
                        .map(
                          (room) => InkWell(
                            onTap: () => setState(() {
                              _selectedRoom = room;
                              _showRoomList = false;
                              _roomController.text = room.name;
                            }),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.shade100,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 18,
                                    color: primaryBlue,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          room.name,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          '${room.building} • Kapasitas ${room.capacity}',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey[600],
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
      ],
    );
  }
}


