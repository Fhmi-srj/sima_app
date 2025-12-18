import 'package:flutter/material.dart';
import '../data/user_data.dart';
import '../data/class_data.dart';
import '../widgets/custom_toast.dart';

class GradeCalculation extends StatefulWidget {
  const GradeCalculation({super.key});

  @override
  State<GradeCalculation> createState() => _GradeCalculationState();
}

class _GradeCalculationState extends State<GradeCalculation>
    with SingleTickerProviderStateMixin {
  static const Color primaryBlue = Color(0xFF4A90E2);
  late TabController _tabController;

  final Map<String, int> _gradeWeights = {
    'tugas': 20,
    'uts': 30,
    'uas': 40,
    'kehadiran': 10,
  };

  final Map<String, Map<String, double?>> _finalGrades = {
    '102230001': {'IF501': null, 'IF502': null, 'IF503': null},
    '102230002': {'IF501': null, 'IF502': null, 'IF503': null},
    '102230039': {
      'IF501': 82.4,
      'IF502': 88.5,
      'IF503': null,
      'IF504': 85.0,
      'IF505': 79.2,
      'IF506': 91.0,
      'IF507': 77.5,
    },
    '102230040': {
      'IF501': 73.2,
      'IF502': 78.0,
      'IF503': 75.5,
      'IF504': null,
      'IF505': 80.0,
      'IF506': 82.3,
      'IF507': 70.0,
    },
    '102230041': {
      'IF501': 89.5,
      'IF502': 91.0,
      'IF503': 87.0,
      'IF504': 85.5,
      'IF505': 88.0,
      'IF506': 92.0,
      'IF507': 90.0,
    },
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _getGradeLetter(double score) {
    if (score >= 85) return 'A';
    if (score >= 80) return 'A-';
    if (score >= 75) return 'B+';
    if (score >= 70) return 'B';
    if (score >= 65) return 'B-';
    if (score >= 60) return 'C+';
    if (score >= 55) return 'C';
    if (score >= 50) return 'D';
    return 'E';
  }

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'A':
      case 'A-':
        return Colors.green;
      case 'B+':
      case 'B':
      case 'B-':
        return Colors.blue;
      case 'C+':
      case 'C':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  bool _isStudentComplete(String studentId, String kelas) {
    final courses = ClassData.getCourseAssignmentsByKelas(kelas);
    for (var course in courses) {
      if (_finalGrades[studentId]?[course.courseCode] == null) return false;
    }
    return true;
  }

  bool _isClassReadyToPublish(String kelas) {
    final students = UserData.getStudentsByKelas(kelas);
    for (var student in students) {
      if (!_isStudentComplete(student.id, kelas)) return false;
    }
    return true;
  }

  int _countIncomplete(String kelas) {
    int count = 0;
    final students = UserData.getStudentsByKelas(kelas);
    final courses = ClassData.getCourseAssignmentsByKelas(kelas);
    for (var student in students) {
      for (var course in courses) {
        if (_finalGrades[student.id]?[course.courseCode] == null) count++;
      }
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
            labelColor: primaryBlue,
            unselectedLabelColor: Colors.grey[600],
            indicatorColor: primaryBlue,
            tabs: const [
              Tab(icon: Icon(Icons.upload), text: 'Publish KHS'),
              Tab(icon: Icon(Icons.settings), text: 'Konfigurasi'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [_buildPublishTab(), _buildConfigTab()],
          ),
        ),
      ],
    );
  }

  Widget _buildPublishTab() {
    final kelasList = UserData.getAllKelas();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: primaryBlue.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: primaryBlue, size: 20),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Nilai akhir otomatis dari input dosen. Publish hanya bisa jika semua nilai lengkap.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF1565C0)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Pilih Kelas',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 10),
          ...kelasList.map((kelas) => _buildClassCard(kelas)),
        ],
      ),
    );
  }

  Widget _buildClassCard(String kelas) {
    final studentCount = UserData.getStudentCountByKelas(kelas);
    final isPagi = UserData.isKelasPagi(kelas);
    final isReady = _isClassReadyToPublish(kelas);
    final incompleteCount = _countIncomplete(kelas);
    final statusColor = isReady ? Colors.green : Colors.grey;

    return GestureDetector(
      onTap: () => _showClassModal(kelas),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                isReady ? Icons.check_circle : Icons.pending,
                color: statusColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kelas,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${isPagi ? "Pagi" : "Malam"} • $studentCount Mahasiswa',
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isReady
                          ? Colors.green.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      isReady
                          ? '✓ Siap Publish'
                          : '$incompleteCount belum lengkap',
                      style: TextStyle(
                        fontSize: 10,
                        color: isReady ? Colors.green : Colors.grey[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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

  void _showClassModal(String kelas) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Class Modal',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return _ClassModal(
          kelas: kelas,
          finalGrades: _finalGrades,
          gradeWeights: _gradeWeights,
          isStudentComplete: _isStudentComplete,
          isClassReadyToPublish: _isClassReadyToPublish,
          getGradeLetter: _getGradeLetter,
          getGradeColor: _getGradeColor,
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

  Widget _buildConfigTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Konfigurasi Bobot',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 16),
          _buildWeightSlider('Tugas', 'tugas', Colors.blue),
          _buildWeightSlider('UTS', 'uts', Colors.purple),
          _buildWeightSlider('UAS', 'uas', Colors.green),
          _buildWeightSlider('Kehadiran', 'kehadiran', Colors.teal),
          Container(
            padding: const EdgeInsets.all(14),
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: _getTotalWeight() == 100
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _getTotalWeight() == 100 ? Colors.green : Colors.red,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getTotalWeight() == 100 ? Colors.green : Colors.red,
                  ),
                ),
                Text(
                  '${_getTotalWeight()}%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: _getTotalWeight() == 100 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () =>
                  CustomToast.success(context, 'Konfigurasi disimpan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Simpan'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightSlider(String label, String key, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: Color(0xFF333333),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${_gradeWeights[key]}%',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(
              value: (_gradeWeights[key] ?? 0).toDouble(),
              min: 0,
              max: 100,
              divisions: 20,
              activeColor: color,
              onChanged: (value) =>
                  setState(() => _gradeWeights[key] = value.round()),
            ),
          ),
        ],
      ),
    );
  }

  int _getTotalWeight() => _gradeWeights.values.fold(0, (sum, v) => sum + v);
}

