import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sm_task/Logic.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sm_task/triangular_chart.dart';
import 'package:sm_task/widget/input_field.dart';
class TriangularCalculator extends StatefulWidget {
  const TriangularCalculator({super.key});

  @override
  State<TriangularCalculator> createState() => _TriangularCalculatorState();
}

class _TriangularCalculatorState extends State<TriangularCalculator> {
  final TextEditingController minController = TextEditingController(text: '50');
  final TextEditingController maxController = TextEditingController(text: '200');
  final TextEditingController modeController = TextEditingController(text: '120');
  final TextEditingController targetController = TextEditingController(text: '150');
  
  double probability = 0.0;
  double area = 0.0;
  String selectedOption = 'less than'; // Default option

  Logic triangularSolution = Logic();

 void _calculateProbability() {
    double a = double.tryParse(minController.text) ?? 0;
    double b = double.tryParse(modeController.text) ?? 0;
    double c = double.tryParse(maxController.text) ?? 0;
    double x = double.tryParse(targetController.text) ?? 0;
    
    setState(() {
      probability = triangularSolution.calculateProbability(a, b, c, x);
      area = triangularSolution.calculateArea(selectedOption, x, a, b, c);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Triangular Distribution Calculator'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Input Section
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Distribution Parameters',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ReuseInputField(label:  'Minimum (a)',controller:  minController,suffix:  'Unit'),
                      const SizedBox(height: 12),
                      ReuseInputField(label: 'Mode (b - Most Likely)',controller:  modeController,suffix:  'Unit'),
                      const SizedBox(height: 12),
                      ReuseInputField(label: 'Maximum (c)',controller:  maxController, suffix: 'Unit'),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 8),
                      ReuseInputField(label: 'Target Value (x)',controller:  targetController,suffix:  'Unit'),
                      
                      // Dropdown for operation selection
                      const SizedBox(height: 16),
                      _buildOperationDropdown(),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Calculate Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (){
                        double a = double.tryParse(minController.text) ?? 0;
    double b = double.tryParse(modeController.text) ?? 0;
     double c = double.tryParse(maxController.text) ?? 0;
     double x = double.tryParse(targetController.text) ?? 0;
                  
              setState(() {
                   probability = triangularSolution.calculateProbability(a, b, c, x);
                   area  = triangularSolution.calculateArea(selectedOption, x, a, b, c);
              });
            print(probability.toString());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: const Text('Calculate Probability'),
                ),

              ),
// Chart Section - Simple call
// Chart Section
TriangularChart(
  a: double.tryParse(minController.text) ?? 50,
  b: double.tryParse(modeController.text) ?? 120,
  c: double.tryParse(maxController.text) ?? 200,
  target: double.tryParse(targetController.text) ?? 150,
  probType: selectedOption,
  probability: probability, 
),
              const SizedBox(height: 20),
              
              // Results Section
              Card(
                color: Colors.blue[50],
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'RESULT',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Probability  ${selectedOption == 'less than' ? '<' : '>'}  \$${targetController.text}: ${(area).toStringAsFixed(4)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      LinearProgressIndicator(
                        value: probability,
                        backgroundColor: Colors.grey[300],
                        color: probability > 0.5 ? Colors.red : Colors.green,
                        minHeight: 12,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Probability: ${(probability )}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildOperationDropdown() { 
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Operation Type',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButton<String>(
            value: selectedOption,
            isExpanded: true,
            underline: const SizedBox(), // Remove default underline
            items: <String>['less than', 'greater than']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 16),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedOption = newValue!;
              });
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    minController.dispose();
    maxController.dispose();
    modeController.dispose();
    targetController.dispose();
    super.dispose();
  }
}