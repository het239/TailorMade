class TailorService {
  final String serviceId;
  final String tailorId;
  final String serviceName;
  final double price;

  TailorService({
    required this.serviceId,
    required this.tailorId,
    required this.serviceName,
    required this.price,
  });

  factory TailorService.fromJson(Map<String, dynamic> json) {
    return TailorService(
      serviceId: json['service_id'],
      tailorId: json['tailor_id'],
      serviceName: json['service_name'],
      price: json['price'],
    );
  }
}