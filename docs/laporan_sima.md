# LAPORAN FINAL PROJECT
# RANCANG BANGUN APLIKASI SISTEM INFORMASI AKADEMIK (SIMA)
# BERBASIS MOBILE DENGAN FRAMEWORK FLUTTER

**Referensi: Sistem SIMITNU ITS NU Pekalongan**

---

## ABSTRAK

Sistem informasi akademik merupakan suatu sistem yang mengelola data dan proses akademik dalam sebuah institusi pendidikan tinggi untuk mendukung kegiatan belajar mengajar serta administrasi kampus. Saat ini, Institut Teknologi dan Sains Nahdlatul Ulama (ITS NU) Pekalongan telah memiliki sistem informasi akademik berbasis web bernama SIMITNU, namun aksesibilitas melalui perangkat mobile masih terbatas. Mahasiswa dan dosen membutuhkan waktu lebih untuk mengakses informasi akademik seperti jadwal kuliah, Kartu Rencana Studi (KRS), Kartu Hasil Studi (KHS), dan absensi karena harus membuka browser dan login melalui website. Masalah yang terjadi adalah kurangnya efisiensi dalam mengakses informasi akademik secara cepat, proses pengisian KRS dan pencatatan absensi yang kurang praktis, serta minimnya notifikasi real-time untuk informasi penting seperti tagihan pembayaran dan approval KRS. Maka dari itu, dibuatlah perancangan aplikasi Sistem Informasi Akademik Mobile (SIMA) berbasis Flutter yang terintegrasi dengan sistem SIMITNU. Metode yang digunakan adalah pengembangan aplikasi mobile cross-platform dengan menggunakan alat bantu perancangan sistem berupa Unified Modelling Language (UML). Aplikasi ini dapat mengolah informasi yang lengkap dan transparan tentang data akademik mahasiswa, jadwal perkuliahan, KRS, KHS, absensi, serta manajemen nilai oleh dosen. Dengan menerapkan aplikasi ini, diharapkan dapat mencapai tujuan yang telah ditetapkan yaitu menyediakan akses mobile yang mudah, cepat, dan efisien bagi civitas akademika ITS NU Pekalongan. Perancangan aplikasi SIMA ini menjadi solusi efektif dan efisien untuk memecahkan masalah aksesibilitas sistem informasi akademik di era mobile.

**Kata Kunci:** sistem informasi akademik, aplikasi mobile, Flutter, KRS, KHS, absensi, UML.

---

## DAFTAR ISI

- BAB I PENDAHULUAN
- BAB II GAMBARAN UMUM INSTITUSI
- BAB III LANDASAN TEORI
- BAB IV PERANCANGAN DAN IMPLEMENTASI
- BAB V PENUTUP

---

## BAB I PENDAHULUAN

### 1.1 Latar Belakang

Dalam kehidupan manusia peran teknologi informasi sangatlah krusial dan esensial terutama dalam bidang pendidikan, manajemen maupun dalam kehidupan sehari-hari. Di era digital saat ini, teknologi menjadi bagian yang penting dalam operasional sebuah institusi pendidikan. Institusi pendidikan yang mampu merangkul dan menggunakan teknologi dengan baik akan memiliki keunggulan kompetitif dan peluang yang lebih besar dalam meningkatkan kualitas layanan akademiknya (Wahyudi & Nugroho, 2021). Namun, teknologi saja tidaklah cukup, dibutuhkan juga manajemen yang baik untuk mengelola teknologi tersebut sedemikian rupa sehingga dapat menghasilkan dampak yang positif bagi institusi (Prasetyo, 2022). Manajemen mengelola data berdasarkan informasi yang diperoleh dan diperlukan institusi untuk pengambilan keputusan. Salah satu sistem yang mengorganisasi data mahasiswa, jadwal, nilai, dan laporan secara terintegrasi untuk menyediakan informasi akademik yang dibutuhkan manajemen untuk mengelola institusi dengan lebih mudah yaitu sistem informasi akademik. Pengelolaan sistem informasi akademik yang baik akan memberikan manajemen berbagai informasi, terutama mengenai informasi akademik seperti data mahasiswa, KRS, KHS, jadwal kuliah, dan absensi (Saputra et al., 2023).

Sistem informasi akademik merupakan sistem yang mencakup segala hal terkait pengelolaan data akademik mahasiswa dan dosen. Selain menentukan jadwal perkuliahan yang harus diikuti, sistem ini juga melibatkan proses pencatatan kehadiran, pengisian Kartu Rencana Studi (KRS), dan penyajian Kartu Hasil Studi (KHS) kepada mahasiswa (Hidayat et al., 2021). Saat ini, Institut Teknologi dan Sains Nahdlatul Ulama (ITS NU) Pekalongan telah memiliki sistem informasi akademik berbasis web bernama SIMITNU (Sistem Informasi Manajemen Terpadu ITS NU). Namun, masih terdapat beberapa permasalahan yang berkaitan dengan aksesibilitas sistem tersebut. Salah satu permasalahan yang sering terjadi adalah mahasiswa dan dosen membutuhkan waktu lebih untuk mengakses informasi akademik karena harus membuka browser terlebih dahulu dan login melalui website. Selain itu, terdapat juga masalah terkait dengan ketidakpraktisan dalam proses pengisian KRS dan pencatatan absensi yang masih harus dilakukan melalui website, yang dapat mempengaruhi efisiensi waktu mahasiswa dan dosen. Selain itu, sistem berbasis web yang kurang responsif di perangkat mobile dan terkadang masih memerlukan koneksi internet yang stabil, menyebabkan banyak kendala dalam mengakses informasi akademik secara cepat. Hal ini dapat menimbulkan ketidaknyamanan bagi mahasiswa dan dosen, serta menimbulkan keterlambatan dalam proses akademik. Oleh karena itu, penting bagi institusi untuk mengadopsi sistem informasi akademik berbasis mobile yang lebih praktis, efisien, dan dapat diakses kapan saja, guna meningkatkan kualitas layanan akademik serta kepuasan mahasiswa dan dosen (Firmansyah, 2022). Salah satu bentuk teknologi yang dapat digunakan dalam membuat sebuah aplikasi mobile yaitu framework Flutter.

Flutter merupakan framework open-source dari Google yang dapat digunakan untuk membangun aplikasi mobile cross-platform melalui proses pengembangan yang efisien (Google, 2023). Flutter menggunakan bahasa pemrograman Dart yang mendukung paradigma Object-Oriented Programming (OOP) dan reactive programming. Pada tahap perancangan, penggunaan diagram UML (Unified Modeling Language) dapat menggambarkan proses perancangan aplikasi secara lebih terstruktur. Unified Modeling Language (UML) adalah sebuah bahasa pemodelan grafis yang digunakan untuk merancang, mendokumentasikan, dan memahami sistem perangkat lunak (Sommerville, 2019). UML memungkinkan para pengembang perangkat lunak untuk menggambarkan struktur, perilaku, dan interaksi sistem secara visual dengan menggunakan notasi yang konsisten.

Menurut (Rahman & Wibowo, 2022) dalam penelitiannya yang berjudul Implementasi Diagram UML Pada Perancangan Aplikasi Mobile menjelaskan bahwa Diagram UML dapat digunakan untuk menggambarkan sistem secara visual dan mudah dimengerti oleh semua pihak terkait. Selain itu penggunaan Diagram UML dalam perancangan aplikasi mobile dapat membantu dalam memudahkan pemahaman sistem, mengurangi risiko kesalahan, dan meningkatkan efisiensi pengembangan aplikasi.

Berdasarkan uraian di atas, untuk mengatasi permasalahan tersebut, dirancanglah suatu aplikasi yang dibangun menggunakan framework Flutter dengan menggunakan alat bantu perancangan sistem berupa Unified Modelling Language (UML). Sebagaimana dapat memperoleh informasi yang lengkap dan transparan tentang data akademik mahasiswa dan dirancanglah sebuah aplikasi Sistem Informasi Akademik Mobile (SIMA) yang terintegrasi dengan sistem SIMITNU ITS NU Pekalongan.

