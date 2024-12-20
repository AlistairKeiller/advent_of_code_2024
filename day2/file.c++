#include <iostream>
#include <fstream>
#include <string>
#include <sstream>

extern "C" int compute_safe(int* reports, int num_reports);

int main() {
    int reports[10000], num_reports = 0;
    std::fstream file("input.txt");

    std::string line;
    while(getline(file, line)) {
        std::stringstream ss(line);
        while (ss >> reports[num_reports]) {
            num_reports++;
        }
        reports[num_reports++] = -1;
    }

    std::cout << compute_safe(reports, num_reports) << std::endl;
}