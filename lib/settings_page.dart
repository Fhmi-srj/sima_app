import 'package:flutter/material.dart';
import 'widgets/custom_toast.dart';
import 'data/user_data.dart';
import 'login_page.dart';

class SettingsPageContent extends StatefulWidget {
  final VoidCallback? onNavigateToProfile;
  final bool isLecturer;

  const SettingsPageContent({
    super.key,
    this.onNavigateToProfile,
    this.isLecturer = false,
  });

  @override
  State<SettingsPageContent> createState() => _SettingsPageContentState();
}

class _SettingsPageContentState extends State<SettingsPageContent> {
  static const Color primaryBlue = Color(0xFF4A90E2);

  // Settings States
  bool _darkMode = false;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _krsReminder = true;
  bool _paymentReminder = true;
  bool _scheduleReminder = true;
  bool _biometricLogin = false;
  String _selectedLanguage = 'id';

  void _showLogoutDialog() {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      child: Column(
        children: [
          // Header
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
                  // Header Row
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
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
                              onTap: widget.onNavigateToProfile,
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Title
                  const Padding(
                    padding: EdgeInsets.only(bottom: 24, top: 8),
                    child: Column(
                      children: [
                        Icon(Icons.settings, color: Colors.white, size: 40),
                        SizedBox(height: 8),
                        Text(
                          'Pengaturan',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Settings List
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Tampilan Section
                  _buildSectionCard(
                    title: 'Tampilan',
                    icon: Icons.palette,
                    children: [
                      _buildSwitchSetting(
                        label: 'Mode Gelap',
                        subtitle: 'Aktifkan tema gelap',
                        icon: Icons.dark_mode,
                        value: _darkMode,
                        onChanged: (value) {
                          setState(() => _darkMode = value);
                          CustomToast.info(
                            context,
                            value ? 'Mode gelap aktif' : 'Mode terang aktif',
                          );
                        },
                      ),
                      const Divider(height: 24),
                      _buildDropdownSetting(
                        label: 'Bahasa',
                        icon: Icons.language,
                        value: _selectedLanguage,
                        items: ['id', 'en'],
                        itemLabels: ['Bahasa Indonesia', 'English'],
                        onChanged: (value) {
                          setState(() => _selectedLanguage = value!);
                          CustomToast.info(context, 'Bahasa diubah');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Notifikasi Section
                  _buildSectionCard(
                    title: 'Notifikasi',
                    icon: Icons.notifications,
                    children: [
                      _buildSwitchSetting(
                        label: 'Notifikasi Email',
                        subtitle: 'Terima notifikasi via email',
                        icon: Icons.email,
                        value: _emailNotifications,
                        onChanged: (value) {
                          setState(() => _emailNotifications = value);
                        },
                      ),
                      const Divider(height: 24),
                      _buildSwitchSetting(
                        label: 'Push Notification',
                        subtitle: 'Notifikasi langsung di perangkat',
                        icon: Icons.phone_android,
                        value: _pushNotifications,
                        onChanged: (value) {
                          setState(() => _pushNotifications = value);
                        },
                      ),
                      const Divider(height: 24),
                      _buildSwitchSetting(
                        label: widget.isLecturer
                            ? 'Pengingat Perwalian'
                            : 'Pengingat KRS',
                        subtitle: widget.isLecturer
                            ? 'Ingatkan saat ada KRS yang perlu disetujui'
                            : 'Ingatkan saat periode pengisian KRS',
                        icon: Icons.assignment,
                        value: _krsReminder,
                        onChanged: (value) {
                          setState(() => _krsReminder = value);
                        },
                      ),
                      const Divider(height: 24),
                      _buildSwitchSetting(
                        label: widget.isLecturer
                            ? 'Pengingat Input Nilai'
                            : 'Pengingat Pembayaran',
                        subtitle: widget.isLecturer
                            ? 'Ingatkan saat periode input nilai'
                            : 'Ingatkan sebelum jatuh tempo SPP',
                        icon: widget.isLecturer ? Icons.grading : Icons.payment,
                        value: _paymentReminder,
                        onChanged: (value) {
                          setState(() => _paymentReminder = value);
                        },
                      ),
                      const Divider(height: 24),
                      _buildSwitchSetting(
                        label: 'Pengingat Jadwal',
                        subtitle: 'Ingatkan sebelum kuliah dimulai',
                        icon: Icons.schedule,
                        value: _scheduleReminder,
                        onChanged: (value) {
                          setState(() => _scheduleReminder = value);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Keamanan Section
                  _buildSectionCard(
                    title: 'Keamanan',
                    icon: Icons.security,
                    children: [
                      _buildSwitchSetting(
                        label: 'Login Biometrik',
                        subtitle: 'Gunakan sidik jari atau wajah',
                        icon: Icons.fingerprint,
                        value: _biometricLogin,
                        onChanged: (value) {
                          setState(() => _biometricLogin = value);
                          CustomToast.info(
                            context,
                            value
                                ? 'Biometrik diaktifkan'
                                : 'Biometrik dinonaktifkan',
                          );
                        },
                      ),
                      const Divider(height: 24),
                      _buildActionButton(
                        label: 'Ubah Password',
                        subtitle: 'Ganti kata sandi akun Anda',
                        icon: Icons.lock,
                        onTap: () => _showChangePasswordDialog(),
                      ),
                      const SizedBox(height: 12),
                      _buildActionButton(
                        label: 'Perangkat Terhubung',
                        subtitle: 'Kelola perangkat yang login',
                        icon: Icons.devices,
                        onTap: () => _showDevicesDialog(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Bantuan & Info Section
                  _buildSectionCard(
                    title: 'Bantuan & Informasi',
                    icon: Icons.help,
                    children: [
                      _buildActionButton(
                        label: 'Panduan Pengguna',
                        subtitle: 'Pelajari cara menggunakan aplikasi',
                        icon: Icons.menu_book,
                        onTap: () {
                          CustomToast.info(context, 'Membuka panduan...');
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildActionButton(
                        label: 'Hubungi Kami',
                        subtitle: 'Butuh bantuan? Hubungi tim support',
                        icon: Icons.support_agent,
                        onTap: () => _showContactDialog(),
                      ),
                      const SizedBox(height: 12),
                      _buildActionButton(
                        label: 'Laporkan Masalah',
                        subtitle: 'Laporkan bug atau kendala',
                        icon: Icons.bug_report,
                        onTap: () => _showReportDialog(),
                      ),
                      const SizedBox(height: 12),
                      _buildActionButton(
                        label: 'Tentang Aplikasi',
                        subtitle: 'Versi 1.0.0 • Build 2024.12.16',
                        icon: Icons.info,
                        onTap: () => _showAboutDialog(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Akun Section
                  _buildSectionCard(
                    title: 'Akun',
                    icon: Icons.person,
                    isDanger: true,
                    children: [
                      _buildDangerButton(
                        label: 'Hapus Cache',
                        icon: Icons.delete_sweep,
                        onTap: () {
                          CustomToast.success(
                            context,
                            'Cache berhasil dihapus',
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildDangerButton(
                        label: 'Keluar dari Akun',
                        icon: Icons.logout,
                        onTap: _showLogoutDialog,
                      ),
                    ],
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
    bool isDanger = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDanger ? Colors.red.withOpacity(0.3) : Colors.grey[200]!,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDanger
                  ? Colors.red.withOpacity(0.05)
                  : primaryBlue.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isDanger ? Colors.red : primaryBlue,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDanger ? Colors.red : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchSetting({
    required String label,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: primaryBlue, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
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
        Switch(value: value, onChanged: onChanged, activeColor: primaryBlue),
      ],
    );
  }

  Widget _buildDropdownSetting({
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    List<String>? itemLabels,
    required ValueChanged<String?> onChanged,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: primaryBlue, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              items: items.asMap().entries.map((entry) {
                return DropdownMenuItem(
                  value: entry.value,
                  child: Text(
                    itemLabels?[entry.key] ?? entry.value,
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: primaryBlue, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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

  Widget _buildDangerButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.red, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.red[300]),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog() {
    final oldController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.lock, color: primaryBlue),
            SizedBox(width: 8),
            Text('Ubah Password'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password Lama',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password Baru',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Konfirmasi Password',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (newController.text != confirmController.text) {
                CustomToast.error(context, 'Password tidak cocok');
                return;
              }
              Navigator.pop(context);
              CustomToast.success(context, 'Password berhasil diubah');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showDevicesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.devices, color: primaryBlue),
            SizedBox(width: 8),
            Text('Perangkat Terhubung'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDeviceItem('Android - OPPO Reno', 'Aktif sekarang', true),
            _buildDeviceItem('Chrome - Windows', '2 jam lalu', false),
            _buildDeviceItem('Safari - iPhone', '1 hari lalu', false),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceItem(String name, String time, bool isCurrent) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        name.contains('Android') ? Icons.phone_android : Icons.computer,
        color: primaryBlue,
      ),
      title: Text(name),
      subtitle: Text(time),
      trailing: isCurrent
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Aktif',
                style: TextStyle(color: Colors.green, fontSize: 12),
              ),
            )
          : TextButton(
              onPressed: () {
                Navigator.pop(context);
                CustomToast.success(context, 'Perangkat dikeluarkan');
              },
              child: const Text('Keluar', style: TextStyle(color: Colors.red)),
            ),
    );
  }

  void _showContactDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.support_agent, color: primaryBlue),
            SizedBox(width: 8),
            Text('Hubungi Kami'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildContactItem(Icons.email, 'support@sima.ac.id'),
            const SizedBox(height: 12),
            _buildContactItem(Icons.phone, '+62 285 123456'),
            const SizedBox(height: 12),
            _buildContactItem(Icons.location_on, 'Gedung IT Lt. 2'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: primaryBlue, size: 20),
        const SizedBox(width: 12),
        Text(text),
      ],
    );
  }

  void _showReportDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.bug_report, color: primaryBlue),
            SizedBox(width: 8),
            Text('Laporkan Masalah'),
          ],
        ),
        content: TextField(
          controller: controller,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Jelaskan masalah yang Anda alami...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              CustomToast.success(context, 'Laporan terkirim');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Kirim'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.info, color: primaryBlue),
            SizedBox(width: 8),
            Text('Tentang SIMA'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SIMA',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('Sistem Informasi Mahasiswa Akademik'),
            SizedBox(height: 16),
            Text('Versi: 1.0.0'),
            Text('Build: 2024.12.16'),
            SizedBox(height: 16),
            Text(
              '© 2024 Institut Teknologi dan Sains Pekalongan',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
