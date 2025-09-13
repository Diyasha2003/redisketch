import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _fadeController;
  late AnimationController _stitchController;

  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<double> _taglineOpacityAnimation;
  late Animation<double> _stitchAnimation;

  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimationSequence();
  }

  void _initAnimations() {
    // Logo animation controller (sketch effect)
    _logoController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Text animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Overall fade controller
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Stitch animation controller
    _stitchController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Logo animations
    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeInOut),
    ));

    _logoScaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
    ));

    // Text animations
    _textOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    _taglineOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
    ));

    // Stitch animation
    _stitchAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _stitchController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimationSequence() async {
    // Start logo sketch animation
    await _logoController.forward();

    // Start text stitch-in animation
    _textController.forward();
    _stitchController.forward();

    // Navigate after animations complete
    _navigationTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.homeDashboard);
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _fadeController.dispose();
    _stitchController.dispose();
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.secondary, // Warm beige background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Logo Section
            AnimatedBuilder(
              animation: _logoController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _logoScaleAnimation.value,
                  child: Opacity(
                    opacity: _logoFadeAnimation.value,
                    child: Container(
                      width: 60.w,
                      height: 60.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primary.withValues(alpha: 0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          children: [
                            // Main logo image
                            Image.asset(
                              'assets/images/RediSketch-1757074391773.png',
                              width: 60.w,
                              height: 60.w,
                              fit: BoxFit.contain,
                            ),
                            // Sketch effect overlay
                            AnimatedBuilder(
                              animation: _logoController,
                              builder: (context, child) {
                                return CustomPaint(
                                  painter: SketchEffectPainter(
                                    progress: _logoController.value,
                                  ),
                                  size: Size(60.w, 60.w),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 5.h),

            // Animated Text Section
            AnimatedBuilder(
              animation: _textController,
              builder: (context, child) {
                return Column(
                  children: [
                    // Main Title with Stitch Effect
                    Opacity(
                      opacity: _textOpacityAnimation.value,
                      child: AnimatedBuilder(
                        animation: _stitchController,
                        builder: (context, child) {
                          return CustomPaint(
                            painter: StitchTextPainter(
                              text: 'RediSketch',
                              progress: _stitchAnimation.value,
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 28.sp,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primary,
                              ),
                            ),
                            size: Size(70.w, 8.h),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Tagline
                    Opacity(
                      opacity: _taglineOpacityAnimation.value,
                      child: Text(
                        'SKETCH IT. STITCH IT.',
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.textSecondary,
                          letterSpacing: 2.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                );
              },
            ),

            SizedBox(height: 10.h),

            // Loading indicator
            AnimatedBuilder(
              animation: _fadeController,
              builder: (context, child) {
                return Opacity(
                  opacity: 0.6,
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.accent,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for sketch effect on logo
class SketchEffectPainter extends CustomPainter {
  final double progress;

  SketchEffectPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primary.withValues(alpha: 0.3)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Draw sketch lines that appear progressively
    final pathCount = 8;
    for (int i = 0; i < pathCount; i++) {
      final lineProgress = (progress * pathCount - i).clamp(0.0, 1.0);
      if (lineProgress > 0) {
        final path = Path();

        // Create sketch lines around the logo
        final startX = (i / pathCount) * size.width;
        final endX = startX + (size.width / pathCount) * lineProgress;
        final y = size.height * (0.2 + (i % 3) * 0.3);

        path.moveTo(startX, y);
        path.lineTo(endX, y);

        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(SketchEffectPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

// Custom painter for stitched text effect
class StitchTextPainter extends CustomPainter {
  final String text;
  final double progress;
  final TextStyle style;

  StitchTextPainter({
    required this.text,
    required this.progress,
    required this.style,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the main text
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final offset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );
    textPainter.paint(canvas, offset);

    // Draw stitch effect
    if (progress > 0.5) {
      final stitchPaint = Paint()
        ..color = AppTheme.accent
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;

      final stitchProgress = ((progress - 0.5) * 2).clamp(0.0, 1.0);
      final stitchCount = 20;

      for (int i = 0; i < stitchCount; i++) {
        final currentStitch =
            (stitchProgress * stitchCount - i).clamp(0.0, 1.0);
        if (currentStitch > 0) {
          final x = offset.dx + (textPainter.width * i / stitchCount);
          final y = offset.dy + textPainter.height + 8;

          // Draw small stitch marks
          canvas.drawLine(
            Offset(x, y),
            Offset(x + 3, y + 2),
            stitchPaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(StitchTextPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.text != text ||
        oldDelegate.style != style;
  }
}
