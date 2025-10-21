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
  String selectedOption = 'less than';
  String? errorMessage;
  bool showError = false;

  Logic triangularSolution = Logic();

  // Input validation function
  List<String> _validateInput() {
    List<String> errors = [];
    
    double a = double.tryParse(minController.text) ?? 0;
    double b = double.tryParse(modeController.text) ?? 0;
    double c = double.tryParse(maxController.text) ?? 0;
    double x = double.tryParse(targetController.text) ?? 0;

    // Check for empty fields
    if (minController.text.isEmpty || maxController.text.isEmpty || 
        modeController.text.isEmpty || targetController.text.isEmpty) {
      errors.add("All fields must be filled");
      return errors;
    }

    // Check for valid numbers
    if (a.isNaN || b.isNaN || c.isNaN || x.isNaN) {
      errors.add("All values must be valid numbers");
      return errors;
    }

    // Check parameter order rule: a ≤ b ≤ c
    if (a > c) {
      errors.add("Minimum (a) must be less than or equal to Maximum (c)\n"
          "Rule Violated: a ≤ b ≤ c");
    }

    if (b < a) {
      errors.add("Mode (b) must be greater than or equal to Minimum (a)\n"
          "Rule Violated: a ≤ b ≤ c");
    }

    if (b > c) {
      errors.add("Mode (b) must be less than or equal to Maximum (c)\n"
          "Rule Violated: a ≤ b ≤ c");
    }

    // Check for degenerate cases
    if (a == c) {
      errors.add("Minimum and Maximum cannot be equal\n"
          "Rule Violated: Distribution must have a valid range (a < c)");
    }

    if (a == b && b == c) {
      errors.add("All parameters cannot be equal\n"
          "Rule Violated: Triangular distribution requires variation in parameters");
    }

    // Check for division by zero scenarios
    if ((a <= x && x <= b) && (b == a || c == a)) {
      errors.add("Invalid parameters for probability calculation\n"
          "Rule Violated: Cannot have b = a or c = a when calculating probability between a and b");
    }

    if ((b <= x && x <= c) && (c == b || c == a)) {
      errors.add("Invalid parameters for probability calculation\n"
          "Rule Violated: Cannot have c = b or c = a when calculating probability between b and c");
    }

    // Check if target value is within reasonable bounds for display
    if (x < a - 100 || x > c + 100) {
      errors.add("Target value is too far outside the distribution range\n"
          "Rule Violated: Target value should be reasonably close to the distribution range for meaningful probability calculation");
    }

    return errors;
  }

  void _calculateProbability() {
    List<String> errors = _validateInput();
    
    if (errors.isNotEmpty) {
      setState(() {
        errorMessage = errors.join('\n\n');
        showError = true;
        probability = 0.0;
        area = 0.0;
      });
      return;
    }

    double a = double.tryParse(minController.text) ?? 0;
    double b = double.tryParse(modeController.text) ?? 0;
    double c = double.tryParse(maxController.text) ?? 0;
    double x = double.tryParse(targetController.text) ?? 0;
    
    setState(() {
      showError = false;
      errorMessage = null;
      
      if (selectedOption == 'less than') {
        probability = triangularSolution.calculateProbability(a, b, c, x);
      } else {
        probability = 1 - triangularSolution.calculateProbability(a, b, c, x);
      }
      area = triangularSolution.calculateArea(selectedOption, x, a, b, c);
    });
  }

  void _clearError() {
    setState(() {
      showError = false;
      errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Triangular Distribution'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Error Message Display
              if (showError && errorMessage != null) ...[
                _buildErrorMessage(),
                const SizedBox(height: 16),
              ],
              
              // Input Section with Guide
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
                      
                      // Input Fields with Guide
                      _buildInputWithGuide(
                        label: 'Minimum (a)',
                        controller: minController,
                        suffix: 'Unit',
                        guideText: 'The lowest possible value in the distribution. All values will be ≥ a.',
                      ),
                      const SizedBox(height: 12),
                      
                      _buildInputWithGuide(
                        label: 'Mode (b - Most Likely)',
                        controller: modeController,
                        suffix: 'Unit',
                        guideText: 'The most frequent value. Peak of the triangle. Must be between a and c.',
                      ),
                      const SizedBox(height: 12),
                      
                      _buildInputWithGuide(
                        label: 'Maximum (c)',
                        controller: maxController,
                        suffix: 'Unit',
                        guideText: 'The highest possible value in the distribution. All values will be ≤ c.',
                      ),
                      const SizedBox(height: 16),
                      
                      const Divider(),
                      const SizedBox(height: 8),
                      
                      _buildInputWithGuide(
                        label: 'Target Value (x)',
                        controller: targetController,
                        suffix: 'Unit',
                        guideText: 'The value for which you want to calculate probability (P(X < x) or P(X > x)).',
                      ),
                      
                      // Dropdown for operation selection
                      const SizedBox(height: 16),
                      _buildOperationDropdown(),
                      
                      // Additional Guide Section
                      const SizedBox(height: 20),
                      _buildDistributionRulesGuide(),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Calculate Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _calculateProbability,
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

              // Chart Section (only show if no errors)
              if (!showError) ...[
                TriangularChart(
                  a: double.tryParse(minController.text) ?? 50,
                  b: double.tryParse(modeController.text) ?? 120,
                  c: double.tryParse(maxController.text) ?? 200,
                  target: double.tryParse(targetController.text) ?? 150,
                  probType: selectedOption,
                  probability: probability, 
                ),
                const SizedBox(height: 20),
              ],
              
              // Results Section (only show if no errors)
              if (!showError) ...[
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
                          'Probability: ${(probability).toStringAsFixed(4)}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red[700],
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Input Validation Error',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            errorMessage!,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _clearError,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.close),
              label: const Text('Dismiss'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputWithGuide({
    required String label,
    required TextEditingController controller,
    required String suffix,
    required String guideText,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Input Field
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReuseInputField(
                label: label,
                controller: controller,
                suffix: suffix,
                onChanged: (value) {
                  // Clear error when user starts typing
                  if (showError) {
                    _clearError();
                  }
                },
              ),
            ],
          ),
        ),
        
        const SizedBox(width: 16),
        
        // Guide Section
        Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border.all(color: Colors.blue[100]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue[600],
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Guide:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  guideText,
                  style:  TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDistributionRulesGuide() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        border: Border.all(color: Colors.blue[100]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Triangular Distribution Rules:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 12),
          _buildRuleItem('1. Minimum (a) ≤ Mode (b) ≤ Maximum (c)'),
          _buildRuleItem('2. Probability density function forms a triangle'),
          _buildRuleItem('3. Area under the triangle = 1 (total probability)'),
          _buildRuleItem('4. Used when minimum, maximum and most likely values are known'),
          _buildRuleItem('5. Continuous probability distribution'),
          const SizedBox(height: 8),
          Text(
            'Formula: f(x) = 2(x-a)/((b-a)(c-a)) for a ≤ x ≤ b\n'
            '         f(x) = 2(c-x)/((c-b)(c-a)) for b ≤ x ≤ c',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              fontFamily: 'Monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
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
            underline: const SizedBox(),
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
                if (showError) {
                  _clearError();
                }
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