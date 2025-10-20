class Logic {
  // Using YOUR notation: a ≤ b ≤ c
  // a = minimum, b = most likely (mode), c = maximum


  // formula to Calculate the Probability 
  double calculateProbability(double a, double b, double c, double x) {
    
     if (a <= x && x <= b) {
      // Case 1: when a ≤ x ≤ b 
      double numerator = 2 * (x - a);
      double denominator =  (b - a) * (c - a) ;
      return numerator / denominator;  // Direct CDF, not 1 - CDF
      
    } else if (b < x && x <= c) {
      // Case 2: when b ≤ x ≤ c 
      double numerator =  2* (c-x);
      double denominator =(c - b) * (c - a);
      return numerator / denominator;
      
    } else if (x < a) {
      return 0.0;
    } else {
      return 1.0; 
    }
  }
   
  double calculateArea ( String probType,double target , double a , double b , double c , ){
double base = target - a;
double height ;
    if(probType == 'less than'){
    height = calculateProbability(a, b, c, target);
    }
    else{
    height = 1 - calculateProbability(a, b, c, target);
 
    }
    
    double area = 0.5 * base * height;
    return area;
    
  }

  
}
