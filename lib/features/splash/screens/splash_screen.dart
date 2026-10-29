import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/main_navigation_shell.dart';
import '../../../app/theme/app_colors.dart';
import '../../auth/services/auth_service.dart';

/// Upgraded, executive-grade Splash Screen for Code2Carbon.
/// Modern micro-interactions, smooth staggered animations, ambient depth glow,
/// and verified compliance indicators.
class SplashScreen extends StatefulWidget {
  final Duration duration;
  final bool autoNavigate;
  final Widget? nextScreen;
  final VoidCallback? onComplete;

  const SplashScreen({
    super.key,
    this.duration = const Duration(milliseconds: 2400),
    this.autoNavigate = true,
    this.nextScreen,
    this.onComplete,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;

  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _contentSlide;
  late Animation<double> _contentFade;
  late Animation<double> _progressAnimation;

  Timer? _navigationTimer;
  bool _navigated = false;

  final List<String> _loadingMilestones = const [
    'Initializing emission ledgers...',
    'Loading GHG Protocol factors...',
    'Preparing Code2Carbon workspace...',
  ];

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    // Staggered entrance animations
    _logoScale = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOutBack),
      ),
    );

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.35, curve: Curves.easeIn),
      ),
    );

    _contentSlide = Tween<double>(begin: 14.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.2, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    _contentFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.25, 0.65, curve: Curves.easeIn),
      ),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.15, 0.95, curve: Curves.easeInOutCubic),
      ),
    );

    _mainController.forward();

    // Preheat user auth session in background
    _preheatServices();

    if (widget.autoNavigate) {
      _navigationTimer = Timer(widget.duration, () {
        _proceedToApp();
      });
    }
  }

  Future<void> _preheatServices() async {
    try {
      await AuthService().init();
    } catch (e) {
      debugPrint('SplashScreen preheat notice: $e');
    }
  }

  void _proceedToApp() {
    if (_navigated || !mounted) return;
    _navigated = true;
    _navigationTimer?.cancel();

    if (widget.onComplete != null) {
      widget.onComplete!();
      return;
    }

    final target = widget.nextScreen ?? const MainNavigationShell();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => target,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 380),
      ),
    );
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _pulseController.dispose();
    _mainController.dispose();
    super.dispose();
  }

  String _currentMilestone(double progress) {
    if (progress < 0.38) return _loadingMilestones[0];
    if (progress < 0.76) return _loadingMilestones[1];
    return _loadingMilestones[2];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      key: const Key('splash_screen'),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: InkWell(
          onTap: _proceedToApp,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Stack(
            children: [
              // 1. Ambient Background Glows
              Positioned(
                top: -60,
                left: size.width * 0.2,
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF10B981).withValues(alpha: 0.08),
                        const Color(0xFF0D9488).withValues(alpha: 0.02),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -80,
                right: -40,
                child: Container(
                  width: 320,
                  height: 320,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF059669).withValues(alpha: 0.06),
                        const Color(0xFF0284C7).withValues(alpha: 0.02),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // 2. Subtle Top Header with Skip Button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
                  child: TextButton(
                    key: const Key('splash_skip_button'),
                    onPressed: _proceedToApp,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      backgroundColor: const Color(0xFFF1F5F9),
                      foregroundColor: const Color(0xFF475569),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Skip',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF475569),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          size: 13,
                          color: Color(0xFF64748B),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 3. Central Hero Content
              Center(
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated Logo Emblem with Ambient Pulse Ring
                      AnimatedBuilder(
                        animation: Listenable.merge([_mainController, _pulseController]),
                        builder: (context, _) {
                          final pulse = _pulseController.value;
                          return FadeTransition(
                            opacity: _logoFade,
                            child: ScaleTransition(
                              scale: _logoScale,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Soft pulsing halo
                                  Container(
                                    width: 82 + (pulse * 10),
                                    height: 82 + (pulse * 10),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: const Color(0xFF10B981)
                                          .withValues(alpha: 0.12 - (pulse * 0.08)),
                                    ),
                                  ),
                                  // Gradient Icon Container
                                  Container(
                                    key: const Key('splash_logo'),
                                    width: 68,
                                    height: 68,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF047857),
                                          Color(0xFF059669),
                                          Color(0xFF0D9488),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF059669).withValues(alpha: 0.35),
                                          blurRadius: 18,
                                          offset: const Offset(0, 8),
                                        ),
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.04),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(14),
                                              border: Border.all(
                                                color: Colors.white.withValues(alpha: 0.22),
                                                width: 1.2,
                                              ),
                                            ),
                                          ),
                                          const Icon(
                                            Icons.eco_rounded,
                                            color: Colors.white,
                                            size: 36,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 22),

                      // Animated Brand Typography & Badge
                      AnimatedBuilder(
                        animation: _mainController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _contentSlide.value),
                            child: FadeTransition(
                              opacity: _contentFade,
                              child: child,
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            // Enterprise Tag Pill
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF10B981),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'ENTERPRISE CLIMATE INTELLIGENCE',
                                    style: GoogleFonts.inter(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.6,
                                      color: const Color(0xFF475569),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Brand Title
                            RichText(
                              key: const Key('splash_title'),
                              text: TextSpan(
                                style: GoogleFonts.inter(
                                  fontSize: 32,
                                  letterSpacing: -0.8,
                                ),
                                children: const [
                                  TextSpan(
                                    text: 'Code2',
                                    style: TextStyle(
                                      color: Color(0xFF0F172A),
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Carbon',
                                    style: TextStyle(
                                      color: Color(0xFF059669),
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8),

                            // Tagline matching requirements & tests
                            Text(
                              'Carbon Footprint Emission Assessment Platform',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF64748B),
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 38),

                      // Sleek Animated Progress Bar & Live Milestone
                      AnimatedBuilder(
                        animation: _progressAnimation,
                        builder: (context, _) {
                          final progress = _progressAnimation.value;
                          final pct = (progress * 100).clamp(0, 100).toInt();

                          return Column(
                            children: [
                              // Progress Track with Gradient Fill
                              Container(
                                width: 200,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: const Color(0xFFE2E8F0)),
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    width: 200 * progress,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF059669),
                                          Color(0xFF10B981),
                                          Color(0xFF14B8A6),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF10B981).withValues(alpha: 0.4),
                                          blurRadius: 6,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 14),

                              // Milestone Text & Percentage
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 250),
                                    child: Text(
                                      _currentMilestone(progress),
                                      key: ValueKey<String>(_currentMilestone(progress)),
                                      style: GoogleFonts.inter(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF64748B),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '$pct%',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF0F172A),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // 4. Trust Badges & Institutional Footer
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 22.0, left: 16.0, right: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.verified_outlined,
                            size: 13,
                            color: Color(0xFF059669),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Institutional Sustainability Platform • ISO 14064-1 & GHG Protocol',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Audit-Ready Carbon Accounting & Mitigation Engine',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
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
