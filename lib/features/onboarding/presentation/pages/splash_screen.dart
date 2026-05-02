import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/controller/main_controller/main_controller.dart';
import '../../data/onboarding_data.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final appController = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// Skip Button and Back Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  currentIndex != 0
                      ? GestureDetector(
                          onTap: () {
                            _controller.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          },
                          child: const Text("Back",
                              style: TextStyle(color: Colors.blue)),
                        )
                      : const SizedBox(),

                  GestureDetector(
                    onTap: () async {
                      await appController.completeOnboarding();
                    },
                    child: const Text("Skip",
                        style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            ),

            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: onboardData.length,
                onPageChanged: (index) {
                  setState(() => currentIndex = index);
                },
                itemBuilder: (context, index) {
                  final item = onboardData[index];

                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),

                        Image.asset(item.image, height: 220),

                        const SizedBox(height: 40),

                        
                        Row(
                          children: List.generate(
                            onboardData.length,
                            (i) => Expanded(
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                height: 4,
                                color: i <= currentIndex
                                    ? const Color(0xFF2F80ED)
                                    : Colors.grey.shade300,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        Text(
                          item.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          item.subtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),

                        const Spacer(),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2F80ED),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {
                              if (currentIndex == onboardData.length - 1) {
                                await appController.completeOnboarding();
                              } else {
                                _controller.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.ease,
                                );
                              }
                            },
                            child: Text(
                              currentIndex == onboardData.length - 1
                                  ? "Get Started"
                                  : "Next",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}
