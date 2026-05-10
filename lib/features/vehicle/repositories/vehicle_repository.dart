import 'package:dartz/dartz.dart';
import 'package:chatbot_app/features/vehicle/data/models/vehicle_permit.dart';

abstract class VehicleRepository {
  Future<Either<String, List<VehiclePermit>>> getPermits();
  Future<Either<String, VehiclePermit?>> getCurrentPermit();
  Future<Either<String, VehiclePermit>> addPermit(VehiclePermit permit);
}