Dengan menerapkan rekomendasi ini, diharapkan institusi dapat mencapai tujuan yang telah ditetapkan yaitu Perancangan Aplikasi Sistem Informasi Akademik Mobile Berbasis Flutter. Dengan adanya perancangan aplikasi SIMA ini diharapkan dapat membantu dalam menyediakan akses mobile yang mudah dan cepat bagi civitas akademika sehingga dapat memecahkan persoalan dalam hal aksesibilitas informasi akademik, serta membantu dalam mengelola proses akademik seperti KRS, KHS, jadwal, dan absensi secara lebih efisien.

### 1.2 Rumusan Masalah

Berdasarkan Latar Belakang di atas, maka didapat rumusan masalah adalah:

1. Proses akses informasi akademik yang masih harus melalui browser website sehingga memakan banyak waktu dan kurang praktis di perangkat mobile.
2. Seringnya terjadi ketidaknyamanan dalam pengisian KRS dan pencatatan absensi karena masih menggunakan sistem berbasis web yang kurang responsif di mobile.
3. Minimnya notifikasi real-time untuk informasi penting seperti approval KRS dan tagihan pembayaran.

### 1.3 Batasan Masalah

Berdasarkan rumusan masalah yang telah dipaparkan, dapat diambil batasan masalah yaitu sebagai berikut:

1. Aplikasi dikembangkan menggunakan framework Flutter untuk platform Android dan iOS.
2. Aplikasi menggunakan data statis untuk keperluan demo dan pengujian, tanpa integrasi langsung ke database SIMITNU.
3. Fokus pengembangan pada 3 role pengguna yaitu Mahasiswa, Dosen, dan Admin.
4. Fitur yang dikembangkan meliputi jadwal kuliah, KRS, KHS, absensi, input nilai, dan manajemen data.

### 1.4 Tujuan

Tujuan dari Final Project ini adalah:

1. Menerapkan pengetahuan dan konsep perancangan sistem dalam pengembangan aplikasi mobile berbasis Flutter.
2. Merancang dan mengembangkan aplikasi Sistem Informasi Akademik Mobile (SIMA) yang terintegrasi dengan konsep sistem SIMITNU.
3. Untuk menerapkan teori dan keterampilan yang telah dipelajari di ITS NU Pekalongan dalam pengembangan aplikasi mobile.
4. Mengembangkan keterampilan praktis dalam perancangan aplikasi, seperti analisis kebutuhan, perancangan antarmuka, pemodelan UML, pengujian, dan dokumentasi.

### 1.5 Manfaat

Adapun manfaat yang diharapkan sesuai penelitian yang dibuat antara lain:

1. **Bagi Institusi**
   
   Membantu institusi untuk menyediakan layanan informasi akademik yang lebih mudah diakses melalui perangkat mobile, sehingga meningkatkan kualitas layanan akademik dan kepuasan civitas akademika.

2. **Bagi Mahasiswa**
   
   Memudahkan mahasiswa dalam mengakses jadwal kuliah, submit KRS, melihat KHS, melakukan absensi, dan melihat tagihan pembayaran kapan saja dan di mana saja melalui smartphone.

3. **Bagi Dosen**
   
   Memudahkan dosen dalam mengelola absensi mahasiswa, melakukan approval KRS mahasiswa bimbingan, dan input nilai komponen secara mobile.

4. **Bagi Penulis**
   
   Menambah wawasan, ilmu dan pengetahuan dalam membuat perancangan dan pengembangan aplikasi mobile berbasis Flutter.

---

## BAB II GAMBARAN UMUM SISTEM SIMITNU

### 2.1 Pengertian SIMITNU

SIMITNU (Sistem Informasi Manajemen Terpadu ITS NU) merupakan sistem informasi akademik berbasis web yang dapat diakses melalui alamat **simitnu.itsnupekalongan.ac.id**. Sistem ini digunakan oleh Institut Teknologi dan Sains Nahdlatul Ulama (ITS NU) Pekalongan untuk mengelola seluruh proses akademik secara digital.

SIMITNU menjadi tulang punggung operasional akademik di ITS NU Pekalongan, mencakup pengelolaan data mahasiswa, dosen, mata kuliah, jadwal perkuliahan, nilai, hingga administrasi keuangan. Sistem ini dapat diakses melalui browser web oleh mahasiswa, dosen, dan admin dengan hak akses yang berbeda sesuai dengan peran masing-masing.

### 2.2 Tampilan dan Fitur SIMITNU

Setelah login, mahasiswa akan melihat halaman dashboard yang menampilkan informasi profil berupa foto, nama lengkap, program studi, dan NIM. Di bagian tengah terdapat tabel Kinerja Pembelajaran yang menampilkan ringkasan akademik meliputi tahun akademik aktif, jumlah SKS yang diambil, IPK, predikat kelulusan, serta total poin SKPI. Selain itu terdapat juga section Pengumuman untuk informasi penting dari institusi dan tombol Cetak Kartu Ujian.

SIMITNU menyediakan menu navigasi di sidebar kiri yang terdiri dari Beranda, Jadwal Kuliah, KRS Mahasiswa, KHS Mahasiswa, Nilai Kumulatif, Keuangan, Profil Mahasiswa, Ubah Password, dan Logout. Melalui menu-menu ini, mahasiswa dapat mengakses seluruh fitur akademik yang dibutuhkan mulai dari pengisian KRS, melihat nilai, hingga cek tagihan pembayaran.

Untuk modul dosen, SIMITNU menyediakan fitur jadwal mengajar, absensi mahasiswa per mata kuliah, input nilai komponen (Tugas, UTS, UAS), serta fitur perwalian untuk approval KRS mahasiswa bimbingan. Sedangkan modul admin memiliki akses penuh untuk manajemen data master mahasiswa dan dosen, manajemen mata kuliah dan kelas, manajemen jadwal dan ruangan, serta manajemen keuangan dan tagihan.

### 2.3 Keterbatasan SIMITNU

Meskipun SIMITNU telah berjalan dengan baik sebagai sistem informasi akademik berbasis web, terdapat beberapa keterbatasan yang menjadi dasar pengembangan aplikasi SIMA. Pertama, aksesibilitas mobile terbatas karena SIMITNU hanya dapat diakses melalui browser web sehingga pengguna harus membuka browser dan login setiap kali ingin mengakses informasi. Kedua, tampilan web SIMITNU belum sepenuhnya responsif di perangkat mobile sehingga pengalaman pengguna kurang optimal saat diakses melalui smartphone. Ketiga, pengguna tidak mendapatkan notifikasi real-time untuk informasi penting seperti approval KRS, jadwal kuliah, atau tagihan pembayaran. Keempat, pengguna harus selalu terhubung ke internet dan membuka browser untuk mengakses informasi akademik.

### 2.4 Kebutuhan Pengembangan SIMA

Berdasarkan keterbatasan SIMITNU di atas, dibutuhkan pengembangan aplikasi mobile SIMA yang dapat memberikan akses cepat melalui satu tap di smartphone, tampilan yang dirancang khusus untuk perangkat mobile dengan user experience yang optimal dan modern, serta fitur-fitur yang serupa dengan SIMITNU sehingga pengguna familiar dengan navigasi dan fungsinya. Selain itu, aplikasi SIMA juga diharapkan memiliki fitur absensi modern dengan verifikasi WiFi dan input NIM untuk memastikan kehadiran mahasiswa yang lebih akurat, serta mendukung multi-role access untuk mahasiswa, dosen, dan admin dengan fitur yang sesuai dengan kebutuhan masing-masing peran.

---

## BAB III LANDASAN TEORI

### 3.1 Sistem Informasi

