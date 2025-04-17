import 'package:flutter/material.dart';
import '../screens/farmer/dashboard_screen.dart';
import '../screens/farmer/profile_screen.dart';
import '../screens/farmer/crop_upload_screen.dart';
import '../screens/auth/signup_screen.dart';

import '../screens/auth/login_screen.dart';
import '../screens/buyer/buyer_dashboard_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  // '/': (context) => const LoginScreen(), // Add default route
  //'/': (context) => const SplashScreen(),
  '/signup': (context) => const SignupScreen(),
  '/login': (context) => const LoginScreen(),
  '/farmerDashboard': (context) => const FarmerDashboardScreen(),
  '/buyerDashboard': (context) => const BuyerDashboardScreen(),
  '/farmerProfile': (context) => const FarmerProfileScreen(),
  '/upload': (context) => const CropUploadScreen(),
};
