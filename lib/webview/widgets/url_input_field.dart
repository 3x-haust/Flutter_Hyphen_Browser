import 'package:flutter/material.dart';

class UrlInputField extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onSubmitted;

  const UrlInputField({
    super.key,
    required this.controller,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(prefixIcon: Icon(Icons.search)),
      controller: controller,
      keyboardType: TextInputType.url,
      onSubmitted: onSubmitted,
    );
  }
}