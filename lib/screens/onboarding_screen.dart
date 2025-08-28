import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  // Dummy data (to add pics and images)
  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/images/pic_1.png",
      "title": "Discover Blogs",
      "desc": "Explore thousands of blogs on technology, lifestyle, and personal growth."
    },
    {
      "image": "assets/images/pic_2.png",
      "title": "Stay Updated",
      "desc": "Get daily updates with the latest blogs tailored to your interests."
    },
    {
      "image": "assets/images/pic_3.png",
      "title": "Join the Community",
      "desc": "Engage with writers, share your ideas, and grow together."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold( backgroundColor: const Color(0xFF0D0D0D),
      body: Stack(
        children: [
          // PageView for screens
          PageView.builder(
            controller: _controller,
            itemCount: onboardingData.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    onboardingData[index]["image"]!,
                    height: 300,
                  ),
                  SizedBox(height: 20),
                  Text(
                    onboardingData[index]["title"]!,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      onboardingData[index]["desc"]!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          ),

          // Skip Button
          Positioned(
            bottom: 40,
            left: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/login");
              },
              child: Text("Skip",
                style: TextStyle(color:
              const Color(0xFF0D0D0D),
              ),
              ),
            ),
          ),

          // Next / Done Button
          Positioned(
            bottom: 40,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                if (_currentPage == onboardingData.length - 1) {
                  // Last screen → Login
                  Navigator.pushReplacementNamed(context, "/login");
                } else {
                  _controller.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                }
              },
              child: Text(
                style: TextStyle(
                color: const Color(0xFF0D0D0D),
              ),
                _currentPage == onboardingData.length - 1 ? "Next" : "Next",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
