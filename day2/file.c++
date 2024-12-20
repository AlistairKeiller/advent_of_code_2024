#include <iostream>
#include <fstream>
#include <string>
#include <sstream>

extern "C" int compute_safe(int* reports, int num_reports);

bool is_safe(int* levels, int size) {
    if (size <= 1) return false;

    bool increasing = true, decreasing = true;
    for (int i = 1; i < size; i++) {
        int diff = abs(levels[i] - levels[i - 1]);
        if (diff < 1 || diff > 3) return false;
        if (levels[i] > levels[i - 1]) decreasing = false;
        if (levels[i] < levels[i - 1]) increasing = false;
    }
    return increasing || decreasing;
}

int compute_safe_c(int* reports, int num_reports) {
    int safe_count = 0;
    int current_report[100];
    int current_size = 0;

    for (int i = 0; i < num_reports; i++) {
        if (reports[i] == -1) {
            if (is_safe(current_report, current_size)) {
                safe_count++;
            }
            current_size = 0;
        } else {
            current_report[current_size++] = reports[i];
        }
    }

    return safe_count;
}


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
    std::cout << compute_safe_c(reports, num_reports) << std::endl;
}