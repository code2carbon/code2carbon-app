import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../features/auth/services/auth_service.dart';
import '../features/auth/widgets/auth_modal_sheet.dart';
import '../features/calculator/screens/calculator_screen.dart';
import '../features/chatbot/widgets/ecobot_chat_drawer.dart';
import '../features/dashboard/screens/dashboard_screen.dart';
import '../features/dashboard/widgets/esg_audit_simulator_sheet.dart';
import '../features/home/screens/home_screen.dart';
import '../features/planner/screens/net_zero_planner_screen.dart';
import '../features/reports/screens/pdf_preview_screen.dart';
import '../shared/widgets/custom_app_bar.dart';
import 'theme/app_colors.dart';
import 'theme/app_typography.dart';

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _openPdfPreview() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PdfPreviewScreen(),
      ),
    );
  }

  void _showEcoBotModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const EcoBotChatDrawer(),
    );
  }

  void _showLoginDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AuthModalSheet(),
    );
  }

  void _showEsgAuditModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const EsgAuditSimulatorSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBg,
      appBar: CustomAppBar(
        onOpenEcoBot: _showEcoBotModal,
        onOpenLogin: _showLoginDialog,
      ),
      drawer: _buildAppDrawer(),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(
            onNavigateToCalculator: () => _onTabTapped(3),
          ),
          const NetZeroPlannerScreen(),
          DashboardScreen(
            onNavigateToCalculator: () => _onTabTapped(3),
          ),
          CalculatorScreen(
            onOpenPdfReport: _openPdfPreview,
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: AppColors.borderSubtle.withValues(alpha: 0.6),
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: _onTabTapped,
            backgroundColor: Colors.white,
            elevation: 0,
            indicatorColor: AppColors.primaryLight,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded, color: AppColors.primary),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.trending_down_outlined),
                selectedIcon: Icon(Icons.trending_down_rounded, color: AppColors.primary),
                label: 'Planner',
              ),
              NavigationDestination(
                icon: Icon(Icons.bar_chart_outlined),
                selectedIcon: Icon(Icons.bar_chart_rounded, color: AppColors.primary),
                label: 'Dashboard',
              ),
              NavigationDestination(
                icon: Icon(Icons.calculate_outlined),
                selectedIcon: Icon(Icons.calculate_rounded, color: AppColors.primary),
                label: 'Calculator',
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () => _onTabTapped(3),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 3,
              extendedPadding: const EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              icon: const Icon(Icons.calculate_rounded, size: 19),
              label: Text(
                'Open Calculator',
                style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 13.5),
              ),
            )
          : null,
    );
  }

  Widget _buildAppDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Brand & User Profile Header
            ListenableBuilder(
              listenable: AuthService(),
              builder: (context, _) {
                final auth = AuthService();
                final user = auth.currentUser;
                final isLoggedIn = auth.isLoggedIn;

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryLight,
                    border: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.eco_rounded, color: Colors.white, size: 22),
                          ),
                          const SizedBox(width: 10),
                          RichText(
                            text: TextSpan(
                              style: AppTypography.displaySmall.copyWith(fontSize: 19),
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
                        ],
                      ),
                      const SizedBox(height: 14),
                      // Account status chip
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          if (!isLoggedIn) {
                            _showLoginDialog();
                          }
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.borderSubtle),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundColor: isLoggedIn ? AppColors.primary : AppColors.darkSlate,
                                child: Icon(
                                  isLoggedIn ? Icons.verified_user_rounded : Icons.person_outline_rounded,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isLoggedIn ? user.name : 'Guest Assessor',
                                      style: const TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.dark,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      isLoggedIn ? user.institution : 'Tap to sign in',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: isLoggedIn ? AppColors.textSecondary : AppColors.primary,
                                        fontWeight: isLoggedIn ? FontWeight.w400 : FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                isLoggedIn ? Icons.chevron_right_rounded : Icons.login_rounded,
                                size: 16,
                                color: AppColors.textMuted,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Navigation Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                children: [
                  _DrawerItem(
                    icon: Icons.home_rounded,
                    title: 'Home Hub',
                    isSelected: _currentIndex == 0,
                    onTap: () {
                      Navigator.pop(context);
                      _onTabTapped(0);
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.trending_down_rounded,
                    title: 'Net-Zero Planner',
                    isSelected: _currentIndex == 1,
                    onTap: () {
                      Navigator.pop(context);
                      _onTabTapped(1);
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.bar_chart_rounded,
                    title: 'Analytics Dashboard',
                    isSelected: _currentIndex == 2,
                    onTap: () {
                      Navigator.pop(context);
                      _onTabTapped(2);
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.calculate_rounded,
                    title: 'Carbon Calculator',
                    isSelected: _currentIndex == 3,
                    onTap: () {
                      Navigator.pop(context);
                      _onTabTapped(3);
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(color: AppColors.borderDivider),
                  ),
                  _DrawerActionItem(
                    icon: Icons.auto_awesome_rounded,
                    iconColor: AppColors.aiIndigo,
                    title: 'EcoBot AI Assistant',
                    badge: 'AI Active',
                    onTap: () {
                      Navigator.pop(context);
                      _showEcoBotModal();
                    },
                  ),
                  _DrawerActionItem(
                    icon: Icons.verified_outlined,
                    iconColor: AppColors.secondary,
                    title: 'ESG Audit Simulator',
                    badge: 'Simulator',
                    onTap: () {
                      Navigator.pop(context);
                      _showEsgAuditModal();
                    },
                  ),
                  _DrawerActionItem(
                    icon: Icons.picture_as_pdf_outlined,
                    iconColor: const Color(0xFFDC2626),
                    title: 'Executive PDF Report',
                    badge: 'Export',
                    onTap: () {
                      Navigator.pop(context);
                      _openPdfPreview();
                    },
                  ),
                ],
              ),
            ),

            // Bottom institutional footer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.borderSubtle)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.shield_rounded, size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'ISO 14064-1 & GHG Protocol Aligned',
                      style: AppTypography.bodySmall.copyWith(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
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

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryLight : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(
          icon,
          color: isSelected ? AppColors.primaryDark : AppColors.textSecondary,
          size: 22,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? AppColors.primaryDark : AppColors.dark,
          ),
        ),
        onTap: onTap,
        dense: true,
      ),
    );
  }
}

class _DrawerActionItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String badge;
  final VoidCallback onTap;

  const _DrawerActionItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor, size: 18),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          color: AppColors.dark,
        ),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          badge,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: iconColor,
          ),
        ),
      ),
      onTap: onTap,
      dense: true,
    );
  }
}
