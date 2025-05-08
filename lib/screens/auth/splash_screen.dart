import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/welcome');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              _buildScreen1(),
              _buildScreen2(),
              _buildScreen3(),
              _buildScreen4(),
            ],
          ),
          // Show arrow only on first and second page.
          if (_currentPage == 0) // Changed condition.
            Positioned(
              bottom: 30,
              right: 30,
              child: FloatingActionButton(
                backgroundColor: const Color(0xFF4C6B57),
                onPressed: _nextPage,
                child: const Icon(Icons.arrow_forward, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildScreen1() {
    return Container(
      color: const Color(0xFF4C6B57),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Kissan',
              style: TextStyle(
                fontSize: 28,
                fontStyle: FontStyle.italic,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Digital App',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScreen2() {
    return Stack(
      children: [
        Container(
          color: const Color(0xFFE3EBE1),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              const Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 58,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1C4B33),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'we’re glad that that you are here',
                style: TextStyle(fontSize: 20, color: Color(0xFF1C4B33)),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4C6B57),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 25,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Lets get started',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        Positioned(
          bottom: -40,
          right: -40,
          child: Transform.scale(
            scale: 1.3,
            child: Opacity(
              opacity: 0.9,
              child: Image.asset('assets/images/farmer_logo.png', height: 300),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScreen3() {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      color: const Color(0xFFE3EBE1),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/splash_image_1.jpg',
            height: 180,
            width: screenWidth,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 40),
          const Text(
            'Your Harvest Meets\nIts Perfect Buyer',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1C4B33),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Where farmer and buyers meet.',
            style: TextStyle(fontSize: 26, color: Colors.grey),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: _nextPage,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4C6B57),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 25),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text(
              'Continue',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScreen4() {
    return Container(
      color: const Color(0xFFE3EBE1),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/splash_image_2.png', height: 200),
          const SizedBox(height: 40),
          const Text(
            'AI-Powered Cotton\nGrading & Valuation',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1C4B33),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Join Now',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/signup');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4C6B57),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 25),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text(
              'Create Account',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}


/*
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/welcome');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: [
          _buildScreen1(),
          _buildScreen2(),
          _buildScreen3(),
          _buildScreen4(),
        ],
      ),
    );
  }

  Widget _buildScreen1() {
    return Container(
      color: const Color(0xFF4C6B57),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Kissan',
              style: TextStyle(
                fontSize: 28,
                fontStyle: FontStyle.italic,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Digital App',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScreen2() {
    return Container(
      color: const Color(0xFFE3EBE1),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Welcome',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1C4B33),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'we’re glad that that you are here',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF1C4B33),
            ),
          ),
          const SizedBox(height: 30),
          Image.asset(
            'assets/farmer_logo.png',
            height: 200,
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _nextPage,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4C6B57),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Lets get started'),
          ),
        ],
      ),
    );
  }

  Widget _buildScreen3() {
    return Container(
      color: const Color(0xFFE3EBE1),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/splash_image_1.png',
            height: 180,
          ),
          const SizedBox(height: 40),
          const Text(
            'Your Harvest Meets\nIts Perfect Buyer',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1C4B33),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Where farmer and buyers meet.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: _nextPage,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4C6B57),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  Widget _buildScreen4() {
    return Container(
      color: const Color(0xFFE3EBE1),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/splash_image_2.png',
            height: 200,
          ),
          const SizedBox(height: 40),
          const Text(
            'AI-Powered Cotton\nGrading & Valuation',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1C4B33),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Join Now',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/signup');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4C6B57),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Create Account'),
          )
        ],
      ),
    );
  }
}
*/