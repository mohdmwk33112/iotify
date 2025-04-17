import 'package:flutter/material.dart';
import 'onboarding_pages.dart';
import '../../routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _onNext() {
    if (_currentPage < onboardingPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushNamed(context, AppRoutes.auth);
    }
  }

  void _onSkip() {
    Navigator.pushNamed(context, AppRoutes.auth);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        itemCount: onboardingPages.length,
        itemBuilder: (context, index) {
          return OnboardingPageView(
            page: onboardingPages[index],
            isLastPage: index == onboardingPages.length - 1,
            onNext: _onNext,
            onSkip: _onSkip,
          );
        },
      ),
    );
  }
} 