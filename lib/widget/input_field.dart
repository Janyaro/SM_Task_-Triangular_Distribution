import 'package:flutter/material.dart';

class ReuseInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String unit;
  const ReuseInputField({super.key, required this.label, required this.controller, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label),
          ),
          Expanded(
            flex: 1,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                suffixText: unit,
              ),
            ),
          ),
        ],
      ),
    );;
  }
}