#include <stdio.h>
#include <stdint.h>

extern void forward();  // funkcja z forward.s

// Funkcja do pomiaru czasu (cykli CPU)
static inline uint64_t rdtsc() {
    uint32_t lo, hi;
    __asm__ volatile (
        "cpuid\n\t"         // serialize
        "rdtsc\n\t"
        "mov %%edx, %0\n\t"
        "mov %%eax, %1\n\t"
        : "=r" (hi), "=r" (lo)
        :
        : "%rax", "%rbx", "%rcx", "%rdx"
    );
    return ((uint64_t)hi << 32) | lo;
}

int main() {
    printf("Uruchamiam forward()\n");

    uint64_t start = rdtsc();
    forward();
    uint64_t end = rdtsc();

    uint64_t czas = end - start;

    printf("Wykonano forward(), czas: %llu cykli\n", czas);

    FILE *plik = fopen("wyniki.txt", "w");
    if (!plik) {
        perror("Nie można otworzyć pliku");
        return 1;
    }

    fprintf(plik, "%llu \n", czas);
    fclose(plik);

    return 0;
}

