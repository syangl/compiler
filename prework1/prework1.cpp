#include <iostream>
// #include<chrono>
#define A 0
#define B 1
#define WHILE while (i < n)
using namespace std;
int main()
{
    int a, b, i, t, n;
    a = A;
    b = B;
    i = 1;
    char dead; //dead code
    cin >> n;
    cout << a << endl;
    cout << b << endl;
	// auto t_start_time1 = std::chrono::high_resolution_clock::now();
    WHILE
    {
        t = b;
        b = a + b;
        cout << b << endl;
        a = t;
        i = i + 1;
    }
//     auto t_end_time1 = std::chrono::high_resolution_clock::now();
//   double t_time1 =
//       std::chrono::duration_cast<std::chrono::milliseconds>(t_end_time1 - t_start_time1).count();
//   std::cout << " time: " << t_time1 <<" ms"<< std::endl;
}