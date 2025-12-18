import 'package:flutter/material.dart';

class EditCertificateModal extends StatefulWidget {
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

  const EditCertificateModal({
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
    required this.isExpired,
  });

  @override
  State<EditCertificateModal> createState() => _EditCertificateModalState();
}

class _EditCertificateModalState extends State<EditCertificateModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _subtitleController;
  late TextEditingController _certNumberController;
  late TextEditingController _issuerController;
  late TextEditingController _descriptionController;

  String _selectedCategory = 'kompetensi';
  DateTime? _issueDate;
  DateTime? _expiryDate;
  late bool _isUnlimitedValidity;
  late bool _isActive;
  bool _isLoading = false;
  String? _selectedFileName;

  final List<Map<String, String>> _categories = [
    {'value': 'kompetensi', 'label': 'Sertifikat Kompetensi'},
    {'value': 'pelatihan', 'label': 'Sertifikat Pelatihan'},
    {'value': 'lomba', 'label': 'Sertifikat Lomba'},
    {'value': 'seminar', 'label': 'Sertifikat Seminar'},
    {'value': 'workshop', 'label': 'Sertifikat Workshop'},
    {'value': 'lainnya', 'label': 'Lainnya'},
  ];

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing data
    _nameController = TextEditingController(text: widget.title);
    _subtitleController = TextEditingController(text: widget.subtitle);
    _certNumberController = TextEditingController(text: widget.certId);
    _issuerController = TextEditingController(text: widget.issuer);
    _descriptionController = TextEditingController(
      text:
          'Sertifikat ini diberikan kepada mahasiswa yang telah menyelesaikan program pembelajaran dengan baik.',
    );

    // Parse dates from string (format: "15 Jan 2024")
    _issueDate = _parseDate(widget.issueDate);
    _isUnlimitedValidity = widget.expiryDate == 'Selamanya';
    if (!_isUnlimitedValidity) {
      _expiryDate = _parseDate(widget.expiryDate);
    }
    _isActive = !widget.isExpired;

    // Determine category from title
    if (widget.title.contains('Kompetensi')) {
      _selectedCategory = 'kompetensi';
    } else if (widget.title.contains('Pelatihan')) {
      _selectedCategory = 'pelatihan';
    } else if (widget.title.contains('Lomba')) {
      _selectedCategory = 'lomba';
    } else if (widget.title.contains('Seminar')) {
      _selectedCategory = 'seminar';
    } else if (widget.title.contains('Workshop')) {
      _selectedCategory = 'workshop';
    } else {
      _selectedCategory = 'lainnya';
    }
  }

  DateTime? _parseDate(String dateStr) {
    try {
      // Map Indonesian month names to numbers
      final months = {
        'Jan': 1,
        'Feb': 2,
        'Mar': 3,
        'Maret': 3,
        'Apr': 4,
        'Mei': 5,
        'Jun': 6,
        'Jul': 7,
        'Agu': 8,
        'Sep': 9,
        'Okt': 10,
        'Nov': 11,
        'Des': 12,
      };

      final parts = dateStr.split(' ');
      if (parts.length >= 3) {
        final day = int.tryParse(parts[0]) ?? 1;
        final month = months[parts[1]] ?? 1;
        final year = int.tryParse(parts[2]) ?? 2024;
        return DateTime(year, month, day);
      }
    } catch (e) {
      // Return null if parsing fails
    }
    return null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _subtitleController.dispose();
    _certNumberController.dispose();
    _issuerController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isIssueDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isIssueDate
          ? (_issueDate ?? DateTime.now())
          : (_expiryDate ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4A90E2),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isIssueDate) {
          _issueDate = picked;
        } else {
          _expiryDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      Future.delayed(const Duration(milliseconds: 1500), () {
        setState(() {
          _isLoading = false;
        });

        // Return updated data back to detail modal
        Navigator.of(context).pop({
          'success': true,
          'title': _nameController.text,
          'subtitle': _subtitleController.text,
          'certId': _certNumberController.text,
          'issuer': _issuerController.text,
          'issueDate': _issueDate,
          'expiryDate': _isUnlimitedValidity ? null : _expiryDate,
          'isActive': _isActive,
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
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
              color: Colors.black.withOpacity(0.2),
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
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Edit Sertifikat',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Perbarui data sertifikat',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
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
            ),

            // Form Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama Sertifikat
                      _buildLabel('Nama Sertifikat', required: true),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _nameController,
                        decoration: _buildInputDecoration(
                          'Contoh: Sertifikat Kompetensi Web Development',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama sertifikat wajib diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Subtitle
                      _buildLabel('Bidang/Pencapaian', required: true),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _subtitleController,
                        decoration: _buildInputDecoration(
                          'Contoh: Web Development',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Bidang/pencapaian wajib diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Kategori
                      _buildLabel('Kategori', required: true),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        decoration: _buildInputDecoration('Pilih Kategori'),
                        items: _categories.map((category) {
                          return DropdownMenuItem<String>(
                            value: category['value'],
                            child: Text(category['label']!),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value ?? '';
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Kategori wajib dipilih';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Nomor Sertifikat
                      _buildLabel('Nomor Sertifikat', required: true),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _certNumberController,
                        decoration: _buildInputDecoration(
                          'Contoh: CERT-2024-001',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nomor sertifikat wajib diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Penerbit
                      _buildLabel('Penerbit', required: true),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _issuerController,
                        decoration: _buildInputDecoration('Contoh: Kampus IT'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Penerbit wajib diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Tanggal Terbit
                      _buildLabel('Tanggal Terbit', required: true),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => _selectDate(context, true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _issueDate != null
                                      ? _formatDate(_issueDate)
                                      : 'Pilih tanggal',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: _issueDate != null
                                        ? Colors.black87
                                        : Colors.grey[500],
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.calendar_today,
                                color: Colors.grey[400],
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Masa Berlaku
                      _buildLabel('Berlaku Hingga'),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isUnlimitedValidity = false;
                                });
                              },
                              child: Row(
                                children: [
                                  Radio<bool>(
                                    value: false,
                                    groupValue: _isUnlimitedValidity,
                                    onChanged: (value) {
                                      setState(() {
                                        _isUnlimitedValidity = value!;
                                      });
                                    },
                                    activeColor: const Color(0xFF4A90E2),
                                  ),
                                  const Text(
                                    'Ada Batas Waktu',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isUnlimitedValidity = true;
                                  _expiryDate = null;
                                });
                              },
                              child: Row(
                                children: [
                                  Radio<bool>(
                                    value: true,
                                    groupValue: _isUnlimitedValidity,
                                    onChanged: (value) {
                                      setState(() {
                                        _isUnlimitedValidity = value!;
                                        _expiryDate = null;
                                      });
                                    },
                                    activeColor: const Color(0xFF4A90E2),
                                  ),
                                  const Text(
                                    'Selamanya',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (!_isUnlimitedValidity) ...[
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () => _selectDate(context, false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _expiryDate != null
                                        ? _formatDate(_expiryDate)
                                        : 'Pilih tanggal berakhir',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: _expiryDate != null
                                          ? Colors.black87
                                          : Colors.grey[500],
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.access_time,
                                  color: Colors.grey[400],
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),

                      // Deskripsi
                      _buildLabel('Deskripsi'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 4,
                        decoration: _buildInputDecoration(
                          'Tulis deskripsi tentang sertifikat ini...',
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Status
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Status Aktif',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Tampilkan sertifikat di profil',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                            Switch(
                              value: _isActive,
                              onChanged: (value) {
                                setState(() {
                                  _isActive = value;
                                });
                              },
                              activeColor: const Color(0xFF4A90E2),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Sticky Footer with Action Buttons
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.grey[300]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Batal',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF59E0B),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        shadowColor: const Color(0xFFF59E0B).withOpacity(0.3),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.save, size: 20, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  'Simpan',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, {bool required = false}) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        if (required)
          const Text(
            ' *',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ),
      ],
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontSize: 15, color: Colors.grey[400]),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF4A90E2), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
