import 'package:flutter/material.dart';
import '../data/user_data.dart';
import '../widgets/custom_toast.dart';

class LecturerManagement extends StatefulWidget {
  const LecturerManagement({super.key});

  @override
  State<LecturerManagement> createState() => _LecturerManagementState();
}

class _LecturerManagementState extends State<LecturerManagement> {
  static const Color primaryBlue = Color(0xFF4A90E2);
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
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.grey[400]),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (value) {
              switch (value) {
                case 'view':
                  _showLecturerDetail(lecturer);
                  break;
                case 'edit':
                  _showEditLecturerModal(lecturer);
                  break;
                case 'assign':
                  _showAssignCoursesModal(lecturer);
                  break;
                case 'delete':
                  _confirmDelete(lecturer);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'view',
                child: Row(
                  children: [
                    Icon(Icons.visibility, size: 18),
                    SizedBox(width: 8),
                    Text('Lihat Detail'),
                  ],
                ),
              ),
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
                    Icon(Icons.book, size: 18),
                    SizedBox(width: 8),
                    Text('Assign Mata Kuliah'),
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

  void _showAddLecturerModal() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Center(
        child: _LecturerFormModal(
          title: 'Tambah Dosen',
          onSave: (data) {
            CustomToast.success(context, 'Dosen berhasil ditambahkan');
          },
        ),
      ),
    );
  }

  void _showEditLecturerModal(AppUser lecturer) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Center(
        child: _LecturerFormModal(
          title: 'Edit Dosen',
          lecturer: lecturer,
          onSave: (data) {
            CustomToast.success(context, 'Data dosen berhasil diupdate');
          },
        ),
      ),
    );
  }

  void _showLecturerDetail(AppUser lecturer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _LecturerDetailModal(lecturer: lecturer),
    );
  }

  void _showAssignCoursesModal(AppUser lecturer) {
    CustomToast.info(context, 'Fitur assign mata kuliah - Coming Soon');
  }

  void _confirmDelete(AppUser lecturer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Dosen?'),
        content: Text('Anda yakin ingin menghapus ${lecturer.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              CustomToast.success(context, 'Dosen berhasil dihapus');
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

// Lecturer Form Modal
class _LecturerFormModal extends StatefulWidget {
  final String title;
  final AppUser? lecturer;
  final Function(Map<String, String>) onSave;

  const _LecturerFormModal({
    required this.title,
    this.lecturer,
    required this.onSave,
  });

  @override
  State<_LecturerFormModal> createState() => _LecturerFormModalState();
}

class _LecturerFormModalState extends State<_LecturerFormModal> {
  static const Color primaryGreen = Colors.green;
  late TextEditingController _nipController;
  late TextEditingController _nameController;
  late TextEditingController _prodiController;

  @override
  void initState() {
    super.initState();
    _nipController = TextEditingController(text: widget.lecturer?.id ?? '');
    _nameController = TextEditingController(text: widget.lecturer?.name ?? '');
    _prodiController = TextEditingController(
      text: widget.lecturer?.prodi ?? 'Informatika',
    );
  }

  @override
  void dispose() {
    _nipController.dispose();
    _nameController.dispose();
    _prodiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 400, maxHeight: 500),
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
                      widget.lecturer == null ? Icons.person_add : Icons.edit,
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
                          widget.lecturer == null
                              ? 'Isi data dosen baru'
                              : 'Perbarui data dosen',
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
                    _buildTextField('NIP', _nipController, Icons.badge),
                    const SizedBox(height: 16),
                    _buildTextField(
                      'Nama Lengkap',
                      _nameController,
                      Icons.person,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      'Bidang Keahlian',
                      _prodiController,
                      Icons.work,
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
                      'nip': _nipController.text,
                      'name': _nameController.text,
                      'prodi': _prodiController.text,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
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
}

// Lecturer Detail Modal
class _LecturerDetailModal extends StatelessWidget {
  final AppUser lecturer;

  const _LecturerDetailModal({required this.lecturer});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
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
                colors: [Colors.green, Color(0xFF66BB6A)],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: Text(
                    lecturer.name[0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
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
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'NIP: ${lecturer.id}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
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

          // Details
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildDetailRow('Bidang Keahlian', lecturer.prodi),
                  _buildDetailRow('Fakultas', lecturer.faculty ?? '-'),
                  _buildDetailRow('Email', lecturer.email),
                  _buildDetailRow('Institusi', lecturer.institusi),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
