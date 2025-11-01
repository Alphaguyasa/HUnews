import 'package:flutter/material.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF1B365D),
        child: Column(
          children: [
            Container(
              height: screenHeight * 0.5,
              width: screenWidth,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
                color: Colors.transparent,
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                'https://ssgi.gov.et/wp-content/uploads/2023/04/ssgi-logo-final-e1689234235773.png',
                fit: BoxFit.fill,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: progress.expectedTotalBytes != null
                          ? progress.cumulativeBytesLoaded /
                          progress.expectedTotalBytes!
                          : null,
                      color: Colors.white,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(
                    Icons.broken_image,
                    color: Colors.white,
                    size: 100,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Welcome to SSGI News',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Get the latest updates and news directly from the Space Science & Geospatial Institute (SSGI).',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                          padding: const EdgeInsets.symmetric(
                              vertical: 18, horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                          shadowColor: Colors.black45,
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()),
                          );
                        },
                        child: const Text(
                          'Get Started',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}