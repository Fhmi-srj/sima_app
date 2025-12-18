import 'package:flutter/material.dart';
import '../widgets/custom_toast.dart';

class AdminSettings extends StatefulWidget {
  const AdminSettings({super.key});

  @override
  State<AdminSettings> createState() => _AdminSettingsState();
}

class _AdminSettingsState extends State<AdminSettings> {
  static const Color primaryBlue = Color(0xFF4A90E2);

  // Settings States
  bool _maintenanceMode = false;
  bool _allowRegistration = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _autoBackup = true;
  String _selectedTheme = 'light';
  String _selectedLanguage = 'id';
  String _selectedSemester = 'Ganjil 2024/2025';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Informasi Aplikasi
            _buildSectionCard(
              title: 'Informasi Aplikasi',
              icon: Icons.info_outline,
              children: [
                _buildInfoRow('Nama Aplikasi', 'SIMA'),
                _buildInfoRow('Versi', '1.0.0'),
                _buildInfoRow('Build', '2024.12.16'),
                _buildInfoRow('Developer', 'IT Department ITSP'),
              ],
            ),
            const SizedBox(height: 16),

            // Pengaturan Akademik
            _buildSectionCard(
              title: 'Pengaturan Akademik',
              icon: Icons.school,
              children: [
                _buildDropdownSetting(
                  label: 'Semester Aktif',
                  value: _selectedSemester,
                  items: [
                    'Ganjil 2024/2025',
                    'Genap 2024/2025',
                    'Ganjil 2025/2026',
                  ],
                  onChanged: (value) {
                    setState(() => _selectedSemester = value!);
                    CustomToast.success(context, 'Semester aktif diubah');
                  },
                ),
                const Divider(height: 24),
                _buildActionButton(
                  label: 'Periode Pengisian KRS',
                  subtitle: '1 Des 2024 - 15 Des 2024',
                  icon: Icons.date_range,
                  onTap: () => _showDateRangeDialog('Periode KRS'),
                ),
                const SizedBox(height: 12),
                _buildActionButton(
                  label: 'Periode Input Nilai',
                  subtitle: '20 Jan 2025 - 31 Jan 2025',
                  icon: Icons.grading,
                  onTap: () => _showDateRangeDialog('Periode Input Nilai'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Pengaturan Sistem
            _buildSectionCard(
              title: 'Pengaturan Sistem',
              icon: Icons.settings,
              children: [
                _buildSwitchSetting(
                  label: 'Mode Maintenance',
                  subtitle: 'Nonaktifkan akses pengguna sementara',
                  value: _maintenanceMode,
                  onChanged: (value) {
                    setState(() => _maintenanceMode = value);
                    CustomToast.info(
                      context,
                      value
                          ? 'Mode maintenance aktif'
                          : 'Mode maintenance nonaktif',
                    );
                  },
                  isWarning: true,
                ),
                const Divider(height: 24),
                _buildSwitchSetting(
                  label: 'Pendaftaran Mahasiswa Baru',
                  subtitle: 'Izinkan pendaftaran akun baru',
                  value: _allowRegistration,
                  onChanged: (value) {
                    setState(() => _allowRegistration = value);
                  },
                ),
                const Divider(height: 24),
                _buildDropdownSetting(
                  label: 'Tema Aplikasi',
                  value: _selectedTheme,
                  items: ['light', 'dark', 'system'],
                  itemLabels: ['Terang', 'Gelap', 'Ikuti Sistem'],
                  onChanged: (value) {
                    setState(() => _selectedTheme = value!);
                    CustomToast.info(context, 'Tema diubah');
                  },
                ),
                const Divider(height: 24),
                _buildDropdownSetting(
                  label: 'Bahasa',
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

            // Notifikasi
            _buildSectionCard(
              title: 'Notifikasi',
              icon: Icons.notifications,
              children: [
                _buildSwitchSetting(
                  label: 'Notifikasi Email',
                  subtitle: 'Kirim notifikasi via email',
                  value: _emailNotifications,
                  onChanged: (value) {
                    setState(() => _emailNotifications = value);
                  },
                ),
                const Divider(height: 24),
                _buildSwitchSetting(
                  label: 'Push Notification',
                  subtitle: 'Notifikasi langsung ke perangkat',
                  value: _pushNotifications,
                  onChanged: (value) {
                    setState(() => _pushNotifications = value);
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Backup & Data
            _buildSectionCard(
              title: 'Backup & Data',
              icon: Icons.backup,
              children: [
                _buildSwitchSetting(
                  label: 'Auto Backup',
                  subtitle: 'Backup otomatis setiap hari',
                  value: _autoBackup,
                  onChanged: (value) {
                    setState(() => _autoBackup = value);
                  },
                ),
                const Divider(height: 24),
                _buildActionButton(
                  label: 'Backup Manual',
                  subtitle: 'Terakhir: 16 Des 2024, 08:00',
                  icon: Icons.cloud_upload,
                  onTap: () {
                    CustomToast.success(context, 'Backup sedang berjalan...');
                  },
                ),
                const SizedBox(height: 12),
                _buildActionButton(
                  label: 'Restore Data',
                  subtitle: 'Pulihkan dari backup sebelumnya',
                  icon: Icons.cloud_download,
                  onTap: () => _showRestoreDialog(),
                ),
                const SizedBox(height: 12),
                _buildActionButton(
                  label: 'Export Data',
                  subtitle: 'Export data ke format Excel/CSV',
                  icon: Icons.download,
                  onTap: () => _showExportDialog(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Danger Zone
            _buildSectionCard(
              title: 'Zona Berbahaya',
              icon: Icons.warning,
              isDanger: true,
              children: [
                _buildDangerButton(
                  label: 'Hapus Cache Sistem',
                  icon: Icons.delete_sweep,
                  onTap: () => _showConfirmDialog(
                    'Hapus Cache',
                    'Semua cache sistem akan dihapus. Lanjutkan?',
                    () => CustomToast.success(context, 'Cache dihapus'),
                  ),
                ),
                const SizedBox(height: 12),
                _buildDangerButton(
                  label: 'Reset Pengaturan',
                  icon: Icons.restore,
                  onTap: () => _showConfirmDialog(
                    'Reset Pengaturan',
                    'Semua pengaturan akan dikembalikan ke default. Lanjutkan?',
                    () => CustomToast.success(context, 'Pengaturan direset'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  CustomToast.success(context, 'Pengaturan berhasil disimpan');
                },
                icon: const Icon(Icons.save, size: 20),
                label: const Text(
                  'Simpan Semua Pengaturan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
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
          // Header
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
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchSetting({
    required String label,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isWarning = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isWarning && value ? Colors.orange : Colors.black87,
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
          value: value,
          onChanged: onChanged,
          activeColor: isWarning ? Colors.orange : primaryBlue,
        ),
      ],
    );
  }

  Widget _buildDropdownSetting({
    required String label,
    required String value,
    required List<String> items,
    List<String>? itemLabels,
    required ValueChanged<String?> onChanged,
  }) {
    return Row(
      children: [
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

  void _showDateRangeDialog(String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.date_range, color: primaryBlue),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: const Text('Fitur pengaturan periode akan segera hadir.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showRestoreDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.cloud_download, color: primaryBlue),
            SizedBox(width: 8),
            Text('Restore Data'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildBackupItem('16 Des 2024, 08:00', '245 MB'),
            _buildBackupItem('15 Des 2024, 08:00', '243 MB'),
            _buildBackupItem('14 Des 2024, 08:00', '240 MB'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
        ],
      ),
    );
  }

  Widget _buildBackupItem(String date, String size) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.backup, color: primaryBlue),
      title: Text(date),
      subtitle: Text(size),
      trailing: TextButton(
        onPressed: () {
          Navigator.pop(context);
          CustomToast.success(context, 'Memulai restore...');
        },
        child: const Text('Restore'),
      ),
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.download, color: primaryBlue),
            SizedBox(width: 8),
            Text('Export Data'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pilih data yang akan di-export:'),
            const SizedBox(height: 16),
            _buildExportOption('Data Mahasiswa', Icons.people),
            _buildExportOption('Data Dosen', Icons.person),
            _buildExportOption('Data KRS/KHS', Icons.assignment),
            _buildExportOption('Data Pembayaran', Icons.payment),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              CustomToast.success(context, 'Export berhasil');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  Widget _buildExportOption(String label, IconData icon) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      value: true,
      onChanged: (value) {},
      title: Row(
        children: [
          Icon(icon, size: 20, color: primaryBlue),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
      activeColor: primaryBlue,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  void _showConfirmDialog(
    String title,
    String message,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.warning, color: Colors.red),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Lanjutkan'),
          ),
        ],
      ),
    );
  }
}
