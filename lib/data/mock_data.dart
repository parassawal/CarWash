import '../models/car_wash_center.dart';
import '../models/review.dart';
import '../models/time_slot.dart';

class MockData {
  static List<CarWashCenter> getCenters() {
    return [
      CarWashCenter(
        id: '1',
        name: 'SparkleWash Pro',
        address: 'MG Road, Sector 17, Chandigarh',
        phone: '+91 98765 43210',
        rating: 4.5,
        reviewCount: 328,
        imageUrl:
            'https://images.unsplash.com/photo-1520340356584-f9917d1eea6f?w=800',
        latitude: 30.7333,
        longitude: 76.7794,
        services: [
          ServiceItem(
            name: 'Basic Wash',
            price: 299,
            duration: '30 min',
            icon: '💧',
          ),
          ServiceItem(
            name: 'Premium Wash',
            price: 599,
            duration: '45 min',
            icon: '✨',
          ),
          ServiceItem(
            name: 'Interior Clean',
            price: 799,
            duration: '60 min',
            icon: '🧹',
          ),
          ServiceItem(
            name: 'Full Detail',
            price: 1499,
            duration: '90 min',
            icon: '💎',
          ),
        ],
        distance: 1.2,
        isOpen: true,
        openTime: '8:00 AM',
        closeTime: '8:00 PM',
        description:
            'Premium car washing and detailing center with state-of-the-art equipment. We treat your car like our own!',
        timeSlots: getTimeSlots(),
      ),
      CarWashCenter(
        id: '2',
        name: 'AquaShine Motors',
        address: 'Bandra West, Mumbai, Maharashtra',
        phone: '+91 98765 12345',
        rating: 4.3,
        reviewCount: 215,
        imageUrl:
            'https://images.unsplash.com/photo-1601362840469-51e4d8d58785?w=800',
        latitude: 19.0596,
        longitude: 72.8295,
        services: [
          ServiceItem(
            name: 'Quick Wash',
            price: 199,
            duration: '20 min',
            icon: '💧',
          ),
          ServiceItem(
            name: 'Foam Wash',
            price: 449,
            duration: '40 min',
            icon: '🫧',
          ),
          ServiceItem(
            name: 'Ceramic Coating',
            price: 2999,
            duration: '120 min',
            icon: '🛡️',
          ),
          ServiceItem(
            name: 'Engine Clean',
            price: 899,
            duration: '60 min',
            icon: '⚙️',
          ),
        ],
        distance: 2.5,
        isOpen: true,
        openTime: '7:00 AM',
        closeTime: '9:00 PM',
        description:
            'Your one-stop solution for car care. From basic wash to ceramic coating, we do it all with precision.',
        timeSlots: getTimeSlots(),
      ),
      CarWashCenter(
        id: '3',
        name: 'CleanDrive Hub',
        address: 'Koramangala, Bangalore, Karnataka',
        phone: '+91 87654 32109',
        rating: 4.7,
        reviewCount: 456,
        imageUrl:
            'https://images.unsplash.com/photo-1601055903647-ddf1ee9701b7?w=800',
        latitude: 12.9352,
        longitude: 77.6245,
        services: [
          ServiceItem(
            name: 'Eco Wash',
            price: 249,
            duration: '25 min',
            icon: '🌿',
          ),
          ServiceItem(
            name: 'Premium Wash',
            price: 549,
            duration: '45 min',
            icon: '✨',
          ),
          ServiceItem(
            name: 'Interior + Exterior',
            price: 999,
            duration: '75 min',
            icon: '🏆',
          ),
          ServiceItem(
            name: 'Paint Protection',
            price: 3499,
            duration: '150 min',
            icon: '🎨',
          ),
        ],
        distance: 0.8,
        isOpen: true,
        openTime: '6:00 AM',
        closeTime: '10:00 PM',
        description:
            'Eco-friendly car wash using biodegradable products. Top rated in Bangalore for quality and service.',
        timeSlots: getTimeSlots(),
      ),
      CarWashCenter(
        id: '4',
        name: 'Royal Car Spa',
        address: 'Connaught Place, New Delhi',
        phone: '+91 99887 76655',
        rating: 4.1,
        reviewCount: 189,
        imageUrl:
            'https://images.unsplash.com/photo-1507136566006-cfc505b114fc?w=800',
        latitude: 28.6315,
        longitude: 77.2167,
        services: [
          ServiceItem(
            name: 'Express Wash',
            price: 349,
            duration: '20 min',
            icon: '⚡',
          ),
          ServiceItem(
            name: 'Deluxe Wash',
            price: 699,
            duration: '50 min',
            icon: '👑',
          ),
          ServiceItem(
            name: 'Upholstery Clean',
            price: 1299,
            duration: '90 min',
            icon: '🛋️',
          ),
          ServiceItem(
            name: 'Complete Makeover',
            price: 2499,
            duration: '180 min',
            icon: '💫',
          ),
        ],
        distance: 3.1,
        isOpen: false,
        openTime: '9:00 AM',
        closeTime: '7:00 PM',
        description:
            'Royal treatment for your car. Our skilled team ensures every corner of your vehicle shines like new.',
        timeSlots: getTimeSlots(),
      ),
      CarWashCenter(
        id: '5',
        name: 'WashMaster Express',
        address: 'Anna Nagar, Chennai, Tamil Nadu',
        phone: '+91 94433 22110',
        rating: 4.6,
        reviewCount: 312,
        imageUrl:
            'https://images.unsplash.com/photo-1600880292203-757bb62b4baf?w=800',
        latitude: 13.0827,
        longitude: 80.2707,
        services: [
          ServiceItem(
            name: 'Basic Wash',
            price: 199,
            duration: '25 min',
            icon: '💧',
          ),
          ServiceItem(
            name: 'Steam Wash',
            price: 599,
            duration: '40 min',
            icon: '♨️',
          ),
          ServiceItem(
            name: 'Teflon Coating',
            price: 1999,
            duration: '120 min',
            icon: '🔮',
          ),
          ServiceItem(
            name: 'AC Vent Clean',
            price: 499,
            duration: '30 min',
            icon: '❄️',
          ),
        ],
        distance: 1.7,
        isOpen: true,
        openTime: '7:30 AM',
        closeTime: '8:30 PM',
        description:
            'Quick, affordable, and thorough car wash services. Serving Chennai with love since 2015.',
        timeSlots: getTimeSlots(),
      ),
      CarWashCenter(
        id: '6',
        name: 'AutoGlow Detailing',
        address: 'Viman Nagar, Pune, Maharashtra',
        phone: '+91 90112 33445',
        rating: 4.8,
        reviewCount: 523,
        imageUrl:
            'https://images.unsplash.com/photo-1605164599901-db40d0fd63d2?w=800',
        latitude: 18.5679,
        longitude: 73.9143,
        services: [
          ServiceItem(
            name: 'Waterless Wash',
            price: 399,
            duration: '30 min',
            icon: '🌊',
          ),
          ServiceItem(
            name: 'Clay Bar Treatment',
            price: 899,
            duration: '60 min',
            icon: '🧽',
          ),
          ServiceItem(
            name: 'Graphene Coating',
            price: 4999,
            duration: '180 min',
            icon: '💠',
          ),
          ServiceItem(
            name: 'Headlight Restore',
            price: 699,
            duration: '45 min',
            icon: '💡',
          ),
        ],
        distance: 0.5,
        isOpen: true,
        openTime: '8:00 AM',
        closeTime: '9:00 PM',
        description:
            'Award-winning detailing studio. We specialize in premium coatings and paint correction.',
        timeSlots: getTimeSlots(),
      ),
      CarWashCenter(
        id: '7',
        name: 'FreshRide Wash',
        address: 'Salt Lake, Kolkata, West Bengal',
        phone: '+91 83365 44778',
        rating: 4.0,
        reviewCount: 142,
        imageUrl:
            'https://images.unsplash.com/photo-1552930294-6b595f4c2974?w=800',
        latitude: 22.5726,
        longitude: 88.3639,
        services: [
          ServiceItem(
            name: 'Rinse & Dry',
            price: 149,
            duration: '15 min',
            icon: '🚿',
          ),
          ServiceItem(
            name: 'Full Wash',
            price: 399,
            duration: '35 min',
            icon: '💧',
          ),
          ServiceItem(
            name: 'Vacuum & Interior',
            price: 599,
            duration: '45 min',
            icon: '🧹',
          ),
          ServiceItem(
            name: 'Polish & Wax',
            price: 999,
            duration: '75 min',
            icon: '🪄',
          ),
        ],
        distance: 4.2,
        isOpen: true,
        openTime: '8:00 AM',
        closeTime: '7:00 PM',
        description:
            'Affordable car wash for everyone. Fast service without compromising on quality.',
        timeSlots: getTimeSlots(),
      ),
      CarWashCenter(
        id: '8',
        name: 'Crystal Clear Auto',
        address: 'Jubilee Hills, Hyderabad, Telangana',
        phone: '+91 96778 55443',
        rating: 4.4,
        reviewCount: 267,
        imageUrl:
            'https://images.unsplash.com/photo-1527853787696-f7be74f2e39a?w=800',
        latitude: 17.4326,
        longitude: 78.4071,
        services: [
          ServiceItem(
            name: 'Pressure Wash',
            price: 299,
            duration: '25 min',
            icon: '🔫',
          ),
          ServiceItem(
            name: 'Foam Party',
            price: 499,
            duration: '35 min',
            icon: '🫧',
          ),
          ServiceItem(
            name: 'Rubbing & Polish',
            price: 1199,
            duration: '90 min',
            icon: '✨',
          ),
          ServiceItem(
            name: 'Underbody Wash',
            price: 799,
            duration: '50 min',
            icon: '🔧',
          ),
        ],
        distance: 2.0,
        isOpen: true,
        openTime: '7:00 AM',
        closeTime: '8:00 PM',
        description:
            'Crystal clear results every time. Our trained professionals use only the best products.',
        timeSlots: getTimeSlots(),
      ),
    ];
  }

