# Laporan Diagram UML Admin - Aplikasi SIMA

---

## 1. Diagram Aktivitas Login

### Gambar 6.1 Diagram Aktivitas Login Admin

> **File:** [activity_login.puml](file:///d:/sima_app/docs/uml/admin/activity/activity_login.puml)

### Tabel 6.1 Diagram Aktivitas Login

| **Elemen** | **Deskripsi** |
|------------|---------------|
| **Activity Diagram Name** | Login |
| **Actor** | Admin |
| **Description** | Activity diagram ini menggambarkan kegiatan admin melakukan login ke aplikasi SIMA |
| **Pre condition** | Admin harus membuka aplikasi SIMA terlebih dahulu |
| **Trigger** | Activity ini dilakukan setelah actor membuka halaman login |

| **Actor Action** | **System Response** |
|------------------|---------------------|
| • Mengakses aplikasi SIMA | • Menampilkan halaman utama |
| • Input ID Admin dan password | • Menampilkan form login |
| • Klik tombol "Masuk" | • Validasi ID dan password |
|  | • Menampilkan dashboard admin |

| **Alternative Flow** | Jika ID dan password salah, sistem menampilkan pesan error |
|---------------------|---|
| **Post Condition** | Admin melihat halaman dashboard |

---

## 2. Diagram Aktivitas Dashboard

### Gambar 6.2 Diagram Aktivitas Dashboard Admin

> **File:** [activity_dashboard.puml](file:///d:/sima_app/docs/uml/admin/activity/activity_dashboard.puml)

### Tabel 6.2 Diagram Aktivitas Dashboard

| **Elemen** | **Deskripsi** |
|------------|---------------|
| **Activity Diagram Name** | Dashboard |
| **Actor** | Admin |
| **Description** | Activity diagram ini menggambarkan kegiatan admin melihat dashboard |
| **Pre condition** | Admin sudah berhasil login ke aplikasi |
| **Trigger** | Activity ini dilakukan setelah login berhasil |

| **Actor Action** | **System Response** |
|------------------|---------------------|
| • Melihat halaman dashboard | • Memuat data statistik |
|  | • Hitung total mahasiswa, dosen, kelas, mata kuliah |
|  | • Menampilkan stat cards, quick actions, class overview |
| • Tap pada komponen | • Navigasi ke halaman terkait |

| **Alternative Flow** | Admin dapat tap stat card, quick action, atau class overview |
|---------------------|---|
| **Post Condition** | Admin melihat informasi dashboard |

---

## 3. Diagram Aktivitas Manajemen Mahasiswa

### Gambar 6.3 Diagram Aktivitas Manajemen Mahasiswa

> **File:** [activity_manajemen_mahasiswa.puml](file:///d:/sima_app/docs/uml/admin/activity/activity_manajemen_mahasiswa.puml)

### Tabel 6.3 Diagram Aktivitas Manajemen Mahasiswa

| **Elemen** | **Deskripsi** |
|------------|---------------|
| **Activity Diagram Name** | Manajemen Mahasiswa |
| **Actor** | Admin |
| **Description** | Activity diagram ini menggambarkan kegiatan admin mengelola data mahasiswa |
| **Pre condition** | Admin sudah login ke aplikasi |
| **Trigger** | Activity ini dilakukan ketika tap menu Mahasiswa |

| **Actor Action** | **System Response** |
|------------------|---------------------|
| • Tap menu Mahasiswa | • Memuat data mahasiswa |
|  | • Menampilkan daftar mahasiswa |
| • Search/Filter | • Filter mahasiswa |
| • Tap kartu mahasiswa | • Buka modal CRUD |
| • Edit/Delete data | • Simpan/Hapus perubahan |
| • Tap FAB (+) | • Buka modal tambah |
| • Input data baru, tap Simpan | • Simpan ke database |

| **Alternative Flow** | - |
|---------------------|---|
| **Post Condition** | Data mahasiswa terupdate |

---

## 4. Diagram Aktivitas Manajemen Dosen

### Gambar 6.4 Diagram Aktivitas Manajemen Dosen

> **File:** [activity_manajemen_dosen.puml](file:///d:/sima_app/docs/uml/admin/activity/activity_manajemen_dosen.puml)

### Tabel 6.4 Diagram Aktivitas Manajemen Dosen

| **Elemen** | **Deskripsi** |
|------------|---------------|
| **Activity Diagram Name** | Manajemen Dosen |
| **Actor** | Admin |
| **Description** | Activity diagram ini menggambarkan kegiatan admin mengelola data dosen |
| **Pre condition** | Admin sudah login ke aplikasi |
| **Trigger** | Activity ini dilakukan ketika tap menu Dosen |

| **Actor Action** | **System Response** |
|------------------|---------------------|
| • Tap menu Dosen | • Memuat data dosen |
|  | • Menampilkan daftar dosen |
| • Search/Filter | • Filter dosen |
| • Tap kartu dosen | • Buka modal CRUD |
| • Edit/Delete data | • Simpan/Hapus perubahan |
| • Tap FAB (+) | • Buka modal tambah |
| • Input data baru, tap Simpan | • Simpan ke database |

| **Alternative Flow** | - |
|---------------------|---|
| **Post Condition** | Data dosen terupdate |

---

## 5. Diagram Aktivitas Manajemen Mata Kuliah

### Gambar 6.5 Diagram Aktivitas Manajemen Mata Kuliah

> **File:** [activity_mata_kuliah.puml](file:///d:/sima_app/docs/uml/admin/activity/activity_mata_kuliah.puml)

### Tabel 6.5 Diagram Aktivitas Manajemen Mata Kuliah

| **Elemen** | **Deskripsi** |
|------------|---------------|
| **Activity Diagram Name** | Manajemen Mata Kuliah |
| **Actor** | Admin |
| **Description** | Activity diagram ini menggambarkan kegiatan admin mengelola mata kuliah |
| **Pre condition** | Admin sudah login ke aplikasi |
| **Trigger** | Activity ini dilakukan ketika tap menu Mata Kuliah |

| **Actor Action** | **System Response** |
|------------------|---------------------|
| • Tap menu Mata Kuliah | • Memuat data mata kuliah |
|  | • Menampilkan daftar MK |
| • Tap kartu MK | • Buka modal detail |
| • Edit MK | • Simpan perubahan |
| • Hapus MK | • Hapus mata kuliah |
| • Assign ke Kelas | • Buka modal assign |
| • Pilih kelas, dosen, simpan | • Simpan assignment |
| • Tap FAB (+), input data | • Simpan MK baru |

| **Alternative Flow** | - |
|---------------------|---|
| **Post Condition** | Data mata kuliah terupdate |

---

## 6. Diagram Aktivitas Jadwal Kuliah

### Gambar 6.6 Diagram Aktivitas Jadwal Kuliah

> **File:** [activity_jadwal_kuliah.puml](file:///d:/sima_app/docs/uml/admin/activity/activity_jadwal_kuliah.puml)

### Tabel 6.6 Diagram Aktivitas Jadwal Kuliah

| **Elemen** | **Deskripsi** |
|------------|---------------|
| **Activity Diagram Name** | Jadwal Kuliah |
| **Actor** | Admin |
| **Description** | Activity diagram ini menggambarkan kegiatan admin mengelola jadwal kuliah |
| **Pre condition** | Admin sudah login ke aplikasi |
| **Trigger** | Activity ini dilakukan ketika tap menu Jadwal Kuliah |

| **Actor Action** | **System Response** |
|------------------|---------------------|
| • Tap menu Jadwal Kuliah | • Memuat data jadwal |
|  | • Menampilkan daftar jadwal |
| • Filter berdasarkan hari | • Filter jadwal |
| • Tap kartu jadwal | • Buka modal detail |
| • Hapus jadwal | • Hapus jadwal dari database |
| • Tap FAB (+) | • Buka modal tambah jadwal |
| • Input kelas, MK, dosen, waktu, ruangan | • Simpan jadwal baru |

| **Alternative Flow** | - |
|---------------------|---|
| **Post Condition** | Data jadwal terupdate |

---

## 7. Diagram Aktivitas Publish KRS

### Gambar 6.7 Diagram Aktivitas Publish KRS

> **File:** [activity_publish_krs.puml](file:///d:/sima_app/docs/uml/admin/activity/activity_publish_krs.puml)

### Tabel 6.7 Diagram Aktivitas Publish KRS

| **Elemen** | **Deskripsi** |
|------------|---------------|
| **Activity Diagram Name** | Publish KRS |
| **Actor** | Admin |
| **Description** | Activity diagram ini menggambarkan kegiatan admin mempublish KRS untuk mahasiswa |
| **Pre condition** | Admin sudah login, data mata kuliah dan kelas sudah tersedia |
| **Trigger** | Activity ini dilakukan ketika tap menu Publish KRS |

| **Actor Action** | **System Response** |
|------------------|---------------------|
| • Tap menu Publish KRS | • Memuat data KRS |
|  | • Menampilkan statistik dan form publish |
| • Pilih kelas | • Load preview mata kuliah |
| • Pilih semester | • Update preview |
| • Set deadline | • Simpan deadline |
| • Tap Publish | • Konfirmasi publish |
| • Konfirmasi | • Buat draft KRS untuk semua mahasiswa |
|  | • Kirim notifikasi ke mahasiswa |

| **Alternative Flow** | Admin dapat melihat status KRS mahasiswa per kelas |
|---------------------|---|
| **Post Condition** | KRS terpublish untuk mahasiswa |

---

## 8. Diagram Aktivitas Publish KHS

### Gambar 6.8 Diagram Aktivitas Publish KHS

> **File:** [activity_publish_khs.puml](file:///d:/sima_app/docs/uml/admin/activity/activity_publish_khs.puml)

### Tabel 6.8 Diagram Aktivitas Publish KHS

| **Elemen** | **Deskripsi** |
|------------|---------------|
| **Activity Diagram Name** | Publish KHS |
| **Actor** | Admin |
| **Description** | Activity diagram ini menggambarkan kegiatan admin mempublish KHS untuk mahasiswa |
| **Pre condition** | Admin sudah login, nilai dari dosen sudah diinput |
| **Trigger** | Activity ini dilakukan ketika tap menu Kalkulasi Nilai, tab Publish |

| **Actor Action** | **System Response** |
|------------------|---------------------|
| • Tap menu Kalkulasi Nilai | • Memuat data kelas |
| • Pilih tab Publish | • Menampilkan status per kelas |
| • Tap kelas | • Buka modal detail |
|  | • Tampilkan daftar mahasiswa + status nilai |
| • Tap Mahasiswa | • Tampilkan detail nilai |
| • Tap Publish | • Cek kelengkapan nilai |
|  | • Generate KHS, kirim notifikasi |

| **Alternative Flow** | Jika nilai belum lengkap, kirim reminder ke dosen |
|---------------------|---|
| **Post Condition** | KHS terpublish untuk mahasiswa |

---

## 9. Diagram Aktivitas Kalkulasi Nilai

### Gambar 6.9 Diagram Aktivitas Kalkulasi Nilai (Konfigurasi Bobot)

> **File:** [activity_kalkulasi_nilai.puml](file:///d:/sima_app/docs/uml/admin/activity/activity_kalkulasi_nilai.puml)

### Tabel 6.9 Diagram Aktivitas Kalkulasi Nilai

| **Elemen** | **Deskripsi** |
|------------|---------------|
| **Activity Diagram Name** | Kalkulasi Nilai (Konfigurasi Bobot) |
| **Actor** | Admin |
| **Description** | Activity diagram ini menggambarkan kegiatan admin mengatur bobot nilai |
| **Pre condition** | Admin sudah login ke aplikasi |
| **Trigger** | Activity ini dilakukan ketika tap menu Kalkulasi Nilai, tab Konfigurasi |

| **Actor Action** | **System Response** |
|------------------|---------------------|
| • Tap menu Kalkulasi Nilai | • Memuat bobot saat ini |
| • Pilih tab Konfigurasi | • Menampilkan slider bobot |
|  | • Tugas, UTS, UAS, Kehadiran |
| • Geser slider bobot | • Hitung total bobot |
| • Tap Simpan | • Cek total = 100% |
|  | • Simpan konfigurasi bobot |

| **Alternative Flow** | Jika total bobot != 100%, tampilkan warning |
|---------------------|---|
| **Post Condition** | Konfigurasi bobot tersimpan |

---

## 10. Diagram Aktivitas Manajemen Tagihan

### Gambar 6.10 Diagram Aktivitas Manajemen Tagihan

> **File:** [activity_tagihan.puml](file:///d:/sima_app/docs/uml/admin/activity/activity_tagihan.puml)

### Tabel 6.10 Diagram Aktivitas Manajemen Tagihan

| **Elemen** | **Deskripsi** |
|------------|---------------|
| **Activity Diagram Name** | Manajemen Tagihan |
| **Actor** | Admin |
| **Description** | Activity diagram ini menggambarkan kegiatan admin mengelola tagihan mahasiswa |
| **Pre condition** | Admin sudah login ke aplikasi |
| **Trigger** | Activity ini dilakukan ketika tap menu Tagihan |

| **Actor Action** | **System Response** |
|------------------|---------------------|
| • Tap menu Tagihan | • Memuat data tagihan |
|  | • Hitung summary, tampilkan daftar |
| • Filter status/tipe | • Filter tagihan |
| • Tap kartu tagihan | • Buka modal detail |
| • Edit nominal/tipe/status | • Simpan perubahan |
| • Hapus tagihan | • Hapus dari database |
| • Tap FAB (+), input data | • Simpan tagihan baru |

| **Alternative Flow** | - |
|---------------------|---|
| **Post Condition** | Data tagihan terupdate |

---

## 11. Diagram Aktivitas Verifikasi Pembayaran

### Gambar 6.11 Diagram Aktivitas Verifikasi Pembayaran

> **File:** [activity_verifikasi_pembayaran.puml](file:///d:/sima_app/docs/uml/admin/activity/activity_verifikasi_pembayaran.puml)

### Tabel 6.11 Diagram Aktivitas Verifikasi Pembayaran

| **Elemen** | **Deskripsi** |
|------------|---------------|
| **Activity Diagram Name** | Verifikasi Pembayaran |
| **Actor** | Admin |
| **Description** | Activity diagram ini menggambarkan kegiatan admin memverifikasi pembayaran |
| **Pre condition** | Admin sudah login, ada pembayaran pending dari mahasiswa |
| **Trigger** | Activity ini dilakukan ketika tap menu Pembayaran |

| **Actor Action** | **System Response** |
|------------------|---------------------|
| • Tap menu Pembayaran | • Memuat data pembayaran |
|  | • Hitung summary, tampilkan daftar |
| • Filter pending | • Tampilkan pembayaran pending |
| • Tap kartu pembayaran | • Buka modal detail |
|  | • Tampilkan info dan bukti transfer |
| • Lihat bukti transfer | • Menampilkan gambar bukti |
| • Tap Approve | • Update status ke Verified |
|  | • Update tagihan mahasiswa |
|  | • Kirim notifikasi ke mahasiswa |
| • Tap Reject, input alasan | • Update status ke Rejected |
|  | • Kirim notifikasi ke mahasiswa |

| **Alternative Flow** | - |
|---------------------|---|
| **Post Condition** | Status pembayaran terupdate |

---

## 12. Diagram Aktivitas Profil

### Gambar 6.12 Diagram Aktivitas Profil Admin

> **File:** [activity_profil.puml](file:///d:/sima_app/docs/uml/admin/activity/activity_profil.puml)

### Tabel 6.12 Diagram Aktivitas Profil

| **Elemen** | **Deskripsi** |
|------------|---------------|
| **Activity Diagram Name** | Profil |
| **Actor** | Admin |
| **Description** | Activity diagram ini menggambarkan kegiatan admin mengelola profil |
| **Pre condition** | Admin sudah login ke aplikasi |
| **Trigger** | Activity ini dilakukan ketika tap menu Profil |

| **Actor Action** | **System Response** |
|------------------|---------------------|
| • Tap menu Profil | • Memuat data admin |
|  | • Menampilkan halaman profil |
| • Pilih tab Identitas | • Tampilkan info admin |
| • Edit data, tap Simpan | • Simpan perubahan |
| • Pilih tab Keamanan | • Tampilkan opsi keamanan |
| • Ubah password / Toggle 2FA | • Update setting keamanan |
| • Pilih tab Aktivitas | • Memuat dan tampilkan log |

| **Alternative Flow** | - |
|---------------------|---|
| **Post Condition** | Data profil terupdate |

---

## 13. Diagram Aktivitas Pengaturan

### Gambar 6.13 Diagram Aktivitas Pengaturan Sistem

> **File:** [activity_pengaturan.puml](file:///d:/sima_app/docs/uml/admin/activity/activity_pengaturan.puml)

### Tabel 6.13 Diagram Aktivitas Pengaturan

| **Elemen** | **Deskripsi** |
|------------|---------------|
| **Activity Diagram Name** | Pengaturan Sistem |
| **Actor** | Admin |
| **Description** | Activity diagram ini menggambarkan kegiatan admin mengatur sistem |
| **Pre condition** | Admin sudah login ke aplikasi |
| **Trigger** | Activity ini dilakukan ketika tap menu Pengaturan |

| **Actor Action** | **System Response** |
|------------------|---------------------|
| • Tap menu Pengaturan | • Memuat settings |
|  | • Menampilkan section settings |
| • Toggle fitur | • Enable/Disable fitur |
| • Setting semester | • Update semester aktif |
| • Backup | • Buat dan download backup |
| • Restore | • Restore database dari file |
| • Export | • Download file export |
| • Clear cache | • Hapus cache |
| • Reset data | • Hapus semua data (dengan konfirmasi) |

| **Alternative Flow** | - |
|---------------------|---|
| **Post Condition** | Pengaturan sistem terupdate |

---

## Daftar File Diagram

### Activity Diagrams
| No | Menu | File |
|----|------|------|
| 1 | Login | `activity/activity_login.puml` |
| 2 | Dashboard | `activity/activity_dashboard.puml` |
| 3 | Manajemen Mahasiswa | `activity/activity_manajemen_mahasiswa.puml` |
| 4 | Manajemen Dosen | `activity/activity_manajemen_dosen.puml` |
| 5 | Mata Kuliah | `activity/activity_mata_kuliah.puml` |
| 6 | Jadwal Kuliah | `activity/activity_jadwal_kuliah.puml` |
| 7 | Publish KRS | `activity/activity_publish_krs.puml` |
| 8 | Publish KHS | `activity/activity_publish_khs.puml` |
| 9 | Kalkulasi Nilai | `activity/activity_kalkulasi_nilai.puml` |
| 10 | Tagihan | `activity/activity_tagihan.puml` |
| 11 | Verifikasi Pembayaran | `activity/activity_verifikasi_pembayaran.puml` |
| 12 | Profil | `activity/activity_profil.puml` |
| 13 | Pengaturan | `activity/activity_pengaturan.puml` |

