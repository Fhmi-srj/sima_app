# Laporan Diagram Sequence Admin - Aplikasi SIMA

---

## 1. Diagram Sequence Login Admin

### Gambar 6.1 Sequence Diagram Login Admin

> **File:** [sequence_login.puml](file:///d:/sima_app/docs/uml/admin/sequence/sequence_login.puml)

Sequence diagram ini menggambarkan proses admin untuk masuk ke halaman admin. Admin harus memasukkan ID Admin dan password untuk masuk. Sistem akan melakukan validasi kredensial melalui UserData, jika valid maka admin akan diarahkan ke AdminContainer yang menampilkan dashboard admin.

---

## 2. Diagram Sequence Dashboard Admin

### Gambar 6.2 Sequence Diagram Dashboard Admin

> **File:** [sequence_dashboard.puml](file:///d:/sima_app/docs/uml/admin/sequence/sequence_dashboard.puml)

Sequence diagram ini menggambarkan proses admin melihat halaman dashboard. Sistem memuat statistik total mahasiswa, dosen, kelas aktif, dan mata kuliah. Dashboard menampilkan stat cards, quick actions, dan class overview. Admin dapat navigasi ke berbagai halaman melalui komponen ini.

---

## 3. Diagram Sequence Manajemen Mahasiswa

### Gambar 6.3 Sequence Diagram Manajemen Mahasiswa

> **File:** [sequence_manajemen_mahasiswa.puml](file:///d:/sima_app/docs/uml/admin/sequence/sequence_manajemen_mahasiswa.puml)

Sequence diagram ini menggambarkan proses admin mengelola data mahasiswa. Admin dapat melihat daftar mahasiswa, mencari mahasiswa, menambah mahasiswa baru melalui form modal, mengedit data mahasiswa, dan menghapus data mahasiswa. Setiap perubahan data tersimpan ke database melalui UserData.

---

## 4. Diagram Sequence Manajemen Dosen

### Gambar 6.4 Sequence Diagram Manajemen Dosen

> **File:** [sequence_manajemen_dosen.puml](file:///d:/sima_app/docs/uml/admin/sequence/sequence_manajemen_dosen.puml)

Sequence diagram ini menggambarkan proses admin mengelola data dosen. Admin dapat melihat daftar dosen, menambah dosen baru dengan mengisi form nama, NIP, email, jabatan, dan password, mengedit data dosen, dan menghapus data dosen dari sistem.

---

## 5. Diagram Sequence Manajemen Mata Kuliah

### Gambar 6.5 Sequence Diagram Manajemen Mata Kuliah

> **File:** [sequence_mata_kuliah.puml](file:///d:/sima_app/docs/uml/admin/sequence/sequence_mata_kuliah.puml)

Sequence diagram ini menggambarkan proses admin mengelola data mata kuliah. Selain operasi CRUD standar, admin dapat melakukan assign mata kuliah ke kelas dengan memilih kelas tujuan dan dosen pengampu. Data assignment tersimpan sebagai course assignment yang menghubungkan mata kuliah, kelas, dan dosen.

---

## 6. Diagram Sequence Jadwal Kuliah

### Gambar 6.6 Sequence Diagram Jadwal Kuliah

> **File:** [sequence_jadwal_kuliah.puml](file:///d:/sima_app/docs/uml/admin/sequence/sequence_jadwal_kuliah.puml)

Sequence diagram ini menggambarkan proses admin mengelola jadwal kuliah. Admin dapat melihat daftar jadwal dengan filter berdasarkan hari, melihat detail jadwal, dan menghapus jadwal. Untuk menambah jadwal baru, admin harus mengisi kelas, mata kuliah, dosen, hari, waktu, dan ruangan.

---

## 7. Diagram Sequence Publish KRS

### Gambar 6.7 Sequence Diagram Publish KRS

> **File:** [sequence_publish_krs.puml](file:///d:/sima_app/docs/uml/admin/sequence/sequence_publish_krs.puml)

Sequence diagram ini menggambarkan proses admin mempublish KRS untuk mahasiswa. Admin memilih kelas dan semester, sistem akan menampilkan preview mata kuliah. Admin mengatur deadline pengisian KRS, kemudian publish. Sistem akan membuat draft KRS untuk semua mahasiswa di kelas tersebut dan mengirimkan notifikasi.

---

## 8. Diagram Sequence Publish KHS

### Gambar 6.8 Sequence Diagram Publish KHS

> **File:** [sequence_publish_khs.puml](file:///d:/sima_app/docs/uml/admin/sequence/sequence_publish_khs.puml)

Sequence diagram ini menggambarkan proses admin mempublish KHS untuk mahasiswa. Admin melihat status kelengkapan nilai per kelas. Jika nilai sudah lengkap, admin dapat publish KHS dan sistem akan generate KHS serta mengirim notifikasi ke mahasiswa. Jika nilai belum lengkap, sistem akan mengirim reminder ke dosen terkait.

---

## 9. Diagram Sequence Kalkulasi Nilai

### Gambar 6.9 Sequence Diagram Kalkulasi Nilai (Konfigurasi Bobot)

> **File:** [sequence_kalkulasi_nilai.puml](file:///d:/sima_app/docs/uml/admin/sequence/sequence_kalkulasi_nilai.puml)

Sequence diagram ini menggambarkan proses admin mengonfigurasi bobot nilai. Admin dapat mengatur persentase bobot untuk Tugas, UTS, UAS, dan Kehadiran menggunakan slider. Total bobot harus 100% agar dapat disimpan. Konfigurasi ini digunakan untuk menghitung nilai akhir mahasiswa.

---

## 10. Diagram Sequence Manajemen Tagihan

### Gambar 6.10 Sequence Diagram Manajemen Tagihan

> **File:** [sequence_tagihan.puml](file:///d:/sima_app/docs/uml/admin/sequence/sequence_tagihan.puml)

Sequence diagram ini menggambarkan proses admin mengelola tagihan mahasiswa. Admin dapat melihat summary tagihan (total, lunas, belum lunas), filter berdasarkan status atau tipe, melihat detail tagihan, mengedit nominal/tipe/status, menghapus tagihan, dan menambah tagihan baru dengan mencari mahasiswa terlebih dahulu.

---

## 11. Diagram Sequence Verifikasi Pembayaran

### Gambar 6.11 Sequence Diagram Verifikasi Pembayaran

> **File:** [sequence_verifikasi_pembayaran.puml](file:///d:/sima_app/docs/uml/admin/sequence/sequence_verifikasi_pembayaran.puml)

Sequence diagram ini menggambarkan proses admin memverifikasi pembayaran mahasiswa. Admin melihat daftar pembayaran pending, melihat detail pembayaran termasuk bukti transfer, kemudian memutuskan untuk approve atau reject. Jika approve, status tagihan mahasiswa diupdate menjadi lunas. Jika reject, admin harus memberikan alasan penolakan.

---

## 12. Diagram Sequence Profil Admin

### Gambar 6.12 Sequence Diagram Profil Admin

> **File:** [sequence_profil.puml](file:///d:/sima_app/docs/uml/admin/sequence/sequence_profil.puml)

Sequence diagram ini menggambarkan proses admin mengelola profil. Halaman profil memiliki tiga tab yaitu Identitas (informasi admin), Keamanan (ubah password, 2FA), dan Aktivitas (log aktivitas akun). Admin dapat mengedit data profil dan mengubah pengaturan keamanan.

---

## 13. Diagram Sequence Pengaturan Sistem

### Gambar 6.13 Sequence Diagram Pengaturan Sistem

> **File:** [sequence_pengaturan.puml](file:///d:/sima_app/docs/uml/admin/sequence/sequence_pengaturan.puml)

Sequence diagram ini menggambarkan proses admin mengatur sistem. Admin dapat toggle fitur (KRS, nilai, pembayaran), mengatur semester aktif, melakukan backup database, restore dari file backup, export data ke berbagai format, clear cache, dan reset semua data (dengan konfirmasi). Semua aksi berbahaya memerlukan konfirmasi.

---

## Daftar File Diagram Sequence Admin

| No | Menu | File |
|----|------|------|
| 1 | Login | `sequence/sequence_login.puml` |
| 2 | Dashboard | `sequence/sequence_dashboard.puml` |
| 3 | Manajemen Mahasiswa | `sequence/sequence_manajemen_mahasiswa.puml` |
| 4 | Manajemen Dosen | `sequence/sequence_manajemen_dosen.puml` |
| 5 | Mata Kuliah | `sequence/sequence_mata_kuliah.puml` |
| 6 | Jadwal Kuliah | `sequence/sequence_jadwal_kuliah.puml` |
| 7 | Publish KRS | `sequence/sequence_publish_krs.puml` |
| 8 | Publish KHS | `sequence/sequence_publish_khs.puml` |
| 9 | Kalkulasi Nilai | `sequence/sequence_kalkulasi_nilai.puml` |
| 10 | Tagihan | `sequence/sequence_tagihan.puml` |
| 11 | Verifikasi Pembayaran | `sequence/sequence_verifikasi_pembayaran.puml` |
| 12 | Profil | `sequence/sequence_profil.puml` |
| 13 | Pengaturan | `sequence/sequence_pengaturan.puml` |
