import 'package:flutter/material.dart';
import '../screens/farmer/dashboard_screen.dart';
import '../screens/farmer/profile_screen.dart';
import '../screens/farmer/crop_upload_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/splash_screen.dart';

import '../screens/auth/login_screen.dart';
import '../screens/buyer/buyer_dashboard_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const SplashScreen(),
  '/signup': (context) => const SignupScreen(),
  '/farmerDashboard': (context) => const FarmerDashboardScreen(),
  '/farmerProfile': (context) => const ProfileScreen(),
  // '/': (context) => const LoginScreen(), // Add default route
  //'/': (context) => const SplashScreen(),
  '/login': (context) => const LoginScreen(),
  '/buyerDashboard': (context) => const BuyerDashboardScreen(),
  '/upload': (context) => const CropUploadScreen(),
};




/*
import 'package:flutter/material.dart';
import '../screens/farmer/dashboard_screen.dart';
import '../screens/farmer/profile_screen.dart';
import '../screens/farmer/crop_upload_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/splash_screen.dart';

import '../screens/auth/login_screen.dart';
import '../screens/buyer/buyer_dashboard_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const SplashScreen(),
  '/signup': (context) => const SignupScreen(),
  '/farmerDashboard': (context) => const FarmerDashboardScreen(),
  '/farmerProfile': (context) => const ProfileScreen(),
  // '/': (context) => const LoginScreen(), // Add default route
  //'/': (context) => const SplashScreen(),
  '/login': (context) => const LoginScreen(),

  '/buyerDashboard': (context) => const BuyerDashboardScreen(),

  '/upload': (context) => const CropUploadScreen(),
};
*/