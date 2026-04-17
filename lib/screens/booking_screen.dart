import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/car_wash_center.dart';
import '../models/booking.dart';
import '../models/time_slot.dart';
import '../providers/app_provider.dart';
import '../theme/app_colors.dart';

class BookingScreen extends StatefulWidget {
  final CarWashCenter center;
  const BookingScreen({super.key, required this.center});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedTimeSlot;
  int _selectedServiceIndex = 0;
  late List<DateTime> _dates;
  bool _isBooking = false;
  Set<String> _bookedSlots = {};

  @override
  void initState() {
    super.initState();
    _dates = List.generate(7, (i) => DateTime.now().add(Duration(days: i)));
    _loadBookedSlots();
  }

  Future<void> _loadBookedSlots() async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final booked = await provider.getBookedSlots(widget.center.id, _selectedDate);
    if (mounted) setState(() => _bookedSlots = booked);
  }

  @override
  Widget build(BuildContext context) {
    final service = widget.center.services[_selectedServiceIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Book a Slot',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Text(
              widget.center.name,
              style: const TextStyle(color: AppColors.textHint, fontSize: 12),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Selection
            _sectionTitle('Select Service'),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: widget.center.services.length,
                itemBuilder: (context, index) {
                  final s = widget.center.services[index];
                  final isSelected = _selectedServiceIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedServiceIndex = index),
                    child: Container(
                      width: 120,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.textPrimary
                            : AppColors.card,
                        borderRadius: BorderRadius.circular(10),
                        border: isSelected
                            ? null
                            : Border.all(color: AppColors.border, width: 0.5),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(s.icon, style: const TextStyle(fontSize: 22)),
                          const SizedBox(height: 4),
                          Text(
                            s.name,
                            style: TextStyle(
                              color: isSelected
                                  ? AppColors.background
                                  : AppColors.textPrimary,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '₹${s.price.toInt()}',
                            style: TextStyle(
                              color: isSelected
                                  ? AppColors.background.withOpacity(0.7)
                                  : AppColors.accent,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Date Selection
            _sectionTitle('Select Date'),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _dates.length,
                itemBuilder: (context, index) {
                  final date = _dates[index];
                  final isSelected =
                      _selectedDate.day == date.day &&
                      _selectedDate.month == date.month;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDate = date;
                        _selectedTimeSlot = null;
                        _bookedSlots = {};
                      });
                      _loadBookedSlots();
                    },
                    child: Container(
                      width: 60,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.textPrimary
                            : AppColors.card,
                        borderRadius: BorderRadius.circular(10),
                        border: isSelected
                            ? null
                            : Border.all(color: AppColors.border, width: 0.5),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            index == 0
                                ? 'Today'
                                : DateFormat('EEE').format(date),
                            style: TextStyle(
                              color: isSelected
                                  ? AppColors.background.withOpacity(0.6)
                                  : AppColors.textHint,
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${date.day}',
                            style: TextStyle(
                              color: isSelected
                                  ? AppColors.background
                                  : AppColors.textPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            DateFormat('MMM').format(date),
                            style: TextStyle(
                              color: isSelected
                                  ? AppColors.background.withOpacity(0.6)
                                  : AppColors.textHint,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Time Slots
            _sectionTitle('Select Time'),
            _buildSlots(widget.center.timeSlots),

            // Summary
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border, width: 0.5),
              ),
              child: Column(
                children: [
                  _summaryRow('Service', service.name),
                  const SizedBox(height: 6),
                  _summaryRow('Duration', service.duration),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Container(height: 0.5, color: AppColors.divider),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '₹${service.price.toInt()}',
                        style: const TextStyle(
                          color: AppColors.accent,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
        ),
        child: SafeArea(
          child: GestureDetector(
            onTap: _selectedTimeSlot != null && !_isBooking
                ? () => _confirmBooking(context)
                : null,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: _selectedTimeSlot != null
                    ? AppColors.textPrimary
                    : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _isBooking
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.background,
                          ),
                        )
                      : Text(
                          _selectedTimeSlot != null
                              ? 'Confirm — ₹${service.price.toInt()}'
                              : 'Select a time slot',
                          style: TextStyle(
                            color: _selectedTimeSlot != null
                                ? AppColors.background
                                : AppColors.textHint,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSlots(List<TimeSlot> slots) {
    if (slots.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          'No time slots available for this center.',
          style: TextStyle(
            color: AppColors.error,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: slots.map((slot) {
          final isSelected = _selectedTimeSlot == slot.time;
          final isBooked = _bookedSlots.contains(slot.time);
          final isUnavailable = !slot.isAvailable || isBooked;
          return GestureDetector(
            onTap: isUnavailable
                ? null
                : () => setState(() => _selectedTimeSlot = slot.time),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.textPrimary
                    : (isUnavailable
                          ? AppColors.surface
                          : AppColors.surfaceLight),
                borderRadius: BorderRadius.circular(10),
                border: isSelected
                    ? null
                    : Border.all(
                        color: isUnavailable
                            ? Colors.transparent
                            : AppColors.border,
                        width: 0.5,
                      ),
              ),
              child: Text(
                slot.time,
                style: TextStyle(
                  color: isSelected
                      ? AppColors.background
                      : (isUnavailable
                            ? AppColors.textHint
                            : AppColors.textPrimary),
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  decoration: isUnavailable
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textHint, fontSize: 13),
        ),
        Text(
          value,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
      ],
    );
  }

  Future<void> _confirmBooking(BuildContext context) async {
    final service = widget.center.services[_selectedServiceIndex];
    setState(() => _isBooking = true);

    final booking = Booking(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      centerId: widget.center.id,
      centerName: widget.center.name,
      centerImage: widget.center.imageUrl,
      date: _selectedDate,
      timeSlot: _selectedTimeSlot!,
      service: service.name,
      price: service.price,
      status: BookingStatus.pending,
    );

    await Provider.of<AppProvider>(context, listen: false).addBooking(booking);

    if (mounted) {
      setState(() => _isBooking = false);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
          backgroundColor: AppColors.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 56,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Booking Confirmed!',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${service.name} on ${DateFormat('dd MMM').format(_selectedDate)} at $_selectedTimeSlot',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.center.name,
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.textPrimary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'Done',
                        style: TextStyle(
                          color: AppColors.background,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
