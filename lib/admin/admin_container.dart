import 'package:flutter/material.dart';
import '../data/user_data.dart';
import '../login_page.dart';
import 'admin_dashboard.dart';
import 'student_management.dart';
import 'lecturer_management.dart';
import 'course_management.dart';
import 'krs_management.dart';
import 'grade_calculation.dart';
import 'billing_management.dart';
import 'payment_verification.dart';
import 'schedule_management.dart';
import 'admin_profile.dart';
import 'admin_settings.dart';

class AdminContainer extends StatefulWidget {
  final AppUser user;

  const AdminContainer({super.key, required this.user});

  @override
  State<AdminContainer> createState() => _AdminContainerState();
}

class _AdminContainerState extends State<AdminContainer> {
  static const Color primaryBlue = Color(0xFF4A90E2);
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _menuItems = [
    {'icon': Icons.dashboard, 'label': 'Dashboard', 'section': null},
    {'icon': Icons.people, 'label': 'Mahasiswa', 'section': 'PENGGUNA'},
    {'icon': Icons.person, 'label': 'Dosen', 'section': null},
    {'icon': Icons.book, 'label': 'Mata Kuliah', 'section': 'AKADEMIK'},
    {'icon': Icons.calendar_today, 'label': 'Jadwal Kuliah', 'section': null},
    {'icon': Icons.publish, 'label': 'Publish KRS', 'section': null},
    {'icon': Icons.calculate, 'label': 'Kalkulasi Nilai', 'section': null},
    {'icon': Icons.payments, 'label': 'Tagihan', 'section': 'KEUANGAN'},
    {'icon': Icons.receipt_long, 'label': 'Pembayaran', 'section': null},
    {'icon': Icons.person, 'label': 'Profil', 'section': 'SISTEM'},
    {'icon': Icons.settings, 'label': 'Pengaturan', 'section': null},
  ];

  String _getPageTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Manajemen Mahasiswa';
      case 2:
        return 'Manajemen Dosen';
      case 3:
        return 'Manajemen Mata Kuliah';
      case 4:
        return 'Jadwal Kuliah';
      case 5:
        return 'Publish KRS';
      case 6:
        return 'Kalkulasi Nilai & KHS';
      case 7:
        return 'Manajemen Tagihan';
      case 8:
        return 'Verifikasi Pembayaran';
      case 9:
        return 'Profil Admin';
      case 10:
        return 'Pengaturan Sistem';
      default:
        return 'Admin Panel';
    }
  }

  Widget _buildPage() {
    switch (_selectedIndex) {
      case 0:
        return const AdminDashboard();
      case 1:
        return const StudentManagement();
      case 2:
        return const LecturerManagement();
      case 3:
        return const CourseManagement();
      case 4:
        return const ScheduleManagement();
      case 5:
        return const KrsManagement();
      case 6:
        return const GradeCalculation();
      case 7:
        return const BillingManagement();
      case 8:
        return const PaymentVerification();
      case 9:
        return const AdminProfile();
      case 10:
        return const AdminSettings();
      default:
        return _buildComingSoon();
    }
  }

  Widget _buildComingSoon() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _menuItems[_selectedIndex]['icon'] as IconData,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            _menuItems[_selectedIndex]['label'] as String,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coming Soon',
            style: TextStyle(fontSize: 16, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  void _logout() {
    UserData.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          _getPageTitle(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      drawer: _buildDrawer(),
      body: _buildPage(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          // Drawer Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4A90E2), Color(0xFF5BA3F5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.admin_panel_settings,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.user.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.user.email,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'ADMINISTRATOR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                final item = _menuItems[index];
                final section = item['section'] as String?;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Header
                    if (section != null) ...[
                      if (index > 0) const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                        child: Text(
                          section,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[500],
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                    // Menu Item
                    _buildMenuItem(
                      icon: item['icon'] as IconData,
                      label: item['label'] as String,
                      index: index,
                    ),
                  ],
                );
              },
            ),
          ),

          // Logout Button
          Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: _logout,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? primaryBlue.withOpacity(0.1) : null,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? primaryBlue : Colors.grey[600],
          size: 22,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isSelected ? primaryBlue : Colors.grey[800],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
        selected: isSelected,
        onTap: () {
          setState(() => _selectedIndex = index);
          Navigator.pop(context); // Close drawer
        },
        dense: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
