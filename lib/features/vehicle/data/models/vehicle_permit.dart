// VehiclePermit model — mirrors backend_specs.md VehiclePermit table
class VehiclePermit {
  final String id;
  final String licensePlate;
  final String make;
  final String model;
  final String color;
  final PermitStatus status;
  final DateTime requestedAt;

  const VehiclePermit({
    required this.id,
    required this.licensePlate,
    required this.make,
    required this.model,
    required this.color,
    required this.status,
    required this.requestedAt,
  });
}

enum PermitStatus { pending, approved, rejected }

extension PermitStatusExt on PermitStatus {
  String get label {
    switch (this) {
      case PermitStatus.pending:
        return 'Pending Review';
      case PermitStatus.approved:
        return 'Approved';
      case PermitStatus.rejected:
        return 'Rejected';
    }
  }
}
