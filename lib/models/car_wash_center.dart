import 'time_slot.dart';

class CarWashCenter {
  final String id;
  final String name;
  final String address;
  final String phone;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final double latitude;
  final double longitude;
  final List<ServiceItem> services;
  final double distance;
  final bool isOpen;
  final String openTime;
  final String closeTime;
  final String description;
  final List<TimeSlot> timeSlots;

  CarWashCenter({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.services,
    required this.distance,
    required this.isOpen,
    required this.openTime,
    required this.closeTime,
    required this.description,
    required this.timeSlots,
  });
}

class ServiceItem {
  final String name;
  final double price;
  final String duration;
  final String icon;

  ServiceItem({
    required this.name,
    required this.price,
    required this.duration,
    required this.icon,
  });
}
