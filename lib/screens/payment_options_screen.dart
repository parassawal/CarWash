import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class PaymentOptionsScreen extends StatefulWidget {
  const PaymentOptionsScreen({super.key});

  @override
  State<PaymentOptionsScreen> createState() => _PaymentOptionsScreenState();
}

class _PaymentOptionsScreenState extends State<PaymentOptionsScreen> {
  // Mock data for payment methods
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': '1',
      'type': 'UPI',
      'title': 'Google Pay',
      'subtitle': 'user@okicici',
      'icon': Icons.account_balance_wallet,
      'isDefault': true,
    },
    {
      'id': '2',
      'type': 'Card',
      'title': 'HDFC Bank Credit Card',
      'subtitle': '**** **** **** 1234',
      'icon': Icons.credit_card,
      'isDefault': false,
    },
    {
      'id': '3',
      'type': 'Wallet',
      'title': 'Paytm Wallet',
      'subtitle': 'Balance: ₹1,500',
      'icon': Icons.account_balance_wallet_outlined,
      'isDefault': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: const Text(
          'Payment Methods',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Saved Payment Methods',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            ..._paymentMethods.map((pm) => _buildPaymentCard(pm)),
            const SizedBox(height: 24),
            const Text(
              'Add New Method',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            _buildActionItem(
              Icons.add_card,
              'Add Credit/Debit Card',
              () => _showSnackBar('Add Card functionality coming soon'),
            ),
            _buildActionItem(
              Icons.qr_code_scanner,
              'Link new UPI ID',
              () => _showSnackBar('Link UPI functionality coming soon'),
            ),
            _buildActionItem(
              Icons.account_balance,
              'Net Banking',
              () => _showSnackBar('Net Banking functionality coming soon'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentCard(Map<String, dynamic> pm) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: pm['isDefault'] ? AppColors.accent.withOpacity(0.5) : AppColors.border,
          width: pm['isDefault'] ? 1 : 0.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            setState(() {
              for (var method in _paymentMethods) {
                method['isDefault'] = method['id'] == pm['id'];
              }
            });
            _showSnackBar('${pm['title']} set as default payment method');
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    pm['icon'],
                    color: AppColors.accent,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pm['title'],
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        pm['subtitle'],
                        style: const TextStyle(
                          color: AppColors.textHint,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                if (pm['isDefault'])
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 22,
                  )
                else
                  const Icon(
                    Icons.radio_button_unchecked,
                    color: AppColors.border,
                    size: 22,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionItem(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: AppColors.textSecondary, size: 22),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppColors.textHint, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.surfaceLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
