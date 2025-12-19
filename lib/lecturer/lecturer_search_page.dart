import 'package:flutter/material.dart';
import '../shared/data/class_data.dart';
import '../shared/data/lecturer_data.dart';
import '../shared/widgets/custom_top_bar.dart';
import 'widgets/grade_input_modal.dart';
import '../shared/widgets/custom_toast.dart';

class LecturerSearchPage extends StatefulWidget {
  final VoidCallback? onNavigateToProfile;
  final VoidCallback? onNavigateToSettings;
  final String userNip;

  const LecturerSearchPage({
    super.key,
    this.onNavigateToProfile,
    this.onNavigateToSettings,
    required this.userNip,
  });

  @override
  State<LecturerSearchPage> createState() => _LecturerSearchPageState();
}

class _LecturerSearchPageState extends State<LecturerSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Semua';
  List<_SearchResult> _searchResults = [];
  bool _isSearching = false;
  static const Color primaryBlue = Color(0xFF4A90E2);

  final List<String> _filters = [
    'Semua',
    'Mata Kuliah',
    'Jadwal',
    'Nilai',
    'Absensi',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _isSearching = _searchController.text.isNotEmpty;
      if (_isSearching) {
        _performSearch(_searchController.text);
      } else {
        _searchResults = [];
      }
    });
  }

  void _performSearch(String query) {
    final lowerQuery = query.toLowerCase();
    final results = <_SearchResult>[];
    final classes = ClassData.getClassesByLecturer(widget.userNip);
    final schedules = LecturerData.getTeachingSchedule(widget.userNip);

    // Search courses (Mata Kuliah)
    if (_selectedFilter == 'Semua' || _selectedFilter == 'Mata Kuliah') {
      for (final classInfo in classes) {
        if (classInfo.subject.toLowerCase().contains(lowerQuery) ||
            classInfo.name.toLowerCase().contains(lowerQuery)) {
          results.add(
            _SearchResult(
              type: 'matkul',
              title: classInfo.subject,
              subtitle: classInfo.name,
              icon: Icons.book,
              color: Colors.orange,
              data: classInfo,
              action: 'Input Nilai',
            ),
          );
        }
      }
    }

    // Search schedules (Jadwal)
    if (_selectedFilter == 'Semua' || _selectedFilter == 'Jadwal') {
      for (final schedule in schedules) {
        final subject = schedule['subject'] ?? '';
        final day = schedule['day'] ?? '';
        final time = schedule['time'] ?? '';
        final room = schedule['room'] ?? '';

        if (subject.toLowerCase().contains(lowerQuery) ||
            day.toLowerCase().contains(lowerQuery) ||
            room.toLowerCase().contains(lowerQuery)) {
          results.add(
            _SearchResult(
              type: 'jadwal',
              title: subject,
              subtitle: '$day • $time • $room',
              icon: Icons.calendar_today,
              color: primaryBlue,
              data: schedule,
              action: 'Lihat Jadwal',
            ),
          );
        }
      }
    }

    // Search for grade input (Nilai)
    if (_selectedFilter == 'Semua' || _selectedFilter == 'Nilai') {
      for (final classInfo in classes) {
        if (classInfo.subject.toLowerCase().contains(lowerQuery) ||
            classInfo.name.toLowerCase().contains(lowerQuery)) {
          // Avoid duplicates if already in matkul
          if (_selectedFilter == 'Nilai') {
            results.add(
              _SearchResult(
                type: 'nilai',
                title: 'Input Nilai: ${classInfo.subject}',
                subtitle: classInfo.name,
                icon: Icons.grade,
                color: Colors.green,
                data: classInfo,
                action: 'Input Nilai',
              ),
            );
          }
        }
      }
    }

    // Search for attendance (Absensi)
    if (_selectedFilter == 'Semua' || _selectedFilter == 'Absensi') {
      // Add classes for attendance history
      for (final classInfo in classes) {
        if (classInfo.subject.toLowerCase().contains(lowerQuery) ||
            classInfo.name.toLowerCase().contains(lowerQuery)) {
          results.add(
            _SearchResult(
              type: 'absensi',
              title: 'Absensi: ${classInfo.subject}',
              subtitle: '${classInfo.name} • Riwayat Kehadiran',
              icon: Icons.fact_check,
              color: Colors.purple,
              data: classInfo,
              action: 'Riwayat Absensi',
            ),
          );
        }
      }

      // Add izin requests if query matches
      final izinKeywords = ['izin', 'persetujuan', 'pending', 'cuti', 'sakit'];
      if (izinKeywords.any(
        (k) => k.contains(lowerQuery) || lowerQuery.contains(k),
      )) {
        results.add(
          _SearchResult(
            type: 'izin',
            title: 'Persetujuan Izin',
            subtitle: 'Kelola permintaan izin mahasiswa',
            icon: Icons.pending_actions,
            color: Colors.orange,
            data: null,
            action: 'Kelola Izin',
          ),
        );
      }
    }

    _searchResults = results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(color: primaryBlue),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  CustomTopBar(
                    onProfileTap: widget.onNavigateToProfile,
                    onSettingsTap: widget.onNavigateToSettings,
                  ),
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Cari mata kuliah, jadwal...',
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 15,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey[400],
                            size: 24,
                          ),
                          suffixIcon: _isSearching
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 20),
                                  onPressed: () => _searchController.clear(),
                                  color: Colors.grey[400],
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Filter Chips
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                    child: SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _filters.length,
                        itemBuilder: (context, index) {
                          final filter = _filters[index];
                          final isSelected = _selectedFilter == filter;
                          return Padding(
                            padding: EdgeInsets.only(
                              right: index < _filters.length - 1 ? 12 : 0,
                            ),
                            child: FilterChip(
                              label: Text(
                                filter,
                                style: TextStyle(
                                  color: isSelected
                                      ? primaryBlue
                                      : Colors.black87,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                ),
                              ),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedFilter = filter;
                                  _onSearchChanged();
                                });
                              },
                              selectedColor: Colors.white,
                              backgroundColor: Colors.white.withOpacity(0.3),
                              checkmarkColor: primaryBlue,
                              side: BorderSide.none,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _isSearching ? _buildSearchResults() : _buildQuickAccess(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'Tidak ditemukan',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            Text(
              '"${_searchController.text}"',
              style: TextStyle(fontSize: 14, color: Colors.grey[400]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) => _buildResultCard(_searchResults[index]),
    );
  }

  Widget _buildResultCard(_SearchResult result) {
    return GestureDetector(
      onTap: () => _onResultTap(result),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: result.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(result.icon, color: result.color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    result.subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: result.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                result.action,
                style: TextStyle(
                  fontSize: 11,
                  color: result.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onResultTap(_SearchResult result) {
    if (result.type == 'matkul' || result.type == 'nilai') {
      GradeInputModal.show(context, classInfo: result.data as ClassInfo);
    } else if (result.type == 'jadwal') {
      CustomToast.info(
        context,
        'Jadwal: ${result.data['subject']} - ${result.data['day']} ${result.data['time']}',
      );
    }
  }

  Widget _buildQuickAccess() {
    final classes = ClassData.getClassesByLecturer(widget.userNip);
    final schedules = LecturerData.getTeachingSchedule(widget.userNip);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Stats
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Mata Kuliah',
                  '${classes.length}',
                  Icons.book,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Jadwal',
                  '${schedules.length}',
                  Icons.calendar_today,
                  primaryBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Recent Searches / Quick Menu
          const Text(
            'Menu Cepat',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),

          _buildQuickMenuItem(
            'Input Nilai',
            'Kelola nilai mahasiswa',
            Icons.grade,
            Colors.green,
            () {
              if (classes.isNotEmpty) {
                GradeInputModal.show(context, classInfo: classes.first);
              }
            },
          ),
          _buildQuickMenuItem(
            'Lihat Jadwal',
            'Jadwal mengajar hari ini',
            Icons.calendar_today,
            primaryBlue,
            () {
              CustomToast.info(context, 'Navigasi ke halaman Jadwal');
            },
          ),
          _buildQuickMenuItem(
            'Riwayat Absensi',
            'Lihat riwayat kehadiran',
            Icons.history,
            Colors.purple,
            () {
              CustomToast.info(context, 'Navigasi ke halaman Absensi');
            },
          ),
          _buildQuickMenuItem(
            'Persetujuan KRS',
            'Approve/reject KRS mahasiswa',
            Icons.fact_check,
            Colors.teal,
            () {
              CustomToast.info(context, 'Navigasi ke halaman Akademik');
            },
          ),

          const SizedBox(height: 24),

          // Mata Kuliah Diampu
          const Text(
            'Mata Kuliah Diampu',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          ...classes.map((classInfo) {
            final students = ClassData.getStudentsInClass(classInfo.code);
            return GestureDetector(
              onTap: () => GradeInputModal.show(context, classInfo: classInfo),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.book,
                        color: Colors.orange,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            classInfo.subject,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${classInfo.name} • ${students.length} mhs',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildQuickMenuItem(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
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
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class _SearchResult {
  final String type;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final dynamic data;
  final String action;

  _SearchResult({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.data,
    required this.action,
  });
}



