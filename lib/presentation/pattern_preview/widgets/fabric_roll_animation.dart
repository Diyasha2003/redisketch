import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class FabricRollAnimation extends StatefulWidget {
  final Widget child;
  final bool shouldAnimate;
  final VoidCallback? onAnimationComplete;

  const FabricRollAnimation({
    Key? key,
    required this.child,
    this.shouldAnimate = true,
    this.onAnimationComplete,
  }) : super(key: key);

  @override
  State<FabricRollAnimation> createState() => _FabricRollAnimationState();
}

class _FabricRollAnimationState extends State<FabricRollAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _unrollAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _unrollAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
    ));

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onAnimationComplete?.call();
      }
    });

    if (widget.shouldAnimate) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          _animationController.forward();
        }
      });
    } else {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Stack(
          children: [
            // Fabric roll background
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppTheme.lightTheme.colorScheme.secondary,
                    AppTheme.lightTheme.colorScheme.secondary
                        .withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),

            // Unrolling effect
            ClipRect(
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: _unrollAnimation.value,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.lightTheme.colorScheme.shadow,
                        offset: const Offset(0, 4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: widget.child,
                  ),
                ),
              ),
            ),

            // Roll edge effect
            if (_unrollAnimation.value < 1.0)
              Positioned(
                top: MediaQuery.of(context).size.height *
                        _unrollAnimation.value -
                    4,
                left: 0,
                right: 0,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                        AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.1),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
