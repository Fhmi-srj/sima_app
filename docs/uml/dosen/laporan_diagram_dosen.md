# Laporan Diagram UML Dosen - Aplikasi SIMA

---

## 1. Diagram Aktivitas Login

### Gambar 5.1 Diagram Aktivitas Login Dosen

> **File:** [activity_login.puml](file:///d:/sima_app/docs/uml/dosen/activity/activity_login.puml)

### Tabel 5.1 Diagram Aktivitas Login

| **Elemen** | **Deskripsi** |
|------------|---------------|
| **Activity Diagram Name** | Login |
| **Actor** | Dosen |
| **Description** | Activity diagram ini menggambarkan kegiatan dosen melakukan login ke aplikasi SIMA |
| **Pre condition** | Dosen harus membuka aplikasi SIMA terlebih dahulu |
| **Trigger** | Activity ini dilakukan setelah actor membuka halaman login |

| **Actor Action** | **System Response** |
|------------------|---------------------|
| • Mengakses aplikasi SIMA | • Menampilkan halaman utama |
| • Memilih role "Dosen" | • Menampilkan form login |
| • Input NIP dan password | • Menunggu input |
| • Klik tombol "Masuk" | • Validasi NIP dan password |
|  | • Menampilkan dashboard dosen |

| **Alternative Flow** | Jika NIP dan password salah, sistem menampilkan pesan error |
|---------------------|---|
| **Post Condition** | Dosen melihat halaman dashboard |

---

## 2. Diagram Aktivitas Dashboard

### Gambar 5.2 Diagram Aktivitas Dashboard Dosen

> **File:** [activity_dashboard.puml](file:///d:/sima_app/docs/uml/dosen/activity/activity_dashboard.puml)

### Tabel 5.2 Diagram Aktivitas Dashboard

| **Elemen** | **Deskripsi** |
|------------|---------------|
| **Activity Diagram Name** | Dashboard/Beranda |
| **Actor** | Dosen |
| **Description** | Activity diagram ini menggambarkan kegiatan dosen melihat halaman dashboard |
| **Pre condition** | Dosen sudah berhasil login ke aplikasi |
| **Trigger** | Activity ini dilakukan setelah login berhasil |

| **Actor Action** | **System Response** |
|------------------|---------------------|
| • Melihat halaman dashboard | • Memuat data dosen |
|  | • Memuat jadwal hari ini |
|  | • Memuat pending tasks |
|  | • Menampilkan halaman dashboard |
| • Tap pada komponen | • Navigasi ke halaman terkait |

| **Alternative Flow** | Dosen dapat tap jadwal, task, quick menu atau avatar |
|---------------------|---|
| **Post Condition** | Dosen melihat informasi dashboard |

---

## 3. Diagram Aktivitas Pencarian

### Gambar 5.3 Diagram Aktivitas Pencarian Dosen

> **File:** [activity_pencarian.puml](file:///d:/sima_app/docs/uml/dosen/activity/activity_pencarian.puml)

### Tabel 5.3 Diagram Aktivitas Pencarian

| **Elemen** | **Deskripsi** |
|------------|---------------|
| **Activity Diagram Name** | Pencarian |
| **Actor** | Dosen |
| **Description** | Activity diagram ini menggambarkan kegiatan dosen mencari informasi |
| **Pre condition** | Dosen sudah login ke aplikasi |
| **Trigger** | Activity ini dilakukan ketika tap menu Pencarian |

| **Actor Action** | **System Response** |
|------------------|---------------------|
| • Tap menu Pencarian | • Menampilkan halaman pencarian |
|  | • Menampilkan statistik |
| • Mengetik kata kunci | • Mencari data mahasiswa, kelas, mata kuliah |
| • Melihat hasil | • Menampilkan hasil pencarian |
| • Tap hasil | • Menampilkan detail modal |

| **Alternative Flow** | Jika tidak ada hasil, tampilkan pesan kosong |
|---------------------|---|
| **Post Condition** | Dosen menemukan informasi yang dicari |

---

## 4. Diagram Aktivitas Input Nilai

### Gambar 5.4 Diagram Aktivitas Input Nilai Dosen

> **File:** [activity_input_nilai.puml](file:///d:/sima_app/docs/uml/dosen/activity/activity_input_nilai.puml)

### Tabel 5.4 Diagram Aktivitas Input Nilai

| **Elemen** | **Deskripsi** |
|------------|---------------|
| **Activity Diagram Name** | Input Nilai |
| **Actor** | Dosen |
| **Description** | Activity diagram ini menggambarkan kegiatan dosen menginput nilai mahasiswa |
| **Pre condition** | Dosen sudah login dan memiliki kelas yang diampu |
| **Trigger** | Activity ini dilakukan ketika tap FAB Akademik dan pilih tab Nilai |

| **Actor Action** | **System Response** |
|------------------|---------------------|
| • Tap FAB Akademik | • Menampilkan halaman Akademik |
| • Pilih tab Nilai | • Memuat kelas yang diampu |
|  | • Menampilkan daftar kelas |
| • Tap kartu kelas | • Membuka modal input nilai |
|  | • Menampilkan daftar mahasiswa |
|  | • Memuat nilai kehadiran otomatis |
| • Input nilai Tugas, UTS, UAS | • Menunggu input |
| • Tap Simpan | • Menyimpan data nilai |
|  | • Menampilkan notifikasi sukses |

| **Alternative Flow** | Nilai kehadiran dihitung otomatis dari riwayat absensi |
|---------------------|---|
| **Post Condition** | Data nilai mahasiswa tersimpan |

---

## 5. Diagram Aktivitas Persetujuan KRS

### Gambar 5.5 Diagram Aktivitas Persetujuan KRS Dosen

> **File:** [activity_persetujuan_krs.puml](file:///d:/sima_app/docs/uml/dosen/activity/activity_persetujuan_krs.puml)

### Tabel 5.5 Diagram Aktivitas Persetujuan KRS

| **Elemen** | **Deskripsi** |
|------------|---------------|
| **Activity Diagram Name** | Persetujuan KRS |
| **Actor** | Dosen |
| **Description** | Activity diagram ini menggambarkan kegiatan dosen menyetujui atau menolak KRS mahasiswa bimbingan |
| **Pre condition** | Dosen sudah login dan ada KRS pending dari mahasiswa bimbingan |
| **Trigger** | Activity ini dilakukan ketika tap FAB Akademik dan pilih tab KRS |

| **Actor Action** | **System Response** |
|------------------|---------------------|
| • Tap FAB Akademik | • Menampilkan halaman Akademik |
| • Pilih tab KRS | • Memuat KRS mahasiswa bimbingan |
| • Pilih filter Pending | • Menampilkan KRS pending |
| • Tap kartu KRS | • Membuka modal KRS Approval |
|  | • Menampilkan info mahasiswa |
|  | • Menampilkan daftar mata kuliah dan total SKS |
| • Review mata kuliah | • Menunggu keputusan |
| • Tap Approve | • Update status KRS ke Approved |
|  | • Mengirim notifikasi ke mahasiswa |
| • Tap Reject | • Menampilkan form alasan |
| • Input alasan penolakan | • Update status KRS ke Draft |
|  | • Menyimpan status ditolak dan alasan |
|  | • Mengirim notifikasi ke mahasiswa |

| **Alternative Flow** | Jika ditolak, mahasiswa melihat status ditolak beserta alasan dari dosen wali |
|---------------------|---|
| **Post Condition** | Status KRS mahasiswa terupdate |

---

## 6. Diagram Aktivitas Jadwal Mengajar

### Gambar 5.6 Diagram Aktivitas Jadwal Mengajar Dosen

> **File:** [activity_jadwal_mengajar.puml](file:///d:/sima_app/docs/uml/dosen/activity/activity_jadwal_mengajar.puml)

### Tabel 5.6 Diagram Aktivitas Jadwal Mengajar

| **Elemen** | **Deskripsi** |
|------------|---------------|
| **Activity Diagram Name** | Jadwal Mengajar |
| **Actor** | Dosen |
| **Description** | Activity diagram ini menggambarkan kegiatan dosen melihat jadwal mengajar |
| **Pre condition** | Dosen sudah login ke aplikasi |
| **Trigger** | Activity ini dilakukan ketika tap menu Jadwal |

| **Actor Action** | **System Response** |
|------------------|---------------------|
| • Tap menu Jadwal | • Memuat jadwal dosen |
|  | • Menampilkan tab hari |
|  | • Render jadwal hari aktif |
| • Pilih tab hari lain | • Update tampilan jadwal |
| • Tap kartu jadwal | • Cek status waktu |
|  | • Tampilkan modal sesuai status |

| **Alternative Flow** | Belum mulai: countdown, Berlangsung: modal presensi, Selesai: rekap |
|---------------------|---|
| **Post Condition** | Dosen melihat jadwal atau membuka modal presensi |

---

## 7. Diagram Aktivitas Modal Absensi Mahasiswa

### Gambar 5.7 Diagram Aktivitas Modal Absensi Mahasiswa

> **File:** [activity_modal_absensi.puml](file:///d:/sima_app/docs/uml/dosen/activity/activity_modal_absensi.puml)

### Tabel 5.7 Diagram Aktivitas Modal Absensi Mahasiswa

| **Elemen** | **Deskripsi** |
|------------|---------------|
| **Activity Diagram Name** | Modal Absensi Mahasiswa |
| **Actor** | Dosen |
| **Description** | Activity diagram ini menggambarkan kegiatan dosen mengelola presensi kelas dan verifikasi izin |
| **Pre condition** | Dosen sudah tap jadwal yang sedang berlangsung |
| **Trigger** | Activity ini dilakukan ketika tap kartu jadwal berlangsung |

| **Actor Action** | **System Response** |
|------------------|---------------------|
| • Tap kartu jadwal berlangsung | • Membuka modal presensi |
|  | • Menampilkan statistik hadir/izin/alpha |
|  | • Menampilkan daftar mahasiswa |
| • Melihat statistik | • Menampilkan count per status |
| • Tap mahasiswa izin pending | • Menampilkan detail izin dan alasan |
| • Tap Approve izin | • Update status ke Izin |
| • Tap Reject izin | • Update status ke Alpha |
| • Tutup modal | • Kembali ke halaman jadwal |

| **Alternative Flow** | - |
|---------------------|---|
| **Post Condition** | Status kehadiran mahasiswa terupdate |

---

## 8. Diagram Aktivitas Riwayat Pertemuan

### Gambar 5.8 Diagram Aktivitas Riwayat Pertemuan Dosen

> **File:** [activity_riwayat_pertemuan.puml](file:///d:/sima_app/docs/uml/dosen/activity/activity_riwayat_pertemuan.puml)

### Tabel 5.8 Diagram Aktivitas Riwayat Pertemuan

| **Elemen** | **Deskripsi** |
|------------|---------------|
| **Activity Diagram Name** | Riwayat Pertemuan |
| **Actor** | Dosen |
| **Description** | Activity diagram ini menggambarkan kegiatan dosen melihat riwayat pertemuan (read-only) |
| **Pre condition** | Dosen sudah login ke aplikasi |
| **Trigger** | Activity ini dilakukan ketika tap menu Riwayat Absensi |

| **Actor Action** | **System Response** |
|------------------|---------------------|
| • Tap menu Riwayat Absensi | • Memuat mata kuliah diampu |
|  | • Menampilkan daftar kelas |
| • Tap kartu kelas | • Membuka modal riwayat pertemuan |
| • Melihat daftar pertemuan | • Menampilkan list pertemuan |
| • Tap pertemuan | • Menampilkan detail kehadiran |
| • Melihat detail kehadiran | • Daftar mahasiswa dengan status |
| • Tutup modal | • Kembali ke halaman riwayat |

| **Alternative Flow** | - |
|---------------------|---|
| **Post Condition** | Dosen melihat rekap kehadiran |

---

## 9. Diagram Aktivitas Profil

### Gambar 5.9 Diagram Aktivitas Profil Dosen

> **File:** [activity_profil.puml](file:///d:/sima_app/docs/uml/dosen/activity/activity_profil.puml)

### Tabel 5.9 Diagram Aktivitas Profil

| **Elemen** | **Deskripsi** |
|------------|---------------|
| **Activity Diagram Name** | Profil |
| **Actor** | Dosen |
| **Description** | Activity diagram ini menggambarkan kegiatan dosen mengelola profil |
| **Pre condition** | Dosen sudah login ke aplikasi |
| **Trigger** | Activity ini dilakukan ketika tap avatar atau menu Profil |

| **Actor Action** | **System Response** |
|------------------|---------------------|
| • Tap avatar atau menu Profil | • Memuat data dosen |
|  | • Menampilkan halaman profil |
| • Pilih tab Identitas | • Menampilkan info dosen |
| • Pilih tab Keamanan | • Menampilkan opsi keamanan |
| • Ubah password / Toggle 2FA | • Update setting keamanan |
| • Pilih tab Riwayat | • Memuat dan menampilkan log aktivitas |

| **Alternative Flow** | - |
|---------------------|---|
| **Post Condition** | Dosen melihat informasi profil |

---

## 10. Diagram Aktivitas Pengaturan

### Gambar 5.10 Diagram Aktivitas Pengaturan Dosen

> **File:** [activity_pengaturan.puml](file:///d:/sima_app/docs/uml/dosen/activity/activity_pengaturan.puml)

### Tabel 5.10 Diagram Aktivitas Pengaturan

| **Elemen** | **Deskripsi** |
|------------|---------------|
| **Activity Diagram Name** | Pengaturan |
| **Actor** | Dosen |
| **Description** | Activity diagram ini menggambarkan kegiatan dosen mengatur preferensi |
| **Pre condition** | Dosen sudah login ke aplikasi |
| **Trigger** | Activity ini dilakukan ketika tap icon Settings |

| **Actor Action** | **System Response** |
|------------------|---------------------|
| • Tap icon Settings | • Memuat preferensi |
|  | • Menampilkan halaman pengaturan |
| • Toggle notifikasi | • Update preferensi notifikasi |
| • Tap Ubah Password | • Menampilkan dialog password |
| • Input password baru | • Menyimpan password |
| • Tap Kelola Perangkat | • Menampilkan dialog perangkat |
| • Tap Hubungi Admin | • Menampilkan dialog kontak |
| • Tap Keluar | • Menampilkan konfirmasi logout |
| • Konfirmasi logout | • Menghapus sesi, navigasi ke login |

| **Alternative Flow** | Jika validasi password gagal, tampilkan error |
|---------------------|---|
| **Post Condition** | Preferensi tersimpan atau dosen logout |

---

## Daftar File Diagram

### Activity Diagrams
| No | Menu | File |
|----|------|------|
| 1 | Login | `activity/activity_login.puml` |
| 2 | Dashboard | `activity/activity_dashboard.puml` |
| 3 | Pencarian | `activity/activity_pencarian.puml` |
| 4 | Input Nilai | `activity/activity_input_nilai.puml` |
| 5 | Persetujuan KRS | `activity/activity_persetujuan_krs.puml` |
| 6 | Jadwal Mengajar | `activity/activity_jadwal_mengajar.puml` |
| 7 | Modal Absensi Mahasiswa | `activity/activity_modal_absensi.puml` |
| 8 | Riwayat Pertemuan | `activity/activity_riwayat_pertemuan.puml` |
| 9 | Profil | `activity/activity_profil.puml` |
| 10 | Pengaturan | `activity/activity_pengaturan.puml` |

