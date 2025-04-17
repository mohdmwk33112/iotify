import 'package:flutter/material.dart';
import '../../core/platform_widgets.dart';

class OnboardingPage {
  final String title;
  final String description;
  final String imagePath;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

final List<OnboardingPage> onboardingPages = [
  OnboardingPage(
    title: 'Welcome to Device Manager',
    description: 'Manage all your smart devices in one place with our intuitive interface.',
    imagePath: 'assets/onboarding1.png',
  ),
  OnboardingPage(
    title: 'Real-time Monitoring',
    description: 'Get instant insights and control over your devices with real-time updates.',
    imagePath: 'assets/onboarding2.png',
  ),
  OnboardingPage(
    title: 'Smart Automation',
    description: 'Create custom rules and automate your devices for a smarter home.',
    imagePath: 'assets/onboarding3.png',
  ),
];

class OnboardingPageView extends StatelessWidget {
  final OnboardingPage page;
  final bool isLastPage;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const OnboardingPageView({
    super.key,
    required this.page,
    required this.isLastPage,
    required this.onNext,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Placeholder for image
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  page.imagePath,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              page.title,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              page.description,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PlatformWidgets.button(
                  context: context,
                  onPressed: onSkip,
                  child: const Text('Skip'),
                ),
                PlatformWidgets.button(
                  context: context,
                  onPressed: onNext,
                  child: Text(isLastPage ? 'Get Started' : 'Next'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 