  static List<Review> getReviews(String centerId) {
    final allReviews = {
      '1': [
        Review(
          id: 'r1',
          centerId: '1',
          userName: 'Rahul Sharma',
          userAvatar: 'RS',
          rating: 5.0,
          comment:
              'Absolutely amazing service! My car looks brand new. The staff was very professional and friendly.',
          date: DateTime.now().subtract(const Duration(days: 2)),
        ),
        Review(
          id: 'r2',
          centerId: '1',
          userName: 'Priya Patel',
          userAvatar: 'PP',
          rating: 4.0,
          comment:
              'Good wash quality but had to wait 15 mins extra. Otherwise great experience.',
          date: DateTime.now().subtract(const Duration(days: 5)),
        ),
        Review(
          id: 'r3',
          centerId: '1',
          userName: 'Amit Kumar',
          userAvatar: 'AK',
          rating: 4.5,
          comment:
              'Premium wash was worth every penny. Will definitely come back!',
          date: DateTime.now().subtract(const Duration(days: 8)),
        ),
        Review(
          id: 'r4',
          centerId: '1',
          userName: 'Sneha Reddy',
          userAvatar: 'SR',
          rating: 5.0,
          comment:
              'Best car wash in the area. Highly recommend the full detail service.',
          date: DateTime.now().subtract(const Duration(days: 12)),
        ),
      ],
      '2': [
        Review(
          id: 'r5',
          centerId: '2',
          userName: 'Vikram Singh',
          userAvatar: 'VS',
          rating: 4.5,
          comment: 'Great foam wash! The ceramic coating is excellent too.',
          date: DateTime.now().subtract(const Duration(days: 1)),
        ),
        Review(
          id: 'r6',
          centerId: '2',
          userName: 'Neha Gupta',
          userAvatar: 'NG',
          rating: 4.0,
          comment: 'Decent service. Could improve on the waiting area.',
          date: DateTime.now().subtract(const Duration(days: 4)),
        ),
        Review(
          id: 'r7',
          centerId: '2',
          userName: 'Ravi Joshi',
          userAvatar: 'RJ',
          rating: 4.5,
          comment:
              'Engine cleaning was thorough. Very satisfied with the results.',
          date: DateTime.now().subtract(const Duration(days: 7)),
        ),
      ],
      '3': [
        Review(
          id: 'r8',
          centerId: '3',
          userName: 'Deepika Nair',
          userAvatar: 'DN',
          rating: 5.0,
          comment:
              'Love the eco-friendly approach! Products smell amazing and car looks spotless.',
          date: DateTime.now().subtract(const Duration(days: 1)),
        ),
        Review(
          id: 'r9',
          centerId: '3',
          userName: 'Karthik M',
          userAvatar: 'KM',
          rating: 4.5,
          comment:
              'Best car wash in Bangalore hands down! Interior cleaning is top notch.',
          date: DateTime.now().subtract(const Duration(days: 3)),
        ),
        Review(
          id: 'r10',
          centerId: '3',
          userName: 'Anita Roy',
          userAvatar: 'AR',
          rating: 5.0,
          comment:
              'Paint protection service was incredible. Worth every rupee!',
          date: DateTime.now().subtract(const Duration(days: 6)),
        ),
        Review(
          id: 'r11',
          centerId: '3',
          userName: 'Suresh B',
          userAvatar: 'SB',
          rating: 4.5,
          comment: 'Quick service and reasonable prices. My go-to wash center.',
          date: DateTime.now().subtract(const Duration(days: 10)),
        ),
        Review(
          id: 'r12',
          centerId: '3',
          userName: 'Meera Das',
          userAvatar: 'MD',
          rating: 4.0,
          comment:
              'Good quality wash. The staff could be more attentive though.',
          date: DateTime.now().subtract(const Duration(days: 15)),
        ),
      ],
    };

    return allReviews[centerId] ??
        [
          Review(
            id: 'rdef1',
            centerId: centerId,
            userName: 'Arun Verma',
            userAvatar: 'AV',
            rating: 4.0,
            comment: 'Great service and friendly staff. Will visit again!',
            date: DateTime.now().subtract(const Duration(days: 3)),
          ),
          Review(
            id: 'rdef2',
            centerId: centerId,
            userName: 'Pooja Shah',
            userAvatar: 'PS',
            rating: 4.5,
            comment: 'My car has never looked this clean. Excellent work!',
            date: DateTime.now().subtract(const Duration(days: 7)),
          ),
          Review(
            id: 'rdef3',
            centerId: centerId,
            userName: 'Rajesh Kumar',
            userAvatar: 'RK',
            rating: 3.5,
            comment: 'Decent wash but a bit overpriced for basic services.',
            date: DateTime.now().subtract(const Duration(days: 14)),
          ),
        ];
  }

