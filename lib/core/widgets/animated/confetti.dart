/// Confetti System
///
/// A performant particle system for celebrations throughout Twine.
/// Supports multiple particle shapes (rectangles, circles, hearts) and
/// customizable physics.
///
/// Usage:
/// ```dart
/// final controller = ConfettiController(
///   particleCount: 50,
///   colors: [Colors.pink, Colors.red, Colors.purple],
/// );
///
/// ConfettiWidget(
///   controller: controller,
///   child: YourContent(),
/// )
///
/// // Trigger celebration
/// controller.play();
/// ```
library;

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Shape of confetti particles.
enum ConfettiShape {
  /// Rectangular confetti (classic).
  rectangle,

  /// Circular confetti.
  circle,

  /// Heart-shaped confetti (on-brand for Twine).
  heart,

  /// Star-shaped confetti.
  star,
}

/// A single confetti particle with physics properties.
class ConfettiParticle {
  /// Current position.
  Offset position;

  /// Current velocity.
  Offset velocity;

  /// Current rotation angle (radians).
  double rotation;

  /// Rotation speed (radians per second).
  double rotationSpeed;

  /// Particle color.
  Color color;

  /// Particle size.
  double size;

  /// Current opacity (fades over time).
  double opacity;

  /// Shape of this particle.
  ConfettiShape shape;

  /// Creates a confetti particle.
  ConfettiParticle({
    required this.position,
    required this.velocity,
    required this.rotation,
    required this.rotationSpeed,
    required this.color,
    required this.size,
    this.opacity = 1.0,
    this.shape = ConfettiShape.rectangle,
  });
}

/// Intensity levels for confetti celebrations.
enum ConfettiIntensity {
  /// Subtle celebration (15-25 particles).
  subtle,

  /// Normal celebration (40-60 particles).
  normal,

  /// Epic celebration (80-100 particles).
  epic,

  /// Maximum celebration (150+ particles).
  maximum,
}

/// Controls confetti particle animations.
///
/// Create an instance and call [play] to trigger a celebration.
/// Attach to a [ConfettiWidget] to render the particles.
class ConfettiController extends ChangeNotifier {
  /// List of active particles.
  final List<ConfettiParticle> particles = [];

  /// Random number generator.
  final Random _random = Random();

  /// Number of particles to generate.
  final int particleCount;

  /// Colors to use for particles.
  final List<Color> colors;

  /// Origin point for the explosion.
  final Offset? origin;

  /// Gravity applied to particles (pixels per second squared).
  final double gravity;

  /// Air drag coefficient (0-1, where 1 is no drag).
  final double drag;

  /// Duration before particles start fading.
  final Duration fadeDelay;

  /// Duration of the fade out.
  final Duration fadeDuration;

  /// Shapes to use for particles.
  final List<ConfettiShape> shapes;

  /// Initial velocity range.
  final double minVelocity;
  final double maxVelocity;

  /// Spread angle in radians (default is upward cone).
  final double spreadAngle;

  /// Whether confetti is currently playing.
  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  /// Time elapsed since play started.
  Duration _elapsed = Duration.zero;

  /// Creates a ConfettiController.
  ConfettiController({
    this.particleCount = 50,
    required this.colors,
    this.origin,
    this.gravity = 400,
    this.drag = 0.98,
    this.fadeDelay = const Duration(milliseconds: 2000),
    this.fadeDuration = const Duration(milliseconds: 500),
    this.shapes = const [
      ConfettiShape.rectangle,
      ConfettiShape.circle,
      ConfettiShape.heart,
    ],
    this.minVelocity = 200,
    this.maxVelocity = 400,
    this.spreadAngle = pi / 3, // 60 degrees
  });

  /// Creates a controller for a specific intensity.
  factory ConfettiController.withIntensity({
    required ConfettiIntensity intensity,
    required List<Color> colors,
    Offset? origin,
  }) {
    final count = switch (intensity) {
      ConfettiIntensity.subtle => 20,
      ConfettiIntensity.normal => 50,
      ConfettiIntensity.epic => 90,
      ConfettiIntensity.maximum => 150,
    };

    return ConfettiController(
      particleCount: count,
      colors: colors,
      origin: origin,
    );
  }