Sistem Informasi (SI) adalah hasil dari penggabungan antara teknologi informasi dan aktivitas manusia yang memanfaatkannya untuk mendukung operasional dan manajemen. Sistem informasi terdiri dari kombinasi teratur antara orang, perangkat lunak, perangkat keras, jaringan komunikasi, dan sumber daya data yang berperan dalam pengumpulan, transformasi, dan penyebaran informasi di dalam sebuah perusahaan maupun organisasi (Anggraeni, 2017).

Sistem informasi memiliki peranan yang sangat penting dalam sebuah organisasi. Dengan adanya sistem informasi, organisasi dapat memastikan bahwa informasi yang disajikan memiliki kualitas yang baik, dan dapat mengambil keputusan berdasarkan informasi dengan cepat, tepat, dan akurat (Riswanda & Priandika, 2021). Sistem informasi menghubungkan berbagai kebutuhan pengolahan transaksi sehari-hari, mendukung operasi, manajemen, dan kegiatan strategis organisasi.

### 3.2 Flutter

Flutter adalah framework open-source yang dikembangkan oleh Google untuk membangun aplikasi mobile, web, dan desktop dari satu codebase tunggal. Flutter menggunakan bahasa pemrograman Dart dan menyediakan widget-widget yang kaya untuk membangun antarmuka pengguna yang menarik dan responsif (Google, 2023).

Salah satu keunggulan utama Flutter adalah kemampuan cross-platform, di mana pengembang dapat menulis kode sekali dan menjalankannya di berbagai platform seperti Android, iOS, Web, dan Desktop. Flutter juga menyediakan fitur Hot Reload yang memungkinkan pengembang melihat perubahan kode secara real-time tanpa harus melakukan kompilasi ulang seluruh aplikasi (Napoli, 2019).

Flutter menggunakan arsitektur widget-based, di mana seluruh elemen UI dibangun dari widget. Terdapat dua jenis widget utama yaitu StatelessWidget untuk komponen yang tidak berubah dan StatefulWidget untuk komponen yang memiliki state dan dapat berubah seiring waktu.

### 3.3 Dart

Dart adalah bahasa pemrograman yang dikembangkan oleh Google dan digunakan sebagai bahasa utama dalam pengembangan aplikasi Flutter. Dart merupakan bahasa yang strongly-typed, object-oriented, dan mendukung paradigma pemrograman reaktif (Kopec, 2021).

Dart memiliki sintaks yang mirip dengan bahasa pemrograman modern lainnya seperti Java, JavaScript, dan C#, sehingga mudah dipelajari oleh pengembang yang sudah familiar dengan bahasa-bahasa tersebut. Dart juga mendukung fitur-fitur modern seperti async/await untuk pemrograman asynchronous, null safety untuk mencegah null pointer exceptions, dan extension methods untuk menambahkan fungsionalitas pada class yang sudah ada.

### 3.4 Widget Flutter

Widget adalah elemen dasar dalam pembangunan antarmuka pengguna pada Flutter. Setiap elemen visual dalam aplikasi Flutter, mulai dari tombol, teks, hingga layout, semuanya adalah widget. Flutter menyediakan berbagai widget bawaan yang dapat digunakan untuk membangun UI, seperti Container, Row, Column, Text, Image, dan lain-lain (Windmill, 2020).

Widget dalam Flutter bersifat immutable, artinya setelah dibuat, widget tidak dapat diubah. Untuk membuat UI yang dinamis, Flutter menggunakan konsep rebuild di mana widget lama akan digantikan dengan widget baru yang memiliki konfigurasi berbeda. Proses ini dilakukan secara efisien oleh Flutter engine sehingga tidak mempengaruhi performa aplikasi.

### 3.5 Figma

Figma adalah aplikasi desain grafis berbasis cloud untuk merancang prototype dan user interface untuk produk digital seperti aplikasi mobile dan website. Figma dapat diakses secara gratis dan dapat dijalankan melalui browser web tanpa memerlukan instalasi software tambahan (Staiano, 2022).

Dengan Figma, pengguna dapat membuat prototipe interaktif, mendesain tata letak halaman aplikasi mobile, serta berkolaborasi dengan tim desain lainnya secara efisien melalui fitur real-time editing. Kelebihan utama dari Figma adalah kemampuannya dalam menyediakan aksesibilitas yang mudah bagi semua orang, sehingga memungkinkan kerja sama dan revisi desain secara real-time (Schwarz, 2023).

### 3.6 UML (Unified Modeling Language)

