import 'package:flutter/material.dart';
import 'dart:async';
import '../models/car_wash_center.dart';
import '../models/booking.dart';
import '../models/review.dart';
import '../services/firestore_service.dart';
import '../services/location_service.dart';

class AppProvider extends ChangeNotifier {
  final FirestoreService _firestore = FirestoreService();
  final LocationService locationService = LocationService();

  List<CarWashCenter> _centers = [];
  List<Booking> _bookings = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _isLoading = true;
  String? _userId;
  bool _isSeedingData = false;

  StreamSubscription? _centersSub;
  StreamSubscription? _bookingsSub;

  bool get isSeedingData => _isSeedingData;

  List<CarWashCenter> get centers {
    var filtered = _centers.map((c) {
      // Calculate real distance from user location
      if (locationService.currentPosition != null) {
        final dist = locationService.distanceTo(c.latitude, c.longitude);
        return CarWashCenter(
          id: c.id,
          name: c.name,
          address: c.address,
          phone: c.phone,
          rating: c.rating,
          reviewCount: c.reviewCount,
          imageUrl: c.imageUrl,
          latitude: c.latitude,
          longitude: c.longitude,
          services: c.services,
          distance: double.parse(dist.toStringAsFixed(1)),
          isOpen: c.isOpen,
          openTime: c.openTime,
          closeTime: c.closeTime,
          description: c.description,
          timeSlots: c.timeSlots,
        );
      }
      return c;
    }).toList();

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (c) =>
                c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                c.address.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                c.services.any(
                  (s) =>
                      s.name.toLowerCase().contains(_searchQuery.toLowerCase()),
                ),
          )
          .toList();
    }
    if (_selectedCategory != 'All') {
      filtered = filtered
          .where(
            (c) => c.services.any(
              (s) => s.name.toLowerCase().contains(
                _selectedCategory.toLowerCase(),
              ),
            ),
          )
          .toList();
    }

    // Sort by distance
    filtered.sort((a, b) => a.distance.compareTo(b.distance));
    return filtered;
  }

  List<Booking> get bookings => _bookings;
  List<Booking> get upcomingBookings =>
      _bookings.where((b) => b.status == BookingStatus.confirmed).toList();
  List<Booking> get pastBookings =>
      _bookings.where((b) => b.status != BookingStatus.confirmed).toList();
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;

  void init(String userId) {
    _userId = userId;
    _loadCenters();
    _loadBookings();
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    await locationService.getCurrentLocation();
    notifyListeners(); // Recalculate distances
  }

  void _loadCenters() {
    _centersSub?.cancel();
    _centersSub = _firestore.getCenters().listen(
      (centers) {
        _centers = centers;
        _isLoading = false;
        notifyListeners();
      },
      onError: (e) {
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  void _loadBookings() {
    if (_userId == null) return;
    _bookingsSub?.cancel();
    _bookingsSub = _firestore.getBookings(_userId!).listen((bookings) {
      _bookings = bookings;
      notifyListeners();
    });
  }

  Future<void> seedData() async {
    await _firestore.seedCenters();
  }

  // Seed test data near user's current location
  Future<void> seedTestDataNearMe() async {
    if (locationService.currentPosition == null) {
      await locationService.getCurrentLocation();
    }
    if (locationService.currentPosition == null) return;

    _isSeedingData = true;
    notifyListeners();

    await _firestore.seedTestDataNearLocation(
      locationService.latitude,
      locationService.longitude,
    );

    _isSeedingData = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Stream<List<Review>> getReviews(String centerId) {
    return _firestore.getReviews(centerId);
  }

  Future<void> addReview(Review review) async {
    await _firestore.addReview(review.centerId, review);
  }

  Future<void> addBooking(Booking booking) async {
    if (_userId == null) return;
    await _firestore.addBooking(_userId!, booking);
  }

  Future<void> cancelBooking(String bookingId) async {
    if (_userId == null) return;
    await _firestore.cancelBooking(_userId!, bookingId);
  }

  CarWashCenter? getCenterById(String id) {
    try {
      return _centers.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  void dispose() {
    _centersSub?.cancel();
    _bookingsSub?.cancel();
    super.dispose();
  }
}
