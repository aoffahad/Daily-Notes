import 'package:flutter/material.dart';
import '../../data/models/onboarding_models.dart';

class OnboardingItem extends StatelessWidget {
  final OnboardingModel item;

  const OnboardingItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        Image.asset(item.image, height: 220),
        const SizedBox(height: 40),

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
      ],
    );
  }
}