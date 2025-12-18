import 'package:flutter/material.dart';
import '../data/user_data.dart';
import '../data/class_data.dart';
import 'custom_toast.dart';

class GradeInputModal extends StatefulWidget {
  final ClassInfo classInfo;
  final List<AppUser> students;

  const GradeInputModal({
    super.key,
    required this.classInfo,
    required this.students,
  });

  static void show(BuildContext context, {required ClassInfo classInfo}) {
    final students = ClassData.getStudentsInClass(classInfo.code);
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Grade Input Modal',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return GradeInputModal(classInfo: classInfo, students: students);
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

  @override
  State<GradeInputModal> createState() => _GradeInputModalState();
}

class _GradeInputModalState extends State<GradeInputModal>
    with SingleTickerProviderStateMixin {
  static const Color primaryBlue = Color(0xFF4A90E2);
  late TabController _tabController;

  // Grade component types
  final List<Map<String, dynamic>> _gradeComponents = [
    {'name': 'Tugas', 'icon': Icons.assignment, 'weight': 20},
    {'name': 'UTS', 'icon': Icons.quiz, 'weight': 30},
    {'name': 'UAS', 'icon': Icons.school, 'weight': 40},
    {'name': 'Kehadiran', 'icon': Icons.fact_check, 'weight': 10},
  ];

  // Controllers for each component per student: {componentIndex: {studentId: controller}}
  final Map<int, Map<String, TextEditingController>> _controllers = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _gradeComponents.length,
      vsync: this,
    );

    // Initialize controllers for each component
    for (int i = 0; i < _gradeComponents.length; i++) {
      _controllers[i] = {};
      for (var student in widget.students) {
        _controllers[i]![student.id] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    for (var componentControllers in _controllers.values) {
      for (var controller in componentControllers.values) {
        controller.dispose();
      }
    }
    super.dispose();
  }

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
                _buildTabBar(),
                _buildInfoBar(),
                Flexible(
                  child: TabBarView(
                    controller: _tabController,
                    children: List.generate(
                      _gradeComponents.length,
                      (index) => _buildGradeList(index),
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
            child: const Icon(Icons.grade, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Input Nilai Komponen',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.classInfo.subject} • ${widget.classInfo.code}',
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

  Widget _buildTabBar() {
    return Container(
      color: Colors.grey[100],
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: primaryBlue,
        unselectedLabelColor: Colors.grey[600],
        indicatorColor: primaryBlue,
        indicatorWeight: 3,
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        tabs: _gradeComponents.map((component) {
          return Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(component['icon'] as IconData, size: 18),
                const SizedBox(width: 6),
                Text(component['name'] as String),
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${component['weight']}%',
                    style: const TextStyle(fontSize: 10, color: primaryBlue),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInfoBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.orange, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Nilai akhir = Tugas 20% + UTS 30% + UAS 40% + Kehadiran 10%. Grade KHS otomatis dihitung admin.',
              style: TextStyle(fontSize: 11, color: Colors.orange[800]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeList(int componentIndex) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.students.length,
      itemBuilder: (context, index) {
        return _buildStudentGradeRow(widget.students[index], componentIndex);
      },
    );
  }

  Widget _buildStudentGradeRow(AppUser student, int componentIndex) {
    final component = _gradeComponents[componentIndex];
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
            backgroundColor: primaryBlue.withOpacity(0.1),
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
            width: 80,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: TextField(
              controller: _controllers[componentIndex]![student.id],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: '0-100',
                hintStyle: TextStyle(fontSize: 11, color: Colors.grey[400]),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 10,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
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
                Navigator.pop(context);
                CustomToast.success(
                  context,
                  'Nilai ${_gradeComponents[_tabController.index]['name']} ${widget.classInfo.subject} berhasil disimpan!',
                );
              },
              icon: const Icon(Icons.save),
              label: const Text('Simpan Nilai'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
