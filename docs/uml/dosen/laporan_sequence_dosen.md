# Laporan Diagram Sequence Dosen - Aplikasi SIMA

---

## 1. Diagram Sequence Login Dosen

### Gambar 5.1 Sequence Diagram Login Dosen

> **File:** [sequence_login.puml](file:///d:/sima_app/docs/uml/dosen/sequence/sequence_login.puml)

Sequence diagram ini menggambarkan proses dosen untuk masuk ke aplikasi SIMA. Dosen harus memilih role "Dosen", kemudian memasukkan NIP dan password untuk login. Sistem akan melakukan validasi kredensial melalui UserData, jika valid maka dosen akan diarahkan ke halaman dashboard dosen.

---

## 2. Diagram Sequence Dashboard Dosen

### Gambar 5.2 Sequence Diagram Dashboard Dosen

> **File:** [sequence_dashboard.puml](file:///d:/sima_app/docs/uml/dosen/sequence/sequence_dashboard.puml)

Sequence diagram ini menggambarkan proses dosen melihat halaman dashboard setelah login berhasil. Sistem akan memuat profil dosen, jadwal mengajar hari ini, dan pending tasks (KRS yang perlu disetujui, izin yang perlu diverifikasi). Dosen dapat navigasi ke berbagai halaman melalui quick menu.

---

## 3. Diagram Sequence Pencarian Dosen

### Gambar 5.3 Sequence Diagram Pencarian Dosen

> **File:** [sequence_pencarian.puml](file:///d:/sima_app/docs/uml/dosen/sequence/sequence_pencarian.puml)

Sequence diagram ini menggambarkan proses dosen mencari informasi dalam aplikasi. Dosen dapat mencari data mahasiswa, kelas, dan mata kuliah. Halaman pencarian juga menampilkan statistik ringkasan dan quick access menu untuk akses cepat ke fitur tertentu.

---

## 4. Diagram Sequence Input Nilai Dosen

### Gambar 5.4 Sequence Diagram Input Nilai Dosen

> **File:** [sequence_input_nilai.puml](file:///d:/sima_app/docs/uml/dosen/sequence/sequence_input_nilai.puml)

Sequence diagram ini menggambarkan proses dosen menginput nilai mahasiswa. Dosen membuka halaman akademik dan memilih tab Nilai. Sistem menampilkan daftar kelas yang diampu. Setelah memilih kelas, dosen dapat menginput nilai Tugas, UTS, dan UAS untuk setiap mahasiswa. Nilai kehadiran dihitung otomatis dari riwayat absensi.

---

## 5. Diagram Sequence Persetujuan KRS Dosen

### Gambar 5.5 Sequence Diagram Persetujuan KRS Dosen

> **File:** [sequence_persetujuan_krs.puml](file:///d:/sima_app/docs/uml/dosen/sequence/sequence_persetujuan_krs.puml)

Sequence diagram ini menggambarkan proses dosen menyetujui atau menolak KRS mahasiswa bimbingan. Dosen melihat daftar KRS pending, dapat mereview mata kuliah yang diambil mahasiswa, kemudian memutuskan untuk approve atau reject. Jika reject, dosen harus memberikan alasan dan status KRS mahasiswa akan kembali ke draft.

---

## 6. Diagram Sequence Jadwal Mengajar Dosen

### Gambar 5.6 Sequence Diagram Jadwal Mengajar Dosen

> **File:** [sequence_jadwal_mengajar.puml](file:///d:/sima_app/docs/uml/dosen/sequence/sequence_jadwal_mengajar.puml)

Sequence diagram ini menggambarkan proses dosen melihat jadwal mengajar. Sistem memuat jadwal mengajar dosen per hari. Dosen dapat memilih tab hari untuk melihat jadwal hari tersebut. Saat tap kartu jadwal, sistem akan mengecek status waktu dan menampilkan modal yang sesuai (countdown, presensi, atau rekap).

---

## 7. Diagram Sequence Modal Absensi Mahasiswa

### Gambar 5.7 Sequence Diagram Modal Absensi Mahasiswa

> **File:** [sequence_modal_absensi.puml](file:///d:/sima_app/docs/uml/dosen/sequence/sequence_modal_absensi.puml)

Sequence diagram ini menggambarkan proses dosen mengelola presensi kelas dan verifikasi izin mahasiswa. Modal presensi menampilkan statistik kehadiran (hadir, izin, alpha) dan daftar mahasiswa. Jika ada mahasiswa dengan status izin pending, dosen dapat melihat alasan izin dan memutuskan untuk approve (ubah status ke izin) atau reject (ubah status ke alpha).

---

## 8. Diagram Sequence Riwayat Pertemuan Dosen

### Gambar 5.8 Sequence Diagram Riwayat Pertemuan Dosen

> **File:** [sequence_riwayat_pertemuan.puml](file:///d:/sima_app/docs/uml/dosen/sequence/sequence_riwayat_pertemuan.puml)

Sequence diagram ini menggambarkan proses dosen melihat riwayat pertemuan (read-only). Dosen memilih mata kuliah yang diampu, kemudian sistem menampilkan daftar pertemuan. Dosen dapat tap pertemuan untuk melihat detail kehadiran mahasiswa per pertemuan tersebut.

---

## 9. Diagram Sequence Profil Dosen

### Gambar 5.9 Sequence Diagram Profil Dosen

> **File:** [sequence_profil.puml](file:///d:/sima_app/docs/uml/dosen/sequence/sequence_profil.puml)

Sequence diagram ini menggambarkan proses dosen mengelola profil. Halaman profil memiliki tiga tab yaitu Identitas (NIP, nama, email, prodi, fakultas), Keamanan (ubah password, 2FA), dan Riwayat (log aktivitas akun). Dosen dapat mengedit data profil dan mengubah pengaturan keamanan.

---

## 10. Diagram Sequence Pengaturan Dosen

### Gambar 5.10 Sequence Diagram Pengaturan Dosen

> **File:** [sequence_pengaturan.puml](file:///d:/sima_app/docs/uml/dosen/sequence/sequence_pengaturan.puml)

Sequence diagram ini menggambarkan proses dosen mengatur preferensi aplikasi. Dosen dapat mengubah pengaturan notifikasi, tampilan, keamanan, kelola perangkat, dan melakukan logout. Saat logout, sistem akan menghapus sesi pengguna dan mengarahkan ke halaman login.

---

## Daftar File Diagram Sequence Dosen

| No | Menu | File |
|----|------|------|
| 1 | Login | `sequence/sequence_login.puml` |
| 2 | Dashboard | `sequence/sequence_dashboard.puml` |
| 3 | Pencarian | `sequence/sequence_pencarian.puml` |
| 4 | Input Nilai | `sequence/sequence_input_nilai.puml` |
| 5 | Persetujuan KRS | `sequence/sequence_persetujuan_krs.puml` |
| 6 | Jadwal Mengajar | `sequence/sequence_jadwal_mengajar.puml` |
| 7 | Modal Absensi Mahasiswa | `sequence/sequence_modal_absensi.puml` |
| 8 | Riwayat Pertemuan | `sequence/sequence_riwayat_pertemuan.puml` |
| 9 | Profil | `sequence/sequence_profil.puml` |
| 10 | Pengaturan | `sequence/sequence_pengaturan.puml` |