  static List<TimeSlot> getTimeSlots() {
    return [
      TimeSlot(id: 't1', time: '8:00 AM', isAvailable: true),
      TimeSlot(id: 't2', time: '9:00 AM', isAvailable: true),
      TimeSlot(id: 't3', time: '10:00 AM', isAvailable: false),
      TimeSlot(id: 't4', time: '11:00 AM', isAvailable: true),
      TimeSlot(id: 't5', time: '12:00 PM', isAvailable: true),
      TimeSlot(id: 't6', time: '1:00 PM', isAvailable: false),
      TimeSlot(id: 't7', time: '2:00 PM', isAvailable: true),
      TimeSlot(id: 't8', time: '3:00 PM', isAvailable: true),
      TimeSlot(id: 't9', time: '4:00 PM', isAvailable: true),
      TimeSlot(id: 't10', time: '5:00 PM', isAvailable: false),
      TimeSlot(id: 't11', time: '6:00 PM', isAvailable: true),
      TimeSlot(id: 't12', time: '7:00 PM', isAvailable: true),
    ];
  }

  static List<String> getCategories() {
    return [
      'All',
      'Basic Wash',
      'Premium',
      'Interior',
      'Detailing',
      'Coating',
      'Express',
    ];
  }

  static List<Map<String, String>> getOffers() {
    return [
      {
        'title': 'FLAT 30% OFF',
        'subtitle': 'On your first Premium Wash',
        'code': 'FIRST30',
      },
      {
        'title': 'FREE Interior Clean',
        'subtitle': 'With every Full Detail booking',
        'code': 'INTERIOR',
      },
      {
        'title': '₹100 Cashback',
        'subtitle': 'On bookings above ₹999',
        'code': 'CASH100',
      },
    ];
  }
}
