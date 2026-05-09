import 'package:hive_flutter/hive_flutter.dart';
import 'package:chatbot_app/features/vehicle/data/models/vehicle_permit.dart';

class VehicleLocalDataSource {
  final Box<dynamic> _box;
  static const _historyKey = 'vehicle_permits_history';
  static const _currentKey = 'vehicle_current_state';

  VehicleLocalDataSource(this._box);

  List<VehiclePermit> getPermitHistory() {
    final raw = _box.get(_historyKey);
    if (raw == null) return [];
    final list = raw as List;
    return list.map((e) {
      final m = Map<String, dynamic>.from(e as Map);
      return VehiclePermit.fromMap(m);
    }).toList();
  }

  Future<void> cachePermitHistory(List<VehiclePermit> permits) async {
    final updated = permits.map((p) => p.toMap()).toList();
    await _box.put(_historyKey, updated);
  }

  VehiclePermit? getCurrentPermit() {
    final raw = _box.get(_currentKey);
    if (raw == null) return null;
    try {
      return VehiclePermit.fromMap(Map<String, dynamic>.from(raw as Map));
    } catch (_) {
      return null;
    }
  }

  Future<void> cacheCurrentPermit(VehiclePermit? permit) async {
    if (permit == null) {
      await _box.delete(_currentKey);
    } else {
      await _box.put(_currentKey, permit.toMap());
    }
  }

  Future<void> addPermitToHistory(VehiclePermit permit) async {
    final existing = getPermitHistory();
    // Prepend to history assuming newest first
    final updated = [
      permit.toMap(),
      ...existing.map((p) => p.toMap()),
    ];
    await _box.put(_historyKey, updated);
  }
}
