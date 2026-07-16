
#include <stdio.h>

// Declare the external assembly functions
extern long long factorial(long long n);
extern long long strlength(const char *str);

int main() {
  // Test the factorial function
  long long fact_input = 5;
  long long fact_result = factorial(fact_input);
  printf("Factorial of %lld is: %lld\n", fact_input, fact_result);

  // Test the factorial edge cases
  printf("Factorial of 0 is: %lld\n", factorial(0));
  printf("Factorial of -5 is: %lld\n", factorial(-5));

  // Test the strlen function
  const char *my_string = "Hello from assembly";
  long long length = strlength(my_string);
  printf("The length of '%s' is: %lld\n", my_string, length);

  return 0;
}
