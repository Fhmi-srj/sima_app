// Room data for the app
class RoomData {
  static final List<Room> _rooms = [
    const Room(
      code: 'A1.1',
      name: 'Ruang A1.1',
      building: 'Gedung A',
      floor: 1,
      capacity: 40,
    ),
    const Room(
      code: 'A1.2',
      name: 'Ruang A1.2',
      building: 'Gedung A',
      floor: 1,
      capacity: 40,
    ),
    const Room(
      code: 'A2.1',
      name: 'Ruang A2.1',
      building: 'Gedung A',
      floor: 2,
      capacity: 35,
    ),
    const Room(
      code: 'A2.2',
      name: 'Ruang A2.2',
      building: 'Gedung A',
      floor: 2,
      capacity: 35,
    ),
    const Room(
      code: 'B3.1',
      name: 'Ruang B3.1',
      building: 'Gedung B',
      floor: 3,
      capacity: 50,
    ),
    const Room(
      code: 'B3.2',
      name: 'Ruang B3.2',
      building: 'Gedung B',
      floor: 3,
      capacity: 50,
    ),
    const Room(
      code: 'B3.3',
      name: 'Ruang B3.3',
      building: 'Gedung B',
      floor: 3,
      capacity: 45,
    ),
    const Room(
      code: 'Lab1',
      name: 'Lab Komputer 1',
      building: 'Gedung Lab',
      floor: 1,
      capacity: 30,
      type: 'lab',
    ),
    const Room(
      code: 'Lab2',
      name: 'Lab Komputer 2',
      building: 'Gedung Lab',
      floor: 1,
      capacity: 30,
      type: 'lab',
    ),
    const Room(
      code: 'Lab3',
      name: 'Lab Komputer 3',
      building: 'Gedung Lab',
      floor: 2,
      capacity: 25,
      type: 'lab',
    ),
    const Room(
      code: 'Media',
      name: 'Ruang Media',
      building: 'Gedung B',
      floor: 2,
      capacity: 40,
      type: 'media',
    ),
    const Room(
      code: 'Aula',
      name: 'Aula Utama',
      building: 'Gedung Utama',
      floor: 1,
      capacity: 200,
      type: 'aula',
    ),
    const Room(
      code: 'R.Sidang',
      name: 'Ruang Sidang',
      building: 'Gedung Utama',
      floor: 2,
      capacity: 20,
      type: 'meeting',
    ),
  ];

  static List<Room> getAllRooms() => _rooms.toList();

  static List<Room> searchRooms(String query) {
    if (query.isEmpty) return [];
    final q = query.toLowerCase();
    return _rooms
        .where(
          (r) =>
              r.code.toLowerCase().contains(q) ||
              r.name.toLowerCase().contains(q) ||
              r.building.toLowerCase().contains(q),
        )
        .take(5)
        .toList();
  }

  static Room? getRoomByCode(String code) {
    try {
      return _rooms.firstWhere((r) => r.code == code);
    } catch (_) {
      return null;
    }
  }

  static List<String> getRoomNames() => _rooms.map((r) => r.name).toList();
}

class Room {
  final String code;
  final String name;
  final String building;
  final int floor;
  final int capacity;
  final String type; // 'class', 'lab', 'media', 'aula', 'meeting'

  const Room({
    required this.code,
    required this.name,
    required this.building,
    required this.floor,
    required this.capacity,
    this.type = 'class',
  });
}
