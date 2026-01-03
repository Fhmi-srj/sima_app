# Laporan Diagram UML Mahasiswa - Aplikasi SIMA

---

## 1. Diagram Aktivitas Login

### Gambar 4.1 Diagram Aktivitas Login Mahasiswa

> **File:** [activity_login.puml](file:///d:/sima_app/docs/uml/mahasiswa/activity/activity_login.puml)

### Tabel 4.1 Diagram Aktivitas Login

| **Elemen** | **Deskripsi** |
|------------|---------------|
| **Activity Diagram Name** | Login |
| **Actor** | Mahasiswa |
| **Description** | Activity diagram ini menggambarkan kegiatan mahasiswa melakukan login ke aplikasi SIMA |
| **Pre condition** | Mahasiswa harus membuka aplikasi SIMA terlebih dahulu |
| **Trigger** | Activity ini dilakukan setelah actor membuka halaman login |

| **Actor Action** | **System Response** |
|------------------|---------------------|
| • Mengakses aplikasi SIMA | • Menampilkan splash screen |
| • Memilih role "Mahasiswa" | • Menampilkan halaman login |
| • Input NIM dan password | • Menunggu input |
| • Klik tombol "Masuk" | • Validasi NIM dan password |
|  | • Menampilkan halaman dashboard |

| **Alternative Flow** | Jika NIM dan password salah, sistem menampilkan pesan error |
|---------------------|---|
| **Post Condition** | Mahasiswa melihat halaman dashboard |

---

## 2. Diagram Aktivitas Dashboard/Beranda

### Gambar 4.2 Diagram Aktivitas Dashboard Mahasiswa

> **File:** [activity_dashboard.puml](file:///d:/sima_app/docs/uml/mahasiswa/activity/activity_dashboard.puml)

### Tabel 4.2 Diagram Aktivitas Dashboard

| **Elemen** | **Deskripsi** |
|------------|---------------|
| **Activity Diagram Name** | Dashboard/Beranda |
| **Actor** | Mahasiswa |
| **Description** | Activity diagram ini menggambarkan kegiatan mahasiswa melihat halaman dashboard |
| **Pre condition** | Mahasiswa sudah berhasil login ke aplikasi |
| **Trigger** | Activity ini dilakukan setelah login berhasil |

| **Actor Action** | **System Response** |
|------------------|---------------------|
| • Melihat halaman dashboard | • Memuat data user |
|  | • Memuat jadwal hari ini |
|  | • Memuat notifikasi tagihan |
|  | • Menampilkan komponen dashboard |
| • Tap pada komponen | • Navigasi ke halaman terkait |

| **Alternative Flow** | Mahasiswa dapat tap reminder, jadwal, atau quick menu untuk navigasi |
|---------------------|---|
| **Post Condition** | Mahasiswa melihat informasi dashboard |

---

## 3. Diagram Aktivitas Pencarian

### Gambar 4.3 Diagram Aktivitas Pencarian Mahasiswa

> **File:** [activity_pencarian.puml](file:///d:/sima_app/docs/uml/mahasiswa/activity/activity_pencarian.puml)

### Tabel 4.3 Diagram Aktivitas Pencarian

| **Elemen** | **Deskripsi** |
|------------|---------------|
| **Activity Diagram Name** | Pencarian |
| **Actor** | Mahasiswa |
| **Description** | Activity diagram ini menggambarkan kegiatan mahasiswa mencari informasi |
| **Pre condition** | Mahasiswa sudah login ke aplikasi |
| **Trigger** | Activity ini dilakukan ketika tap menu Pencarian |

| **Actor Action** | **System Response** |
|------------------|---------------------|
| • Tap menu Pencarian | • Menampilkan halaman pencarian |
| • Mengetik kata kunci | • Mencari data |
| • Melihat hasil | • Menampilkan hasil pencarian |
| • Tap hasil | • Menampilkan detail item |

| **Alternative Flow** | Jika tidak ada hasil, tampilkan pesan "Tidak ada hasil" |
|---------------------|---|
| **Post Condition** | Mahasiswa menemukan informasi yang dicari |

---

## 4. Diagram Aktivitas Submit KRS

### Gambar 4.4 Diagram Aktivitas Submit KRS Mahasiswa

> **File:** [activity_krs.puml](file:///d:/sima_app/docs/uml/mahasiswa/activity/activity_krs.puml)

### Tabel 4.4 Diagram Aktivitas Submit KRS

| **Elemen** | **Deskripsi** |
|------------|---------------|
| **Activity Diagram Name** | Submit KRS |
| **Actor** | Mahasiswa |
| **Description** | Activity diagram ini menggambarkan kegiatan mahasiswa mengajukan KRS |
| **Pre condition** | Mahasiswa sudah login dan memiliki KRS draft |
| **Trigger** | Activity ini dilakukan ketika tap FAB Akademik dan pilih tab KRS |

| **Actor Action** | **System Response** |
|------------------|---------------------|
| • Tap FAB Akademik | • Memuat halaman Akademik |
| • Pilih tab KRS | • Memuat data KRS |
| • Pilih tab Draft | • Menampilkan KRS draft |
| • Tap kartu KRS | • Menampilkan detail KRS |
| • Tap "Ajukan KRS" | • Menampilkan konfirmasi |
| • Tap "Konfirmasi Ajukan" | • Mengubah status ke Pending |
|  | • Mengirim notifikasi ke Dosen Wali |
|  | • Menampilkan pesan sukses |

| **Alternative Flow** | - |
|---------------------|---|
| **Post Condition** | KRS terkirim untuk disetujui dosen wali |

---

## 5. Diagram Aktivitas Melihat KHS

### Gambar 4.5 Diagram Aktivitas Melihat KHS Mahasiswa

> **File:** [activity_khs.puml](file:///d:/sima_app/docs/uml/mahasiswa/activity/activity_khs.puml)

### Tabel 4.5 Diagram Aktivitas Melihat KHS

| **Elemen** | **Deskripsi** |
|------------|---------------|
| **Activity Diagram Name** | Melihat KHS |
| **Actor** | Mahasiswa |
| **Description** | Activity diagram ini menggambarkan kegiatan mahasiswa melihat nilai |
| **Pre condition** | Mahasiswa sudah login ke aplikasi |
| **Trigger** | Activity ini dilakukan ketika tap FAB Akademik dan pilih tab KHS |

| **Actor Action** | **System Response** |
|------------------|---------------------|
| • Tap FAB Akademik | • Memuat halaman Akademik |
| • Pilih tab KHS | • Memuat data KHS |
|  | • Menghitung IPK, IPS |
|  | • Menampilkan ringkasan nilai |
| • Melihat daftar semester | • Menampilkan kartu semester |
| • Tap kartu semester | • Menampilkan detail nilai |

| **Alternative Flow** | - |
|---------------------|---|
| **Post Condition** | Mahasiswa melihat nilai akademik |

---

## 6. Diagram Aktivitas Jadwal Kuliah

### Gambar 4.6 Diagram Aktivitas Jadwal Kuliah Mahasiswa

> **File:** [activity_jadwal.puml](file:///d:/sima_app/docs/uml/mahasiswa/activity/activity_jadwal.puml)

### Tabel 4.6 Diagram Aktivitas Jadwal Kuliah

| **Elemen** | **Deskripsi** |
|------------|---------------|
| **Activity Diagram Name** | Jadwal Kuliah |
| **Actor** | Mahasiswa |
| **Description** | Activity diagram ini menggambarkan kegiatan mahasiswa melihat jadwal kuliah |
| **Pre condition** | Mahasiswa sudah login dan KRS disetujui |
| **Trigger** | Activity ini dilakukan ketika tap menu Jadwal |

| **Actor Action** | **System Response** |
|------------------|---------------------|
| • Tap menu Jadwal | • Cek status KRS |
|  | • Memuat jadwal berdasarkan KRS |
|  | • Menampilkan tab hari |
| • Pilih tab hari | • Menampilkan jadwal hari tersebut |
| • Tap kartu jadwal | • Membuka modal presensi |

| **Alternative Flow** | Jika KRS belum disetujui, tampilkan pesan "Ajukan KRS terlebih dahulu" |
|---------------------|---|
| **Post Condition** | Mahasiswa melihat jadwal kuliah |

---

## 7. Diagram Aktivitas Keuangan

### Gambar 4.7 Diagram Aktivitas Keuangan Mahasiswa

> **File:** [activity_tagihan.puml](file:///d:/sima_app/docs/uml/mahasiswa/activity/activity_tagihan.puml)

### Tabel 4.7 Diagram Aktivitas Keuangan

| **Elemen** | **Deskripsi** |
|------------|---------------|
| **Activity Diagram Name** | Melihat Tagihan dan Pembayaran |
| **Actor** | Mahasiswa |
| **Description** | Activity diagram ini menggambarkan kegiatan mahasiswa melihat keuangan |
| **Pre condition** | Mahasiswa sudah login ke aplikasi |
| **Trigger** | Activity ini dilakukan ketika tap menu Keuangan |

| **Actor Action** | **System Response** |
|------------------|---------------------|
| • Tap menu Keuangan | • Memuat data tagihan |
|  | • Menghitung ringkasan |
|  | • Menampilkan tabs |
| • Pilih tab Tagihan | • Menampilkan daftar tagihan |
| • Tap tagihan | • Menampilkan detail pembayaran |
| • Pilih tab Riwayat | • Menampilkan history |

| **Alternative Flow** | - |
|---------------------|---|
| **Post Condition** | Mahasiswa melihat info keuangan |

---

## 8. Diagram Aktivitas Profil

### Gambar 4.8 Diagram Aktivitas Profil Mahasiswa

> **File:** [activity_profil.puml](file:///d:/sima_app/docs/uml/mahasiswa/activity/activity_profil.puml)

### Tabel 4.8 Diagram Aktivitas Profil

| **Elemen** | **Deskripsi** |
|------------|---------------|
| **Activity Diagram Name** | Profil |
| **Actor** | Mahasiswa |
| **Description** | Activity diagram ini menggambarkan kegiatan mahasiswa mengelola profil |
| **Pre condition** | Mahasiswa sudah login ke aplikasi |
| **Trigger** | Activity ini dilakukan ketika tap avatar atau menu Profil |

| **Actor Action** | **System Response** |
|------------------|---------------------|
| • Tap menu Profil | • Memuat data user |
|  | • Menampilkan tabs profil |
| • Pilih tab Identitas | • Menampilkan data identitas |
| • Pilih tab Keamanan | • Menampilkan opsi keamanan |
| • Pilih tab Riwayat | • Menampilkan log aktivitas |

| **Alternative Flow** | - |
|---------------------|---|
| **Post Condition** | Mahasiswa melihat informasi profil |

---

## 9. Diagram Aktivitas Kelola Sertifikat

### Gambar 4.9 Diagram Aktivitas Kelola Sertifikat Mahasiswa

> **File:** [activity_sertifikat.puml](file:///d:/sima_app/docs/uml/mahasiswa/activity/activity_sertifikat.puml)

### Tabel 4.9 Diagram Aktivitas Kelola Sertifikat

| **Elemen** | **Deskripsi** |
|------------|---------------|
| **Activity Diagram Name** | Kelola Sertifikat |
| **Actor** | Mahasiswa |
| **Description** | Activity diagram ini menggambarkan kegiatan mahasiswa mengelola sertifikat |
| **Pre condition** | Mahasiswa sudah login ke aplikasi |
| **Trigger** | Activity ini dilakukan ketika tap menu Sertifikat |

| **Actor Action** | **System Response** |
|------------------|---------------------|
| • Tap menu Sertifikat | • Memuat data sertifikat |
|  | • Menampilkan daftar sertifikat |
| • Tap FAB (+) | • Menampilkan form tambah |
| • Input data sertifikat | • Menyimpan sertifikat baru |
| • Tap kartu sertifikat | • Menampilkan detail |
| • Tap Edit/Hapus | • Edit atau hapus sertifikat |

| **Alternative Flow** | - |
|---------------------|---|
| **Post Condition** | Data sertifikat tersimpan |

---

## 10. Diagram Aktivitas Pengaturan

### Gambar 4.10 Diagram Aktivitas Pengaturan Mahasiswa

> **File:** [activity_pengaturan.puml](file:///d:/sima_app/docs/uml/mahasiswa/activity/activity_pengaturan.puml)

### Tabel 4.10 Diagram Aktivitas Pengaturan

| **Elemen** | **Deskripsi** |
|------------|---------------|
| **Activity Diagram Name** | Pengaturan |
| **Actor** | Mahasiswa |
| **Description** | Activity diagram ini menggambarkan kegiatan mahasiswa mengatur preferensi |
| **Pre condition** | Mahasiswa sudah login ke aplikasi |
| **Trigger** | Activity ini dilakukan ketika tap icon Settings |

| **Actor Action** | **System Response** |
|------------------|---------------------|
| • Tap icon Settings | • Menampilkan halaman pengaturan |
| • Toggle notifikasi | • Menyimpan preferensi |
| • Tap Ubah Password | • Menampilkan dialog password |
| • Tap Keluar | • Menampilkan konfirmasi logout |
| • Konfirmasi logout | • Menghapus sesi, ke halaman login |

| **Alternative Flow** | Jika password tidak valid, tampilkan error |
|---------------------|---|
| **Post Condition** | Preferensi tersimpan atau mahasiswa logout |

---

## 11. Diagram Aktivitas Absensi

### Gambar 4.11 Diagram Aktivitas Absensi Mahasiswa

> **File:** [activity_absensi.puml](file:///d:/sima_app/docs/uml/mahasiswa/activity/activity_absensi.puml)

### Tabel 4.11 Diagram Aktivitas Absensi

| **Elemen** | **Deskripsi** |
|------------|---------------|
| **Activity Diagram Name** | Absensi |
| **Actor** | Mahasiswa |
| **Description** | Activity diagram ini menggambarkan kegiatan mahasiswa melakukan presensi |
| **Pre condition** | Mahasiswa sudah login dan memiliki jadwal |
| **Trigger** | Activity ini dilakukan ketika tap kartu jadwal |

| **Actor Action** | **System Response** |
|------------------|---------------------|
| • Tap kartu jadwal | • Cek waktu kelas |
| • Pilih jenis kehadiran | • Menampilkan modal presensi |
| • Input alasan (jika izin/sakit) | • Menunggu input |
| • Tap Submit | • Menyimpan data presensi |
|  | • Menampilkan notifikasi sukses |

| **Alternative Flow** | - Jika kelas belum mulai: tampilkan countdown |
| | - Jika kelas sudah selesai: tandai Alpha |
|---------------------|---|
| **Post Condition** | Data kehadiran tersimpan |

---

## Daftar File Diagram

### Activity Diagrams
| No | Menu | File |
|----|------|------|
| 1 | Login | `activity/activity_login.puml` |
| 2 | Dashboard | `activity/activity_dashboard.puml` |
| 3 | Pencarian | `activity/activity_pencarian.puml` |
| 4 | Submit KRS | `activity/activity_krs.puml` |
| 5 | Melihat KHS | `activity/activity_khs.puml` |
| 6 | Jadwal Kuliah | `activity/activity_jadwal.puml` |
| 7 | Keuangan | `activity/activity_tagihan.puml` |
| 8 | Profil | `activity/activity_profil.puml` |
| 9 | Kelola Sertifikat | `activity/activity_sertifikat.puml` |
| 10 | Pengaturan | `activity/activity_pengaturan.puml` |
| 11 | Absensi | `activity/activity_absensi.puml` |

