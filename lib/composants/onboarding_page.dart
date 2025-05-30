import 'package:flutter/cupertino.dart';

import '../theme/style.dart';
import 'layout.dart';

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final Widget? action;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: "",
      subtitle: "",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Text(title, style: KTypography.h1(context, color: KColors.primary)),
          const SizedBox(height: 20),
          Image.asset(
            image,
            height: 300,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              description,
              style: KTypography.h3(context, color: KColors.primary),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          if (action != null) action!,
        ],
      ),
    );
  }
}
