#include <iostream>
#include <fstream>
#include <string>
#include <sstream>

extern "C" int compute_safe(int* reports, int num_reports);

int main() {
    int safe = 0;
    std::fstream file("input.txt");

    std::string line;
    while(getline(file, line)) {
        std::stringstream ss(line);
        int reports[100], num_reports = 0;
        while (ss >> reports[num_reports]) {
            num_reports++;
        }
        safe += compute_safe(reports, num_reports);
    }

    std::cout << safe << std::endl;
}