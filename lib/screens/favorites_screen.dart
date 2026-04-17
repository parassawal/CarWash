import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/center_card.dart';
import 'center_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final favorites = provider.favoriteCenters;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: const Text(
          'Favorites',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: favorites.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(top: 8, bottom: 20),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final center = favorites[index];
                return CenterCard(
                  center: center,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CenterDetailScreen(center: center),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.favorite_outline,
            size: 48,
            color: AppColors.textHint,
          ),
          SizedBox(height: 12),
          Text(
            'No favorites yet',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Tap the heart icon to save your favorite centers',
            style: TextStyle(color: AppColors.textHint, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
