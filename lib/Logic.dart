class Logic {
  // Using YOUR notation: a ≤ b ≤ c
  // a = minimum, b = most likely (mode), c = maximum


  // formula to Calculate the Probability 
  double calculateProbability(double a, double b, double c, double x) {
    if(a >= b || b >= c){
      return 0.0;
    }
    else if (a <= x && x <= b) {
      // Case 1: when a ≤ x ≤ b 
      double numerator = (x - a) * (x - a);
      double denominator = (c - a) * (b - a);
      return numerator / denominator;  // Direct CDF, not 1 - CDF
      
    } else if (b <= x && x <= c) {
      // Case 2: when b ≤ x ≤ c 
      double numerator = (x - a) * (2 * b - a - x);
      double denominator = (c - a) * (c - b);
      return numerator / denominator;
      
    } else if (x < a) {
      return 0.0;
    } else {
      return 1.0; 
    }
  }
   
  double calculateArea (double target , double a , double b , double c){
    double base = target - a;
    double height = calculateProbability(a, b, c, target);

    double area = 0.5 * base * height;
    return area;
  }

  String getProbabilityResult(double target , double a , double b , double c) {
    double probability = calculateProbability(a, b, c, target);
    return "Probability that sales > \$$target: ${(probability * 100).toStringAsFixed(1)}%";
  }
}
