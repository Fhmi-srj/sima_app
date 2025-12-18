// Centralized academic data for the app
class AcademicData {
  // Student academic summary
  static Map<String, dynamic> getSummary() {
    return {
      'currentSemester': 5,
      'totalSKS': 120,
      'completedSKS': 96,
      'currentSKS': 24,
      'ipk': 3.75,
      'ips': 3.80,
      'status': 'Aktif',
    };
  }

  // KRS data - courses enrolled this semester
  static List<Map<String, dynamic>> getCurrentKRS() {
    return [
      {
        'code': 'IF301',
        'name': 'Rekayasa Perangkat Lunak',
        'sks': 3,
        'class': 'A',
        'lecturer': 'Pak Hendra Wijaya',
        'schedule': 'Kamis, 08:30 - 11:00',
        'room': 'Ruang B3.1',
      },
      {
        'code': 'IF302',
        'name': 'Kecerdasan Buatan',
        'sks': 3,
        'class': 'B',
        'lecturer': 'Pak Doni Prasetyo',
        'schedule': 'Jumat, 09:00 - 11:30',
        'room': 'Ruang Lab 3',
      },
      {
        'code': 'IF303',
        'name': 'Interaksi Manusia Komputer',
        'sks': 3,
        'class': 'A',
        'lecturer': 'Bu Rina Kusuma',
        'schedule': 'Kamis, 14:00 - 16:30',
        'room': 'Ruang Media',
      },
      {
        'code': 'IF304',
        'name': 'Jaringan Komputer',
        'sks': 3,
        'class': 'C',
        'lecturer': 'Pak Budi Santoso',
        'schedule': 'Rabu, 10:00 - 12:30',
        'room': 'Ruang Lab 2',
      },
      {
        'code': 'IF305',
        'name': 'Basis Data Lanjut',
        'sks': 3,
        'class': 'A',
        'lecturer': 'Bu Siti Aminah',
        'schedule': 'Selasa, 08:00 - 10:30',
        'room': 'Ruang Lab 1',
      },
      {
        'code': 'IF306',
        'name': 'Pemrograman Web',
        'sks': 3,
        'class': 'B',
        'lecturer': 'Pak Razak Naufal',
        'schedule': 'Senin, 13:00 - 15:30',
        'room': 'Ruang Media',
      },
      {
        'code': 'IF307',
        'name': 'Matematika Diskrit',
        'sks': 3,
        'class': 'A',
        'lecturer': 'Bu Mega Nindityawati',
        'schedule': 'Senin, 10:30 - 13:00',
        'room': 'Ruang B3.2',
      },
      {
        'code': 'IF308',
        'name': 'Desain Grafis',
        'sks': 3,
        'class': 'A',
        'lecturer': 'Pak M. Al\'Amin',
        'schedule': 'Senin, 08:30 - 10:30',
        'room': 'Ruang Media',
      },
    ];
  }

  // KHS data - grades per semester
  static List<Map<String, dynamic>> getAllKHS() {
    return [
      {
        'semester': 4,
        'year': '2023/2024',
        'period': 'Genap',
        'ips': 3.80,
        'sks': 24,
        'courses': [
          {
            'code': 'IF201',
            'name': 'Struktur Data',
            'sks': 3,
            'grade': 'A',
            'score': 4.0,
          },
          {
            'code': 'IF202',
            'name': 'Algoritma',
            'sks': 3,
            'grade': 'A-',
            'score': 3.7,
          },
          {
            'code': 'IF203',
            'name': 'Basis Data',
            'sks': 3,
            'grade': 'A',
            'score': 4.0,
          },
          {
            'code': 'IF204',
            'name': 'Pemrograman OOP',
            'sks': 3,
            'grade': 'B+',
            'score': 3.3,
          },
          {
            'code': 'IF205',
            'name': 'Sistem Operasi',
            'sks': 3,
            'grade': 'A',
            'score': 4.0,
          },
          {
            'code': 'IF206',
            'name': 'Statistika',
            'sks': 3,
            'grade': 'A-',
            'score': 3.7,
          },
          {
            'code': 'IF207',
            'name': 'Bahasa Inggris',
            'sks': 3,
            'grade': 'A',
            'score': 4.0,
          },
          {
            'code': 'IF208',
            'name': 'Kewirausahaan',
            'sks': 3,
            'grade': 'A-',
            'score': 3.7,
          },
        ],
      },
      {
        'semester': 3,
        'year': '2023/2024',
        'period': 'Ganjil',
        'ips': 3.65,
        'sks': 24,
        'courses': [
          {
            'code': 'IF151',
            'name': 'Pemrograman Dasar',
            'sks': 3,
            'grade': 'A',
            'score': 4.0,
          },
          {
            'code': 'IF152',
            'name': 'Logika Informatika',
            'sks': 3,
            'grade': 'B+',
            'score': 3.3,
          },
          {
            'code': 'IF153',
            'name': 'Matematika Dasar',
            'sks': 3,
            'grade': 'A-',
            'score': 3.7,
          },
          {
            'code': 'IF154',
            'name': 'Pengantar TI',
            'sks': 3,
            'grade': 'A',
            'score': 4.0,
          },
          {
            'code': 'IF155',
            'name': 'Fisika Dasar',
            'sks': 3,
            'grade': 'B+',
            'score': 3.3,
          },
          {
            'code': 'IF156',
            'name': 'Bahasa Indonesia',
            'sks': 3,
            'grade': 'A',
            'score': 4.0,
          },
          {
            'code': 'IF157',
            'name': 'Agama',
            'sks': 3,
            'grade': 'A',
            'score': 4.0,
          },
          {
            'code': 'IF158',
            'name': 'Pancasila',
            'sks': 3,
            'grade': 'B+',
            'score': 3.3,
          },
        ],
      },
    ];
  }

