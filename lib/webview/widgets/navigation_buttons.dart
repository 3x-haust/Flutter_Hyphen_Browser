import 'package:flutter/material.dart';

class NavigationButtons extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onForward;
  final VoidCallback onRefresh;

  const NavigationButtons({
    super.key,
    required this.onBack,
    required this.onForward,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(child: const Icon(Icons.arrow_back), onPressed: onBack),
        ElevatedButton(child: const Icon(Icons.arrow_forward), onPressed: onForward),
        ElevatedButton(child: const Icon(Icons.refresh), onPressed: onRefresh),
      ],
    );
  }
}