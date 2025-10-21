import 'package:flutter/material.dart';

class ReuseInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String suffix;
  const ReuseInputField({super.key, required this.label, required this.controller, required this.suffix, required Null Function(dynamic value) onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      onChanged: (value) => (){},
    );
   }
}