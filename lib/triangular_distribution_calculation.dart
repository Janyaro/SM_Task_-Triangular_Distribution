import 'package:flutter/material.dart';
import 'package:sm_task/Logic.dart';

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
  String resultText = '';
  String? minValue ; 
  String? maxValue ;
  String? modeValue ;
  String? TargetValue;

  @override
  // void initState() {
  //   super.initState();
  //   calculateProbability();
  // }
  Logic triangularSolution = Logic();
  void calculateProbability() {
    double a = double.tryParse(minController.text) ?? 0;
    double b = double.tryParse(modeController.text) ?? 0;
    double c = double.tryParse(maxController.text) ?? 0;
    double x = double.tryParse(targetController.text) ?? 0;

    if (a >= b || b >= c) {
      setState(() {
        resultText = 'Error: Must satisfy Min < Mode < Max';
        probability = 0.0;
      });
      return;
    }

    double prob =triangularSolution.calculateProbability(a, b, c, x);
    
    setState(() {
      probability = prob;
      resultText = 'Pr(X < \$$x) = ${(prob * 100).toStringAsFixed(1)}%';
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
                      _buildInputField('Minimum (a)', minController, 'Unit'),
                      const SizedBox(height: 12),
                      _buildInputField('Mode (b - Most Likely)', modeController, 'Unit'),
                      const SizedBox(height: 12),
                      _buildInputField('Maximum (c)', maxController, 'Unit'),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 8),
                      _buildInputField('Target Value (x)', targetController, 'Unit'),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Calculate Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: calculateProbability,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: const Text('Calculate Probability'),
                ),
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
                        resultText,
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
                        'Probability: ${(probability * 100).toStringAsFixed(2)}%',
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
              
              // Explanation Section
              const Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About Triangular Distribution',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'This calculator finds the probability that a random variable X '
                        'is less than a target value, where X follows a triangular distribution '
                        'with minimum (a), mode (b), and maximum (c) values.',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, String prefix) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        prefixText: prefix,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      onChanged: (value) => calculateProbability(),
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