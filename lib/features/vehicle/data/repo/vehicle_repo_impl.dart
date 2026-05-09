import 'package:chatbot_app/features/vehicle/data/datasource/vehicle_local_datasource.dart';
import 'package:chatbot_app/features/vehicle/data/models/vehicle_permit.dart';
import 'package:chatbot_app/features/vehicle/repositories/vehicle_repository.dart';

class VehicleRepoImpl implements VehicleRepository {
  final VehicleLocalDataSource _ds;
  VehicleRepoImpl(this._ds);

  @override
  List<VehiclePermit> getPermits() => _ds.getPermits();

  @override
  Future<void> addPermit(VehiclePermit permit) => _ds.addPermit(permit);
}
