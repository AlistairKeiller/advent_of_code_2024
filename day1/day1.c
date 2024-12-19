#include <stdio.h>
#include <stdlib.h>

int compare(const void *a, const void *b) {
    return (*(int*)a - *(int*)b);
}

int calculate_total_distance(int *left, int *right, int size) {
    // Sort both lists
    qsort(left, size, sizeof(int), compare);
    qsort(right, size, sizeof(int), compare);

    int total_distance = 0;
    for (int i = 0; i < size; i++) {
        total_distance += abs(left[i] - right[i]);
    }
    return total_distance;
}

int main() {
    FILE *file = fopen("input.txt", "r");
    if (file == NULL) {
        perror("Failed to open file");
        return 1;
    }

    int left[1000], right[1000];
    int left_size = 0, right_size = 0;

    while (fscanf(file, "%d %d", &left[left_size], &right[right_size]) == 2) {
        left_size++;
        right_size++;
    }

    fclose(file);

    if (left_size != right_size) {
        fprintf(stderr, "The lists are not of the same size\n");
        return 1;
    }

    int total_distance = calculate_total_distance(left, right, left_size);
    printf("Total distance: %d\n", total_distance);

    return 0;
}