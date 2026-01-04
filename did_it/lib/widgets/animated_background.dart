import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;

  const AnimatedBackground({
    super.key,
    required this.child,
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.lerp(
                Alignment.topLeft,
                Alignment.topRight,
                _animation.value,
              )!,
              end: Alignment.lerp(
                Alignment.bottomRight,
                Alignment.bottomLeft,
                _animation.value,
              )!,
              colors: [
                AppTheme.darkBackground,
                Color.lerp(
                  AppTheme.darkBackgroundSecondary,
                  AppTheme.darkBackground,
                  _animation.value * 0.3,
                )!,
                AppTheme.electricBlue.withValues(alpha: 0.05 + (_animation.value * 0.05)),
                AppTheme.darkBackground,
              ],
              stops: [
                0.0,
                0.3 + (_animation.value * 0.1),
                0.6 + (_animation.value * 0.1),
                1.0,
              ],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}