  /// Start the confetti animation from a specific origin.
  void playAt(Offset origin) {
    if (_isPlaying) return;

    _isPlaying = true;
    _elapsed = Duration.zero;
    _generateParticles(origin);
    notifyListeners();
  }

  /// Start the confetti animation from the default origin.
  void play() {
    if (origin != null) {
      playAt(origin!);
    }
  }

  /// Stop the animation and clear all particles.
  void stop() {
    _isPlaying = false;
    particles.clear();
    notifyListeners();
  }

  void _generateParticles(Offset origin) {
    particles.clear();

    for (int i = 0; i < particleCount; i++) {
      // Random angle within spread cone (centered upward)
      final angle = -pi / 2 + // Start pointing up
          (_random.nextDouble() - 0.5) * spreadAngle;

      // Random speed within range
      final speed =
          minVelocity + _random.nextDouble() * (maxVelocity - minVelocity);

      particles.add(ConfettiParticle(
        position: origin,
        velocity: Offset(
          cos(angle) * speed,
          sin(angle) * speed,
        ),
        rotation: _random.nextDouble() * 2 * pi,
        rotationSpeed: (_random.nextDouble() - 0.5) * 10,
        color: colors[_random.nextInt(colors.length)],
        size: 8 + _random.nextDouble() * 7,
        shape: shapes[_random.nextInt(shapes.length)],
      ));
    }
  }

  /// Update particle physics. Called every frame by the widget.
  void update(Duration elapsed) {
    if (!_isPlaying) return;

    final dt = (elapsed - _elapsed).inMicroseconds / 1000000.0;
    _elapsed = elapsed;

    // Clamp dt to prevent huge jumps
    final clampedDt = dt.clamp(0.0, 0.1);

    bool anyVisible = false;

    for (final particle in particles) {
      // Apply physics
      particle.velocity = Offset(
        particle.velocity.dx * pow(drag, clampedDt * 60),
        particle.velocity.dy * pow(drag, clampedDt * 60) + gravity * clampedDt,
      );

      particle.position += particle.velocity * clampedDt;
      particle.rotation += particle.rotationSpeed * clampedDt;

      // Fade out
      final fadeStart = fadeDelay.inMilliseconds;
      final fadeEnd = fadeStart + fadeDuration.inMilliseconds;
      final currentMs = _elapsed.inMilliseconds;

      if (currentMs > fadeStart) {
        final fadeProgress =
            ((currentMs - fadeStart) / fadeDuration.inMilliseconds)
                .clamp(0.0, 1.0);
        particle.opacity = 1.0 - fadeProgress;
      }

      if (particle.opacity > 0) {
        anyVisible = true;
      }
    }

    if (!anyVisible) {
      _isPlaying = false;
      particles.clear();
    }

    notifyListeners();
  }

  @override
  void dispose() {
    particles.clear();
    super.dispose();
  }
}

/// A widget that renders confetti particles.
///
/// Place this as an ancestor of the content you want confetti over.
class ConfettiWidget extends StatefulWidget {
  /// The confetti controller.
  final ConfettiController controller;

  /// The child widget (content behind confetti).
  final Widget child;

  /// Creates a ConfettiWidget.
  const ConfettiWidget({
    super.key,
    required this.controller,
    required this.child,
  });

  @override
  State<ConfettiWidget> createState() => _ConfettiWidgetState();
}