  // Get specific semester KHS
  static Map<String, dynamic>? getKHSBySemester(int semester) {
    return getAllKHS().firstWhere(
      (khs) => khs['semester'] == semester,
      orElse: () => {},
    );
  }

  // Certificates data
  static List<Map<String, dynamic>> getCertificates() {
    return [
      {
        'id': 'CERT001',
        'title': 'Sertifikat MSIB Batch 6',
        'issuer': 'Kemendikbudristek',
        'date': '15 Januari 2024',
        'category': 'Magang',
        'credentialId': 'MSIB-2024-001234',
        'description':
            'Sertifikat kelulusan program Magang dan Studi Independen Bersertifikat Batch 6',
        'skills': [
          'Project Management',
          'Web Development',
          'Team Collaboration',
        ],
        'isVerified': true,
      },
      {
        'id': 'CERT002',
        'title': 'Google Data Analytics',
        'issuer': 'Google',
        'date': '20 November 2023',
        'category': 'Sertifikasi',
        'credentialId': 'GDA-2023-567890',
        'description': 'Professional Certificate in Data Analytics',
        'skills': ['Data Analysis', 'SQL', 'Tableau', 'R Programming'],
        'isVerified': true,
      },
      {
        'id': 'CERT003',
        'title': 'AWS Cloud Practitioner',
        'issuer': 'Amazon Web Services',
        'date': '05 Oktober 2023',
        'category': 'Sertifikasi',
        'credentialId': 'AWS-CLP-2023-112233',
        'description': 'AWS Certified Cloud Practitioner',
        'skills': ['Cloud Computing', 'AWS Services', 'Cloud Architecture'],
        'isVerified': true,
      },
      {
        'id': 'CERT004',
        'title': 'Juara 2 Hackathon Nasional',
        'issuer': 'Kemenkominfo',
        'date': '10 Agustus 2023',
        'category': 'Kompetisi',
        'credentialId': 'HACK-2023-445566',
        'description': 'Penghargaan juara 2 Hackathon Nasional 2023',
        'skills': ['Problem Solving', 'Innovation', 'Teamwork'],
        'isVerified': true,
      },
    ];
  }

  // Get certificate by ID
  static Map<String, dynamic>? getCertificateById(String id) {
    return getCertificates().firstWhere(
      (cert) => cert['id'] == id,
      orElse: () => {},
    );
  }

  // Exam card data
  static Map<String, dynamic> getExamCard() {
    return {
      'semester': 'Ganjil 2024/2025',
      'examPeriod': '15 - 27 Desember 2024',
      'studentName': 'Ahmad Rizky',
      'nim': '102230039',
      'prodi': 'Informatika',
      'faculty': 'Fakultas Teknik',
      'status': 'Aktif',
      'examSchedule': [
        {
          'date': 'Senin, 16 Des 2024',
          'time': '08:00 - 10:00',
          'course': 'Matematika Diskrit',
          'room': 'Ruang A1.1',
        },
        {
          'date': 'Selasa, 17 Des 2024',
          'time': '10:30 - 12:30',
          'course': 'Basis Data Lanjut',
          'room': 'Ruang Lab 1',
        },
        {
          'date': 'Rabu, 18 Des 2024',
          'time': '08:00 - 10:00',
          'course': 'Jaringan Komputer',
          'room': 'Ruang Lab 2',
        },
        {
          'date': 'Kamis, 19 Des 2024',
          'time': '13:00 - 15:00',
          'course': 'Rekayasa Perangkat Lunak',
          'room': 'Ruang B3.1',
        },
        {
          'date': 'Jumat, 20 Des 2024',
          'time': '08:00 - 10:00',
          'course': 'Kecerdasan Buatan',
          'room': 'Ruang Lab 3',
        },
      ],
      'rules': [
        'Hadir 15 menit sebelum ujian dimulai',
        'Membawa KTM dan Kartu Ujian',
        'Dilarang membawa HP ke dalam ruangan',
        'Menggunakan pakaian rapi dan sopan',
        'Tidak diperkenankan mencontek',
      ],
    };
  }

  // Attendance summary
  static Map<String, dynamic> getAttendanceSummary() {
    return {
      'totalClasses': 112,
      'attended': 98,
      'absent': 8,
      'permitted': 6,
      'percentage': 87.5,
    };
  }

  // Attendance details per course
  static List<Map<String, dynamic>> getAttendanceDetails() {
    return [
      {
        'course': 'Rekayasa Perangkat Lunak',
        'attended': 14,
        'total': 16,
        'percentage': 87.5,
      },
      {
        'course': 'Kecerdasan Buatan',
        'attended': 15,
        'total': 16,
        'percentage': 93.75,
      },
      {
        'course': 'Interaksi Manusia Komputer',
        'attended': 13,
        'total': 16,
        'percentage': 81.25,
      },
      {
        'course': 'Jaringan Komputer',
        'attended': 14,
        'total': 16,
        'percentage': 87.5,
      },
      {
        'course': 'Basis Data Lanjut',
        'attended': 12,
        'total': 14,
        'percentage': 85.71,
      },
      {
        'course': 'Pemrograman Web',
        'attended': 14,
        'total': 14,
        'percentage': 100.0,
      },
      {
        'course': 'Matematika Diskrit',
        'attended': 10,
        'total': 12,
        'percentage': 83.33,
      },
      {
        'course': 'Desain Grafis',
        'attended': 6,
        'total': 8,
        'percentage': 75.0,
      },
    ];
  }
}
