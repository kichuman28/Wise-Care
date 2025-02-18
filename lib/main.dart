import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/document_provider.dart';
import 'ui/screens/login_screen.dart';
import 'core/theme/app_theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/services/sos_service.dart';
import 'core/services/fall_detection_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  late final SOSService _sosService;
  late final FallDetectionService _fallDetectionService;

  @override
  void initState() {
    super.initState();
    _sosService = SOSService();
    _fallDetectionService = FallDetectionService(
      _sosService,
      scaffoldKey: _scaffoldKey,
      navigatorKey: _navigatorKey,
    );
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
      ],
      child: MaterialApp(
        scaffoldMessengerKey: _scaffoldKey,
        navigatorKey: _navigatorKey,
        title: 'Wise Care',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: Builder(
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
