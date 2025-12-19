import 'package:flutter/material.dart';
import '../shared/data/class_data.dart';
import '../shared/data/user_data.dart';
import '../shared/widgets/custom_toast.dart';

class CourseManagement extends StatefulWidget {
  const CourseManagement({super.key});

  @override
  State<CourseManagement> createState() => _CourseManagementState();
}

class _CourseManagementState extends State<CourseManagement> {
  static const Color primaryBlue = Color(0xFF4A90E2);
  String _searchQuery = '';

  // Master mata kuliah (unique courses)
  final List<Map<String, dynamic>> _masterCourses = [
    {
      'code': 'IF501',
      'name': 'Matematika Diskrit',
      'sks': 3,
      'type': 'Wajib',
      'semester': 5,
    },
    {
      'code': 'IF502',
      'name': 'Pemrograman Web I',
      'sks': 3,
      'type': 'Wajib',
      'semester': 5,
    },
    {
      'code': 'IF503',
      'name': 'Basis Data Lanjut',
      'sks': 3,
      'type': 'Wajib',
      'semester': 5,
    },
    {
      'code': 'IF504',
      'name': 'Jaringan Komputer',
      'sks': 3,
      'type': 'Wajib',
      'semester': 5,
    },
    {
      'code': 'IF505',
      'name': 'Rekayasa Perangkat Lunak',
      'sks': 3,
      'type': 'Wajib',
      'semester': 5,
    },
    {
      'code': 'IF506',
      'name': 'Desain Grafis',
      'sks': 3,
      'type': 'Wajib',
      'semester': 5,
    },
    {
      'code': 'IF507',
      'name': 'Statistika dan Probabilitas',
      'sks': 3,
      'type': 'Wajib',
      'semester': 5,
    },
    {
      'code': 'IF508',
      'name': 'Kecerdasan Buatan',
      'sks': 3,
      'type': 'Pilihan',
      'semester': 5,
    },
    {
      'code': 'IF301',
      'name': 'Algoritma Pemrograman',
      'sks': 3,
      'type': 'Wajib',
      'semester': 3,
    },
    {
      'code': 'IF302',
      'name': 'Struktur Data',
      'sks': 3,
      'type': 'Wajib',
      'semester': 3,
    },
  ];

