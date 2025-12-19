import 'package:flutter/material.dart';
import '../shared/widgets/custom_top_bar.dart';
import '../shared/widgets/custom_bottom_nav_bar.dart';
import 'widgets/certificate_detail_modal.dart';
import 'widgets/add_certificate_modal.dart';

class CertificatePageContent extends StatefulWidget {
  final VoidCallback? onNavigateToProfile;
  final VoidCallback? onNavigateToSettings;

  const CertificatePageContent({
    super.key,
    this.onNavigateToProfile,
    this.onNavigateToSettings,
  });

  @override
  State<CertificatePageContent> createState() => _CertificatePageContentState();
}

class _CertificatePageContentState extends State<CertificatePageContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AddCertificateModal(),
          );
        },
        backgroundColor: const Color(0xFF4A90E2),
        elevation: 6,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Column(
        children: [
          // Fixed Header with Custom Top Bar
          Container(
            decoration: const BoxDecoration(color: Color(0xFF4A90E2)),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // Custom Top Bar
                  CustomTopBar(
                    onProfileTap: widget.onNavigateToProfile,
                    onSettingsTap: widget.onNavigateToSettings,
                  ),

                  // Page Title
                  const Padding(
                    padding: EdgeInsets.only(bottom: 32, top: 8),
                    child: Text(
                      'Sertifikat Saya',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content with rounded top
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              transform: Matrix4.translationValues(0, -16, 0),
              child: Column(
                children: [
                  const SizedBox(height: 24),

                  // Filter Tabs (Finance Page Style)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        _buildTab('Semua', 0),
                        const SizedBox(width: 6),
                        _buildTab('Aktif', 1),
                        const SizedBox(width: 6),
                        _buildTab('Kadaluarsa', 2),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Certificate Cards
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildAllCertificates(),
                        _buildActiveCertificates(),
                        _buildExpiredCertificates(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _tabController.animateTo(index);
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF4A90E2) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFF4A90E2).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : const Color(0xFF4A90E2),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAllCertificates() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        _buildCertificateCard(
          title: 'Sertifikat Kompetensi',
          subtitle: 'Web Development',
          certId: 'CERT-2024-001',
          issueDate: '15 Jan 2024',
          expiryDate: '15 Jan 2027',
          issuer: 'Kampus IT',
          status: 'Aktif',
          gradientColors: [const Color(0xFF4A90E2), const Color(0xFF5BA3F5)],
          icon: Icons.check_circle_outline,
        ),
        const SizedBox(height: 16),
        _buildCertificateCard(
          title: 'Lomba UI/UX Desain',
          subtitle: 'Juara 1 Tingkat Nasional',
          certId: 'LOMBA-2025-045',
          issueDate: '05 Feb 2025',
          expiryDate: 'Selamanya',
          issuer: 'Dikti',
          status: 'Aktif',
          gradientColors: [const Color(0xFF9333EA), const Color(0xFFA855F7)],
          icon: Icons.menu_book_outlined,
        ),
        const SizedBox(height: 16),
        _buildCertificateCard(
          title: 'Pelatihan Database',
          subtitle: 'MySQL & PostgreSQL',
          certId: 'TRAIN-2024-089',
          issueDate: '10 Maret 2024',
          expiryDate: '10 Maret 2024',
          issuer: 'Kampus IT',
          status: 'Kadaluarsa',
          gradientColors: [const Color(0xFF9CA3AF), const Color(0xFF6B7280)],
          icon: Icons.storage_outlined,
          isExpired: true,
        ),
      ],
    );
  }

  Widget _buildActiveCertificates() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        _buildCertificateCard(
          title: 'Sertifikat Kompetensi',
          subtitle: 'Web Development',
          certId: 'CERT-2024-001',
          issueDate: '15 Jan 2024',
          expiryDate: '15 Jan 2027',
          issuer: 'Kampus IT',
          status: 'Aktif',
          gradientColors: [const Color(0xFF4A90E2), const Color(0xFF5BA3F5)],
          icon: Icons.check_circle_outline,
        ),
        const SizedBox(height: 16),
        _buildCertificateCard(
          title: 'Lomba UI/UX Desain',
          subtitle: 'Juara 1 Tingkat Nasional',
          certId: 'LOMBA-2025-045',
          issueDate: '05 Feb 2025',
          expiryDate: 'Selamanya',
          issuer: 'Dikti',
          status: 'Aktif',
          gradientColors: [const Color(0xFF9333EA), const Color(0xFFA855F7)],
          icon: Icons.menu_book_outlined,
        ),
      ],
    );
  }

  Widget _buildExpiredCertificates() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        _buildCertificateCard(
          title: 'Pelatihan Database',
          subtitle: 'MySQL & PostgreSQL',
          certId: 'TRAIN-2024-089',
          issueDate: '10 Maret 2024',
          expiryDate: '10 Maret 2024',
          issuer: 'Kampus IT',
          status: 'Kadaluarsa',
          gradientColors: [const Color(0xFF9CA3AF), const Color(0xFF6B7280)],
          icon: Icons.storage_outlined,
          isExpired: true,
        ),
      ],
    );
  }

  Widget _buildCertificateCard({
    required String title,
    required String subtitle,
    required String certId,
    required String issueDate,
    required String expiryDate,
    required String issuer,
    required String status,
    required List<Color> gradientColors,
    required IconData icon,
    bool isExpired = false,
  }) {
    return Opacity(
      opacity: isExpired ? 0.75 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[100]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gradient Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Stack(
                children: [
                  // Status Badge
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isExpired
                            ? Colors.grey[300]
                            : const Color(0xFF86EFAC),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isExpired
                              ? Colors.grey[700]
                              : const Color(0xFF166534),
                        ),
                      ),
                    ),
                  ),

                  // Icon and Title
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, color: Colors.white, size: 32),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              subtitle,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Certificate Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Grid Details
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'No. Sertifikat',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[500],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              certId,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tanggal Terbit',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[500],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              issueDate,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Berlaku Hingga',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[500],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              expiryDate,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Penerbit',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[500],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              issuer,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => CertificateDetailModal(
                                title: title,
                                subtitle: subtitle,
                                certId: certId,
                                issueDate: issueDate,
                                expiryDate: expiryDate,
                                issuer: issuer,
                                status: status,
                                gradientColors: gradientColors,
                                icon: icon,
                                isExpired: isExpired,
                              ),
                            );
                          },
                          icon: const Icon(Icons.visibility_outlined, size: 16),
                          label: const Text('Lihat Detail'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4A90E2),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: () {
                            // TODO: Share certificate
                          },
                          icon: Icon(
                            Icons.share_outlined,
                            color: Colors.grey[600],
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Standalone Certificate Page (for navigation)
class CertificatePage extends StatelessWidget {
  const CertificatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CertificatePageContent(),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 4, // Assuming certificate is index 4
        onItemTapped: (index) {
          // Handle navigation
          if (index != 4) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}




