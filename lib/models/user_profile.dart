import 'package:flutter/material.dart';

class UserProfile extends ChangeNotifier {
  String _nama = 'Ahmad Rizky';
  String _nim = '102260011';
  String _prodi = 'Informatika';
  String _institusi = 'Institut Teknologi dan Sains Pekalongan';
  String _angkatan = '2023';

  String get nama => _nama;
  String get nim => _nim;
  String get prodi => _prodi;
  String get institusi => _institusi;
  String get angkatan => _angkatan;

  void updateProfile({
    String? nama,
    String? nim,
    String? prodi,
    String? institusi,
    String? angkatan,
  }) {
    if (nama != null) _nama = nama;
    if (nim != null) _nim = nim;
    if (prodi != null) _prodi = prodi;
    if (institusi != null) _institusi = institusi;
    if (angkatan != null) _angkatan = angkatan;
    notifyListeners();
  }
}
