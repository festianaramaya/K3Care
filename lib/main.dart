import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/dashboard_screen.dart';
import 'screens/info_k3_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/pelaporan_screen.dart';
import 'screens/pelaporan_form_screen.dart';
import 'screens/pelaporan_success_screen.dart';
import 'screens/pelaporan_history_screen.dart';
import 'screens/pengingat_k3_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/add_activity_screen.dart';
import 'screens/add_certification_screen.dart';
import 'screens/manage_safety_tips_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  initializeDateFormatting('id_ID');
  runApp(const K3CareApp());
}

class K3CareApp extends StatelessWidget {
  const K3CareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'K3Care',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1E8E3E),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E8E3E),
          primary: const Color(0xFF1E8E3E),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E8E3E),
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E8E3E),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/': (context) => const DashboardScreen(),
        '/info_k3': (context) => const InfoK3Screen(),
        '/profile': (context) => const ProfileScreen(),
        '/edit_profile': (context) => const EditProfileScreen(),
        '/pelaporan': (context) => const PelaporanScreen(),
        '/pelaporan_form': (context) => const PelaporanFormScreen(),
        '/pelaporan_success': (context) => const PelaporanSuccessScreen(),
        '/pelaporan_history': (context) => const PelaporanHistoryScreen(),
        '/pengingat_k3': (context) => const PengingatK3Screen(),
        '/add_activity': (context) => const AddActivityScreen(),
        '/add_certification': (context) => const AddCertificationScreen(),
        '/manage_safety_tips': (context) => const ManageSafetyTipsScreen(),
      },
    );
  }
}
