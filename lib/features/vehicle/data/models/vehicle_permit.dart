enum PermitStatus { pending, approved, rejected, none }

extension PermitStatusExt on PermitStatus {
  String get label {
    switch (this) {
      case PermitStatus.pending:
        return 'Pending Review';
      case PermitStatus.approved:
        return 'Approved';
      case PermitStatus.rejected:
        return 'Rejected';
      case PermitStatus.none:
        return 'None';
    }
  }

  static PermitStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return PermitStatus.pending;
      case 'approved':
        return PermitStatus.approved;
      case 'rejected':
        return PermitStatus.rejected;
      default:
        return PermitStatus.none;
    }
  }
}

class VehiclePermit {
  final int id;
  final String licensePlate;
  final String make;
  final String model;
  final String color;
  final PermitStatus status;
  final DateTime? requestedAt;
  final DateTime? validFrom;
  final DateTime? validUntil;
  final String? rejectionReason;

  const VehiclePermit({
    required this.id,
    required this.licensePlate,
    required this.make,
    required this.model,
    required this.color,
    required this.status,
    this.requestedAt,
    this.validFrom,
    this.validUntil,
    this.rejectionReason,
  });

  factory VehiclePermit.fromMap(Map<String, dynamic> map) {
    final statusStr = map['status'] as String? ?? 'none';
    final status = PermitStatusExt.fromString(statusStr);

    DateTime? reqAt;
    if (map['submitted_at'] != null) {
      reqAt = DateTime.tryParse(map['submitted_at'] as String);
    } else if (map['created_at'] != null) {
      reqAt = DateTime.tryParse(map['created_at'] as String);
    } else if (map['approved_at'] != null) {
      reqAt = DateTime.tryParse(map['approved_at'] as String);
    } else if (map['rejected_at'] != null) {
      reqAt = DateTime.tryParse(map['rejected_at'] as String);
    }

    return VehiclePermit(
      id: map['id'] as int? ?? 0,
      licensePlate: map['plate_number'] as String? ?? '',
      make: map['vehicle_type'] as String? ?? '',
      model: map['vehicle_model'] as String? ?? '',
      color: map['vehicle_color'] as String? ?? '',
      status: status,
      requestedAt: reqAt,
      validFrom: map['valid_from'] != null
          ? DateTime.tryParse(map['valid_from'] as String)
          : null,
      validUntil: map['valid_until'] != null
          ? DateTime.tryParse(map['valid_until'] as String)
          : null,
      rejectionReason: map['rejection_reason'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'plate_number': licensePlate,
      'vehicle_type': make,
      'vehicle_model': model,
      'vehicle_color': color,
      'status': status.name,
      'submitted_at': requestedAt?.toIso8601String(),
      'valid_from': validFrom?.toIso8601String(),
      'valid_until': validUntil?.toIso8601String(),
      'rejection_reason': rejectionReason,
    };
  }
}
