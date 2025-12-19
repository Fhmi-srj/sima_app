// Centralized user data for multi-role support
import '../models/student_model.dart';

enum UserRole { student, lecturer, admin }

class AppUser {
  final String id; // NIM for student, NIP for lecturer
  final String name;
  final String email;
  final UserRole role;
  final String prodi;
  final String? faculty;
  final String? year; // Angkatan for students
  final String? kelas; // Class code like IM23A, IM23B, etc.
  final String institusi;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.prodi,
    this.faculty,
    this.year,
    this.kelas,
    this.institusi = 'Institut Teknologi dan Sains Pekalongan',
  });
}

class UserData {
  // Current logged in user
  static AppUser? _currentUser;

  static AppUser? get currentUser => _currentUser;

  // Helper to create student
  static AppUser _createStudent(String nim, String name, String kelas) {
    return AppUser(
      id: nim,
      name: name,
      email: '${name.toLowerCase().replaceAll(' ', '.')}@student.itsp.ac.id',
      role: UserRole.student,
      prodi: 'Informatika',
      faculty: 'Teknik',
      year: '2023',
      kelas: kelas,
    );
  }

  // All users (students + lecturers)
  static final Map<String, AppUser> _users = {
    // ===== KELAS IM23A (Pagi) - 25 mahasiswa =====
    '102230001': _createStudent('102230001', 'Eko Prasetyo', 'IM23A'),
    '102230002': _createStudent('102230002', 'Fitri Handayani', 'IM23A'),
    '102230003': _createStudent('102230003', 'Gunawan Wibowo', 'IM23A'),
    '102230004': _createStudent('102230004', 'Hesti Rahayu', 'IM23A'),
    '102230005': _createStudent('102230005', 'Irfan Maulana', 'IM23A'),
    '102230006': _createStudent('102230006', 'Julia Permata', 'IM23A'),
    '102230007': _createStudent('102230007', 'Kevin Saputra', 'IM23A'),
    '102230008': _createStudent('102230008', 'Linda Kusuma', 'IM23A'),
    '102230009': _createStudent('102230009', 'Mario Pratama', 'IM23A'),
    '102230010': _createStudent('102230010', 'Nadia Putri', 'IM23A'),
    '102230011': _createStudent('102230011', 'Oscar Wijaya', 'IM23A'),
    '102230012': _createStudent('102230012', 'Putri Ayu', 'IM23A'),
    '102230013': _createStudent('102230013', 'Qori Hidayat', 'IM23A'),
    '102230014': _createStudent('102230014', 'Rina Safitri', 'IM23A'),
    '102230015': _createStudent('102230015', 'Surya Dharma', 'IM23A'),
    '102230016': _createStudent('102230016', 'Tika Lestari', 'IM23A'),
    '102230017': _createStudent('102230017', 'Umar Faruq', 'IM23A'),
    '102230018': _createStudent('102230018', 'Vina Anggraeni', 'IM23A'),
    '102230019': _createStudent('102230019', 'Wahyu Nugroho', 'IM23A'),
    '102230020': _createStudent('102230020', 'Xena Maharani', 'IM23A'),
    '102230021': _createStudent('102230021', 'Yoga Pratama', 'IM23A'),
    '102230022': _createStudent('102230022', 'Zahra Amelia', 'IM23A'),
    '102230023': _createStudent('102230023', 'Arif Rahman', 'IM23A'),
    '102230024': _createStudent('102230024', 'Bella Susanti', 'IM23A'),
    '102230025': _createStudent('102230025', 'Candra Wijaya', 'IM23A'),

    // ===== KELAS IM23B (Pagi) - 27 mahasiswa =====
    '102230026': _createStudent('102230026', 'Dani Kurniawan', 'IM23B'),
    '102230027': _createStudent('102230027', 'Eka Putri', 'IM23B'),
    '102230028': _createStudent('102230028', 'Fajar Hidayat', 'IM23B'),
    '102230029': _createStudent('102230029', 'Gita Pramesti', 'IM23B'),
    '102230030': _createStudent('102230030', 'Hendra Gunawan', 'IM23B'),
    '102230031': _createStudent('102230031', 'Intan Permata', 'IM23B'),
    '102230032': _createStudent('102230032', 'Jaya Kusuma', 'IM23B'),
    '102230033': _createStudent('102230033', 'Kartini Wulan', 'IM23B'),
    '102230034': _createStudent('102230034', 'Leo Firmansyah', 'IM23B'),
    '102230035': _createStudent('102230035', 'Mega Sari', 'IM23B'),
    '102230036': _createStudent('102230036', 'Niko Pratama', 'IM23B'),
    '102230037': _createStudent('102230037', 'Olivia Dewi', 'IM23B'),
    '102230038': _createStudent('102230038', 'Putra Mahendra', 'IM23B'),
    '102230044': _createStudent('102230044', 'Rosa Melinda', 'IM23B'),
    '102230045': _createStudent('102230045', 'Sandi Prasetya', 'IM23B'),
    '102230046': _createStudent('102230046', 'Tari Maharani', 'IM23B'),
    '102230047': _createStudent('102230047', 'Uki Wahyudi', 'IM23B'),
    '102230048': _createStudent('102230048', 'Vera Anjani', 'IM23B'),
    '102230049': _createStudent('102230049', 'Wawan Setiawan', 'IM23B'),
    '102230050': _createStudent('102230050', 'Yani Fitriani', 'IM23B'),
    '102230051': _createStudent('102230051', 'Zaki Maulana', 'IM23B'),
    '102230052': _createStudent('102230052', 'Agus Salim', 'IM23B'),

    // ===== KELAS IM23C (Pagi) -  mahasiswa =====
    '102230039': _createStudent('102230039','Ahmad Rizky','IM23C',), // Login user
    '102230040': _createStudent('102230040', 'Siti Nurhaliza', 'IM23C'),
    '102230041': _createStudent('102230041', 'Budi Santoso', 'IM23C'),
    '102230042': _createStudent('102230042', 'Dewi Lestari', 'IM23C'),
    '102230043': _createStudent('102230043', 'Andi Pratama', 'IM23C'),
    '102230053': _createStudent('102230053', 'Feri Yanto', 'IM23C'),
    '102230054': _createStudent('102230054', 'Gina Lolita', 'IM23C'),
    '102230055': _createStudent('102230055', 'Hadi Santoso', 'IM23C'),
    '102230056': _createStudent('102230056', 'Ira Wati', 'IM23C'),
    '102230057': _createStudent('102230057', 'Joko Susilo', 'IM23C'),
    '102230058': _createStudent('102230058', 'Kiki Amelia', 'IM23C'),
    '102230059': _createStudent('102230059', 'Lukman Hakim', 'IM23C'),
    '102230060': _createStudent('102230060', 'Mira Lestari', 'IM23C'),
    '102230061': _createStudent('102230061', 'Nanda Permana', 'IM23C'),
    '102230062': _createStudent('102230062', 'Oki Saputra', 'IM23C'),
    '102230063': _createStudent('102230063', 'Pipit Anggraini', 'IM23C'),
    '102230064': _createStudent('102230064', 'Qila Maharani', 'IM23C'),
    '102230065': _createStudent('102230065', 'Rendi Firmansyah', 'IM23C'),
    '102230066': _createStudent('102230066', 'Siska Widya', 'IM23C'),
    '102230067': _createStudent('102230067', 'Toni Hermawan', 'IM23C'),
    '102230068': _createStudent('102230068', 'Ulfa Safitri', 'IM23C'),
    '102230069': _createStudent('102230069', 'Vicky Ananda', 'IM23C'),
    '102230070': _createStudent('102230070', 'Winda Sari', 'IM23C'),
    '102230071': _createStudent('102230071', 'Xander Putra', 'IM23C'),
    '102230072': _createStudent('102230072', 'Yuda Pratama', 'IM23C'),
    '102230073': _createStudent('102230073', 'Zulfa Amira', 'IM23C'),
    '102230074': _createStudent('102230074', 'Adi Nugroho', 'IM23C'),
    '102230075': _createStudent('102230075', 'Bunga Citra', 'IM23C'),

    // ===== KELAS IM23D (Malam) - 26 mahasiswa =====
    '102230076': _createStudent('102230076', 'Dedi Supriadi', 'IM23D'),
    '102230077': _createStudent('102230077', 'Eva Susanti', 'IM23D'),
    '102230078': _createStudent('102230078', 'Farid Akbar', 'IM23D'),
    '102230079': _createStudent('102230079', 'Gita Nirmala', 'IM23D'),
    '102230080': _createStudent('102230080', 'Hasim Maulana', 'IM23D'),
    '102230081': _createStudent('102230081', 'Indah Permata', 'IM23D'),
    '102230082': _createStudent('102230082', 'Joni Iskandar', 'IM23D'),
    '102230083': _createStudent('102230083', 'Kartika Sari', 'IM23D'),
    '102230084': _createStudent('102230084', 'Luthfi Hakim', 'IM23D'),
    '102230085': _createStudent('102230085', 'Maya Putri', 'IM23D'),
    '102230086': _createStudent('102230086', 'Nur Hidayat', 'IM23D'),
    '102230087': _createStudent('102230087', 'Ovi Marcelina', 'IM23D'),
    '102230088': _createStudent('102230088', 'Pandu Wijaya', 'IM23D'),
    '102230089': _createStudent('102230089', 'Qomar Zaman', 'IM23D'),
    '102230090': _createStudent('102230090', 'Rita Anggraeni', 'IM23D'),
    '102230091': _createStudent('102230091', 'Sahrul Gunawan', 'IM23D'),
    '102230092': _createStudent('102230092', 'Tiara Kusuma', 'IM23D'),
    '102230093': _createStudent('102230093', 'Udin Saepudin', 'IM23D'),
    '102230094': _createStudent('102230094', 'Vina Melati', 'IM23D'),
    '102230095': _createStudent('102230095', 'Wawan Kurniawan', 'IM23D'),
    '102230096': _createStudent('102230096', 'Yanti Susanti', 'IM23D'),
    '102230097': _createStudent('102230097', 'Zaenal Abidin', 'IM23D'),
    '102230098': _createStudent('102230098', 'Anto Sugiarto', 'IM23D'),
    '102230099': _createStudent('102230099', 'Bintang Ramadhan', 'IM23D'),
    '102230100': _createStudent('102230100', 'Citra Dewi', 'IM23D'),
    '102230101': _createStudent('102230101', 'Dimas Pratama', 'IM23D'),

    // ===== DOSEN =====
    '198506152010121001': const AppUser(
      id: '198506152010121001',
      name: 'Dr. Hendra Wijaya, M.Kom',
      email: 'hendra.wijaya@itsp.ac.id',
      role: UserRole.lecturer,
      prodi: 'Informatika',
      faculty: 'Teknik',
    ),
    '198712202015042001': const AppUser(
      id: '198712202015042001',
      name: 'Mega Nindityawati, S.Kom., M.Cs.',
      email: 'mega.nindityawati@itsp.ac.id',
      role: UserRole.lecturer,
      prodi: 'Informatika',
      faculty: 'Teknik',
    ),
    '199003152018031001': const AppUser(
      id: '199003152018031001',
      name: 'Razak Naufal, S.Kom., M.T.',
      email: 'razak.naufal@itsp.ac.id',
      role: UserRole.lecturer,
      prodi: 'Informatika',
      faculty: 'Teknik',
    ),
    '198805102012121001': const AppUser(
      id: '198805102012121001',
      name: "M. Al'Amin, S.Sn., M.Ds.",
      email: 'alamin@itsp.ac.id',
      role: UserRole.lecturer,
      prodi: 'Informatika',
      faculty: 'Teknik',
    ),
    '199105202019032001': const AppUser(
      id: '199105202019032001',
      name: 'Siti Aminah, S.Kom., M.Kom.',
      email: 'siti.aminah@itsp.ac.id',
      role: UserRole.lecturer,
      prodi: 'Informatika',
      faculty: 'Teknik',
    ),

    // ===== ADMIN USERS =====
    'admin@sima.ac.id': const AppUser(
      id: 'admin@sima.ac.id',
      name: 'Administrator',
      email: 'admin@sima.ac.id',
      role: UserRole.admin,
      prodi: 'System Administrator',
      faculty: 'IT Department',
    ),
    'superadmin@sima.ac.id': const AppUser(
      id: 'superadmin@sima.ac.id',
      name: 'Super Admin',
      email: 'superadmin@sima.ac.id',
      role: UserRole.admin,
      prodi: 'System Administrator',
      faculty: 'IT Department',
    ),
  };

