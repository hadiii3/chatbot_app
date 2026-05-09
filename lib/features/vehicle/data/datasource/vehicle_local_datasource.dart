import 'package:hive_flutter/hive_flutter.dart';
import 'package:chatbot_app/features/vehicle/data/models/vehicle_permit.dart';

class VehicleLocalDataSource {
  final Box<dynamic> _box;
  static const _key = 'vehicle_permits';

  VehicleLocalDataSource(this._box);

  List<VehiclePermit> getPermits() {
    final raw = _box.get(_key);
    if (raw == null) return [];
    final list = raw as List;
    return list.map((e) {
      final m = e as Map<dynamic, dynamic>;
      return VehiclePermit(
        id: m['id'] as String,
        licensePlate: m['licensePlate'] as String,
        make: m['make'] as String,
        model: m['model'] as String,
        color: m['color'] as String,
        status: PermitStatus.values[(m['status'] as int)],
        requestedAt: DateTime.parse(m['requestedAt'] as String),
      );
    }).toList();
  }

  Future<void> addPermit(VehiclePermit permit) async {
    final existing = getPermits();
    final updated = [
      ...existing.map((p) => _permitToMap(p)),
      _permitToMap(permit),
    ];
    await _box.put(_key, updated);
  }

  Map<String, dynamic> _permitToMap(VehiclePermit p) => {
        'id': p.id,
        'licensePlate': p.licensePlate,
        'make': p.make,
        'model': p.model,
        'color': p.color,
        'status': p.status.index,
        'requestedAt': p.requestedAt.toIso8601String(),
      };
}
