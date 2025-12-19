import 'package:flutter/material.dart';
import 'home_page.dart';
import 'search_page.dart';
import 'academic_page.dart';
import 'schedule_page.dart';
import 'finance_page.dart';
import 'profile_page.dart';
import 'settings_page.dart';
import 'certificate_page.dart';
import 'lecturer_home_page.dart';
import 'lecturer_schedule_page.dart';
import 'attendance_management_page.dart';
import 'lecturer_academic_page.dart';
import 'lecturer_search_page.dart';
import 'widgets/custom_bottom_nav_bar.dart';
import 'data/user_data.dart';

class MainContainer extends StatefulWidget {
  final AppUser user;

  const MainContainer({super.key, required this.user});

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _selectedIndex = 0;
  int _academicInitialTab = 0;

  // User Profile Data
  late String _userName;
  late String _userNim;
  late String _userProdi;
  late String _userInstitusi;
  late String _userAngkatan;
  late String _userSemester;
  late String _userFakultas;

  @override
  void initState() {
    super.initState();
    // Initialize from passed user
    _userName = widget.user.name;
    _userNim = widget.user.id;
    _userProdi = widget.user.prodi;
    _userInstitusi = widget.user.institusi;
    _userAngkatan = widget.user.year ?? '';
    _userSemester = '5'; // Default semester, can be made dynamic
    _userFakultas = widget.user.faculty ?? 'SAINTEK';
  }

