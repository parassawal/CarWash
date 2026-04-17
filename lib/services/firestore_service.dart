import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/car_wash_center.dart';
import '../models/booking.dart';
import '../models/review.dart';
import '../models/time_slot.dart';
import '../data/mock_data.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ---- CENTERS ----

  Stream<List<CarWashCenter>> getCenters() {
    return _db.collection('centers').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final d = doc.data();
        return CarWashCenter(
          id: doc.id,
          name: d['name'] ?? '',
          address: d['address'] ?? '',
          phone: d['phone'] ?? '',
          rating: (d['rating'] ?? 0).toDouble(),
          reviewCount: d['reviewCount'] ?? 0,
          imageUrl: d['imageUrl'] ?? '',
          latitude: (d['latitude'] ?? 0).toDouble(),
          longitude: (d['longitude'] ?? 0).toDouble(),
          services: (d['services'] as List<dynamic>? ?? [])
              .map(
                (s) => ServiceItem(
                  name: s['name'] ?? '',
                  price: (s['price'] ?? 0).toDouble(),
                  duration: s['duration'] ?? '',
                  icon: s['icon'] ?? '💧',
                ),
              )
              .toList(),
          distance: (d['distance'] ?? 0).toDouble(),
          isOpen: d['isOpen'] ?? true,
          openTime: d['openTime'] ?? '',
          closeTime: d['closeTime'] ?? '',
          description: d['description'] ?? '',
          timeSlots: (d['timeSlots'] as List<dynamic>? ?? [])
              .map(
                (t) => TimeSlot(
                  id: t['id'] ?? '',
                  time: t['time'] ?? '',
                  isAvailable: t['isAvailable'] ?? true,
                ),
              )
              .toList(),
        );
      }).toList();
    });
  }

  Future<void> seedCenters() async {
    final snapshot = await _db.collection('centers').limit(1).get();
    if (snapshot.docs.isNotEmpty) return; // Already seeded

    await _seedCentersAtLocation(0, 0); // Default coords, will be overwritten
  }

  // Delete all centers and re-seed near a specific location
  Future<void> seedTestDataNearLocation(double lat, double lng) async {
    // Delete existing centers and their reviews
    final existing = await _db.collection('centers').get();
    for (final doc in existing.docs) {
      // Delete reviews subcollection
      final reviews = await doc.reference.collection('reviews').get();
      for (final r in reviews.docs) {
        await r.reference.delete();
      }
      await doc.reference.delete();
    }

    await _seedCentersAtLocation(lat, lng);
  }

  Future<void> _seedCentersAtLocation(double lat, double lng) async {
    final centers = MockData.getCenters();
    // Offsets to scatter centers around the user's location (in degrees, ~0.005 = 500m)
    final offsets = [
      [0.004, 0.003],
      [-0.003, 0.005],
      [0.006, -0.002],
      [-0.005, -0.004],
      [0.002, 0.007],
      [-0.007, 0.001],
      [0.008, -0.005],
      [-0.001, -0.008],
    ];

    final batch = _db.batch();
    for (int i = 0; i < centers.length; i++) {
      final c = centers[i];
      final offset = offsets[i % offsets.length];
      final centerLat = lat + offset[0];
      final centerLng = lng + offset[1];

      final ref = _db.collection('centers').doc(c.id);
      batch.set(ref, {
        'name': c.name,
        'address': c.address,
        'phone': c.phone,
        'rating': c.rating,
        'reviewCount': c.reviewCount,
        'imageUrl': c.imageUrl,
        'latitude': centerLat,
        'longitude': centerLng,
        'services': c.services
            .map(
              (s) => {
                'name': s.name,
                'price': s.price,
                'duration': s.duration,
                'icon': s.icon,
              },
            )
            .toList(),
        'distance': c.distance,
        'isOpen': c.isOpen,
        'openTime': c.openTime,
        'closeTime': c.closeTime,
        'description': c.description,
        'timeSlots': c.timeSlots
            .map(
              (t) => {'id': t.id, 'time': t.time, 'isAvailable': t.isAvailable},
            )
            .toList(),
      });
    }
    await batch.commit();

    // Seed reviews
    for (final c in centers) {
      final reviews = MockData.getReviews(c.id);
      for (final r in reviews) {
        await _db
            .collection('centers')
            .doc(c.id)
            .collection('reviews')
            .doc(r.id)
            .set({
              'userName': r.userName,
              'userAvatar': r.userAvatar,
              'rating': r.rating,
              'comment': r.comment,
              'date': Timestamp.fromDate(r.date),
            });
      }
    }
  }

  // ---- BOOKINGS ----

  Future<void> addBooking(String userId, Booking booking, {String userName = '', String userEmail = '', String userPhone = ''}) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('bookings')
        .doc(booking.id)
        .set({
          'centerId': booking.centerId,
          'centerName': booking.centerName,
          'centerImage': booking.centerImage,
          'date': Timestamp.fromDate(booking.date),
          'timeSlot': booking.timeSlot,
          'service': booking.service,
          'price': booking.price,
          'status': booking.status.name,
          // Store user details so admin panel can display them
          'userId': userId,
          'userName': userName,
          'userEmail': userEmail,
          'userPhone': userPhone,
        });
  }

  /// Mark a time slot on a center as booked (isAvailable = false) for a given date.
  /// Uses a sub-collection path: centers/{centerId}/bookedSlots/{dateKey}/{slotId}
  Future<void> markSlotBooked(String centerId, String slotTime, DateTime date) async {
    final dateKey = '${date.year}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}';
    await _db
        .collection('centers')
        .doc(centerId)
        .collection('bookedSlots')
        .doc(dateKey)
        .set({slotTime: true}, SetOptions(merge: true));
  }

  /// Fetch booked slot times for a center on a given date.
  Future<Set<String>> getBookedSlots(String centerId, DateTime date) async {
    final dateKey = '${date.year}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')}';
    final doc = await _db
        .collection('centers')
        .doc(centerId)
        .collection('bookedSlots')
        .doc(dateKey)
        .get();
    if (!doc.exists || doc.data() == null) return {};
    return doc.data()!.keys.toSet();
  }

  Stream<List<Booking>> getBookings(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('bookings')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final d = doc.data();
            return Booking(
              id: doc.id,
              centerId: d['centerId'] ?? '',
              centerName: d['centerName'] ?? '',
              centerImage: d['centerImage'] ?? '',
              date: (d['date'] as Timestamp).toDate(),
              timeSlot: d['timeSlot'] ?? '',
              service: d['service'] ?? '',
              price: (d['price'] ?? 0).toDouble(),
              status: BookingStatus.values.firstWhere(
                (s) => s.name == (d['status'] ?? 'pending'),
                orElse: () => BookingStatus.pending,
              ),
            );
          }).toList();
        });
  }

  Future<void> cancelBooking(String userId, String bookingId) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('bookings')
        .doc(bookingId)
        .update({'status': 'cancelled'});
  }

  /// Called by admin to accept a pending booking → sets status to 'confirmed'
  /// and writes a notification to the user's notifications subcollection.
  Future<void> acceptBooking(String userId, String bookingId) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('bookings')
        .doc(bookingId)
        .update({'status': 'confirmed'});

    // Write a notification so the user sees an in-app alert
    await _db
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .add({
          'type': 'booking_confirmed',
          'bookingId': bookingId,
          'message': 'Your booking has been accepted! 🎉',
          'isRead': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
  }

  /// Stream of unread notifications for the user.
  Stream<List<Map<String, dynamic>>> getNotifications(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .where('isRead', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => {'id': d.id, ...d.data()})
            .toList());
  }

  Future<void> markNotificationRead(String userId, String notificationId) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .doc(notificationId)
        .update({'isRead': true});
  }

  // ---- REVIEWS ----

  Stream<List<Review>> getReviews(String centerId) {
    return _db
        .collection('centers')
        .doc(centerId)
        .collection('reviews')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final d = doc.data();
            return Review(
              id: doc.id,
              centerId: centerId,
              userName: d['userName'] ?? '',
              userAvatar: d['userAvatar'] ?? '',
              rating: (d['rating'] ?? 0).toDouble(),
              comment: d['comment'] ?? '',
              date: (d['date'] as Timestamp).toDate(),
            );
          }).toList();
        });
  }

  Future<void> addReview(String centerId, Review review) async {
    await _db
        .collection('centers')
        .doc(centerId)
        .collection('reviews')
        .doc(review.id)
        .set({
          'userName': review.userName,
          'userAvatar': review.userAvatar,
          'rating': review.rating,
          'comment': review.comment,
          'date': Timestamp.fromDate(review.date),
        });

    // Update center rating
    final reviewsSnap = await _db
        .collection('centers')
        .doc(centerId)
        .collection('reviews')
        .get();
    double totalRating = 0;
    for (final doc in reviewsSnap.docs) {
      totalRating += (doc.data()['rating'] ?? 0).toDouble();
    }
    final avgRating = totalRating / reviewsSnap.docs.length;
    await _db.collection('centers').doc(centerId).update({
      'rating': double.parse(avgRating.toStringAsFixed(1)),
      'reviewCount': reviewsSnap.docs.length,
    });
  }

  // ---- FAVORITES ----

  Stream<List<String>> getFavorites(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.id).toList();
    });
  }

  Future<void> toggleFavorite(String userId, String centerId, bool isFavorite) async {
    if (isFavorite) {
      await _db
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(centerId)
          .set({'timestamp': FieldValue.serverTimestamp()});
    } else {
      await _db
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(centerId)
          .delete();
    }
  }
}
