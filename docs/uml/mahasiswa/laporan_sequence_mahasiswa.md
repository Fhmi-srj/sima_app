# Laporan Diagram Sequence Mahasiswa - Aplikasi SIMA

---

## 1. Diagram Sequence Login Mahasiswa

### Gambar 4.1 Sequence Diagram Login Mahasiswa

> **File:** [sequence_login.puml](file:///d:/sima_app/docs/uml/mahasiswa/sequence/sequence_login.puml)

Sequence diagram ini menggambarkan proses mahasiswa untuk masuk ke aplikasi SIMA. Mahasiswa harus memilih role "Mahasiswa", kemudian memasukkan NIM dan password untuk login. Sistem akan melakukan validasi kredensial melalui UserData, jika valid maka mahasiswa akan diarahkan ke halaman dashboard, jika tidak valid akan ditampilkan pesan error.

---

## 2. Diagram Sequence Dashboard Mahasiswa

### Gambar 4.2 Sequence Diagram Dashboard Mahasiswa

> **File:** [sequence_dashboard.puml](file:///d:/sima_app/docs/uml/mahasiswa/sequence/sequence_dashboard.puml)

Sequence diagram ini menggambarkan proses mahasiswa melihat halaman dashboard setelah login berhasil. Sistem akan memuat data user, jadwal hari ini, dan notifikasi tagihan. Mahasiswa dapat melihat berbagai komponen dashboard dan melakukan navigasi ke halaman lain melalui quick menu.

---

## 3. Diagram Sequence Pencarian Mahasiswa

### Gambar 4.3 Sequence Diagram Pencarian Mahasiswa

> **File:** [sequence_pencarian.puml](file:///d:/sima_app/docs/uml/mahasiswa/sequence/sequence_pencarian.puml)

Sequence diagram ini menggambarkan proses mahasiswa mencari informasi dalam aplikasi. Mahasiswa dapat mengetik kata kunci pencarian, sistem akan mencari data yang relevan dan menampilkan hasil. Jika hasil ditemukan, mahasiswa dapat tap untuk melihat detail item.

---

## 4. Diagram Sequence Submit KRS Mahasiswa

### Gambar 4.4 Sequence Diagram Submit KRS Mahasiswa

> **File:** [sequence_krs.puml](file:///d:/sima_app/docs/uml/mahasiswa/sequence/sequence_krs.puml)

Sequence diagram ini menggambarkan proses mahasiswa mengajukan Kartu Rencana Studi (KRS). Mahasiswa membuka halaman akademik, melihat draft KRS yang tersedia, memilih mata kuliah yang akan diambil, dan mengajukan KRS untuk disetujui oleh dosen wali. Sistem akan mengirimkan notifikasi ke dosen wali setelah KRS diajukan.

---

## 5. Diagram Sequence Melihat KHS Mahasiswa

### Gambar 4.5 Sequence Diagram Melihat KHS Mahasiswa

> **File:** [sequence_khs.puml](file:///d:/sima_app/docs/uml/mahasiswa/sequence/sequence_khs.puml)

Sequence diagram ini menggambarkan proses mahasiswa melihat Kartu Hasil Studi (KHS). Mahasiswa membuka halaman akademik dan memilih tab KHS. Sistem akan memuat data nilai, menghitung IPK dan IPS, kemudian menampilkan ringkasan nilai per semester beserta detail nilai mata kuliah.

---

## 6. Diagram Sequence Jadwal Kuliah Mahasiswa

### Gambar 4.6 Sequence Diagram Jadwal Kuliah Mahasiswa

> **File:** [sequence_jadwal.puml](file:///d:/sima_app/docs/uml/mahasiswa/sequence/sequence_jadwal.puml)

Sequence diagram ini menggambarkan proses mahasiswa melihat jadwal kuliah. Sistem terlebih dahulu memeriksa status KRS, jika sudah disetujui maka jadwal akan ditampilkan berdasarkan data KRS. Mahasiswa dapat memilih tab hari untuk melihat jadwal hari tersebut dan tap kartu jadwal untuk membuka modal presensi.

---

## 7. Diagram Sequence Keuangan Mahasiswa

### Gambar 4.7 Sequence Diagram Keuangan Mahasiswa

> **File:** [sequence_tagihan.puml](file:///d:/sima_app/docs/uml/mahasiswa/sequence/sequence_tagihan.puml)

Sequence diagram ini menggambarkan proses mahasiswa melihat informasi keuangan. Sistem memuat data tagihan dan menghitung ringkasan total tagihan, yang sudah dibayar, dan yang belum dibayar. Mahasiswa dapat melihat detail tagihan dan riwayat pembayaran.

---

## 8. Diagram Sequence Profil Mahasiswa

### Gambar 4.8 Sequence Diagram Profil Mahasiswa

> **File:** [sequence_profil.puml](file:///d:/sima_app/docs/uml/mahasiswa/sequence/sequence_profil.puml)

Sequence diagram ini menggambarkan proses mahasiswa mengelola profil. Halaman profil memiliki tiga tab yaitu Identitas (informasi pribadi), Keamanan (ubah password, 2FA), dan Riwayat (log aktivitas akun). Mahasiswa dapat mengedit data profil dan mengubah pengaturan keamanan.

---

## 9. Diagram Sequence Kelola Sertifikat Mahasiswa

### Gambar 4.9 Sequence Diagram Kelola Sertifikat Mahasiswa

> **File:** [sequence_sertifikat.puml](file:///d:/sima_app/docs/uml/mahasiswa/sequence/sequence_sertifikat.puml)

Sequence diagram ini menggambarkan proses mahasiswa mengelola sertifikat. Mahasiswa dapat melihat daftar sertifikat yang dimiliki, menambah sertifikat baru melalui form modal, mengedit data sertifikat, dan menghapus sertifikat. Sertifikat dikategorikan berdasarkan status aktif dan kadaluarsa.

---

## 10. Diagram Sequence Pengaturan Mahasiswa

### Gambar 4.10 Sequence Diagram Pengaturan Mahasiswa

> **File:** [sequence_pengaturan.puml](file:///d:/sima_app/docs/uml/mahasiswa/sequence/sequence_pengaturan.puml)

Sequence diagram ini menggambarkan proses mahasiswa mengatur preferensi aplikasi. Mahasiswa dapat mengubah pengaturan notifikasi, tampilan, keamanan, dan melakukan logout. Saat logout, sistem akan menghapus sesi pengguna dan mengarahkan ke halaman login.

---

## 11. Diagram Sequence Absensi Mahasiswa

### Gambar 4.11 Sequence Diagram Absensi Mahasiswa

> **File:** [sequence_absensi.puml](file:///d:/sima_app/docs/uml/mahasiswa/sequence/sequence_absensi.puml)

Sequence diagram ini menggambarkan proses mahasiswa melakukan presensi kelas. Saat tap kartu jadwal, sistem akan mengecek waktu kelas. Jika kelas sedang berlangsung, mahasiswa dapat memilih jenis kehadiran (hadir, izin, sakit). Sistem akan menyimpan data presensi dan menampilkan notifikasi sukses.

---

## Daftar File Diagram Sequence Mahasiswa

| No | Menu | File |
|----|------|------|
| 1 | Login | `sequence/sequence_login.puml` |
| 2 | Dashboard | `sequence/sequence_dashboard.puml` |
| 3 | Pencarian | `sequence/sequence_pencarian.puml` |
| 4 | Submit KRS | `sequence/sequence_krs.puml` |
| 5 | Melihat KHS | `sequence/sequence_khs.puml` |
| 6 | Jadwal Kuliah | `sequence/sequence_jadwal.puml` |
| 7 | Keuangan | `sequence/sequence_tagihan.puml` |
| 8 | Profil | `sequence/sequence_profil.puml` |
| 9 | Kelola Sertifikat | `sequence/sequence_sertifikat.puml` |
| 10 | Pengaturan | `sequence/sequence_pengaturan.puml` |
| 11 | Absensi | `sequence/sequence_absensi.puml` |
