#include <iostream>
#include <fstream>

extern "C" int compute_distance(int* a, int* b, int n);

int main() {
    int x[1000], y[1000], n = 0;
    std::ifstream file("day1.txt");
    
    while (file >> x[n] >> y[n]) {
        n++;
    }


    std::cout << compute_distance(x, y, n) << std::endl;

    for (int i = 0; i < n; i++) {
        std::cout << "x[" << i << "] = " << x[i] << ", y[" << i << "] = " << y[i] << std::endl;
    }
}