class _ConfettiWidgetState extends State<ConfettiWidget>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  Duration _lastElapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  void _onTick(Duration elapsed) {
    if (widget.controller.isPlaying) {
      widget.controller.update(elapsed - _lastElapsed + _lastElapsed);
    }
    _lastElapsed = elapsed;
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        widget.child,
        Positioned.fill(
          child: IgnorePointer(
            child: ListenableBuilder(
              listenable: widget.controller,
              builder: (context, _) {
                if (!widget.controller.isPlaying) {
                  return const SizedBox.shrink();
                }
                return CustomPaint(
                  painter: _ConfettiPainter(
                    particles: widget.controller.particles,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

/// Custom painter for confetti particles.
class _ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;

  _ConfettiPainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      if (particle.opacity <= 0) continue;

      canvas.save();
      canvas.translate(particle.position.dx, particle.position.dy);
      canvas.rotate(particle.rotation);

      final paint = Paint()
        ..color = particle.color.withOpacity(particle.opacity)
        ..style = PaintingStyle.fill;

      switch (particle.shape) {
        case ConfettiShape.rectangle:
          _drawRectangle(canvas, particle.size, paint);
          break;
        case ConfettiShape.circle:
          _drawCircle(canvas, particle.size, paint);
          break;
        case ConfettiShape.heart:
          _drawHeart(canvas, particle.size, paint);
          break;
        case ConfettiShape.star:
          _drawStar(canvas, particle.size, paint);
          break;
      }

      canvas.restore();
    }
  }

  void _drawRectangle(Canvas canvas, double size, Paint paint) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset.zero,
          width: size,
          height: size * 0.6,
        ),
        const Radius.circular(2),
      ),
      paint,
    );
  }

  void _drawCircle(Canvas canvas, double size, Paint paint) {
    canvas.drawCircle(Offset.zero, size / 2, paint);
  }

  void _drawHeart(Canvas canvas, double size, Paint paint) {
    final path = Path();
    final s = size / 2;

    path.moveTo(0, s * 0.3);
    path.cubicTo(-s * 0.8, -s * 0.5, -s, s * 0.3, 0, s);
    path.cubicTo(s, s * 0.3, s * 0.8, -s * 0.5, 0, s * 0.3);

    canvas.drawPath(path, paint);
  }

  void _drawStar(Canvas canvas, double size, Paint paint) {
    final path = Path();
    final outerRadius = size / 2;
    final innerRadius = size / 4;
    const points = 5;

    for (int i = 0; i < points * 2; i++) {
      final radius = i.isEven ? outerRadius : innerRadius;
      final angle = (i * pi / points) - pi / 2;
      final point = Offset(cos(angle) * radius, sin(angle) * radius);

      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) => true;
}

/// A widget that shows confetti from the center of the screen.
///
/// Convenience widget for common celebration patterns.
class CelebrationOverlay extends StatefulWidget {
  /// The child widget.
  final Widget child;

  /// Whether to show the celebration.
  final bool celebrate;

  /// Colors for the confetti.
  final List<Color>? colors;

  /// Intensity of the celebration.
  final ConfettiIntensity intensity;

  /// Callback when the celebration ends.
  final VoidCallback? onComplete;

  /// Creates a CelebrationOverlay.
  const CelebrationOverlay({
    super.key,
    required this.child,
    this.celebrate = false,
    this.colors,
    this.intensity = ConfettiIntensity.normal,
    this.onComplete,
  });

  @override
  State<CelebrationOverlay> createState() => _CelebrationOverlayState();
}

class _CelebrationOverlayState extends State<CelebrationOverlay> {
  late ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController.withIntensity(
      intensity: widget.intensity,
      colors: widget.colors ?? _defaultColors,
    );

    _controller.addListener(_checkComplete);

    if (widget.celebrate) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _play();
      });
    }
  }

  void _checkComplete() {
    if (!_controller.isPlaying && widget.celebrate) {
      widget.onComplete?.call();
    }
  }

  void _play() {
    final size = MediaQuery.of(context).size;
    _controller.playAt(Offset(size.width / 2, size.height / 2));
  }

  @override
  void didUpdateWidget(CelebrationOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.celebrate && !oldWidget.celebrate) {
      _play();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_checkComplete);
    _controller.dispose();
    super.dispose();
  }

  static const _defaultColors = [
    Color(0xFFE91E63), // Pink
    Color(0xFFFF5722), // Deep Orange
    Color(0xFF9C27B0), // Purple
    Color(0xFFF44336), // Red
    Color(0xFFFFEB3B), // Yellow
  ];

  @override
  Widget build(BuildContext context) {
    return ConfettiWidget(
      controller: _controller,
      child: widget.child,
    );
  }
}
