#include <iostream>
#include <fstream>

extern "C" int count_xmas(char* input, int rows, int cols);

int main() {
    std::fstream inputFile("input.txt");
    if (!inputFile) {
        std::cerr << "Unable to open file input.txt";
        return 1;
    }

    const int rows = 10;
    const int cols = 10;
    char input[rows*cols];

    for (int x = 0; x < rows; ++x) {
        for (int y = 0; y < cols; ++y) {
            inputFile >> input[x*cols + y];
        }
    }

    inputFile.close();

    std::cout << count_xmas(input, rows, cols) << std::endl;
}