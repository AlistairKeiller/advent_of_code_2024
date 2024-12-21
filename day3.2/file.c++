#include <iostream>
#include <fstream>
#include <sstream>

extern "C" int count_mul(const char* input);

int main() {
    std::ifstream inputFile("input.txt");
    if (!inputFile) {
        std::cerr << "Unable to open file input.txt";
        return 1;
    }

    std::stringstream buffer;
    buffer << inputFile.rdbuf();
    std::string content = buffer.str();

    const char* charArray = content.c_str();
    std::cout << count_mul(charArray) << std::endl;

    inputFile.close();
}