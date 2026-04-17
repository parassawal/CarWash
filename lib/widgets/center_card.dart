import 'package:flutter/material.dart';
import '../models/car_wash_center.dart';
import '../theme/app_colors.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class CenterCard extends StatelessWidget {
  final CarWashCenter center;
  final VoidCallback onTap;

  const CenterCard({super.key, required this.center, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Container(
                    height: 160,
                    width: double.infinity,
                    color: AppColors.surfaceLight,
                    child: Image.network(
                      center.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Icon(
                          Icons.local_car_wash,
                          size: 48,
                          color: AppColors.accent,
                        ),
                      ),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.accent,
                            strokeWidth: 1.5,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Gradient overlay
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                ),
                // Status
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: center.isOpen
                          ? AppColors.success
                          : AppColors.error,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      center.isOpen ? 'OPEN' : 'CLOSED',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                // Distance
                Positioned(
                  top: 10,
                  right: 45, // Shifted to make room for Favorite Button
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${center.distance} km',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                // Rating
                Positioned(
                  bottom: 8,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.ratingGreen,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${center.rating}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Icon(Icons.star, size: 11, color: Colors.white),
                      ],
                    ),
                  ),
                ),
                // Favorite Button
                Positioned(
                  top: 5,
                  right: 5,
                  child: Consumer<AppProvider>(
                    builder: (context, provider, child) {
                      final isFav = provider.isFavorite(center.id);
                      return IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_outline,
                          color: isFav ? AppColors.error : Colors.white,
                          size: 22,
                        ),
                        onPressed: () => provider.toggleFavorite(center.id),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black.withOpacity(0.3),
                          padding: const EdgeInsets.all(6),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          center.name,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${center.reviewCount} reviews',
                        style: const TextStyle(
                          color: AppColors.textHint,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    center.address,
                    style: const TextStyle(
                      color: AppColors.textHint,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 12,
                        color: AppColors.textHint,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${center.openTime} - ${center.closeTime}',
                        style: const TextStyle(
                          color: AppColors.textHint,
                          fontSize: 11,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '₹${center.services.first.price.toInt()}+',
                        style: const TextStyle(
                          color: AppColors.accent,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
