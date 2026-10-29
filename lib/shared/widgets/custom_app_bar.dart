import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import '../../features/auth/services/auth_service.dart';

/// Top App Bar matching CarbonTrack Logo & Responsive Actions
/// Guaranteed zero overlap on all mobile screen widths (320px to tablets)
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onOpenEcoBot;
  final VoidCallback? onOpenLogin;

  const CustomAppBar({
    super.key,
    this.onOpenEcoBot,
    this.onOpenLogin,
  });

  @override
  Size get preferredSize => const Size.fromHeight(62);

  void _showUserProfileSheet(BuildContext context, AuthUser user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderSubtle,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : 'A',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              user.name,
                              style: AppTypography.titleMedium.copyWith(fontSize: 17),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.verified_rounded,
                            color: AppColors.primary,
                            size: 16,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user.institution,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        user.email.isNotEmpty ? user.email : 'Verified Assessor',
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.shield_outlined, color: AppColors.primaryDark, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Institutional Scope 1-3 Assessor Session Active',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: () async {
                await AuthService().signOut();
                if (ctx.mounted) Navigator.pop(ctx);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: Color(0xFFFECACA)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.logout_rounded, size: 18),
              label: const Text('Sign Out Session'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isVerySmall = screenWidth < 365;
    final isCompact = screenWidth < 410;

    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 1.5,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      titleSpacing: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: AppColors.borderSubtle.withValues(alpha: 0.7),
          height: 1,
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(left: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo Icon
            Container(
              width: isVerySmall ? 32 : 36,
              height: isVerySmall ? 32 : 36,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, Color(0xFF059669)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(9),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.eco_rounded,
                color: Colors.white,
                size: isVerySmall ? 18 : 21,
              ),
            ),
            const SizedBox(width: 8),

            // Flexible title so it shrinks gracefully on small screens without overflowing
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    style: AppTypography.displaySmall.copyWith(
                      fontSize: isVerySmall ? 17 : 19,
                      letterSpacing: -0.4,
                    ),
                    children: const [
                      TextSpan(
                        text: 'Code2',
                        style: TextStyle(
                          color: AppColors.dark,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      TextSpan(
                        text: 'Carbon',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        // Responsive AI EcoBot Button
        if (onOpenEcoBot != null)
          Padding(
            padding: EdgeInsets.symmetric(vertical: isCompact ? 13 : 11),
            child: Tooltip(
              message: 'EcoBot AI Assistant',
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onOpenEcoBot,
                  borderRadius: BorderRadius.circular(20),
                  child: Ink(
                    padding: EdgeInsets.symmetric(
                      horizontal: isCompact ? 8 : 11,
                      vertical: isCompact ? 6 : 7,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppColors.aiGradient,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.aiIndigo.withValues(alpha: 0.32),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.auto_awesome_rounded,
                          size: 14,
                          color: Colors.white,
                        ),
                        if (!isVerySmall) ...[
                          const SizedBox(width: 4),
                          Text(
                            isCompact ? 'AI' : 'EcoBot AI',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

        const SizedBox(width: 6),

        // Responsive Login / Profile Button
        if (onOpenLogin != null)
          ListenableBuilder(
            listenable: AuthService(),
            builder: (context, _) {
              final auth = AuthService();
              final isLoggedIn = auth.isLoggedIn;
              final user = auth.currentUser;

              return Padding(
                padding: EdgeInsets.only(
                  right: isVerySmall ? 8 : 12,
                  top: isCompact ? 13 : 11,
                  bottom: isCompact ? 13 : 11,
                ),
                child: Tooltip(
                  message: isLoggedIn ? 'Assessor Profile' : 'Sign In',
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        if (isLoggedIn) {
                          _showUserProfileSheet(context, user);
                        } else {
                          onOpenLogin!();
                        }
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Ink(
                        padding: EdgeInsets.symmetric(
                          horizontal: isCompact ? 8 : 11,
                          vertical: isCompact ? 6 : 7,
                        ),
                        decoration: BoxDecoration(
                          gradient: isLoggedIn
                              ? const LinearGradient(
                                  colors: [Color(0xFF047857), Color(0xFF065F46)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryDark.withValues(alpha: 0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isLoggedIn ? Icons.account_circle_rounded : Icons.login_rounded,
                              size: 14,
                              color: Colors.white,
                            ),
                            if (!isVerySmall) ...[
                              const SizedBox(width: 4),
                              Text(
                                isLoggedIn
                                    ? (isCompact ? 'Profile' : user.name.split(' ').first)
                                    : 'Login',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
