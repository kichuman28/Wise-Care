import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import '../../core/theme/app_theme.dart';
import 'main_layout_screen.dart';

class MorphingPageRoute extends PageRouteBuilder {
  final Widget child;
  final Offset center;

  MorphingPageRoute({
    required this.child,
    required this.center,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: const Duration(milliseconds: 1000),
          reverseTransitionDuration: const Duration(milliseconds: 800),
        );

  @override
  Widget buildTransitions(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final radius = animation.value * MediaQuery.of(context).size.longestSide * 1.5;
        return ClipPath(
          clipper: CircularRevealClipper(
            center: center,
            radius: radius,
          ),
          child: child,
        );
      },
      child: child,
    );
  }
}

class CircularRevealClipper extends CustomClipper<Path> {
  final Offset center;
  final double radius;

  CircularRevealClipper({
    required this.center,
    required this.radius,
  });

  @override
  Path getClip(Size size) {
    return Path()
      ..addOval(
        Rect.fromCircle(
          center: center,
          radius: radius,
        ),
      );
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isLoading = false;
  bool _isInitializing = true;
  bool _isFadingOut = false;
  late AnimationController _buttonAnimationController;
  late Animation<double> _buttonScaleAnimation;
  Offset? _tapPosition;

  @override
  void initState() {
    super.initState();
    _buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _buttonScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _buttonAnimationController,
      curve: Curves.easeInOut,
    ));

    // Check if user is already signed in
    _checkCurrentUser();
  }

  Future<void> _showLoginAnimation(BuildContext context, {bool isWelcomeBack = false}) async {
    // First fade out the current content
    setState(() {
      _isFadingOut = true;
    });

    // Wait for fade out animation
    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;

    // Show full screen loading animation
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: Dialog.fullscreen(
          backgroundColor: AppColors.tertiary,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                width: 200,
                child: Lottie.asset(
                  'assets/animations/login_success.json',
                  repeat: true,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                isWelcomeBack ? 'Welcome back!' : 'Signing you in...',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.text,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _checkCurrentUser() async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        if (!mounted) return;

        await _showLoginAnimation(context, isWelcomeBack: true);

        // Wait for animation to play
        await Future.delayed(const Duration(milliseconds: 2000));

        if (!mounted) return;

        // Navigate to main layout
        Navigator.of(context).pop(); // Remove animation dialog
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const MainLayoutScreen(),
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
        return;
      }
    } catch (e) {
      debugPrint('Error checking current user: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _buttonAnimationController.dispose();
    super.dispose();
  }

  Future<void> _handleGoogleSignIn(BuildContext context, Offset position) async {
    _tapPosition = position;
    try {
      setState(() {
        _isLoading = true;
      });
      await _buttonAnimationController.forward();

      await _showLoginAnimation(context);

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        Navigator.of(context).pop(); // Remove loading animation
        throw Exception('Google Sign In was cancelled');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        if (!mounted) return;

        // Wait for a moment to show the success state
        await Future.delayed(const Duration(milliseconds: 500));

        // Navigate with morphing animation and remove the loading dialog
        Navigator.of(context).pop(); // Remove loading animation
        Navigator.of(context).pushReplacement(
          MorphingPageRoute(
            center: position,
            child: const MainLayoutScreen(),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      // Remove loading animation if it's showing
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign in failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      await _buttonAnimationController.reverse();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isFadingOut = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primary.withOpacity(0.1),
                Colors.white,
              ],
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return Scaffold(
      body: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: _isFadingOut ? 0.0 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primary.withOpacity(0.1),
                Colors.white,
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),
                  Center(
                    child: Image.asset(
                      'assets/logo/logo_no_text.png',
                      width: 120,
                      height: 120,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Welcome to\nWise Care',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: AppColors.text,
                          height: 1.2,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your personal health companion for a better and healthier life',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  if (_isLoading)
                    const SizedBox.shrink() // Hide the loading indicator since we're showing the fullscreen animation
                  else
                    ScaleTransition(
                      scale: _buttonScaleAnimation,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary,
                              AppColors.secondary,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTapDown: (details) {
                              _tapPosition = details.globalPosition;
                            },
                            onTap: () {
                              if (_tapPosition != null) {
                                _handleGoogleSignIn(context, _tapPosition!);
                              }
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 32,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/logo/google_logo.png',
                                    height: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Sign in with Google',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
