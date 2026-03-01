class Booking {
  final String id;
  final String centerId;
  final String centerName;
  final String centerImage;
  final DateTime date;
  final String timeSlot;
  final String service;
  final double price;
  final BookingStatus status;

  Booking({
    required this.id,
    required this.centerId,
    required this.centerName,
    required this.centerImage,
    required this.date,
    required this.timeSlot,
    required this.service,
    required this.price,
    required this.status,
  });

  Booking copyWith({BookingStatus? status}) {
    return Booking(
      id: id,
      centerId: centerId,
      centerName: centerName,
      centerImage: centerImage,
      date: date,
      timeSlot: timeSlot,
      service: service,
      price: price,
      status: status ?? this.status,
    );
  }
}

enum BookingStatus { confirmed, completed, cancelled }
