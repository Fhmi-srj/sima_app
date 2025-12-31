import 'package:flutter/material.dart';
import '../shared/widgets/custom_toast.dart';
import '../shared/data/user_data.dart';
import '../login_page.dart';

class ProfilePageContent extends StatefulWidget {
  final VoidCallback? onNavigateToSettings;
  final VoidCallback? onNavigateToCertificate;
  final String userName;
  final String userNim;
  final String userProdi;
  final String userInstitusi;
  final String userAngkatan;
  final String userFakultas;
  final bool isLecturer;
  final Function({
    String? nama,
    String? nim,
    String? prodi,
    String? institusi,
    String? angkatan,
    String? fakultas,
  })?
  onUpdateProfile;

  const ProfilePageContent({
    super.key,
    this.onNavigateToSettings,
    this.onNavigateToCertificate,
    required this.userName,
    required this.userNim,
    required this.userProdi,
    required this.userInstitusi,
    required this.userAngkatan,
    this.userFakultas = 'SAINTEK',
    this.isLecturer = false,
    this.onUpdateProfile,
  });

  @override
  State<ProfilePageContent> createState() => _ProfilePageContentState();
}

class _ProfilePageContentState extends State<ProfilePageContent>
    with SingleTickerProviderStateMixin {
  static const Color primaryBlue = Color(0xFF4A90E2);

  late TabController _tabController;

  // Controllers for personal info
  late final TextEditingController _namaController;
  late final TextEditingController _nimController;
  late final TextEditingController _prodiController;
  late final TextEditingController _institusiController;
  late final TextEditingController _angkatanController;
  late final TextEditingController _fakultasController;
  final TextEditingController _teleponController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();

  // Controllers for password
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  String _selectedGender = 'Laki-laki';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _namaController = TextEditingController(text: widget.userName);
    _nimController = TextEditingController(text: widget.userNim);
    _prodiController = TextEditingController(text: widget.userProdi);
    _institusiController = TextEditingController(text: widget.userInstitusi);
    _angkatanController = TextEditingController(text: widget.userAngkatan);
    _fakultasController = TextEditingController(text: widget.userFakultas);
    _loadDemoData();
  }

  void _loadDemoData() {
    final user = UserData.currentUser;
    if (user != null) {
      _emailController.text = user.email;
      _teleponController.text = '081234567890';
      _alamatController.text = 'Jl. Patriot No. 123, Pekalongan';
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _namaController.dispose();
    _nimController.dispose();
    _prodiController.dispose();
    _institusiController.dispose();
    _angkatanController.dispose();
    _fakultasController.dispose();
    _teleponController.dispose();
    _emailController.dispose();
    _alamatController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.logout, color: primaryBlue),
            SizedBox(width: 8),
            Text('Konfirmasi Keluar'),
          ],
        ),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              UserData.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  String get _roleLabel => widget.isLecturer ? 'Dosen' : 'Mahasiswa';
  IconData get _roleIcon => widget.isLecturer ? Icons.school : Icons.person;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      child: Column(
        children: [
          // Sticky Header with Profile Photo
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryBlue, Color(0xFF5BA3F5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // Top Bar with Settings
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'SIMA',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.notifications,
                              color: Colors.white,
                              size: 24,
                            ),
                            const SizedBox(width: 16),
                            GestureDetector(
                              onTap: widget.onNavigateToSettings,
                              child: const Icon(
                                Icons.settings,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Profile Avatar
                  Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.5),
                            width: 3,
                          ),
                        ),
                        child: Icon(_roleIcon, size: 60, color: Colors.white),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 18,
                            color: primaryBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Edit Foto Button
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.edit, size: 14, color: Colors.white),
                        SizedBox(width: 6),
                        Text(
                          'Edit Foto',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // User Name and ID
                  Text(
                    _namaController.text,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _nimController.text,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Role Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _roleLabel.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Sticky Tab Bar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: primaryBlue,
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: primaryBlue,
              indicatorWeight: 3,
              tabs: const [
                Tab(
                  icon: Icon(Icons.person_outline, size: 20),
                  text: 'Identitas',
                ),
                Tab(
                  icon: Icon(Icons.security_outlined, size: 20),
                  text: 'Keamanan',
                ),
                Tab(
                  icon: Icon(Icons.history_outlined, size: 20),
                  text: 'Riwayat',
                ),
              ],
            ),
          ),

          // Scrollable Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildIdentityTab(),
                _buildSecurityTab(),
                _buildHistoryTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdentityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Notice about data can only be edited by admin
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.amber.shade200),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.amber.shade700,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Data profil hanya dapat diubah oleh Admin',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.amber.shade800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Sertifikat Button - Only for students
          if (!widget.isLecturer) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: widget.onNavigateToCertificate,
                icon: const Icon(Icons.verified, size: 20),
                label: const Text(
                  'Lihat Sertifikat',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Informasi Pribadi Section
          _buildSectionHeader('Informasi Pribadi', Icons.person),
          const SizedBox(height: 16),

          _buildInfoCard([
            _buildInfoRow(
              'Nama Lengkap',
              _namaController.text,
              Icons.person_outline,
            ),
            _buildInfoRow(
              widget.isLecturer ? 'NIP' : 'NIM',
              _nimController.text,
              widget.isLecturer ? Icons.work_outline : Icons.badge_outlined,
            ),
            _buildInfoRow('Email', _emailController.text, Icons.email_outlined),
            _buildInfoRow(
              'Nomor Telepon',
              _teleponController.text.isNotEmpty
                  ? _teleponController.text
                  : '-',
              Icons.phone_outlined,
            ),
            _buildInfoRow(
              'Jenis Kelamin',
              _selectedGender,
              _selectedGender == 'Laki-laki' ? Icons.male : Icons.female,
            ),
          ]),
          const SizedBox(height: 24),

          // Informasi Akademik Section
          _buildSectionHeader(
            widget.isLecturer ? 'Informasi Dosen' : 'Informasi Akademik',
            Icons.school,
          ),
          const SizedBox(height: 16),

          _buildInfoCard([
            _buildInfoRow(
              widget.isLecturer ? 'Jabatan Fungsional' : 'Program Studi',
              _prodiController.text,
              widget.isLecturer ? Icons.military_tech : Icons.school_outlined,
            ),
            _buildInfoRow(
              'Fakultas',
              _fakultasController.text,
              Icons.domain_outlined,
            ),
            _buildInfoRow(
              'Institusi',
              _institusiController.text,
              Icons.business_outlined,
            ),
            _buildInfoRow(
              widget.isLecturer ? 'Bidang Keahlian' : 'Angkatan',
              _angkatanController.text.isNotEmpty
                  ? _angkatanController.text
                  : '-',
              widget.isLecturer
                  ? Icons.psychology
                  : Icons.calendar_today_outlined,
            ),
            _buildInfoRow(
              'Alamat',
              _alamatController.text.isNotEmpty ? _alamatController.text : '-',
              Icons.location_on_outlined,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
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
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        children: [
          Icon(icon, color: primaryBlue, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ubah Password Section
          _buildSectionHeader('Ubah Password', Icons.lock),
          const SizedBox(height: 16),

          _buildPasswordField(
            label: 'Password Lama',
            controller: _oldPasswordController,
            obscure: _obscureOldPassword,
            onToggle: () {
              setState(() => _obscureOldPassword = !_obscureOldPassword);
            },
          ),
          const SizedBox(height: 16),

          _buildPasswordField(
            label: 'Password Baru',
            controller: _newPasswordController,
            obscure: _obscureNewPassword,
            onToggle: () {
              setState(() => _obscureNewPassword = !_obscureNewPassword);
            },
          ),
          const SizedBox(height: 16),

          _buildPasswordField(
            label: 'Konfirmasi Password Baru',
            controller: _confirmPasswordController,
            obscure: _obscureConfirmPassword,
            onToggle: () {
              setState(
                () => _obscureConfirmPassword = !_obscureConfirmPassword,
              );
            },
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                if (_newPasswordController.text !=
                    _confirmPasswordController.text) {
                  CustomToast.error(context, 'Password baru tidak cocok');
                  return;
                }
                if (_newPasswordController.text.isEmpty) {
                  CustomToast.warning(context, 'Masukkan password baru');
                  return;
                }
                CustomToast.success(context, 'Password berhasil diubah');
                _oldPasswordController.clear();
                _newPasswordController.clear();
                _confirmPasswordController.clear();
              },
              icon: const Icon(Icons.save, size: 18),
              label: const Text(
                'Ubah Password',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Keamanan Akun Section
          _buildSectionHeader('Keamanan Akun', Icons.security),
          const SizedBox(height: 16),

          _buildSecurityOption(
            title: 'Autentikasi Dua Faktor',
            subtitle: 'Tambahkan lapisan keamanan ekstra',
            icon: Icons.phonelink_lock,
            enabled: false,
          ),
          const SizedBox(height: 12),

          _buildSecurityOption(
            title: 'Notifikasi Login',
            subtitle: 'Dapatkan pemberitahuan saat login baru',
            icon: Icons.notifications_active,
            enabled: true,
          ),
          const SizedBox(height: 24),

          // Logout Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showLogoutDialog(context),
              icon: const Icon(Icons.logout, size: 20),
              label: const Text(
                'Keluar dari Akun',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    final activities = widget.isLecturer
        ? _getLecturerActivities()
        : _getStudentActivities();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Riwayat Aktivitas', Icons.history),
          const SizedBox(height: 16),
          ...activities,
        ],
      ),
    );
  }

  List<Widget> _getStudentActivities() {
    return [
      _buildActivityItem(
        title: 'Login berhasil',
        subtitle: 'Chrome di Windows',
        time: 'Hari ini, 08:30',
        icon: Icons.login,
        color: Colors.green,
      ),
      _buildActivityItem(
        title: 'Mengisi KRS',
        subtitle: 'Semester Ganjil 2024/2025',
        time: 'Hari ini, 09:00',
        icon: Icons.edit_document,
        color: primaryBlue,
      ),
      _buildActivityItem(
        title: 'Melihat KHS',
        subtitle: 'Semester Genap 2023/2024',
        time: 'Kemarin, 14:22',
        icon: Icons.visibility,
        color: Colors.orange,
      ),
      _buildActivityItem(
        title: 'Mengunggah sertifikat',
        subtitle: 'Sertifikat BNSP',
        time: 'Kemarin, 10:45',
        icon: Icons.upload_file,
        color: Colors.green,
      ),
      _buildActivityItem(
        title: 'Pembayaran SPP',
        subtitle: 'Semester Ganjil 2024/2025',
        time: '15 Des 2024, 11:30',
        icon: Icons.payment,
        color: primaryBlue,
      ),
      _buildActivityItem(
        title: 'Memperbarui profil',
        subtitle: 'Nomor telepon diubah',
        time: '14 Des 2024, 09:00',
        icon: Icons.person,
        color: Colors.amber,
      ),
    ];
  }

  List<Widget> _getLecturerActivities() {
    return [
      _buildActivityItem(
        title: 'Login berhasil',
        subtitle: 'Chrome di Windows',
        time: 'Hari ini, 08:30',
        icon: Icons.login,
        color: Colors.green,
      ),
      _buildActivityItem(
        title: 'Menyetujui KRS',
        subtitle: '15 mahasiswa - Kelas IM23C',
        time: 'Hari ini, 09:15',
        icon: Icons.check_circle,
        color: Colors.green,
      ),
      _buildActivityItem(
        title: 'Input nilai',
        subtitle: 'Pemrograman Web - UTS',
        time: 'Kemarin, 14:22',
        icon: Icons.grading,
        color: primaryBlue,
      ),
      _buildActivityItem(
        title: 'Melihat jadwal',
        subtitle: 'Jadwal mengajar semester ini',
        time: 'Kemarin, 10:45',
        icon: Icons.calendar_today,
        color: Colors.orange,
      ),
      _buildActivityItem(
        title: 'Konsultasi mahasiswa',
        subtitle: 'Ahmad Rizky - IM23C',
        time: '15 Des 2024, 11:30',
        icon: Icons.chat,
        color: primaryBlue,
      ),
      _buildActivityItem(
        title: 'Memperbarui profil',
        subtitle: 'Bidang keahlian diubah',
        time: '14 Des 2024, 09:00',
        icon: Icons.person,
        color: Colors.amber,
      ),
    ];
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: primaryBlue, size: 22),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[300]!, width: 1),
          ),
          child: Row(
            children: [
              const Icon(Icons.lock_outline, color: primaryBlue, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: obscure,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                    hintText: '••••••••',
                  ),
                ),
              ),
              GestureDetector(
                onTap: onToggle,
                child: Icon(
                  obscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey[400],
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool enabled,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: primaryBlue, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Switch(
            value: enabled,
            onChanged: (value) {},
            activeColor: primaryBlue,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    required String title,
    required String subtitle,
    required String time,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Text(time, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
        ],
      ),
    );
  }
}
