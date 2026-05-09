import 'package:dartz/dartz.dart';
import 'package:chatbot_app/features/vehicle/data/datasource/vehicle_local_datasource.dart';
import 'package:chatbot_app/features/vehicle/data/datasource/vehicle_remote_datasource.dart';
import 'package:chatbot_app/features/vehicle/data/models/vehicle_permit.dart';
import 'package:chatbot_app/features/vehicle/repositories/vehicle_repository.dart';

class VehicleRepoImpl implements VehicleRepository {
  final VehicleLocalDataSource _localDataSource;
  final VehicleRemoteDataSource _remoteDataSource;

  VehicleRepoImpl(this._localDataSource, this._remoteDataSource);

  @override
  Future<Either<String, List<VehiclePermit>>> getPermits() async {
    try {
      final permits = await _remoteDataSource.getVehicleHistory();
      await _localDataSource.cachePermitHistory(permits);
      return Right(permits);
    } catch (e) {
      final cached = _localDataSource.getPermitHistory();
      if (cached.isNotEmpty) {
        return Right(cached);
      }
      return const Left('Failed to load vehicle history. Please check your network connection.');
    }
  }

  @override
  Future<Either<String, VehiclePermit?>> getCurrentPermit() async {
    try {
      final permit = await _remoteDataSource.getCurrentVehicleState();
      await _localDataSource.cacheCurrentPermit(permit);
      return Right(permit);
    } catch (e) {
      final cached = _localDataSource.getCurrentPermit();
      return Right(cached);
    }
  }

  @override
  Future<Either<String, VehiclePermit>> addPermit(VehiclePermit permit) async {
    try {
      final newPermit = await _remoteDataSource.requestVehiclePermit(
        vehicleType: permit.make,
        vehicleModel: permit.model,
        vehicleColor: permit.color,
        plateNumber: permit.licensePlate,
      );
      await _localDataSource.addPermitToHistory(newPermit);
      await _localDataSource.cacheCurrentPermit(newPermit);
      return Right(newPermit);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
