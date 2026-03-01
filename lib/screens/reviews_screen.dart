import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/car_wash_center.dart';
import '../models/review.dart';
import '../providers/app_provider.dart';
import '../services/auth_service.dart';
import '../theme/app_colors.dart';

class ReviewsScreen extends StatefulWidget {
  final CarWashCenter center;
  const ReviewsScreen({super.key, required this.center});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  final TextEditingController _commentController = TextEditingController();
  double _userRating = 4.0;
  bool _showForm = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);

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
              'Reviews',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Text(
              widget.center.name,
              style: const TextStyle(color: AppColors.textHint, fontSize: 12),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Rating summary
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border, width: 0.5),
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      '${widget.center.rating}',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (i) => Icon(
                          i < widget.center.rating.floor()
                              ? Icons.star
                              : (i < widget.center.rating
                                    ? Icons.star_half
                                    : Icons.star_border),
                          color: AppColors.ratingStar,
                          size: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.center.reviewCount} ratings',
                      style: const TextStyle(
                        color: AppColors.textHint,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    children: [
                      _ratingBar('5', 0.7),
                      _ratingBar('4', 0.2),
                      _ratingBar('3', 0.06),
                      _ratingBar('2', 0.03),
                      _ratingBar('1', 0.01),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Reviews list
          Expanded(
            child: StreamBuilder<List<Review>>(
              stream: provider.getReviews(widget.center.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.accent,
                      strokeWidth: 2,
                    ),
                  );
                }
                final reviews = snapshot.data ?? [];
                if (reviews.isEmpty) {
                  return const Center(
                    child: Text(
                      'No reviews yet. Be the first!',
                      style: TextStyle(color: AppColors.textHint),
                    ),
                  );
                }
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    final r = reviews[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.border, width: 0.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: AppColors.surfaceLight,
                                child: Text(
                                  r.userAvatar,
                                  style: const TextStyle(
                                    color: AppColors.accent,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  r.userName,
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    size: 12,
                                    color: AppColors.ratingStar,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    '${r.rating}',
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            r.comment,
                            style: const TextStyle(
                              color: AppColors.textHint,
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Add Review
          if (_showForm)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(
                  top: BorderSide(color: AppColors.border, width: 0.5),
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Your Rating',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: AppColors.textHint,
                            size: 18,
                          ),
                          onPressed: () => setState(() => _showForm = false),
                        ),
                      ],
                    ),
                    Center(
                      child: RatingBar.builder(
                        initialRating: _userRating,
                        minRating: 1,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 32,
                        unratedColor: AppColors.surfaceLight,
                        itemBuilder: (_, __) =>
                            const Icon(Icons.star, color: AppColors.ratingStar),
                        onRatingUpdate: (r) => _userRating = r,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _commentController,
                      maxLines: 3,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Write your review...',
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: _isSubmitting ? null : _submitReview,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.textPrimary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: _isSubmitting
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.background,
                                  ),
                                )
                              : const Text(
                                  'Submit',
                                  style: TextStyle(
                                    color: AppColors.background,
                                    fontSize: 14,
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
        ],
      ),
      floatingActionButton: !_showForm
          ? FloatingActionButton.extended(
              onPressed: () => setState(() => _showForm = true),
              backgroundColor: AppColors.textPrimary,
              icon: const Icon(
                Icons.rate_review,
                color: AppColors.background,
                size: 18,
              ),
              label: const Text(
                'Review',
                style: TextStyle(
                  color: AppColors.background,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
    );
  }

  Widget _ratingBar(String label, double fraction) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.textHint, fontSize: 11),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: fraction,
                backgroundColor: AppColors.surfaceLight,
                valueColor: const AlwaysStoppedAnimation(AppColors.ratingStar),
                minHeight: 5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitReview() async {
    if (_commentController.text.isEmpty) return;
    setState(() => _isSubmitting = true);

    final auth = Provider.of<AuthService>(context, listen: false);
    final review = Review(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      centerId: widget.center.id,
      userName: auth.userName,
      userAvatar: auth.userInitials,
      rating: _userRating,
      comment: _commentController.text,
      date: DateTime.now(),
    );

    await Provider.of<AppProvider>(context, listen: false).addReview(review);

    if (mounted) {
      setState(() {
        _isSubmitting = false;
        _showForm = false;
      });
      _commentController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Review added!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }
}
