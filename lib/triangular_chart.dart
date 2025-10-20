import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TriangularChart extends StatelessWidget {
  final double a;
  final double b;
  final double c;
  final double target;
  final String probType;
  final double probability;

  const TriangularChart({
    Key? key,
    required this.a,
    required this.b,
    required this.c,
    required this.target,
    required this.probType,
    required this.probability,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double targetY = _calculatePDF(a, b, c, target);
    List<FlSpot> shadedAreaPoints = _generateShadedAreaPoints(a, b, c, target, probType);
    
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Triangular Distribution',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 250,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          if (value == a || value == b || value == c || value == target) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                value.toInt().toString(),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: _getColorForValue(value),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }
                          return Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                  minX: a - (c - a) * 0.1,
                  maxX: c + (c - a) * 0.1,
                  minY: 0,
                  maxY: _calculateMaxY(a, b, c) * 1.2,
                  lineBarsData: [
                    // SHADED AREA (First so it's behind the lines)
                    LineChartBarData(
                      spots: shadedAreaPoints,
                      isCurved: false,
                      color: Colors.transparent,
                      barWidth: 0,
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            Colors.orange.withOpacity(0.6),
                            Colors.orange.withOpacity(0.3),
                            Colors.orange.withOpacity(0.1),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      dotData: FlDotData(show: false),
                    ),
                    // Main triangular distribution
                    LineChartBarData(
                      spots: _generateDataPoints(a, b, c),
                      isCurved: false,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                    ),
                    // Target vertical line
                    LineChartBarData(
                      spots: [
                        FlSpot(target, 0),
                        FlSpot(target, _calculateMaxY(a, b, c) * 1.1),
                      ],
                      isCurved: false,
                      color: Colors.red,
                      barWidth: 2,
                      dotData: FlDotData(show: false),
                    ),
                    // Target point on curve
                    LineChartBarData(
                      spots: [FlSpot(target, targetY)],
                      isCurved: false,
                      color: Colors.red,
                      barWidth: 8,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 5,
                            color: Colors.red,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            // Probability info with colored box
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.area_chart, color: Colors.orange, size: 16),
                      SizedBox(width: 5),
                      Text(
                        'Target: (${target.toInt()}, ${targetY.toStringAsFixed(4)})',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    'P(X ${probType == 'less than' ? '<' : '>'} ${target.toInt()}) = ${(probability * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Shaded Area: ${probType == 'less than' ? 'Left side' : 'Right side'} of target',
                    style: TextStyle(
                      color: Colors.orange[700],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLegend('Min: ${a.toInt()}', Colors.blue),
                _buildLegend('Mode: ${b.toInt()}', Colors.green),
                _buildLegend('Max: ${c.toInt()}', Colors.orange),
                _buildLegend('Target', Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _generateDataPoints(double a, double b, double c) {
    List<FlSpot> points = [];
    
    // Left side of triangle (a to b)
    for (double x = a; x <= b; x += (b - a) / 30) {
      double y = _calculatePDF(a, b, c, x);
      points.add(FlSpot(x, y));
    }
    
    // Right side of triangle (b to c)
    for (double x = b; x <= c; x += (c - b) / 30) {
      double y = _calculatePDF(a, b, c, x);
      points.add(FlSpot(x, y));
    }
    
    return points;
  }

  List<FlSpot> _generateShadedAreaPoints(double a, double b, double c, double target, String probType) {
    List<FlSpot> points = [];
    
    if (probType == 'less than') {
      // Shade left side (from a to target)
      points.add(FlSpot(a, 0));
      
      for (double x = a; x <= target; x += (target - a) / 20) {
        double y = _calculatePDF(a, b, c, x);
        points.add(FlSpot(x, y));
      }
      
      points.add(FlSpot(target, 0));
    } else {
      // Shade right side (from target to c)
      points.add(FlSpot(target, 0));
      
      for (double x = target; x <= c; x += (c - target) / 20) {
        double y = _calculatePDF(a, b, c, x);
        points.add(FlSpot(x, y));
      }
      
      points.add(FlSpot(c, 0));
    }
    
    return points;
  }

  double _calculatePDF(double a, double b, double c, double x) {
    if (x < a || x > c) return 0.0;
    if (x <= b) {
      return 2 * (x - a) / ((b - a) * (c - a));
    } else {
      return 2 * (c - x) / ((c - b) * (c - a));
    }
  }

  double _calculateMaxY(double a, double b, double c) {
    return 2 / (c - a); // Maximum height at mode
  }

  Color _getColorForValue(double value) {
    if (value == a) return Colors.blue;
    if (value == b) return Colors.green;
    if (value == c) return Colors.orange;
    if (value == target) return Colors.red;
    return Colors.black;
  }

  Widget _buildLegend(String text, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.rectangle,
          ),
        ),
        SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}