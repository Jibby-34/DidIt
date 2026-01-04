import 'package:flutter/material.dart';

class LightningAnimation extends StatefulWidget {
  final VoidCallback? onComplete;
  final double size;

  const LightningAnimation({
    super.key,
    this.onComplete,
    this.size = 100,
  });

  @override
  State<LightningAnimation> createState() => _LightningAnimationState();
}

class _LightningAnimationState extends State<LightningAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.5)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.5, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 60,
      ),
    ]).animate(_controller);

    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.0),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.8),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.8, end: 0.0),
        weight: 50,
      ),
    ]).animate(_controller);

    _rotationAnimation = Tween<double>(
      begin: -0.2,
      end: 0.2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _controller.forward().then((_) {
      if (widget.onComplete != null) {
        widget.onComplete!();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.yellow.withValues(alpha: 0.8),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '⚡',
                    style: TextStyle(
                      fontSize: widget.size * 0.7,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// A glowing lightning effect widget
class LightningGlow extends StatefulWidget {
  final Widget child;
  final bool isActive;

  const LightningGlow({
    super.key,
    required this.child,
    this.isActive = false,
  });

  @override
  State<LightningGlow> createState() => _LightningGlowState();
}

class _LightningGlowState extends State<LightningGlow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
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
    if (!widget.isActive) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.yellow.withValues(alpha: _pulseAnimation.value * 0.5),
                blurRadius: 20 * _pulseAnimation.value,
                spreadRadius: 5 * _pulseAnimation.value,
              ),
            ],
          ),
          child: widget.child,
        );
      },
    );
  }
}

/// Lightning bolt painter for custom animations
class LightningBoltPainter extends CustomPainter {
  final Color color;
  final double animationValue;

  LightningBoltPainter({
    required this.color,
    this.animationValue = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: animationValue)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(size.width * 0.5, 0)
      ..lineTo(size.width * 0.35, size.height * 0.4)
      ..lineTo(size.width * 0.55, size.height * 0.4)
      ..lineTo(size.width * 0.3, size.height)
      ..lineTo(size.width * 0.5, size.height * 0.6)
      ..lineTo(size.width * 0.4, size.height * 0.6)
      ..lineTo(size.width * 0.7, 0)
      ..close();

    canvas.drawPath(path, paint);

    // Fill
    final fillPaint = Paint()
      ..color = color.withValues(alpha: animationValue * 0.3)
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, fillPaint);
  }

  @override
  bool shouldRepaint(LightningBoltPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

