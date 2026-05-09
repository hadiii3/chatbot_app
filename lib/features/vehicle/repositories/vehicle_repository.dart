import 'package:chatbot_app/features/vehicle/data/models/vehicle_permit.dart';

abstract class VehicleRepository {
  List<VehiclePermit> getPermits();
  Future<void> addPermit(VehiclePermit permit);
}
