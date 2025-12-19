import 'package:flutter/material.dart';
import '../../shared/widgets/curved_bracket_painter.dart';
import 'edit_certificate_modal.dart';
import '../../shared/widgets/custom_toast.dart';

class CertificateDetailModal extends StatelessWidget {
  final String title;
  final String subtitle;
  final String certId;
  final String issueDate;
  final String expiryDate;
  final String issuer;
  final String status;
  final List<Color> gradientColors;
  final IconData icon;
  final bool isExpired;

  const CertificateDetailModal({
    super.key,
    required this.title,
    required this.subtitle,
    required this.certId,
    required this.issueDate,
    required this.expiryDate,
    required this.issuer,
    required this.status,
    required this.gradientColors,
    required this.icon,
    this.isExpired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 420,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Sticky Header with Gradient
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  // Close Button and Title Row
                  Row(
                    children: [
                      // Icon
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(icon, color: Colors.white, size: 40),
                      ),
                      const SizedBox(width: 16),
                      // Title and Subtitle
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 20,
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
                      // Close Button
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
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
                  const SizedBox(height: 16),
                  // Status and ID Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isExpired
                              ? Colors.grey[300]
                              : const Color(0xFF86EFAC),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isExpired ? status : '✓ $status',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isExpired
                                ? Colors.grey[700]
                                : const Color(0xFF166534),
                          ),
                        ),
                      ),
                      Text(
                        'ID: $certId',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Certificate Preview
                    _buildCertificatePreview(),
                    const SizedBox(height: 24),

                    // Details Grid
                    _buildDetailItem(
                      icon: Icons.local_offer_outlined,
                      iconColor: const Color(0xFF4A90E2),
                      iconBgColor: const Color(0xFFE3F2FD),
                      label: 'Nomor Sertifikat',
                      value: certId,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailItem(
                      icon: Icons.calendar_today_outlined,
                      iconColor: const Color(0xFF10B981),
                      iconBgColor: const Color(0xFFD1FAE5),
                      label: 'Tanggal Terbit',
                      value: issueDate,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailItem(
                      icon: Icons.access_time_outlined,
                      iconColor: const Color(0xFFF97316),
                      iconBgColor: const Color(0xFFFFEDD5),
                      label: 'Berlaku Hingga',
                      value: expiryDate,
                      subtitle: isExpired
                          ? '⚠️ Sertifikat sudah tidak berlaku'
                          : '⏰ Berlaku 2 tahun 1 bulan lagi',
                      subtitleColor: isExpired
                          ? Colors.red[600]
                          : Colors.green[600],
                    ),
                    const SizedBox(height: 16),
                    _buildDetailItem(
                      icon: Icons.business_outlined,
                      iconColor: const Color(0xFF9333EA),
                      iconBgColor: const Color(0xFFF3E8FF),
                      label: 'Penerbit',
                      value: issuer,
                      subtitle: 'Jakarta, Indonesia',
                    ),
                    const SizedBox(height: 16),
                    _buildDetailItem(
                      icon: Icons.description_outlined,
                      iconColor: const Color(0xFF6366F1),
                      iconBgColor: const Color(0xFFE0E7FF),
                      label: 'Deskripsi',
                      value:
                          'Sertifikat ini diberikan kepada mahasiswa yang telah menyelesaikan program pembelajaran dengan baik dan memenuhi standar kompetensi yang ditetapkan.',
                    ),

                    // Verification Info (only for active certificates)
                    if (!isExpired) ...[
                      const SizedBox(height: 24),
                      _buildVerificationInfo(),
                    ],
                  ],
                ),
              ),
            ),

            // Sticky Footer with Action Buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Download Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        CustomToast.info(
                          context,
                          'Download sertifikat dimulai...',
                        );
                      },
                      icon: const Icon(Icons.download_outlined, size: 20),
                      label: const Text('Download Sertifikat'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A90E2),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        shadowColor: const Color(0xFF4A90E2).withOpacity(0.3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Edit and Delete Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            Navigator.pop(context);
                            final result = await showDialog(
                              context: context,
                              builder: (context) => EditCertificateModal(
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
                            if (result != null && result['success'] == true) {
                              // Handle success
                            }
                          },
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          label: const Text('Edit'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF59E0B),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Delete certificate with confirmation
                            showGeneralDialog(
                              context: context,
                              barrierDismissible: true,
                              barrierLabel: 'Delete Confirm',
                              barrierColor: Colors.black.withOpacity(0.5),
                              transitionDuration: const Duration(
                                milliseconds: 200,
                              ),
                              pageBuilder: (dialogContext, animation, secondaryAnimation) {
                                return Center(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 32,
                                      ),
                                      padding: const EdgeInsets.all(24),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.3,
                                            ),
                                            blurRadius: 20,
                                            offset: const Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(16),
                                            decoration: const BoxDecoration(
                                              color: Color(0xFFFEE2E2),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.delete_outline,
                                              color: Color(0xFFEF4444),
                                              size: 32,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          const Text(
                                            'Hapus Sertifikat?',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1F2937),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          const Text(
                                            'Sertifikat yang dihapus tidak dapat dikembalikan!',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF6B7280),
                                            ),
                                          ),
                                          const SizedBox(height: 24),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: OutlinedButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                        dialogContext,
                                                      ),
                                                  style: OutlinedButton.styleFrom(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 12,
                                                        ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                    side: BorderSide(
                                                      color: Colors.grey[300]!,
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    'Batal',
                                                    style: TextStyle(
                                                      color: Color(0xFF6B7280),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(
                                                      dialogContext,
                                                    );
                                                    Navigator.pop(context);
                                                    CustomToast.success(
                                                      context,
                                                      'Sertifikat berhasil dihapus',
                                                    );
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color(0xFFEF4444),
                                                    foregroundColor:
                                                        Colors.white,
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 12,
                                                        ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    'Hapus',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              transitionBuilder: (ctx, anim, secAnim, child) {
                                return ScaleTransition(
                                  scale: Tween<double>(begin: 0.8, end: 1.0)
                                      .animate(
                                        CurvedAnimation(
                                          parent: anim,
                                          curve: Curves.easeOut,
                                        ),
                                      ),
                                  child: FadeTransition(
                                    opacity: anim,
                                    child: child,
                                  ),
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.delete_outline, size: 18),
                          label: const Text('Hapus'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEF4444),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
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

  Widget _buildCertificatePreview() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Background Container with padding for content
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFBFDBFE), width: 2),
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'CERTIFICATE OF ACHIEVEMENT',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E40AF),
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Ahmad Rizky',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2563EB),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'NIM: 102230039',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF3B82F6),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Has successfully completed',
                  style: TextStyle(fontSize: 13, color: Color(0xFF1E40AF)),
                ),
                const SizedBox(height: 12),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Informatika - Kampus IT',
                  style: TextStyle(fontSize: 13, color: Color(0xFF3B82F6)),
                ),
              ],
            ),
          ),
        ),
        // Curved Bracket Corners (Custom Paint) - positioned on top
        Positioned.fill(
          child: CustomPaint(
            painter: CurvedBracketPainter(
              color: const Color(0xFF3B82F6),
              strokeWidth: 4.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String label,
    required String value,
    String? subtitle,
    Color? subtitleColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconBgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 11, color: Colors.grey[500]),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: subtitleColor ?? Colors.grey[500],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Download Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: Download certificate
              CustomToast.info(context, 'Download sertifikat dimulai...');
            },
            icon: const Icon(Icons.download_outlined, size: 20),
            label: const Text('Download Sertifikat'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A90E2),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              shadowColor: const Color(0xFF4A90E2).withOpacity(0.3),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Share and Verify Buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: Share certificate
                  CustomToast.info(context, 'Berbagi sertifikat...');
                },
                icon: const Icon(Icons.share_outlined, size: 18),
                label: const Text('Bagikan'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey[700],
                  backgroundColor: Colors.grey[100],
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: Verify certificate
                  CustomToast.info(context, 'Memverifikasi sertifikat...');
                },
                icon: const Icon(Icons.verified_outlined, size: 18),
                label: const Text('Verifikasi'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey[700],
                  backgroundColor: Colors.grey[100],
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEditDeleteButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () async {
              // Close detail modal first
              Navigator.pop(context);

              // Show edit modal
              final result = await showDialog(
                context: context,
                builder: (context) => EditCertificateModal(
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

              // Show success message if edited
              if (result != null && result['success'] == true) {
                // Show success toast
                showGeneralDialog(
                  context: context,
                  barrierDismissible: true,
                  barrierLabel: 'Success Toast',
                  barrierColor: Colors.transparent,
                  transitionDuration: const Duration(milliseconds: 200),
                  pageBuilder: (toastContext, anim, secAnim) {
                    Future.delayed(const Duration(seconds: 3), () {
                      if (Navigator.canPop(toastContext)) {
                        Navigator.pop(toastContext);
                      }
                    });
                    return Center(
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 32),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.check_circle_outline,
                                color: Colors.white,
                                size: 28,
                              ),
                              SizedBox(width: 16),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Berhasil!',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Sertifikat berhasil diperbarui.',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  transitionBuilder: (ctx, anim, secAnim, child) {
                    return FadeTransition(
                      opacity: anim,
                      child: ScaleTransition(
                        scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                          CurvedAnimation(parent: anim, curve: Curves.easeOut),
                        ),
                        child: child,
                      ),
                    );
                  },
                );
              }
            },
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text('Edit'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF59E0B),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: Delete certificate with confirmation
              showGeneralDialog(
                context: context,
                barrierDismissible: true,
                barrierLabel: 'Delete Confirm',
                barrierColor: Colors.black.withOpacity(0.5),
                transitionDuration: const Duration(milliseconds: 200),
                pageBuilder: (dialogContext, animation, secondaryAnimation) {
                  return Center(
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 32),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEE2E2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.delete_outline,
                                color: Color(0xFFEF4444),
                                size: 32,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Hapus Sertifikat?',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Sertifikat yang dihapus tidak dapat dikembalikan!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () =>
                                        Navigator.pop(dialogContext),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      side: BorderSide(
                                        color: Colors.grey[300]!,
                                      ),
                                    ),
                                    child: const Text(
                                      'Batal',
                                      style: TextStyle(
                                        color: Color(0xFF6B7280),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(
                                        dialogContext,
                                      ); // Close confirmation
                                      Navigator.pop(context); // Close modal
                                      // Show success toast
                                      showGeneralDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        barrierLabel: 'Success Toast',
                                        barrierColor: Colors.transparent,
                                        transitionDuration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        pageBuilder: (toastContext, anim, secAnim) {
                                          Future.delayed(
                                            const Duration(seconds: 3),
                                            () {
                                              if (Navigator.canPop(
                                                toastContext,
                                              )) {
                                                Navigator.pop(toastContext);
                                              }
                                            },
                                          );
                                          return Center(
                                            child: Material(
                                              color: Colors.transparent,
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 32,
                                                    ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 24,
                                                      vertical: 16,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: const Color(
                                                    0xFF10B981,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.3),
                                                      blurRadius: 20,
                                                      offset: const Offset(
                                                        0,
                                                        8,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: const [
                                                    Icon(
                                                      Icons
                                                          .check_circle_outline,
                                                      color: Colors.white,
                                                      size: 28,
                                                    ),
                                                    SizedBox(width: 16),
                                                    Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Berhasil!',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        SizedBox(height: 4),
                                                        Text(
                                                          'Sertifikat berhasil dihapus.',
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        transitionBuilder:
                                            (ctx, anim, secAnim, child) {
                                              return FadeTransition(
                                                opacity: anim,
                                                child: ScaleTransition(
                                                  scale:
                                                      Tween<double>(
                                                        begin: 0.8,
                                                        end: 1.0,
                                                      ).animate(
                                                        CurvedAnimation(
                                                          parent: anim,
                                                          curve: Curves.easeOut,
                                                        ),
                                                      ),
                                                  child: child,
                                                ),
                                              );
                                            },
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFEF4444),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: const Text(
                                      'Ya, Hapus!',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                transitionBuilder:
                    (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(
                          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOut,
                            ),
                          ),
                          child: child,
                        ),
                      );
                    },
              );
            },
            icon: const Icon(Icons.delete_outline, size: 18),
            label: const Text('Hapus'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        border: Border.all(color: const Color(0xFFBBF7D0)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Color(0xFF10B981),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sertifikat Terverifikasi',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF166534),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Sertifikat ini telah diverifikasi oleh sistem dan sah untuk digunakan sebagai bukti kompetensi.',
                  style: TextStyle(fontSize: 11, color: Colors.green[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}