  // Authenticate user
  static AppUser? authenticate(
    String id,
    String password,
    UserRole expectedRole,
  ) {
    // Check if email is admin (hidden login)
    if (id.contains('@') && id.endsWith('@sima.ac.id')) {
      final adminUser = _users[id];
      if (adminUser != null && adminUser.role == UserRole.admin) {
        _currentUser = adminUser;
        return adminUser;
      }
    }

    // Normal login flow
    final user = _users[id];
    if (user != null && user.role == expectedRole) {
      _currentUser = user;
      return user;
    }
    return null;
  }

  // Get all admins
  static List<AppUser> getAllAdmins() {
    return _users.values.where((user) => user.role == UserRole.admin).toList();
  }

  // Get user by ID
  static AppUser? getUserById(String id) {
    return _users[id];
  }

  // Get all students
  static List<AppUser> getAllStudents() {
    return _users.values
        .where((user) => user.role == UserRole.student)
        .toList();
  }

  // Get all lecturers
  static List<AppUser> getAllLecturers() {
    return _users.values
        .where((user) => user.role == UserRole.lecturer)
        .toList();
  }

  // Get students by prodi
  static List<AppUser> getStudentsByProdi(String prodi) {
    return _users.values
        .where(
          (user) =>
              user.role == UserRole.student &&
              user.prodi.toLowerCase() == prodi.toLowerCase(),
        )
        .toList();
  }

