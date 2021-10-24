
#include <stdio.h>
using namespace std;
int main() {
  int sum3 = (3 + 999) * 999 / 3 / 2;
  int sum5 = (5 + 995) * 995 / 5 / 2;
  int sum15 = (15 + 990) * 990 / 15 / 2;
  int sum = sum3 + sum5 - sum15;
  printf("%d", sum);

  return 0;
}
