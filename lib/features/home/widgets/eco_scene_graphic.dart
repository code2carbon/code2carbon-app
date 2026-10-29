import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../app/theme/app_colors.dart';

/// Lottie Animated Eco-Scene Visual (Bicycles & Wind Turbines)
class EcoSceneGraphic extends StatelessWidget {
  const EcoSceneGraphic({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryDark.withOpacity(0.06),
            AppColors.secondary.withOpacity(0.06),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.8),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Lottie.asset(
            'assets/lottie/bicycles_wind_turbines.json',
            fit: BoxFit.contain,
            repeat: true,
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Icon(
                  Icons.eco_rounded,
                  size: 48,
                  color: AppColors.primary.withOpacity(0.5),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