  List<Map<String, dynamic>> get _filteredCourses {
    if (_searchQuery.isEmpty) return _masterCourses;
    return _masterCourses
        .where(
          (c) =>
              c['name'].toString().toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              c['code'].toString().toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: TextField(
            onChanged: (value) => setState(() => _searchQuery = value),
            decoration: InputDecoration(
              hintText: 'Cari mata kuliah (nama/kode)...',
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
              prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),

        // Stats Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: Colors.orange.withOpacity(0.1),
          child: Row(
            children: [
              const Icon(Icons.info_outline, size: 18, color: Colors.orange),
              const SizedBox(width: 8),
              Text(
                'Menampilkan ${_filteredCourses.length} mata kuliah',
                style: const TextStyle(fontSize: 13, color: Colors.orange),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => _showAddCourseModal(),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Tambah'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Course List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _filteredCourses.length,
            itemBuilder: (context, index) {
              return _buildCourseCard(_filteredCourses[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCourseCard(Map<String, dynamic> course) {
    final isWajib = course['type'] == 'Wajib';

    return Container(
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
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: (isWajib ? Colors.orange : Colors.purple).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '${course['sks']}',
                style: TextStyle(
                  color: isWajib ? Colors.orange : Colors.purple,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        course['code'],
                        style: const TextStyle(
                          fontSize: 11,
                          color: primaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: (isWajib ? Colors.orange : Colors.purple)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        course['type'],
                        style: TextStyle(
                          fontSize: 10,
                          color: isWajib ? Colors.orange : Colors.purple,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  course['name'],
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Semester ${course['semester']} • ${course['sks']} SKS',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.grey[400]),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  _showEditCourseModal(course);
                  break;
                case 'assign':
                  _showAssignToClassModal(course);
                  break;
                case 'delete':
                  _confirmDelete(course);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 18),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'assign',
                child: Row(
                  children: [
                    Icon(Icons.class_, size: 18),
                    SizedBox(width: 8),
                    Text('Assign ke Kelas'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 18, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Hapus', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddCourseModal() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Center(
        child: _CourseFormModal(
          title: 'Tambah Mata Kuliah',
          onSave: (data) {
            CustomToast.success(context, 'Mata kuliah berhasil ditambahkan');
          },
        ),
      ),
    );
  }

  void _showEditCourseModal(Map<String, dynamic> course) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Center(
        child: _CourseFormModal(
          title: 'Edit Mata Kuliah',
          course: course,
          onSave: (data) {
            CustomToast.success(context, 'Mata kuliah berhasil diupdate');
          },
        ),
      ),
    );
  }

  void _showAssignToClassModal(Map<String, dynamic> course) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AssignCourseModal(course: course),
    );
  }

  void _confirmDelete(Map<String, dynamic> course) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Mata Kuliah?'),
        content: Text('Anda yakin ingin menghapus ${course['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              CustomToast.success(context, 'Mata kuliah berhasil dihapus');
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
}

// Course Form Modal
class _CourseFormModal extends StatefulWidget {
  final String title;
  final Map<String, dynamic>? course;
  final Function(Map<String, dynamic>) onSave;

  const _CourseFormModal({
    required this.title,
    this.course,
    required this.onSave,
  });

  @override
  State<_CourseFormModal> createState() => _CourseFormModalState();
}

class _CourseFormModalState extends State<_CourseFormModal> {
  late TextEditingController _codeController;
  late TextEditingController _nameController;
  int _sks = 3;
  String _type = 'Wajib';
  int _semester = 5;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: widget.course?['code'] ?? '');
    _nameController = TextEditingController(text: widget.course?['name'] ?? '');
    _sks = widget.course?['sks'] ?? 3;
    _type = widget.course?['type'] ?? 'Wajib';
    _semester = widget.course?['semester'] ?? 5;
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 420, maxHeight: 550),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange, Color(0xFFFFA726)],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
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
                    child: Icon(
                      widget.course == null ? Icons.add : Icons.edit,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          widget.course == null
                              ? 'Isi data mata kuliah baru'
                              : 'Perbarui data mata kuliah',
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
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField('Kode Mata Kuliah', _codeController),
                    const SizedBox(height: 16),
                    _buildTextField('Nama Mata Kuliah', _nameController),
                    const SizedBox(height: 16),

                    // SKS
                    const Text(
                      'SKS',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [1, 2, 3, 4]
                          .map(
                            (sks) => GestureDetector(
                              onTap: () => setState(() => _sks = sks),
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: _sks == sks
                                      ? Colors.orange
                                      : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    '$sks',
                                    style: TextStyle(
                                      color: _sks == sks
                                          ? Colors.white
                                          : Colors.grey[700],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 16),

                    // Type
                    const Text(
                      'Tipe',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: ['Wajib', 'Pilihan']
                          .map(
                            (type) => Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _type = type),
                                child: Container(
                                  margin: EdgeInsets.only(
                                    right: type == 'Wajib' ? 8 : 0,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _type == type
                                        ? (type == 'Wajib'
                                              ? Colors.orange
                                              : Colors.purple)
                                        : Colors.grey[100],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      type,
                                      style: TextStyle(
                                        color: _type == type
                                            ? Colors.white
                                            : Colors.grey[700],
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 16),

                    // Semester
                    const Text(
                      'Semester',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          isExpanded: true,
                          value: _semester,
                          items: [1, 2, 3, 4, 5, 6, 7, 8]
                              .map(
                                (s) => DropdownMenuItem(
                                  value: s,
                                  child: Text('Semester $s'),
                                ),
                              )
                              .toList(),
                          onChanged: (value) =>
                              setState(() => _semester = value!),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey[200]!)),
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onSave({
                      'code': _codeController.text,
                      'name': _nameController.text,
                      'sks': _sks,
                      'type': _type,
                      'semester': _semester,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Simpan', style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
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
}

// Assign Course to Class Modal
class _AssignCourseModal extends StatefulWidget {
  final Map<String, dynamic> course;

  const _AssignCourseModal({required this.course});

  @override
  State<_AssignCourseModal> createState() => _AssignCourseModalState();
}

class _AssignCourseModalState extends State<_AssignCourseModal> {
  static const Color primaryBlue = Color(0xFF4A90E2);
  String _selectedKelas = 'IM23C';
  String _selectedDosen = '198712202015042001';
  String _selectedHari = 'Senin';
  final _jamMulaiController = TextEditingController(text: '10:30');
  final _jamSelesaiController = TextEditingController(text: '13:00');
  final _ruanganController = TextEditingController(text: 'B3.2');

  @override
  void dispose() {
    _jamMulaiController.dispose();
    _jamSelesaiController.dispose();
    _ruanganController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lecturers = UserData.getAllLecturers();

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4A90E2), Color(0xFF5BA3F5)],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
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
                  child: const Icon(Icons.class_, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Assign ke Kelas',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${widget.course['code']} - ${widget.course['name']}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kelas
                  const Text(
                    'Kelas',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
                        value: _selectedKelas,
                        items: UserData.getAllKelas()
                            .map(
                              (k) => DropdownMenuItem(value: k, child: Text(k)),
                            )
                            .toList(),
                        onChanged: (value) =>
                            setState(() => _selectedKelas = value!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Dosen
                  const Text(
                    'Dosen Pengampu',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
                        value: _selectedDosen,
                        items: lecturers
                            .map(
                              (l) => DropdownMenuItem(
                                value: l.id,
                                child: Text(l.name),
                              ),
                            )
                            .toList(),
                        onChanged: (value) =>
                            setState(() => _selectedDosen = value!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Hari
                  const Text(
                    'Hari',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu']
                              .map(
                                (hari) => GestureDetector(
                                  onTap: () =>
                                      setState(() => _selectedHari = hari),
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _selectedHari == hari
                                          ? primaryBlue
                                          : Colors.grey[100],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      hari,
                                      style: TextStyle(
                                        color: _selectedHari == hari
                                            ? Colors.white
                                            : Colors.grey[700],
                                        fontWeight: _selectedHari == hari
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Jam
                  const Text(
                    'Jam',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _jamMulaiController,
                          decoration: InputDecoration(
                            hintText: 'Mulai',
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('-', style: TextStyle(fontSize: 20)),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _jamSelesaiController,
                          decoration: InputDecoration(
                            hintText: 'Selesai',
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Ruangan
                  const Text(
                    'Ruangan',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _ruanganController,
                    decoration: InputDecoration(
                      hintText: 'Contoh: B3.2',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Footer
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Find lecturer name
                  final lecturers = UserData.getAllLecturers();
                  final lecturer = lecturers.firstWhere(
                    (l) => l.id == _selectedDosen,
                    orElse: () => lecturers.first,
                  );

                  // Create new assignment
                  final assignment = CourseAssignment(
                    courseCode: widget.course['code'],
                    courseName: widget.course['name'],
                    kelasCode: _selectedKelas,
                    lecturerId: _selectedDosen,
                    lecturerName: lecturer.name,
                    day: _selectedHari,
                    time:
                        '${_jamMulaiController.text} - ${_jamSelesaiController.text}',
                    room: _ruanganController.text,
                    sks: widget.course['sks'] ?? 3,
                  );

                  // Add to ClassData
                  ClassData.addCourseAssignment(assignment);

                  Navigator.pop(context);
                  CustomToast.success(
                    context,
                    '${widget.course['name']} berhasil di-assign ke $_selectedKelas',
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Simpan Assignment',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


