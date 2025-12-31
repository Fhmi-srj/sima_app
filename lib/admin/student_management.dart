import 'package:flutter/material.dart';
import '../shared/data/user_data.dart';
import '../shared/widgets/custom_toast.dart';

class StudentManagement extends StatefulWidget {
  const StudentManagement({super.key});

  @override
  State<StudentManagement> createState() => _StudentManagementState();
}

class _StudentManagementState extends State<StudentManagement> {
  static const Color primaryBlue = Color(0xFF4A90E2);
  String _searchQuery = '';
  String _selectedKelas = 'Semua';

  List<AppUser> get _filteredStudents {
    var students = UserData.getAllStudents();

    if (_selectedKelas != 'Semua') {
      students = students.where((s) => s.kelas == _selectedKelas).toList();
    }

    if (_searchQuery.isNotEmpty) {
      students = students
          .where(
            (s) =>
                s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                s.id.contains(_searchQuery),
          )
          .toList();
    }

    return students;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search & Filter Bar
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            children: [
              // Search Field
              TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: 'Cari mahasiswa (nama/NIM)...',
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
              const SizedBox(height: 12),
              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('Semua'),
                    ...UserData.getAllKelas().map((k) => _buildFilterChip(k)),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Stats Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: primaryBlue.withOpacity(0.1),
          child: Row(
            children: [
              Icon(Icons.info_outline, size: 18, color: primaryBlue),
              const SizedBox(width: 8),
              Text(
                'Menampilkan ${_filteredStudents.length} mahasiswa',
                style: TextStyle(fontSize: 13, color: primaryBlue),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => _showAddStudentModal(),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Tambah'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
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

        // Student List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _filteredStudents.length,
            itemBuilder: (context, index) {
              return _buildStudentCard(_filteredStudents[index]);
            },
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryBlue : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildStudentCard(AppUser student) {
    return GestureDetector(
      onTap: () => _showStudentCrudModal(student),
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
            CircleAvatar(
              radius: 24,
              backgroundColor: primaryBlue.withOpacity(0.1),
              child: Text(
                student.name[0],
                style: const TextStyle(
                  color: primaryBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
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
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'NIM: ${student.id}',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
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
                          student.kelas ?? '-',
                          style: const TextStyle(
                            fontSize: 11,
                            color: primaryBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        student.prodi,
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  void _showStudentCrudModal(AppUser student) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Center(
        child: _StudentFormModal(
          title: 'Detail Mahasiswa',
          student: student,
          isEdit: true,
          onSave: (data) {
            setState(() {});
            CustomToast.success(context, 'Data mahasiswa berhasil diupdate');
          },
          onDelete: () {
            setState(() {});
            CustomToast.success(context, 'Mahasiswa berhasil dihapus');
          },
        ),
      ),
    );
  }

  void _showAddStudentModal() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Center(
        child: _StudentFormModal(
          title: 'Tambah Mahasiswa',
          isEdit: false,
          onSave: (data) {
            setState(() {});
            CustomToast.success(context, 'Mahasiswa berhasil ditambahkan');
          },
        ),
      ),
    );
  }
}

// Student Form Modal - for both add and edit
class _StudentFormModal extends StatefulWidget {
  final String title;
  final AppUser? student;
  final bool isEdit;
  final Function(Map<String, String>) onSave;
  final VoidCallback? onDelete;

  const _StudentFormModal({
    required this.title,
    this.student,
    required this.isEdit,
    required this.onSave,
    this.onDelete,
  });

  @override
  State<_StudentFormModal> createState() => _StudentFormModalState();
}

class _StudentFormModalState extends State<_StudentFormModal> {
  static const Color primaryBlue = Color(0xFF4A90E2);

  late TextEditingController _nimController;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _teleponController;
  late TextEditingController _prodiController;
  late TextEditingController _fakultasController;
  late TextEditingController _institusiController;
  late TextEditingController _angkatanController;
  late TextEditingController _alamatController;
  late TextEditingController _passwordController;
  String _selectedKelas = 'IM23A';
  String _selectedGender = 'Laki-laki';
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    _nimController = TextEditingController(text: widget.student?.id ?? '');
    _nameController = TextEditingController(text: widget.student?.name ?? '');
    _emailController = TextEditingController(text: widget.student?.email ?? '');
    _teleponController = TextEditingController(text: '081234567890');
    _prodiController = TextEditingController(
      text: widget.student?.prodi ?? 'Informatika',
    );
    _fakultasController = TextEditingController(
      text: widget.student?.faculty ?? 'Fakultas Teknik',
    );
    _institusiController = TextEditingController(
      text: widget.student?.institusi ?? 'Institut Teknologi Pekalongan',
    );
    _angkatanController = TextEditingController(
      text: widget.student?.year ?? '2023',
    );
    _alamatController = TextEditingController(
      text: 'Jl. Patriot No. 123, Pekalongan',
    );
    _passwordController = TextEditingController(
      text: widget.isEdit ? '' : 'sima123',
    );
    _selectedKelas = widget.student?.kelas ?? 'IM23A';
  }

  @override
  void dispose() {
    _nimController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _teleponController.dispose();
    _prodiController.dispose();
    _fakultasController.dispose();
    _institusiController.dispose();
    _angkatanController.dispose();
    _alamatController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.92,
        constraints: BoxConstraints(
          maxWidth: 450,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
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
                    child: Icon(
                      widget.isEdit ? Icons.edit : Icons.person_add,
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
                          widget.isEdit
                              ? 'Edit semua data mahasiswa'
                              : 'Isi semua data mahasiswa baru',
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
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Informasi Pribadi
                    _buildSectionHeader('Informasi Pribadi', Icons.person),
                    const SizedBox(height: 12),
                    _buildTextField('NIM', _nimController, Icons.badge),
                    const SizedBox(height: 12),
                    _buildTextField(
                      'Nama Lengkap',
                      _nameController,
                      Icons.person_outline,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      'Email',
                      _emailController,
                      Icons.email_outlined,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      'Nomor Telepon',
                      _teleponController,
                      Icons.phone_outlined,
                    ),
                    const SizedBox(height: 12),
                    _buildGenderSelector(),
                    const SizedBox(height: 20),

                    // Informasi Akademik
                    _buildSectionHeader('Informasi Akademik', Icons.school),
                    const SizedBox(height: 12),
                    _buildDropdownField('Kelas'),
                    const SizedBox(height: 12),
                    _buildTextField(
                      'Program Studi',
                      _prodiController,
                      Icons.school_outlined,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      'Fakultas',
                      _fakultasController,
                      Icons.domain_outlined,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      'Institusi',
                      _institusiController,
                      Icons.business_outlined,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      'Angkatan',
                      _angkatanController,
                      Icons.calendar_today_outlined,
                    ),
                    const SizedBox(height: 12),
                    _buildTextField(
                      'Alamat',
                      _alamatController,
                      Icons.location_on_outlined,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 20),

                    // Keamanan
                    _buildSectionHeader('Keamanan', Icons.lock_outline),
                    const SizedBox(height: 12),
                    _buildPasswordField(),
                    if (widget.isEdit)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Kosongkan jika tidak ingin mengubah password',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Footer with buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey[200]!)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  if (widget.isEdit && widget.onDelete != null)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _confirmDelete(),
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: 18,
                        ),
                        label: const Text('Hapus'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  if (widget.isEdit && widget.onDelete != null)
                    const SizedBox(width: 12),
                  Expanded(
                    flex: widget.isEdit ? 2 : 1,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        widget.onSave({
                          'nim': _nimController.text,
                          'name': _nameController.text,
                          'email': _emailController.text,
                          'telepon': _teleponController.text,
                          'gender': _selectedGender,
                          'kelas': _selectedKelas,
                          'prodi': _prodiController.text,
                          'fakultas': _fakultasController.text,
                          'institusi': _institusiController.text,
                          'angkatan': _angkatanController.text,
                          'alamat': _alamatController.text,
                          'password': _passwordController.text,
                        });
                      },
                      icon: const Icon(Icons.save, size: 18),
                      label: const Text('Simpan'),
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
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: primaryBlue, size: 16),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 13, color: Colors.grey[600]),
        prefixIcon: Icon(icon, color: Colors.grey[400], size: 20),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: _selectedKelas,
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[400]),
          style: const TextStyle(fontSize: 14, color: Colors.black87),
          items: UserData.getAllKelas().map((k) {
            return DropdownMenuItem(value: k, child: Text(k));
          }).toList(),
          onChanged: (value) {
            setState(() => _selectedKelas = value!);
          },
        ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedGender = 'Laki-laki'),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: _selectedGender == 'Laki-laki'
                    ? primaryBlue
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _selectedGender == 'Laki-laki'
                      ? primaryBlue
                      : Colors.grey[300]!,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.male,
                    color: _selectedGender == 'Laki-laki'
                        ? Colors.white
                        : Colors.grey[600],
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Laki-laki',
                    style: TextStyle(
                      color: _selectedGender == 'Laki-laki'
                          ? Colors.white
                          : Colors.grey[600],
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedGender = 'Perempuan'),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: _selectedGender == 'Perempuan'
                    ? primaryBlue
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _selectedGender == 'Perempuan'
                      ? primaryBlue
                      : Colors.grey[300]!,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.female,
                    color: _selectedGender == 'Perempuan'
                        ? Colors.white
                        : Colors.grey[600],
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Perempuan',
                    style: TextStyle(
                      color: _selectedGender == 'Perempuan'
                          ? Colors.white
                          : Colors.grey[600],
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: !_showPassword,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: widget.isEdit ? 'Password Baru' : 'Password',
        labelStyle: TextStyle(fontSize: 13, color: Colors.grey[600]),
        prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[400], size: 20),
        suffixIcon: IconButton(
          icon: Icon(
            _showPassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey[400],
            size: 20,
          ),
          onPressed: () => setState(() => _showPassword = !_showPassword),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
      ),
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Mahasiswa?'),
        content: Text(
          'Anda yakin ingin menghapus ${widget.student?.name}?\n\nTindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close modal
              widget.onDelete?.call();
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