Unified Modeling Language (UML) adalah suatu bahasa grafis yang digunakan untuk menggambarkan, menjelaskan, membangun, dan mendokumentasikan elemen-elemen dari sebuah sistem perangkat lunak. UML dapat digunakan sebagai standar untuk membuat rancangan sebuah sistem, yang meliputi aspek konseptual seperti proses bisnis dan fungsi sistem, serta aspek yang lebih konkret seperti pernyataan dalam bahasa pemrograman dan komponen sistem (Fu'adi et al., 2022).

Penggunaan UML bertujuan untuk menyediakan representasi visual yang umum digunakan dalam perancangan sistem informasi berbasis objek, analisis sistem perangkat lunak, dan teknik pemodelan perangkat lunak. UML digunakan untuk menggambarkan sistem dalam bentuk diagram atau gambar untuk menganalisis dan merancang sistem perangkat lunak, termasuk aplikasi mobile (Abdillah et al., 2019).

### 3.7 Use Case Diagram

Use case diagram merupakan representasi grafis yang digunakan untuk menggambarkan fungsi-fungsi suatu sistem dari sudut pandang pengguna (Setiyani, 2021). Diagram ini digunakan untuk menyampaikan interaksi antara pengguna (aktor) dengan kemampuan yang dimiliki oleh sistem. Use case menjelaskan tentang tindakan atau aksi yang dilakukan oleh aktor, sedangkan aktor adalah seseorang atau sistem lain yang berinteraksi dengan sistem yang sedang dikembangkan.

Komponen utama dalam use case diagram meliputi aktor yang merepresentasikan pengguna sistem, use case yang merepresentasikan fungsionalitas sistem, serta relasi-relasi seperti asosiasi, include, dan extend yang menghubungkan aktor dengan use case.

### 3.8 Activity Diagram

Activity diagram adalah sebuah representasi grafis yang menggambarkan aliran data atau kontrol, aksi-aksi terstruktur, dan desain dalam sebuah sistem. Diagram ini menunjukkan langkah-langkah konkret dalam proses bisnis atau perilaku sistem, serta bagaimana aktivitas-aktivitas tersebut terhubung satu sama lain (Arianti et al., 2022).

Activity diagram membantu dalam memahami urutan aktivitas, kegiatan paralel, dan pengambilan keputusan dalam suatu sistem, sehingga memudahkan analisis dan perancangan sistem yang efisien. Komponen utama dalam activity diagram meliputi status awal, status akhir, aktivitas, percabangan, penggabungan, dan decision.

### 3.9 Sequence Diagram

Sequence diagram digunakan untuk menggambarkan objek-objek yang terlibat dalam sebuah use case dan menggambarkan aliran pesan antara objek-objek tersebut. Diagram ini menunjukkan aktivitas objek secara dinamis berdasarkan urutan waktu (Abdillah et al., 2019).

Komponen utama dalam sequence diagram meliputi lifeline yang merepresentasikan objek atau aktor, message yang menggambarkan komunikasi antar objek, dan activation bar yang menunjukkan periode waktu di mana objek sedang aktif melakukan proses.

---

## BAB IV HASIL DAN PEMBAHASAN

### 4.1 Perancangan Sistem

Sistem yang dibangun terdiri dari 3 hak akses yaitu untuk Mahasiswa, Dosen, dan Admin. Admin adalah pengguna yang bertugas mengelola data master sistem seperti data mahasiswa, dosen, mata kuliah, kelas, dan verifikasi pembayaran. Dosen memiliki akses untuk mengelola absensi, input nilai, dan approval KRS mahasiswa bimbingan. Sedangkan Mahasiswa dapat mengakses informasi akademik seperti jadwal kuliah, KRS, KHS, absensi, dan keuangan.

### 4.2 Hasil dan Pembahasan

#### 4.2.1 Diagram Use Case

Diagram ini menggambarkan fungsional dari sistem dan bagaimana input dan output sistem bekerja. Berikut diagram use case dari sistem SIMA:

*(Gambar 4.1 Diagram Use Case Aplikasi SIMA)*

| No. | Actor | Description |
|-----|-------|-------------|
| 1 | Mahasiswa | Mahasiswa mempunyai hak akses untuk login/logout, melihat dashboard/beranda, melihat jadwal matkul, melakukan absensi, submit KRS, melihat KHS, melihat tagihan, melakukan pembayaran, melihat profil, melakukan pencarian, dan mengubah pengaturan. |
| 2 | Dosen | Dosen mempunyai hak akses untuk login/logout, melihat dashboard/beranda, melihat jadwal matkul, mengelola riwayat absensi, approve KRS mahasiswa bimbingan, input nilai, melihat profil, dan mengubah pengaturan. |
| 3 | Admin | Admin mempunyai hak akses untuk kelola tagihan, kelola sertifikat, kelola mahasiswa, kelola jadwal, publikasi KHS, kelola dosen, kelola kelas, kelola matkul, dan verifikasi pembayaran. |

#### 4.2.2 Diagram Aktivitas

Diagram aktivitas memvisualisasikan urutan dan aliran kegiatan yang terjadi dalam suatu proses, termasuk keputusan, perulangan, dan tindakan paralel.

**A. Mahasiswa**

**1. Diagram Aktivitas Login**

*(Gambar 4.2 Diagram Aktivitas Login)*

| Atribut | Deskripsi |
|---------|-----------|
| Activity Diagram Name | Login |
| Actor | Mahasiswa, Dosen |
| Description | Activity diagram ini menggambarkan kegiatan user melakukan login |
| Pre condition | User harus membuka aplikasi SIMA terlebih dahulu |
| Trigger | Activity ini dilakukan setelah actor membuka halaman login |
| Typical course of event | Actor: Mengakses aplikasi SIMA, Input NIM/NIP dan password, Klik login. System: Menampilkan halaman login, Cek kredensial, Menampilkan dashboard sesuai role |
| Alternative flow | Jika NIM/NIP dan password salah, maka sistem akan menampilkan pesan error |
| Post condition | Melihat halaman dashboard sesuai role pengguna |

**2. Diagram Aktivitas Submit KRS**

*(Gambar 4.3 Diagram Aktivitas Submit KRS)*

| Atribut | Deskripsi |
|---------|-----------|
| Activity Diagram Name | Submit KRS |
| Actor | Mahasiswa |
| Description | Activity diagram ini menggambarkan kegiatan mahasiswa submit KRS |
| Pre condition | Mahasiswa harus melakukan login terlebih dahulu |
| Trigger | Activity ini dilakukan setelah actor memilih menu KRS |
| Typical course of event | Actor: Memilih menu KRS, Pilih mata kuliah, Klik submit. System: Menampilkan daftar matkul, Validasi SKS, Simpan KRS dan kirim ke Dosen PA |
| Alternative flow | Jika SKS melebihi batas, maka sistem akan menampilkan pesan error |
| Post condition | KRS tersimpan dengan status draft dan menunggu approval Dosen PA |

**3. Diagram Aktivitas Melihat KHS**

*(Gambar 4.4 Diagram Aktivitas Melihat KHS)*

| Atribut | Deskripsi |
|---------|-----------|
| Activity Diagram Name | Melihat KHS |
| Actor | Mahasiswa |
| Description | Activity diagram ini menggambarkan kegiatan mahasiswa melihat KHS |
| Pre condition | Mahasiswa harus melakukan login terlebih dahulu |
| Trigger | Activity ini dilakukan setelah actor memilih menu KHS |
| Typical course of event | Actor: Memilih menu KHS, Pilih semester. System: Menampilkan daftar semester, Menampilkan nilai dan IP semester |
| Alternative flow | - |
| Post condition | Melihat nilai mata kuliah dan IP pada semester yang dipilih |

**4. Diagram Aktivitas Absensi**

*(Gambar 4.5 Diagram Aktivitas Absensi)*

| Atribut | Deskripsi |
|---------|-----------|
| Activity Diagram Name | Absensi |
| Actor | Mahasiswa |
| Description | Activity diagram ini menggambarkan kegiatan mahasiswa melakukan absensi |
| Pre condition | Mahasiswa harus melakukan login dan berada di lokasi kampus |
| Trigger | Activity ini dilakukan saat kelas berlangsung |
| Typical course of event | Actor: Pilih kelas, Klik absen, Input NIM. System: Cek WiFi kampus, Validasi NIM, Simpan absensi |
| Alternative flow | Jika tidak terhubung WiFi, mahasiswa dapat mengajukan izin dengan upload bukti |
| Post condition | Status kehadiran tersimpan (Hadir/Izin Pending) |

**5. Diagram Aktivitas Melihat Tagihan**

*(Gambar 4.6 Diagram Aktivitas Melihat Tagihan)*

| Atribut | Deskripsi |
|---------|-----------|
| Activity Diagram Name | Melihat Tagihan |
| Actor | Mahasiswa |
| Description | Activity diagram ini menggambarkan kegiatan mahasiswa melihat tagihan |
| Pre condition | Mahasiswa harus melakukan login terlebih dahulu |
| Trigger | Activity ini dilakukan setelah actor memilih menu Keuangan |
| Typical course of event | Actor: Memilih menu Keuangan. System: Menampilkan daftar tagihan dan status pembayaran |
| Alternative flow | - |
| Post condition | Melihat daftar tagihan dan riwayat pembayaran |

**6. Diagram Aktivitas Pembayaran**

*(Gambar 4.7 Diagram Aktivitas Pembayaran)*

| Atribut | Deskripsi |
|---------|-----------|
| Activity Diagram Name | Pembayaran |
| Actor | Mahasiswa |
| Description | Activity diagram ini menggambarkan kegiatan mahasiswa melakukan pembayaran |
| Pre condition | Mahasiswa harus melakukan login dan memiliki tagihan |
| Trigger | Activity ini dilakukan setelah actor memilih tagihan |
| Typical course of event | Actor: Pilih tagihan, Pilih metode pembayaran, Upload bukti. System: Tampilkan detail tagihan, Simpan bukti pembayaran |
| Alternative flow | - |
| Post condition | Pembayaran tersimpan dengan status menunggu verifikasi |

**7. Diagram Aktivitas Dashboard**

*(Gambar 4.8 Diagram Aktivitas Dashboard Mahasiswa)*

| Atribut | Deskripsi |
|---------|-----------|
| Activity Diagram Name | Dashboard |
| Actor | Mahasiswa |
| Description | Activity diagram ini menggambarkan kegiatan mahasiswa melihat dashboard |
| Pre condition | Mahasiswa harus melakukan login terlebih dahulu |
| Trigger | Activity ini dilakukan setelah login berhasil |
| Typical course of event | Actor: Login berhasil. System: Tampilkan profil, ringkasan IPK/SKS, jadwal hari ini, notifikasi |
| Alternative flow | - |
| Post condition | Melihat informasi dashboard mahasiswa |

**8. Diagram Aktivitas Profil**

*(Gambar 4.9 Diagram Aktivitas Profil Mahasiswa)*

| Atribut | Deskripsi |
|---------|-----------|
| Activity Diagram Name | Profil |
| Actor | Mahasiswa |
| Description | Activity diagram ini menggambarkan kegiatan mahasiswa melihat profil |
| Pre condition | Mahasiswa harus melakukan login terlebih dahulu |
| Trigger | Activity ini dilakukan setelah actor memilih menu Profil |
| Typical course of event | Actor: Pilih menu Profil. System: Tampilkan data profil mahasiswa |
| Alternative flow | - |
| Post condition | Melihat informasi profil mahasiswa |

**9. Diagram Aktivitas Sertifikat**

*(Gambar 4.10 Diagram Aktivitas Sertifikat)*

| Atribut | Deskripsi |
|---------|-----------|
| Activity Diagram Name | Sertifikat |
| Actor | Mahasiswa |
| Description | Activity diagram ini menggambarkan kegiatan mahasiswa mengelola sertifikat |
| Pre condition | Mahasiswa harus melakukan login terlebih dahulu |
| Trigger | Activity ini dilakukan setelah actor memilih menu Sertifikat |
| Typical course of event | Actor: Pilih aksi (Tambah/Edit/Hapus/Download), Input data, Upload file, Simpan. System: Proses CRUD, Refresh daftar |
| Alternative flow | Jika ada form kosong, sistem menampilkan pesan error |
| Post condition | Data sertifikat terupdate di database |

**10. Diagram Aktivitas Jadwal Kuliah**

*(Gambar 4.11 Diagram Aktivitas Jadwal Kuliah Mahasiswa)*

| Atribut | Deskripsi |
|---------|-----------|
| Activity Diagram Name | Jadwal Kuliah |
| Actor | Mahasiswa |
| Description | Activity diagram ini menggambarkan kegiatan mahasiswa melihat jadwal kuliah |
| Pre condition | Mahasiswa harus melakukan login terlebih dahulu |
| Trigger | Activity ini dilakukan setelah actor memilih menu Jadwal |
| Typical course of event | Actor: Pilih menu Jadwal, Pilih hari, Pilih kelas. System: Tampilkan jadwal per hari, Tampilkan detail kelas |
| Alternative flow | - |
| Post condition | Melihat jadwal kuliah dan detail kelas |

**11. Diagram Aktivitas Pencarian**

*(Gambar 4.12 Diagram Aktivitas Pencarian Mahasiswa)*

| Atribut | Deskripsi |
|---------|-----------|
| Activity Diagram Name | Pencarian |
| Actor | Mahasiswa |
| Description | Activity diagram ini menggambarkan kegiatan mahasiswa melakukan pencarian |
| Pre condition | Mahasiswa harus melakukan login terlebih dahulu |
| Trigger | Activity ini dilakukan setelah actor klik ikon pencarian |
| Typical course of event | Actor: Klik pencarian, Input kata kunci, Pilih hasil. System: Cari di database, Tampilkan hasil |
| Alternative flow | - |
| Post condition | Melihat hasil pencarian dan detail |

**12. Diagram Aktivitas Pengaturan**

*(Gambar 4.13 Diagram Aktivitas Pengaturan Mahasiswa)*

| Atribut | Deskripsi |
|---------|-----------|
| Activity Diagram Name | Pengaturan |
| Actor | Mahasiswa |
| Description | Activity diagram ini menggambarkan kegiatan mahasiswa mengelola pengaturan akun |
| Pre condition | Mahasiswa harus melakukan login terlebih dahulu |
| Trigger | Activity ini dilakukan setelah actor memilih menu Pengaturan |
| Typical course of event | Actor: Pilih pengaturan (ubah password/notifikasi/tema), Ubah data, Simpan. System: Validasi, Update preferensi |
| Alternative flow | Jika password lama salah, sistem menampilkan pesan error |
| Post condition | Pengaturan akun terupdate |

**B. Dosen**

**1. Diagram Aktivitas Approve KRS**

*(Gambar 4.8 Diagram Aktivitas Approve KRS)*

| Atribut | Deskripsi |
|---------|-----------|
| Activity Diagram Name | Approve KRS |
| Actor | Dosen PA |
| Description | Activity diagram ini menggambarkan kegiatan dosen PA approve/reject KRS |
| Pre condition | Dosen harus melakukan login terlebih dahulu |
| Trigger | Activity ini dilakukan setelah ada KRS pending dari mahasiswa bimbingan |
| Typical course of event | Actor: Pilih menu Akademik, Pilih KRS mahasiswa, Klik Approve/Reject. System: Tampilkan daftar KRS, Update status KRS |
| Alternative flow | Jika reject, dosen harus input alasan penolakan |
| Post condition | Status KRS terupdate (Approved/Rejected) |

**2. Diagram Aktivitas Input Nilai**

*(Gambar 4.9 Diagram Aktivitas Input Nilai)*

| Atribut | Deskripsi |
|---------|-----------|
| Activity Diagram Name | Input Nilai |
| Actor | Dosen |
| Description | Activity diagram ini menggambarkan kegiatan dosen input nilai mahasiswa |
| Pre condition | Dosen harus melakukan login terlebih dahulu |
| Trigger | Activity ini dilakukan setelah actor memilih menu Nilai |
| Typical course of event | Actor: Pilih mata kuliah, Pilih komponen nilai, Input nilai, Klik simpan. System: Tampilkan daftar mahasiswa, Simpan nilai |
| Alternative flow | - |
| Post condition | Nilai mahasiswa tersimpan di database |

**3. Diagram Aktivitas Kelola Absensi**

*(Gambar 4.10 Diagram Aktivitas Kelola Absensi)*

| Atribut | Deskripsi |
|---------|-----------|
| Activity Diagram Name | Kelola Absensi |
| Actor | Dosen |
| Description | Activity diagram ini menggambarkan kegiatan dosen mengelola absensi kelas |
| Pre condition | Dosen harus melakukan login terlebih dahulu |
| Trigger | Activity ini dilakukan setelah actor memilih menu Absensi |
| Typical course of event | Actor: Pilih kelas, Mulai sesi absensi, Selesaikan sesi, Lihat record, Approve/reject izin. System: Buka sesi, Catat kehadiran, Tampilkan record, Update status izin |
| Alternative flow | Jika ada izin pending, dosen dapat approve/reject di modal detail izin |
| Post condition | Record absensi dan status izin terupdate |

**5. Diagram Aktivitas Dashboard Dosen**

*(Gambar 4.17 Diagram Aktivitas Dashboard Dosen)*

| Atribut | Deskripsi |
|---------|-----------|
| Activity Diagram Name | Dashboard |
| Actor | Dosen |
| Description | Activity diagram ini menggambarkan kegiatan dosen melihat dashboard |
| Pre condition | Dosen harus melakukan login terlebih dahulu |
| Trigger | Activity ini dilakukan setelah login berhasil |
| Typical course of event | Actor: Login berhasil. System: Tampilkan profil, jadwal mengajar hari ini, notifikasi KRS pending |
| Alternative flow | - |
| Post condition | Melihat informasi dashboard dosen |

**6. Diagram Aktivitas Profil Dosen**

*(Gambar 4.18 Diagram Aktivitas Profil Dosen)*

| Atribut | Deskripsi |
|---------|-----------|
| Activity Diagram Name | Profil |
| Actor | Dosen |
| Description | Activity diagram ini menggambarkan kegiatan dosen melihat profil |
| Pre condition | Dosen harus melakukan login terlebih dahulu |
| Trigger | Activity ini dilakukan setelah actor memilih menu Profil |
| Typical course of event | Actor: Pilih menu Profil. System: Tampilkan data profil dosen |
| Alternative flow | - |
| Post condition | Melihat informasi profil dosen |

**7. Diagram Aktivitas Jadwal Mengajar**

*(Gambar 4.19 Diagram Aktivitas Jadwal Mengajar)*

| Atribut | Deskripsi |
|---------|-----------|
| Activity Diagram Name | Jadwal Mengajar |
| Actor | Dosen |
| Description | Activity diagram ini menggambarkan kegiatan dosen melihat jadwal mengajar |
| Pre condition | Dosen harus melakukan login terlebih dahulu |
| Trigger | Activity ini dilakukan setelah actor memilih menu Jadwal |
| Typical course of event | Actor: Pilih menu Jadwal, Pilih hari, Pilih kelas. System: Tampilkan jadwal mengajar, Tampilkan daftar mahasiswa kelas |
| Alternative flow | - |
| Post condition | Melihat jadwal mengajar dan detail kelas |

**8. Diagram Aktivitas Pencarian Dosen**

*(Gambar 4.20 Diagram Aktivitas Pencarian Dosen)*

| Atribut | Deskripsi |
|---------|-----------|
| Activity Diagram Name | Pencarian |
| Actor | Dosen |
| Description | Activity diagram ini menggambarkan kegiatan dosen melakukan pencarian |
| Pre condition | Dosen harus melakukan login terlebih dahulu |
| Trigger | Activity ini dilakukan setelah actor klik ikon pencarian |
| Typical course of event | Actor: Klik pencarian, Input kata kunci, Pilih hasil. System: Cari mahasiswa/matkul/kelas, Tampilkan hasil |
| Alternative flow | - |
| Post condition | Melihat hasil pencarian dan detail |

**9. Diagram Aktivitas Pengaturan Dosen**

*(Gambar 4.21 Diagram Aktivitas Pengaturan Dosen)*

| Atribut | Deskripsi |
|---------|-----------|
| Activity Diagram Name | Pengaturan |
| Actor | Dosen |
| Description | Activity diagram ini menggambarkan kegiatan dosen mengelola pengaturan akun |
| Pre condition | Dosen harus melakukan login terlebih dahulu |
| Trigger | Activity ini dilakukan setelah actor memilih menu Pengaturan |
| Typical course of event | Actor: Pilih pengaturan (ubah password/notifikasi/tema), Ubah data, Simpan. System: Validasi, Update preferensi |
| Alternative flow | Jika password lama salah, sistem menampilkan pesan error |
| Post condition | Pengaturan akun terupdate |

**C. Admin**

**1. Diagram Aktivitas Login Admin**

*(Gambar 4.22 Diagram Aktivitas Login Admin)*

| Atribut | Deskripsi |
|---------|-----------|
| Activity Diagram Name | Login |
| Actor | Admin |
| Description | Activity diagram ini menggambarkan kegiatan admin login ke sistem |
| Pre condition | Admin sudah terdaftar di sistem |
| Trigger | Activity ini dilakukan saat admin membuka aplikasi |
| Typical course of event | Actor: Input NIP/Email, Input Password, Klik Login. System: Validasi kredensial, Cek role, Tampilkan dashboard admin |
| Alternative flow | Jika kredensial salah, sistem menampilkan pesan error |
| Post condition | Admin berhasil login dan melihat dashboard |

**2. Diagram Aktivitas Kelola Mahasiswa**

*(Gambar 4.12 Diagram Aktivitas Kelola Mahasiswa)*

| Atribut | Deskripsi |
|---------|-----------|
| Activity Diagram Name | Kelola Mahasiswa |
| Actor | Admin |
| Description | Activity diagram ini menggambarkan kegiatan admin mengelola data mahasiswa |
| Pre condition | Admin harus melakukan login terlebih dahulu |
| Trigger | Activity ini dilakukan setelah actor memilih menu Kelola Mahasiswa |
| Typical course of event | Actor: Pilih aksi (Tambah/Edit/Hapus), Input/ubah data, Klik simpan. System: Tampilkan daftar mahasiswa, Proses CRUD, Refresh data |
| Alternative flow | Jika ada form kosong, sistem menampilkan pesan error |
| Post condition | Data mahasiswa terupdate di database |

**2. Diagram Aktivitas Kelola Dosen**

*(Gambar 4.13 Diagram Aktivitas Kelola Dosen)*

| Atribut | Deskripsi |
|---------|-----------|
| Activity Diagram Name | Kelola Dosen |
| Actor | Admin |
| Description | Activity diagram ini menggambarkan kegiatan admin mengelola data dosen |
| Pre condition | Admin harus melakukan login terlebih dahulu |
| Trigger | Activity ini dilakukan setelah actor memilih menu Kelola Dosen |
| Typical course of event | Actor: Pilih aksi (Tambah/Edit/Hapus), Input/ubah data, Klik simpan. System: Tampilkan daftar dosen, Proses CRUD, Refresh data |
| Alternative flow | Jika ada form kosong, sistem menampilkan pesan error |
| Post condition | Data dosen terupdate di database |

**3. Diagram Aktivitas Kelola Mata Kuliah**

*(Gambar 4.14 Diagram Aktivitas Kelola Mata Kuliah)*

| Atribut | Deskripsi |
|---------|-----------|
| Activity Diagram Name | Kelola Mata Kuliah |
| Actor | Admin |
| Description | Activity diagram ini menggambarkan kegiatan admin mengelola data mata kuliah |
| Pre condition | Admin harus melakukan login terlebih dahulu |
| Trigger | Activity ini dilakukan setelah actor memilih menu Kelola Matkul |
| Typical course of event | Actor: Pilih aksi, Input kode/nama/SKS, Pilih dosen, Klik simpan. System: Tampilkan daftar matkul, Proses CRUD, Refresh data |
| Alternative flow | Jika ada form kosong, sistem menampilkan pesan error |
| Post condition | Data mata kuliah terupdate di database |

**4. Diagram Aktivitas Verifikasi Pembayaran**

*(Gambar 4.15 Diagram Aktivitas Verifikasi Pembayaran)*

| Atribut | Deskripsi |
|---------|-----------|
| Activity Diagram Name | Verifikasi Pembayaran |
| Actor | Admin |
| Description | Activity diagram ini menggambarkan kegiatan admin verifikasi pembayaran |
| Pre condition | Admin harus melakukan login dan ada pembayaran pending |
| Trigger | Activity ini dilakukan setelah ada upload bukti pembayaran |
| Typical course of event | Actor: Pilih pembayaran, Lihat bukti, Klik Approve/Reject. System: Tampilkan detail, Update status pembayaran |
| Alternative flow | Jika reject, admin harus input alasan penolakan |
| Post condition | Status pembayaran terupdate (Lunas/Ditolak) |

**5. Diagram Aktivitas Dashboard Admin**

*(Gambar 4.25 Diagram Aktivitas Dashboard Admin)*

| Atribut | Deskripsi |
|---------|-----------|
| Activity Diagram Name | Dashboard |
| Actor | Admin |
| Description | Activity diagram ini menggambarkan kegiatan admin melihat dashboard |
| Pre condition | Admin harus melakukan login terlebih dahulu |
| Trigger | Activity ini dilakukan setelah login berhasil |
| Typical course of event | Actor: Login berhasil. System: Tampilkan statistik dosen, mahasiswa, matkul, dan daftar kelas |
| Alternative flow | - |
| Post condition | Melihat informasi dashboard admin |

**6. Diagram Aktivitas Kelola Jadwal Kuliah**

*(Gambar 4.26 Diagram Aktivitas Kelola Jadwal Kuliah)*

| Atribut | Deskripsi |
|---------|-----------|
| Activity Diagram Name | Kelola Jadwal Kuliah |
| Actor | Admin |
| Description | Activity diagram ini menggambarkan kegiatan admin mengelola jadwal kuliah |
| Pre condition | Admin harus melakukan login terlebih dahulu |
| Trigger | Activity ini dilakukan setelah actor memilih menu Jadwal Kuliah |
| Typical course of event | Actor: Pilih aksi (Tambah/Edit/Hapus), Pilih matkul/kelas/hari/jam/ruang, Simpan. System: Proses CRUD, Refresh data |
| Alternative flow | Jika ada form kosong, sistem menampilkan pesan error |
| Post condition | Data jadwal terupdate di database |

**7. Diagram Aktivitas Kelola Kelas**

*(Gambar 4.27 Diagram Aktivitas Kelola Kelas)*

| Atribut | Deskripsi |
|---------|-----------|
| Activity Diagram Name | Kelola Kelas |
| Actor | Admin |
| Description | Activity diagram ini menggambarkan kegiatan admin mengelola data kelas |
| Pre condition | Admin harus melakukan login terlebih dahulu |
| Trigger | Activity ini dilakukan setelah actor memilih menu Kelas |
| Typical course of event | Actor: Pilih aksi, Input kode kelas/matkul/dosen/kapasitas, Simpan. System: Proses CRUD, Refresh data |
| Alternative flow | Jika ada form kosong, sistem menampilkan pesan error |
| Post condition | Data kelas terupdate di database |

**8. Diagram Aktivitas Publish KRS**

*(Gambar 4.28 Diagram Aktivitas Publish KRS)*

| Atribut | Deskripsi |
|---------|-----------|
| Activity Diagram Name | Publish KRS |
| Actor | Admin |
| Description | Activity diagram ini menggambarkan kegiatan admin membuka/menutup periode KRS |
| Pre condition | Admin harus melakukan login terlebih dahulu |
| Trigger | Activity ini dilakukan setelah actor memilih menu Publish KRS |
| Typical course of event | Actor: Pilih semester, Set tanggal, Buka/Tutup KRS. System: Update status periode, Notifikasi mahasiswa |
| Alternative flow | - |
| Post condition | Periode KRS terupdate (Aktif/Tutup) |

**9. Diagram Aktivitas Kalkulasi Nilai**

*(Gambar 4.29 Diagram Aktivitas Kalkulasi Nilai)*

| Atribut | Deskripsi |
|---------|-----------|
| Activity Diagram Name | Kalkulasi Nilai |
| Actor | Admin |
| Description | Activity diagram ini menggambarkan kegiatan admin kalkulasi nilai akhir |
| Pre condition | Admin harus melakukan login terlebih dahulu |
| Trigger | Activity ini dilakukan setelah actor memilih menu Kalkulasi Nilai |
| Typical course of event | Actor: Pilih semester, Pilih matkul, Klik kalkulasi. System: Hitung nilai akhir, Generate grade, Update database |
| Alternative flow | - |
| Post condition | Nilai akhir dan grade tersimpan di database |

**10. Diagram Aktivitas Kelola Tagihan**

*(Gambar 4.30 Diagram Aktivitas Kelola Tagihan)*

| Atribut | Deskripsi |
|---------|-----------|
| Activity Diagram Name | Kelola Tagihan |
| Actor | Admin |
| Description | Activity diagram ini menggambarkan kegiatan admin mengelola tagihan mahasiswa |
| Pre condition | Admin harus melakukan login terlebih dahulu |
| Trigger | Activity ini dilakukan setelah actor memilih menu Tagihan |
| Typical course of event | Actor: Pilih aksi, Input jenis/nominal/jatuh tempo, Simpan. System: Proses CRUD, Notifikasi mahasiswa |
| Alternative flow | Jika ada form kosong, sistem menampilkan pesan error |
| Post condition | Data tagihan terupdate di database |

**11. Diagram Aktivitas Profil Admin**

*(Gambar 4.31 Diagram Aktivitas Profil Admin)*

| Atribut | Deskripsi |
|---------|-----------|
| Activity Diagram Name | Profil |
| Actor | Admin |
| Description | Activity diagram ini menggambarkan kegiatan admin melihat dan edit profil |
| Pre condition | Admin harus melakukan login terlebih dahulu |
| Trigger | Activity ini dilakukan setelah actor memilih menu Profil |
| Typical course of event | Actor: Pilih menu Profil, Edit data jika perlu, Simpan. System: Tampilkan data profil, Update database |
| Alternative flow | - |
| Post condition | Data profil tersimpan di database |

**12. Diagram Aktivitas Pengaturan**

*(Gambar 4.32 Diagram Aktivitas Pengaturan)*

| Atribut | Deskripsi |
|---------|-----------|
| Activity Diagram Name | Pengaturan |
| Actor | Admin |
| Description | Activity diagram ini menggambarkan kegiatan admin mengelola pengaturan sistem |
| Pre condition | Admin harus melakukan login terlebih dahulu |
| Trigger | Activity ini dilakukan setelah actor memilih menu Pengaturan |
| Typical course of event | Actor: Pilih pengaturan (password/tahun akademik/periode), Ubah data, Simpan. System: Validasi, Update konfigurasi |
| Alternative flow | Jika password lama salah, sistem menampilkan pesan error |
| Post condition | Pengaturan sistem terupdate |

#### 4.2.3 Diagram Sequence

Sequence diagram digunakan untuk menggambarkan objek-objek yang terlibat dalam sebuah use case dan menggambarkan aliran pesan antara objek-objek tersebut.

**A. Mahasiswa**

**1. Sequence Diagram Login**

*(Gambar 4.16 Sequence Diagram Login)*

Sequence diagram ini adalah proses user untuk masuk ke halaman dashboard, dimana user harus memasukkan NIM/NIP dan password untuk masuk ke aplikasi.

**2. Sequence Diagram Submit KRS**

*(Gambar 4.17 Sequence Diagram Submit KRS)*

Sequence diagram ini adalah proses mahasiswa untuk submit KRS, dimana mahasiswa dapat memilih mata kuliah yang akan diambil pada semester tersebut.

**3. Sequence Diagram Melihat KHS**

*(Gambar 4.18 Sequence Diagram Melihat KHS)*

Sequence diagram ini adalah proses mahasiswa untuk melihat KHS, dimana mahasiswa dapat melihat nilai dan IP per semester.

**4. Sequence Diagram Absensi**

*(Gambar 4.19 Sequence Diagram Absensi)*

Sequence diagram ini adalah proses mahasiswa untuk melakukan absensi dengan verifikasi WiFi kampus dan input NIM.

**5. Sequence Diagram Pembayaran**

*(Gambar 4.20 Sequence Diagram Pembayaran)*

Sequence diagram ini adalah proses mahasiswa untuk melihat tagihan dan melakukan pembayaran dengan upload bukti.

**6. Sequence Diagram Dashboard**

*(Gambar 4.38 Sequence Diagram Dashboard Mahasiswa)*

Sequence diagram ini adalah proses mahasiswa untuk melihat dashboard setelah login, menampilkan profil, IPK, jadwal hari ini.

**7. Sequence Diagram Profil**

*(Gambar 4.39 Sequence Diagram Profil Mahasiswa)*

Sequence diagram ini adalah proses mahasiswa untuk melihat dan edit profil.

**8. Sequence Diagram Sertifikat**

*(Gambar 4.40 Sequence Diagram Sertifikat)*

Sequence diagram ini adalah proses mahasiswa untuk melihat daftar sertifikat dan download.

**9. Sequence Diagram Jadwal Kuliah**

*(Gambar 4.41 Sequence Diagram Jadwal Kuliah)*

Sequence diagram ini adalah proses mahasiswa untuk melihat jadwal kuliah per hari.

**10. Sequence Diagram Pencarian**

*(Gambar 4.42 Sequence Diagram Pencarian Mahasiswa)*

Sequence diagram ini adalah proses mahasiswa untuk melakukan pencarian mata kuliah, dosen, atau pengumuman.

**B. Dosen**

**1. Sequence Diagram Approve KRS**

*(Gambar 4.21 Sequence Diagram Approve KRS)*

Sequence diagram ini adalah proses dosen PA untuk approve atau reject KRS mahasiswa bimbingan.

**2. Sequence Diagram Input Nilai**

*(Gambar 4.22 Sequence Diagram Input Nilai)*

Sequence diagram ini adalah proses dosen untuk input nilai komponen (Tugas, UTS, UAS) mahasiswa.

**3. Sequence Diagram Kelola Absensi**

*(Gambar 4.23 Sequence Diagram Kelola Absensi)*

Sequence diagram ini adalah proses dosen untuk membuka sesi absensi dan melihat rekap kehadiran mahasiswa.

**4. Sequence Diagram Dashboard Dosen**

*(Gambar 4.46 Sequence Diagram Dashboard Dosen)*

Sequence diagram ini adalah proses dosen untuk melihat dashboard, menampilkan jadwal mengajar dan notifikasi KRS pending.

**5. Sequence Diagram Profil Dosen**

*(Gambar 4.47 Sequence Diagram Profil Dosen)*

Sequence diagram ini adalah proses dosen untuk melihat dan edit profil.

**6. Sequence Diagram Jadwal Mengajar**

*(Gambar 4.48 Sequence Diagram Jadwal Mengajar)*

Sequence diagram ini adalah proses dosen untuk melihat jadwal mengajar dan daftar mahasiswa per kelas.

**7. Sequence Diagram Pencarian Dosen**

*(Gambar 4.49 Sequence Diagram Pencarian Dosen)*

Sequence diagram ini adalah proses dosen untuk melakukan pencarian mahasiswa, mata kuliah, atau kelas.

**C. Admin**

**1. Sequence Diagram Kelola Mahasiswa**

*(Gambar 4.50 Sequence Diagram Kelola Mahasiswa)*

Sequence diagram ini adalah proses admin untuk mengelola data mahasiswa, dimana admin dapat melakukan proses tambah, edit, dan hapus data.

**2. Sequence Diagram Verifikasi Pembayaran**

*(Gambar 4.51 Sequence Diagram Verifikasi Pembayaran)*

Sequence diagram ini adalah proses admin untuk verifikasi pembayaran mahasiswa.

**3. Sequence Diagram Dashboard Admin**

*(Gambar 4.52 Sequence Diagram Dashboard Admin)*

Sequence diagram ini adalah proses admin untuk melihat dashboard dengan statistik dosen, mahasiswa, dan mata kuliah.

**4. Sequence Diagram Kelola Dosen**

*(Gambar 4.53 Sequence Diagram Kelola Dosen)*

Sequence diagram ini adalah proses admin untuk mengelola data dosen dengan operasi CRUD.

**5. Sequence Diagram Kelola Mata Kuliah**

*(Gambar 4.54 Sequence Diagram Kelola Mata Kuliah)*

Sequence diagram ini adalah proses admin untuk mengelola data mata kuliah dengan operasi CRUD.

**6. Sequence Diagram Kelola Jadwal**

*(Gambar 4.55 Sequence Diagram Kelola Jadwal)*

Sequence diagram ini adalah proses admin untuk mengelola jadwal kuliah.

**7. Sequence Diagram Kelola Kelas**

*(Gambar 4.56 Sequence Diagram Kelola Kelas)*

Sequence diagram ini adalah proses admin untuk mengelola data kelas dan melihat daftar mahasiswa.

**8. Sequence Diagram Publish KRS**

*(Gambar 4.57 Sequence Diagram Publish KRS)*

Sequence diagram ini adalah proses admin untuk membuka dan menutup periode KRS.

**9. Sequence Diagram Kalkulasi Nilai**

*(Gambar 4.58 Sequence Diagram Kalkulasi Nilai)*

Sequence diagram ini adalah proses admin untuk menghitung nilai akhir dan generate grade mahasiswa.

**10. Sequence Diagram Kelola Tagihan**

*(Gambar 4.59 Sequence Diagram Kelola Tagihan)*

Sequence diagram ini adalah proses admin untuk mengelola tagihan mahasiswa dengan operasi CRUD.

**11. Sequence Diagram Profil Admin**

*(Gambar 4.60 Sequence Diagram Profil Admin)*

Sequence diagram ini adalah proses admin untuk melihat dan edit profil.

**12. Sequence Diagram Pengaturan**

*(Gambar 4.61 Sequence Diagram Pengaturan)*

Sequence diagram ini adalah proses admin untuk mengelola pengaturan sistem seperti password, tahun akademik, dan periode.

#### 4.2.4 Diagram Kelas

Diagram kelas memvisualisasikan atribut-atribut, metode, dan hubungan antar kelas dalam bentuk grafis. Berikut kelas diagram pada sistem SIMA:

*(Gambar 4.26 Class Diagram Aplikasi SIMA)*

Class diagram aplikasi SIMA terdiri dari kelas-kelas utama:
- **AppUser**: Kelas induk untuk semua pengguna dengan atribut id, name, email, password, role
- **Mahasiswa**: Kelas turunan AppUser dengan atribut nim, prodi, semester, dosenPaId, ipk
- **Dosen**: Kelas turunan AppUser dengan atribut nip, mataKuliah, jabatan
- **MataKuliah**: Kelas untuk data mata kuliah dengan atribut kode, nama, sks, semester
- **Kelas**: Kelas untuk data kelas dengan atribut kode, jadwal, mahasiswa
- **Schedule**: Kelas untuk jadwal dengan atribut hari, jamMulai, jamSelesai, ruang
- **KRSItem**: Kelas untuk item KRS dengan atribut mataKuliahId, semester, status
- **KHSItem**: Kelas untuk nilai dengan atribut nilaiTugas, nilaiUTS, nilaiUAS, nilaiAkhir, grade
- **Attendance**: Kelas untuk absensi dengan atribut tanggal, status, alasan, bukti
- **Bill**: Kelas untuk tagihan dengan atribut nama, nominal, tanggalJatuhTempo, status

### 4.3 Rancangan Tampilan Aplikasi

#### 4.3.1 Desain UI/UX

Rancangan tampilan aplikasi SIMA dirancang menggunakan Figma dengan memperhatikan prinsip-prinsip UI/UX untuk aplikasi mobile. Berikut beberapa rancangan tampilan utama:

**1. Halaman Splash Screen**

Halaman splash screen menampilkan logo SIMA dan nama aplikasi saat aplikasi pertama kali dibuka.

**2. Halaman Login**

Halaman login terdapat dua kolom yaitu NIM/NIP dan Password. User harus memasukkan informasi yang benar untuk berhasil masuk ke dashboard.

**3. Halaman Dashboard Mahasiswa**

Dashboard mahasiswa menampilkan informasi profil, ringkasan akademik (IPK, SKS), quick access menu, dan jadwal hari ini.

**4. Halaman Jadwal Kuliah**

Halaman jadwal menampilkan jadwal perkuliahan per hari dengan tab navigasi Senin-Jumat.

**5. Halaman KRS**

Halaman KRS menampilkan daftar mata kuliah yang tersedia dan mata kuliah yang sudah diambil.

**6. Halaman KHS**

Halaman KHS menampilkan nilai per semester dengan pilihan semester dan tampilan IP/IPK.

**7. Halaman Absensi**

Halaman absensi menampilkan kelas yang sedang berlangsung dengan tombol absen dan form izin.

**8. Halaman Keuangan**

Halaman keuangan menampilkan daftar tagihan, status pembayaran, dan riwayat pembayaran.

**9. Halaman Dashboard Dosen**

Dashboard dosen menampilkan informasi profil, jadwal mengajar hari ini, dan notifikasi KRS pending.

**10. Halaman Input Nilai**

Halaman input nilai menampilkan daftar mata kuliah yang diampu dengan akses ke modal input nilai per komponen.

**11. Halaman Approval KRS**

Halaman approval menampilkan daftar KRS mahasiswa bimbingan yang menunggu approval.

*(Screenshot dapat ditambahkan sesuai kebutuhan)*

---

## BAB V PENUTUP

### 5.1 Kesimpulan

1. Aplikasi SIMA berhasil dikembangkan menggunakan Flutter
2. Fitur KRS, KHS, Jadwal, dan Absensi telah diimplementasikan
3. Role-based access untuk 3 aktor berhasil diterapkan

### 5.2 Saran

1. Integrasi langsung dengan backend SIMITNU
2. Implementasi push notification
3. Fitur offline mode untuk akses tanpa internet

---

## DAFTAR PUSTAKA

1. Flutter Documentation. https://flutter.dev/docs
2. Dart Language. https://dart.dev
3. SIMITNU ITS NU Pekalongan

---

*Laporan ini dibuat sebagai dokumentasi pengembangan aplikasi SIMA*
