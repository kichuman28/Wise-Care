import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/document_provider.dart';
import 'core/providers/doctor_provider.dart';
import 'core/providers/booking_provider.dart';
import 'core/providers/prescription_provider.dart';
import 'core/providers/order_provider.dart';
import 'core/providers/user_address_provider.dart';
import 'core/models/health_module_model.dart';
import 'core/services/google_fit_service.dart';
import 'ui/screens/login_screen.dart';
import 'core/theme/app_theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/services/sos_service.dart';
import 'core/services/fall_detection_service.dart';
import 'package:lottie/lottie.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style for status bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  late final SOSService _sosService;
  late final FallDetectionService _fallDetectionService;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _sosService = SOSService();
    _fallDetectionService = FallDetectionService(
      _sosService,
      scaffoldKey: _scaffoldKey,
      navigatorKey: _navigatorKey,
    );

    // Simulate initialization delay for splash screen
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Simulate app initialization with a delay
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, DocumentProvider?>(
          create: (_) => null,
          update: (context, auth, previous) {
            if (auth.user != null) {
              return previous ?? DocumentProvider(userId: auth.user!.uid);
            }
            return null;
          },
        ),
        ChangeNotifierProvider(create: (_) => DoctorProvider()),
        ChangeNotifierProxyProvider<AuthProvider, BookingProvider?>(
          create: (_) => null,
          update: (context, auth, previous) {
            if (auth.user != null) {
              final provider = previous ?? BookingProvider();
              provider.loadUserBookings(auth.user!.uid);
              return provider;
            }
            return null;
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, PrescriptionProvider?>(
          create: (_) => null,
          update: (context, auth, previous) {
            if (auth.user != null) {
              final provider = previous ?? PrescriptionProvider();
              provider.loadUserPrescriptions(auth.user!.uid);
              return provider;
            }
            return null;
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrderProvider?>(
          create: (_) => null,
          update: (context, auth, previous) {
            if (auth.user != null) {
              final provider = previous ?? OrderProvider();
              provider.loadUserOrders(auth.user!.uid);
              return provider;
            }
            return null;
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, UserAddressProvider?>(
          create: (_) => null,
          update: (context, auth, previous) {
            if (auth.user != null) {
              final provider = previous ?? UserAddressProvider();
              provider.loadUserAddresses(auth.user!.uid);
              return provider;
            }
            return null;
          },
        ),
        Provider(create: (_) => GoogleFitService()),
        ChangeNotifierProxyProvider<GoogleFitService, HealthModuleModel>(
          create: (context) =>
              HealthModuleModel(context.read<GoogleFitService>()),
          update: (context, googleFitService, previous) =>
              previous ?? HealthModuleModel(googleFitService),
        ),
      ],
      child: MaterialApp(
        scaffoldMessengerKey: _scaffoldKey,
        navigatorKey: _navigatorKey,
        title: 'Wise Care',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: !_isInitialized
            ? const SplashScreen()
            : Builder(
                builder: (context) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _fallDetectionService.startMonitoring();
                  });
                  return const LoginScreen();
                },
              ),
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.primaryGradient,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/logo/wise-care.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 24),

                // App name
                const Text(
                  'WISE CARE',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 8),

                // Tagline
                const Text(
                  'Your Health, Our Priority',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 48),

                // Loading indicator
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