// Modal matching KRS/KHS modal style
class _ClassModal extends StatefulWidget {
  final String kelas;
  final Map<String, Map<String, double?>> finalGrades;
  final Map<String, int> gradeWeights;
  final bool Function(String, String) isStudentComplete;
  final bool Function(String) isClassReadyToPublish;
  final String Function(double) getGradeLetter;
  final Color Function(String) getGradeColor;

  const _ClassModal({
    required this.kelas,
    required this.finalGrades,
    required this.gradeWeights,
    required this.isStudentComplete,
    required this.isClassReadyToPublish,
    required this.getGradeLetter,
    required this.getGradeColor,
  });

  @override
  State<_ClassModal> createState() => _ClassModalState();
}

class _ClassModalState extends State<_ClassModal> {
  static const Color primaryBlue = Color(0xFF4A90E2);
  AppUser? _selectedStudent;

  @override
  Widget build(BuildContext context) {
    final students = UserData.getStudentsByKelas(widget.kelas);
    final isReady = widget.isClassReadyToPublish(widget.kelas);

    // Matching KRS/KHS modal sizing
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
                  final isDetail = _selectedStudent != null;
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(isDetail ? 1 : -1, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
                child: _selectedStudent == null
                    ? _buildStudentList(students, isReady)
                    : _buildStudentDetail(_selectedStudent!),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStudentList(List<AppUser> students, bool isReady) {
    final courses = ClassData.getCourseAssignmentsByKelas(widget.kelas);

    return Column(
      key: const ValueKey('list'),
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header - Blue gradient like KRS/KHS
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4A90E2), Color(0xFF5B9FED)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.class_, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kelas ${widget.kelas}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${students.length} Mahasiswa',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
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

        // List
        Flexible(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            shrinkWrap: true,
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              final isComplete = widget.isStudentComplete(
                student.id,
                widget.kelas,
              );
              int completeCount = 0;
              for (var c in courses) {
                if (widget.finalGrades[student.id]?[c.courseCode] != null)
                  completeCount++;
              }

              return GestureDetector(
                onTap: () => setState(() => _selectedStudent = student),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: isComplete
                            ? Colors.green.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.1),
                        child: Text(
                          student.name[0],
                          style: TextStyle(
                            color: isComplete ? Colors.green : Colors.grey[600],
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
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
                                fontSize: 14,
                                color: Color(0xFF333333),
                              ),
                            ),
                            Text(
                              student.id,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: isComplete
                              ? Colors.green.withOpacity(0.1)
                              : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$completeCount/${courses.length}',
                          style: TextStyle(
                            fontSize: 12,
                            color: isComplete ? Colors.green : Colors.grey[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey[400],
                        size: 20,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Footer
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            border: Border(top: BorderSide(color: Colors.grey.shade200)),
          ),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isReady
                  ? () {
                      Navigator.pop(context);
                      CustomToast.success(
                        context,
                        'KHS kelas ${widget.kelas} berhasil di-publish!',
                      );
                    }
                  : null,
              icon: const Icon(Icons.upload, size: 20),
              label: Text(
                isReady ? 'Publish KHS' : 'Lengkapi Semua Nilai',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey[300],
                disabledForegroundColor: Colors.grey[500],
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStudentDetail(AppUser student) {
    final courses = ClassData.getCourseAssignmentsByKelas(widget.kelas);

    return Column(
      key: const ValueKey('detail'),
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header with Back - Blue gradient
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF4A90E2), Color(0xFF5B9FED)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => _selectedStudent = null),
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
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: Text(
                  student.name[0],
                  style: const TextStyle(
                    color: Colors.white,
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
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${student.id} • ${widget.kelas}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
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

        // Info bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: const Color(0xFFE3F2FD),
          child: Row(
            children: [
              const Icon(
                Icons.info_outline,
                size: 16,
                color: Color(0xFF1565C0),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Tugas ${widget.gradeWeights['tugas']}% + UTS ${widget.gradeWeights['uts']}% + UAS ${widget.gradeWeights['uas']}% + Hadir ${widget.gradeWeights['kehadiran']}%',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF1565C0),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Courses
        Flexible(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            shrinkWrap: true,
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              final finalScore =
                  widget.finalGrades[student.id]?[course.courseCode];
              final hasGrade = finalScore != null;
              final gradeLetter = hasGrade
                  ? widget.getGradeLetter(finalScore)
                  : '-';
              final gradeColor = hasGrade
                  ? widget.getGradeColor(gradeLetter)
                  : Colors.grey;

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        course.courseCode,
                        style: const TextStyle(
                          color: Color(0xFF1565C0),
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course.courseName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Color(0xFF333333),
                            ),
                          ),
                          Text(
                            course.lecturerName,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (hasGrade)
                      Container(
                        width: 48,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: gradeColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: gradeColor.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              gradeLetter,
                              style: TextStyle(
                                color: gradeColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              finalScore.toStringAsFixed(0),
                              style: TextStyle(fontSize: 10, color: gradeColor),
                            ),
                          ],
                        ),
                      )
                    else
                      GestureDetector(
                        onTap: () => _notifyLecturer(course),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.red.withOpacity(0.3),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.notifications_active,
                                size: 14,
                                color: Colors.red,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Kirim',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _notifyLecturer(CourseAssignment course) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.send, color: primaryBlue, size: 22),
            const SizedBox(width: 10),
            const Text(
              'Kirim Notifikasi',
              style: TextStyle(fontSize: 18, color: Color(0xFF333333)),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ingatkan dosen untuk input nilai:',
              style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.lecturerName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${course.courseCode} - ${course.courseName}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Batal',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              CustomToast.success(
                context,
                'Notifikasi terkirim ke ${course.lecturerName}',
              );
            },
            icon: const Icon(Icons.send, size: 16),
            label: const Text('Kirim', style: TextStyle(fontSize: 14)),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