  // Get students by class code (e.g., IM23C)
  static List<AppUser> getStudentsByKelas(String kelas) {
    return _users.values
        .where((user) => user.role == UserRole.student && user.kelas == kelas)
        .toList();
  }

  // Get all available classes
  static List<String> getAllKelas() {
    return ['IM23A', 'IM23B', 'IM23C', 'IM23D'];
  }

  // Check if class is morning or evening
  static bool isKelasPagi(String kelas) {
    return ['IM23A', 'IM23B', 'IM23C'].contains(kelas);
  }

  // Get student count per kelas
  static int getStudentCountByKelas(String kelas) {
    return getStudentsByKelas(kelas).length;
  }

  // Logout
  static void logout() {
    _currentUser = null;
  }

  // Convert to Student model for backward compatibility
  static Student? getStudentByNim(String nim) {
    final user = _users[nim];
    if (user != null && user.role == UserRole.student) {
      return Student(
        nim: user.id,
        name: user.name,
        prodi: user.prodi,
        year: user.year ?? '',
      );
    }
    return null;
  }

  // Get current user as Student (for backward compatibility)
  static Student get currentStudentUser {
    if (_currentUser != null && _currentUser!.role == UserRole.student) {
      return Student(
        nim: _currentUser!.id,
        name: _currentUser!.name,
        prodi: _currentUser!.prodi,
        year: _currentUser!.year ?? '',
      );
    }
    // Default fallback - Ahmad Rizky from IM23C
    return const Student(
      nim: '102230039',
      name: 'Ahmad Rizky',
      prodi: 'Informatika',
      year: '2023',
    );
  }
}

