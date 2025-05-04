import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

class CustomSplashScreen extends StatefulWidget {
  final Widget nextScreen;
  final String imagePath;
  final Duration duration;
  final Color backgroundColor;
  final bool withLottie;
  final String? tagline;

  const CustomSplashScreen({
    Key? key,
    required this.nextScreen,
    required this.imagePath,
    this.duration = const Duration(milliseconds: 3000),
    this.backgroundColor = Colors.white,
    this.withLottie = false,
    this.tagline = "Make photoshoots, Just magic",
  }) : super(key: key);

  @override
  _CustomSplashScreenState createState() => _CustomSplashScreenState();
}

class _CustomSplashScreenState extends State<CustomSplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _particlesAnimationController;
  late AnimationController _taglineAnimationController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _taglineAnimation;

  final List<ParticleModel> _particles = [];
  final int _numberOfParticles = 30;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();

    // Initialize main logo animation controller
    _logoAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Initialize particles animation controller
    _particlesAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();

    // Initialize tagline animation controller
    _taglineAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    // Logo fade-in animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    // Logo scale animation
    _scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: const Interval(0.3, 0.8, curve: Curves.elasticOut),
      ),
    );

    // Glow effect animation
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Tagline fade-in and slide-up animation
    _taglineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _taglineAnimationController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Create particles
    _createParticles();

    // Sequence animations
    _logoAnimationController.forward();

    // Delay tagline animation
    Future.delayed(const Duration(milliseconds: 1000), () {
      _taglineAnimationController.forward();
    });

    // Navigate to next screen after specified duration
    Timer(widget.duration, () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => widget.nextScreen),
      );
    });
  }

  void _createParticles() {
    // Create magical particle effects
    for (int i = 0; i < _numberOfParticles; i++) {
      _particles.add(ParticleModel(
        position: Offset(
          _random.nextDouble() * 400 - 200,
          _random.nextDouble() * 400 - 200,
        ),
        size: _random.nextDouble() * 15 + 5,
        color: _getRandomColor(),
        speedFactor: _random.nextDouble() * 0.8 + 0.2,
      ));
    }
  }

  Color _getRandomColor() {
    // Colors for the magical particles - purple, blue, and gold tones
    List<Color> colors = [
      Colors.purple.shade300,
      Colors.deepPurple.shade300,
      Colors.blue.shade300,
      Colors.amber.shade300,
      Colors.amber.shade200,
    ];
    return colors[_random.nextInt(colors.length)];
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _particlesAnimationController.dispose();
    _taglineAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
        ),
        child: Stack(
          children: [
            // Background effect
            AnimatedBuilder(
              animation: _particlesAnimationController,
              builder: (context, child) {
                return CustomPaint(
                  painter: ParticlesPainter(
                    particles: _particles,
                    animation: _particlesAnimationController,
                  ),
                  size: Size(size.width, size.height),
                );
              },
            ),

            // Logo with animation
            Center(
              child: AnimatedBuilder(
                animation: _logoAnimationController,
                builder: (context, child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          boxShadow: [
                            if (_glowAnimation.value > 0)
                              BoxShadow(
                                color: Colors.white.withOpacity(_glowAnimation.value * 0.3),
                                blurRadius: 30 * _glowAnimation.value,
                                spreadRadius: 10 * _glowAnimation.value,
                              ),
                          ],
                        ),
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: ScaleTransition(
                            scale: _scaleAnimation,
                            child: widget.withLottie
                                ? _buildLottieAnimation()
                                : Image.asset(
                              widget.imagePath,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 40),

                      // Tagline animation
                      AnimatedBuilder(
                        animation: _taglineAnimationController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _taglineAnimation.value,
                            child: Transform.translate(
                              offset: Offset(0, 20 * (1 - _taglineAnimation.value)),
                              child: _buildTaglineWidget(),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaglineWidget() {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: [
                Colors.white,
                Colors.white.withOpacity(0.8),
                Colors.purple.shade200,
                Colors.blue.shade200,
              ],
              stops: [0.0, 0.4, 0.7, 1.0],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds);
          },
          child: Text(
            widget.tagline?.split(',').first ?? "",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 8),
        ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: [
                Colors.amber.shade200,
                Colors.amber.shade300,
                Colors.amber.shade400,
              ],
              stops: [0.0, 0.5, 1.0],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds);
          },
          child: Text(
            widget.tagline?.split(',').last.trim() ?? "",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLottieAnimation() {
    // If you want to use Lottie animation, first add the dependency:
    // lottie: ^2.3.2

    // Then uncomment the below code:
    /*
    return Lottie.asset(
      widget.imagePath,
      width: 250,
      height: 250,
      fit: BoxFit.contain,
    );
    */

    // For now, we'll show a placeholder with animation
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Icon(
          Icons.auto_awesome,
          size: 100,
          color: Colors.white,
        ),
      ),
    );
  }
}

// Particle model for magical effects
class ParticleModel {
  Offset position;
  double size;
  Color color;
  double speedFactor;

  ParticleModel({
    required this.position,
    required this.size,
    required this.color,
    required this.speedFactor,
  });
}

// Custom painter for magical particle effects
class ParticlesPainter extends CustomPainter {
  final List<ParticleModel> particles;
  final Animation<double> animation;

  ParticlesPainter({required this.particles, required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < particles.length; i++) {
      final particle = particles[i];

      // Calculate particle position based on animation
      final angle = (animation.value * 2 * math.pi * particle.speedFactor) % (2 * math.pi);
      final radius = 100 + (50 * math.sin(animation.value * math.pi * particle.speedFactor));

      final dx = math.cos(angle + i) * radius + particle.position.dx;
      final dy = math.sin(angle + i) * radius + particle.position.dy;

      final position = center + Offset(dx, dy);

      // Draw the particle
      final paint = Paint()
        ..color = particle.color.withOpacity(0.6 + 0.4 * math.sin(animation.value * math.pi))
        ..style = PaintingStyle.fill
        ..blendMode = BlendMode.srcOver;

      canvas.drawCircle(position, particle.size * (0.5 + 0.5 * math.sin(animation.value * math.pi * 2)), paint);
    }
  }

  @override
  bool shouldRepaint(ParticlesPainter oldDelegate) => true;
}

// Example usage:
/*
void main() {
  runApp(
    MaterialApp(
      home: CustomSplashScreen(
        imagePath: 'assets/logo.png',  // Your logo path
        nextScreen: HomeScreen(),      // Your home screen
        backgroundColor: Colors.blue.shade50,
        duration: Duration(milliseconds: 3500),
        withLottie: false,  // Set to true if using Lottie animation
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}
*/