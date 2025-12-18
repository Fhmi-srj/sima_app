import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../data/student_data.dart';
import '../data/attendance_data.dart';
import '../models/student_model.dart';

class AttendanceModal extends StatefulWidget {
  final String subject;
  final String lecturer;
  final String time;
  final String room;
  final String session;
  final String date;

  const AttendanceModal({
    super.key,
    required this.subject,
    required this.lecturer,
    required this.time,
    required this.room,
    required this.session,
    required this.date,
  });

  @override
  State<AttendanceModal> createState() => _AttendanceModalState();
}

class _AttendanceModalState extends State<AttendanceModal> {
  bool _isWifiConnected = false;
  String? _selectedIzinReason;
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _customReasonController = TextEditingController();
  PlatformFile? _selectedFile;
  Student? _verifiedStudent;
  bool _isLoading = false;

  @override
  void dispose() {
    _nimController.dispose();
    _customReasonController.dispose();
    super.dispose();
  }

  void _showToast(String message, {bool isError = false}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: isError ? Colors.red : Colors.green,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  Future<void> _checkWifi() async {
    setState(() => _isLoading = true);

    // Simulasi checking WiFi (demo: always connect)
    await Future.delayed(const Duration(milliseconds: 1500));

    setState(() {
      _isWifiConnected = true;
      _isLoading = false;
    });

    _showToast('WiFi Terhubung - Berhasil terhubung ke WiFi Kampus-IT');
  }

  Future<void> _submitAttendance() async {
    final nim = _nimController.text.trim();

    if (nim.isEmpty) {
      _showToast('Silakan masukkan NIM Anda', isError: true);
      return;
    }

    if (!_isWifiConnected) {
      _showToast('Hubungkan ke WiFi Kampus terlebih dahulu', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    // Simulasi verifikasi
    await Future.delayed(const Duration(milliseconds: 1500));

    final studentData = StudentData.getStudentByNim(nim);

    if (studentData == null) {
      setState(() => _isLoading = false);
      _showToast('NIM tidak ditemukan', isError: true);
      return;
    }

    if (studentData.nim != StudentData.currentUser.nim) {
      setState(() => _isLoading = false);
      _showToast('NIM tidak sesuai dengan akun yang login', isError: true);
      return;
    }

    setState(() {
      _verifiedStudent = studentData;
    });

    // Simulasi penyimpanan
    await Future.delayed(const Duration(milliseconds: 1000));

    // Save attendance record
    AttendanceData.recordAttendance(
      studentId: studentData.nim,
      courseCode: widget.subject,
      courseName: widget.subject,
      date: AttendanceData.getTodayFormatted(),
      type: 'hadir',
    );

    setState(() => _isLoading = false);
    _showToast(
      'Absensi Berhasil! ✓ - Terima kasih ${studentData.name}, kehadiran Anda telah tercatat',
    );

    // Auto close after 2 seconds
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) Navigator.pop(context);
  }

  Future<void> _submitIzin() async {
    final nim = _nimController.text.trim();

    if (nim.isEmpty) {
      _showToast('Silakan masukkan NIM Anda', isError: true);
      return;
    }

    if (_selectedIzinReason == null || _selectedIzinReason!.isEmpty) {
      _showToast('Silakan pilih alasan izin', isError: true);
      return;
    }

    if (_selectedIzinReason == 'lainnya' &&
        _customReasonController.text.trim().isEmpty) {
      _showToast('Silakan jelaskan alasan izin Anda', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    // Simulasi verifikasi
    await Future.delayed(const Duration(milliseconds: 1500));

    final studentData = StudentData.getStudentByNim(nim);

    if (studentData == null) {
      setState(() => _isLoading = false);
      _showToast('NIM tidak ditemukan', isError: true);
      return;
    }

    if (studentData.nim != StudentData.currentUser.nim) {
      setState(() => _isLoading = false);
      _showToast('NIM tidak sesuai dengan akun yang login', isError: true);
      return;
    }

    // Simulasi penyimpanan
    await Future.delayed(const Duration(milliseconds: 1000));

    final reasonText = _selectedIzinReason == 'lainnya'
        ? _customReasonController.text
        : _getReasonText(_selectedIzinReason!);

    // Save attendance record for izin
    AttendanceData.recordAttendance(
      studentId: studentData.nim,
      courseCode: widget.subject,
      courseName: widget.subject,
      date: AttendanceData.getTodayFormatted(),
      type: 'izin',
      reason: reasonText,
    );

    setState(() => _isLoading = false);

    _showToast(
      'Permohonan Izin Terkirim! ✓ - Izin Anda ($reasonText) telah tercatat',
    );

    // Auto close after 2 seconds
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) Navigator.pop(context);
  }

  String _getReasonText(String value) {
    switch (value) {
      case 'sakit':
        return 'Sakit';
      case 'keperluan_keluarga':
        return 'Keperluan Keluarga';
      case 'keperluan_kuliah':
        return 'Keperluan Kuliah/Akademik';
      case 'kegiatan_organisasi':
        return 'Kegiatan Organisasi';
      default:
        return value;
    }
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        final file = result.files.first;
        if (file.size > 5 * 1024 * 1024) {
          _showToast('Ukuran file maksimal 5MB', isError: true);
          return;
        }
        setState(() => _selectedFile = file);
      }
    } catch (e) {
      _showToast('Gagal memilih file', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 420,
        maxHeight: screenHeight * 0.85, // 85% of screen height
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            24,
          ), // All corners rounded for centered dialog
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            _buildHeader(),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Schedule Details
                    _buildScheduleDetails(),
                    const SizedBox(height: 24),

                    // WiFi Status
                    _buildWifiStatus(),
                    const SizedBox(height: 24),

                    // Form (conditional based on WiFi status)
                    if (_isWifiConnected)
                      _buildAttendanceForm()
                    else
                      _buildIzinForm(),

                    const SizedBox(height: 24),

                    // Info Box
                    _buildInfoBox(),
                  ],
                ),
              ),
            ),

            // Sticky Footer with Action Buttons
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: _isWifiConnected
                  ? SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitAttendance,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4A90E2),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_circle),
                                  SizedBox(width: 8),
                                  Text(
                                    'Verifikasi & Absen',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitIzin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFA726),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.send),
                                  SizedBox(width: 8),
                                  Text(
                                    'Ajukan Izin',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4A90E2), Color(0xFF5B9FED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.date,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.subject,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Dosen: ${widget.lecturer}',
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleDetails() {
    return Column(
      children: [
        _buildDetailItem(
          icon: Icons.access_time,
          color: const Color(0xFF4A90E2),
          backgroundColor: const Color(0xFFE3F2FD),
          label: 'Waktu',
          value: widget.time,
        ),
        const SizedBox(height: 12),
        _buildDetailItem(
          icon: Icons.location_on,
          color: const Color(0xFF4CAF50),
          backgroundColor: const Color(0xFFE8F5E9),
          label: 'Ruangan',
          value: widget.room,
        ),
        const SizedBox(height: 12),
        _buildDetailItem(
          icon: Icons.info,
          color: const Color(0xFF9C27B0),
          backgroundColor: const Color(0xFFF3E5F5),
          label: 'Sesi',
          value: widget.session,
        ),
      ],
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required Color color,
    required Color backgroundColor,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWifiStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Status Koneksi WiFi',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            if (!_isWifiConnected)
              TextButton(
                onPressed: _isLoading ? null : _checkWifi,
                child: const Text('Cek Ulang'),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _isWifiConnected
                ? const Color(0xFFE8F5E9)
                : const Color(0xFFFFEBEE),
            border: Border.all(
              color: _isWifiConnected
                  ? const Color(0xFF4CAF50)
                  : const Color(0xFFF44336),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _isWifiConnected
                      ? const Color(0xFF4CAF50)
                      : const Color(0xFFF44336),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _isWifiConnected ? Icons.wifi : Icons.wifi_off,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isWifiConnected
                          ? 'Terhubung ke WiFi Kampus'
                          : 'Tidak Terhubung WiFi Kampus',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _isWifiConnected
                            ? const Color(0xFF2E7D32)
                            : const Color(0xFFC62828),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isWifiConnected
                          ? 'SSID: Kampus-IT • Signal: Kuat'
                          : 'Anda harus terhubung ke WiFi "Kampus-IT" untuk melakukan absensi hadir',
                      style: TextStyle(
                        fontSize: 12,
                        color: _isWifiConnected
                            ? const Color(0xFF388E3C)
                            : const Color(0xFFD32F2F),
                      ),
                    ),
                  ],
                ),
              ),
              if (_isWifiConnected)
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFF4CAF50),
                  size: 24,
                ),
            ],
          ),
        ),
        if (!_isWifiConnected) ...[
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _isLoading ? null : _checkWifi,
            icon: _isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.wifi),
            label: Text(_isLoading ? 'Memeriksa WiFi...' : 'Coba Hubungkan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF44336),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAttendanceForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Absensi Hadir',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Masukkan NIM Anda untuk melakukan absensi kehadiran',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 16),

        // NIM Input
        TextField(
          controller: _nimController,
          keyboardType: TextInputType.number,
          maxLength: 10,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            labelText: 'Nomor Induk Mahasiswa (NIM)',
            hintText: 'Contoh: 102230039',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF4A90E2), width: 2),
            ),
            counterText: '',
          ),
        ),

        // Verified Student Data
        if (_verifiedStudent != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              border: Border.all(color: const Color(0xFF4A90E2)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFF4A90E2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _verifiedStudent!.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'NIM: ${_verifiedStudent!.nim}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Program Studi',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            _verifiedStudent!.prodi,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Angkatan',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            _verifiedStudent!.year,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
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
        ],
      ],
    );
  }

  Widget _buildIzinForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Atau Ajukan Izin',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Jika Anda berhalangan hadir, silakan ajukan izin di bawah ini',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 16),

        // NIM Input
        TextField(
          controller: _nimController,
          keyboardType: TextInputType.number,
          maxLength: 10,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            labelText: 'Nomor Induk Mahasiswa (NIM)',
            hintText: 'Contoh: 102230039',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFFFA726), width: 2),
            ),
            counterText: '',
          ),
        ),
        const SizedBox(height: 16),

        // Dropdown Alasan Izin
        _buildCustomDropdown(),

        // Custom Reason TextField
        if (_selectedIzinReason == 'lainnya') ...[
          const SizedBox(height: 16),
          TextField(
            controller: _customReasonController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Detail Alasan',
              hintText: 'Jelaskan alasan izin Anda...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFFFFA726),
                  width: 2,
                ),
              ),
            ),
          ),
        ],
        const SizedBox(height: 16),

        // File Upload
        _buildFileUpload(),
      ],
    );
  }

  Widget _buildCustomDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Alasan Izin *',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedIzinReason,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: InputBorder.none,
            ),
            hint: const Text('Pilih Alasan'),
            icon: const Icon(Icons.keyboard_arrow_down),
            isExpanded: true,
            items: const [
              DropdownMenuItem(value: 'sakit', child: Text('Sakit')),
              DropdownMenuItem(
                value: 'keperluan_keluarga',
                child: Text('Keperluan Keluarga'),
              ),
              DropdownMenuItem(
                value: 'keperluan_kuliah',
                child: Text('Keperluan Kuliah/Akademik'),
              ),
              DropdownMenuItem(
                value: 'kegiatan_organisasi',
                child: Text('Kegiatan Organisasi'),
              ),
              DropdownMenuItem(value: 'lainnya', child: Text('Lainnya')),
            ],
            onChanged: (value) {
              setState(() => _selectedIzinReason = value);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFileUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upload Surat Izin (Opsional)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _pickFile,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.shade300,
                width: 2,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _selectedFile == null
                ? const Column(
                    children: [
                      Icon(Icons.cloud_upload, size: 32, color: Colors.grey),
                      SizedBox(height: 8),
                      Text(
                        'Klik untuk upload surat',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        'PNG, JPG, atau PDF (Max. 5MB)',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      const Icon(
                        Icons.insert_drive_file,
                        color: Color(0xFFFFA726),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _selectedFile!.name,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () => setState(() => _selectedFile = null),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        border: Border.all(color: const Color(0xFFFFA726)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info, color: Color(0xFFF57C00), size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Perhatian',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF57C00),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Pastikan Anda berada di area kampus dan terhubung ke WiFi Kampus-IT untuk melakukan absensi.',
                  style: TextStyle(fontSize: 12, color: Color(0xFFF57C00)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
