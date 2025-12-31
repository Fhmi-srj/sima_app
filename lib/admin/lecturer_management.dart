import 'package:flutter/material.dart';
import '../shared/data/user_data.dart';
import '../shared/widgets/custom_toast.dart';

class LecturerManagement extends StatefulWidget {
  const LecturerManagement({super.key});

  @override
  State<LecturerManagement> createState() => _LecturerManagementState();
}

class _LecturerManagementState extends State<LecturerManagement> {
  static const Color primaryGreen = Colors.green;
  String _searchQuery = '';

  List<AppUser> get _filteredLecturers {
    var lecturers = UserData.getAllLecturers();

    if (_searchQuery.isNotEmpty) {
      lecturers = lecturers
          .where(
            (l) =>
                l.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                l.id.contains(_searchQuery),
          )
          .toList();
    }

    return lecturers;
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
              hintText: 'Cari dosen (nama/NIP)...',
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
          color: Colors.green.withOpacity(0.1),
          child: Row(
            children: [
              const Icon(Icons.info_outline, size: 18, color: Colors.green),
              const SizedBox(width: 8),
              Text(
                'Menampilkan ${_filteredLecturers.length} dosen',
                style: const TextStyle(fontSize: 13, color: Colors.green),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => _showAddLecturerModal(),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Tambah'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
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

        // Lecturer List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _filteredLecturers.length,
            itemBuilder: (context, index) {
              return _buildLecturerCard(_filteredLecturers[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLecturerCard(AppUser lecturer) {
    return GestureDetector(
      onTap: () => _showLecturerCrudModal(lecturer),
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
              backgroundColor: Colors.green.withOpacity(0.1),
              child: Text(
                lecturer.name[0],
                style: const TextStyle(
                  color: Colors.green,
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
                    lecturer.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'NIP: ${lecturer.id}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          lecturer.prodi,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        lecturer.faculty ?? '',
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

  void _showLecturerCrudModal(AppUser lecturer) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Center(
        child: _LecturerFormModal(
          title: 'Detail Dosen',
          lecturer: lecturer,
          isEdit: true,
          onSave: (data) {
            setState(() {});
            CustomToast.success(context, 'Data dosen berhasil diupdate');
          },
          onDelete: () {
            setState(() {});
            CustomToast.success(context, 'Dosen berhasil dihapus');
          },
        ),
      ),
    );
  }

  void _showAddLecturerModal() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Center(
        child: _LecturerFormModal(
          title: 'Tambah Dosen',
          isEdit: false,
          onSave: (data) {
            setState(() {});
            CustomToast.success(context, 'Dosen berhasil ditambahkan');
          },
        ),
      ),
    );
  }
}

// Lecturer Form Modal - for both add and edit
class _LecturerFormModal extends StatefulWidget {
  final String title;
  final AppUser? lecturer;
  final bool isEdit;
  final Function(Map<String, String>) onSave;
  final VoidCallback? onDelete;

  const _LecturerFormModal({
    required this.title,
    this.lecturer,
    required this.isEdit,
    required this.onSave,
    this.onDelete,
  });

  @override
  State<_LecturerFormModal> createState() => _LecturerFormModalState();
}

class _LecturerFormModalState extends State<_LecturerFormModal> {
  static const Color primaryGreen = Colors.green;

  late TextEditingController _nipController;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _teleponController;
  late TextEditingController _jabatanController;
  late TextEditingController _fakultasController;
  late TextEditingController _institusiController;
  late TextEditingController _bidangController;
  late TextEditingController _alamatController;
  late TextEditingController _passwordController;
  String _selectedGender = 'Laki-laki';
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    _nipController = TextEditingController(text: widget.lecturer?.id ?? '');
    _nameController = TextEditingController(text: widget.lecturer?.name ?? '');
    _emailController = TextEditingController(
      text: widget.lecturer?.email ?? '',
    );
    _teleponController = TextEditingController(text: '081234567890');
    _jabatanController = TextEditingController(
      text: widget.lecturer?.prodi ?? 'Lektor',
    );
    _fakultasController = TextEditingController(
      text: widget.lecturer?.faculty ?? 'Fakultas Teknik',
    );
    _institusiController = TextEditingController(
      text: widget.lecturer?.institusi ?? 'Institut Teknologi Pekalongan',
    );
    _bidangController = TextEditingController(text: 'Sistem Informasi');
    _alamatController = TextEditingController(
      text: 'Jl. Patriot No. 123, Pekalongan',
    );
    _passwordController = TextEditingController(
      text: widget.isEdit ? '' : 'sima123',
    );
  }

  @override
  void dispose() {
    _nipController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _teleponController.dispose();
    _jabatanController.dispose();
    _fakultasController.dispose();
    _institusiController.dispose();
    _bidangController.dispose();
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
                  colors: [Colors.green, Color(0xFF66BB6A)],
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
                              ? 'Edit semua data dosen'
                              : 'Isi semua data dosen baru',
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
                    _buildTextField('NIP', _nipController, Icons.badge),
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

                    // Informasi Dosen
                    _buildSectionHeader('Informasi Dosen', Icons.school),
                    const SizedBox(height: 12),
                    _buildTextField(
                      'Jabatan Fungsional',
                      _jabatanController,
                      Icons.military_tech,
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
                      'Bidang Keahlian',
                      _bidangController,
                      Icons.psychology,
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
                          'nip': _nipController.text,
                          'name': _nameController.text,
                          'email': _emailController.text,
                          'telepon': _teleponController.text,
                          'gender': _selectedGender,
                          'jabatan': _jabatanController.text,
                          'fakultas': _fakultasController.text,
                          'institusi': _institusiController.text,
                          'bidang': _bidangController.text,
                          'alamat': _alamatController.text,
                          'password': _passwordController.text,
                        });
                      },
                      icon: const Icon(Icons.save, size: 18),
                      label: const Text('Simpan'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
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
            color: primaryGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: primaryGreen, size: 16),
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
          borderSide: const BorderSide(color: primaryGreen, width: 2),
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
                    ? primaryGreen
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _selectedGender == 'Laki-laki'
                      ? primaryGreen
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
                    ? primaryGreen
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _selectedGender == 'Perempuan'
                      ? primaryGreen
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
          borderSide: const BorderSide(color: primaryGreen, width: 2),
        ),
      ),
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Dosen?'),
        content: Text(
          'Anda yakin ingin menghapus ${widget.lecturer?.name}?\n\nTindakan ini tidak dapat dibatalkan.',
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