  bool get isLecturer => widget.user.role == UserRole.lecturer;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 4) {
        // Reset to KRS tab when navigating via bottom nav
        _academicInitialTab = 0;
      }
    });
  }

  void _onFABTapped() {
    setState(() {
      _selectedIndex = 4;
      _academicInitialTab = 0; // Default to KRS tab
    });
  }

  void _onNavigateToAcademic(int tabIndex) {
    setState(() {
      _selectedIndex = 4; // Switch to academic page
      _academicInitialTab = tabIndex; // Set the specific tab
    });
  }

  void _onNavigateToProfile() {
    setState(() {
      _selectedIndex = 5; // Navigate to profile page
    });
  }

  void _onNavigateToSettings() {
    setState(() {
      _selectedIndex = 6; // Navigate to settings page
    });
  }

  void _onNavigateToCertificate() {
    setState(() {
      _selectedIndex = 7; // Navigate to certificate page
    });
  }

  void _onNavigateToAttendance() {
    setState(() {
      _selectedIndex = 3; // Navigate to attendance (same slot as finance)
    });
  }

  void _onNavigateToSchedule() {
    setState(() {
      _selectedIndex = 2; // Navigate to schedule page
    });
  }

  void _updateUserProfile({
    String? nama,
    String? nim,
    String? prodi,
    String? institusi,
    String? angkatan,
    String? fakultas,
  }) {
    setState(() {
      if (nama != null) _userName = nama;
      if (nim != null) _userNim = nim;
      if (prodi != null) _userProdi = prodi;
      if (institusi != null) _userInstitusi = institusi;
      if (angkatan != null) _userAngkatan = angkatan;
      if (fakultas != null) _userFakultas = fakultas;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build pages dynamically to pass callbacks and state
    Widget currentPage;
    switch (_selectedIndex) {
      case 0:
        // Role-based home page
        if (isLecturer) {
          currentPage = LecturerHomePageContent(
            onNavigateToProfile: _onNavigateToProfile,
            onNavigateToSettings: _onNavigateToSettings,
            onNavigateToAttendance: _onNavigateToAttendance,
            onNavigateToSchedule: _onNavigateToSchedule,
            onNavigateToAcademic: _onNavigateToAcademic,
            userName: _userName,
            userNip: _userNim,
            userProdi: _userProdi,
            userInstitusi: _userInstitusi,
            userAngkatan: _userAngkatan,
          );
        } else {
          currentPage = HomeContent(
            onNavigateToAcademic: _onNavigateToAcademic,
            onNavigateToCertificate: _onNavigateToCertificate,
            onNavigateToFinance: () => setState(() => _selectedIndex = 3),
            onNavigateToProfile: _onNavigateToProfile,
            onNavigateToSettings: _onNavigateToSettings,
            userName: _userName,
            userNim: _userNim,
            userProdi: _userProdi,
            userAngkatan: _userAngkatan,
            userInstitusi: _userInstitusi,
            userSemester: _userSemester,
            studentId: _userNim, // Pass studentId for KRS-filtered schedule
          );
        }
        break;
      case 1:
        // Role-based search page
        if (isLecturer) {
          currentPage = LecturerSearchPage(
            onNavigateToProfile: _onNavigateToProfile,
            onNavigateToSettings: _onNavigateToSettings,
            userNip: _userNim,
          );
        } else {
          currentPage = SearchPage(
            onNavigateToProfile: _onNavigateToProfile,
            onNavigateToSettings: _onNavigateToSettings,
          );
        }
        break;
      case 2:
        // Role-based schedule page
        if (isLecturer) {
          currentPage = LecturerSchedulePageContent(
            onNavigateToProfile: _onNavigateToProfile,
            onNavigateToSettings: _onNavigateToSettings,
            userNip: _userNim,
          );
        } else {
          currentPage = SchedulePageContent(
            onNavigateToProfile: _onNavigateToProfile,
            onNavigateToSettings: _onNavigateToSettings,
            studentId: _userNim, // Pass studentId for KRS-based schedule
          );
        }
        break;
      case 3:
        // Role-based: Finance for students, Attendance for lecturers
        if (isLecturer) {
          currentPage = AttendanceManagementPageContent(
            onNavigateToProfile: _onNavigateToProfile,
            onNavigateToSettings: _onNavigateToSettings,
            userNip: _userNim,
          );
        } else {
          currentPage = FinancePageContent(
            onNavigateToProfile: _onNavigateToProfile,
            onNavigateToSettings: _onNavigateToSettings,
            studentId: _userNim,
          );
        }
        break;
      case 4:
        // Role-based academic page
        if (isLecturer) {
          currentPage = LecturerAcademicPageContent(
            initialTab: _academicInitialTab,
            onNavigateToProfile: _onNavigateToProfile,
            onNavigateToSettings: _onNavigateToSettings,
            userName: _userName,
            userNip: _userNim,
            userProdi: _userProdi,
          );
        } else {
          currentPage = AcademicPageContent(
            initialTab: _academicInitialTab,
            onNavigateToProfile: _onNavigateToProfile,
            onNavigateToSettings: _onNavigateToSettings,
            userName: _userName,
            userNim: _userNim,
            userProdi: _userProdi,
            userFakultas: _userFakultas,
            userKelas: widget.user.kelas ?? 'IM23C',
          );
        }
        break;
      case 5:
        currentPage = ProfilePageContent(
          onNavigateToSettings: _onNavigateToSettings,
          onNavigateToCertificate: _onNavigateToCertificate,
          userName: _userName,
          userNim: _userNim,
          userProdi: _userProdi,
          userInstitusi: _userInstitusi,
          userAngkatan: _userAngkatan,
          userFakultas: _userFakultas,
          isLecturer: isLecturer,
          onUpdateProfile: _updateUserProfile,
        );
        break;
      case 6:
        currentPage = SettingsPageContent(
          onNavigateToProfile: _onNavigateToProfile,
        );
        break;
      case 7:
        currentPage = CertificatePageContent(
          onNavigateToProfile: _onNavigateToProfile,
          onNavigateToSettings: _onNavigateToSettings,
        );
        break;
      default:
        currentPage = Container(); // Fallback for unknown index
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: currentPage,
      floatingActionButton: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 4),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6B4CE6).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: _onFABTapped,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _selectedIndex == 4
                    ? [const Color(0xFF8B6CE8), const Color(0xFF6B4CE6)]
                    : [const Color(0xFF6B4CE6), const Color(0xFF8B6CE8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.school, color: Colors.white, size: 32),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
        showFAB: true,
        isLecturer: isLecturer,
      ),
    );
  }
}
