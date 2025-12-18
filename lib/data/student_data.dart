import '../models/student_model.dart';
import 'user_data.dart';

class StudentData {
  // Simulasi database mahasiswa (mirip dengan HTML version)
  static final Map<String, Student> students = {
    '102230039': const Student(
      nim: '102230039',
      name: 'Ahmad Rizky',
      prodi: 'Informatika',
      year: '2023',
    ),
    '102230040': const Student(
      nim: '102230040',
      name: 'Siti Nurhaliza',
      prodi: 'Sistem Informasi',
      year: '2023',
    ),
    '102230041': const Student(
      nim: '102230041',
      name: 'Budi Santoso',
      prodi: 'Informatika',
      year: '2023',
    ),
  };

  // Dynamic current user based on actual login
  static Student get currentUser {
    final user = UserData.currentUser;
    if (user != null && user.role == UserRole.student) {
      return Student(
        nim: user.id,
        name: user.name,
        prodi: user.prodi,
        year: user.year ?? '',
      );
    }
    // Fallback to default user if not logged in
    return const Student(
      nim: '102230039',
      name: 'Ahmad Rizky',
      prodi: 'Informatika',
      year: '2023',
    );
  }

  static Student? getStudentByNim(String nim) {
    // First check from UserData for all registered students
    final userStudent = UserData.getStudentByNim(nim);
    if (userStudent != null) {
      return userStudent;
    }
    // Fallback to local students map
    return students[nim];
  }
}
