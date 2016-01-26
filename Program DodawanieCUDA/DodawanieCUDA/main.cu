#include <iostream>
#include <cuda.h>

using namespace std;

// Wprowadzenie funkcji dodawaj¹cej dwie zmienne i zapisuj¹ce je jako wskaŸnik
// "__global__" wykonywanie funkcji na hoœcie i przekazywanie do karty graficznej w celu wykonania
__global__ void AddIntsCUDA(int* a, int *b)
{
	a[0] += b[0];
}

int main()
{
	//Podanie zmiennych oraz wskaŸników które bêd¹ u¿ywane jako zmienne na GPU
	int a = 7, b = 9;
	int *d_a, *d_b;

	// Allokacja pamiêci w GPU
	cudaMalloc(&d_a, sizeof(int));
	cudaMalloc(&d_b, sizeof(int));

	// Kopiowanie z CPU do GPU
	cudaMemcpy(d_a, &a, sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(d_b, &b, sizeof(int), cudaMemcpyHostToDevice);

	// Wywo³anie funkcji dodawania ze zmiennymi bêd¹cymi w GPU
	// "<<<1, 1>>>" odpowiada za iloœæ w siatce (gridzie) a druga odpowiada za iloœæ w¹tków w gridzie.
	// "<<<grid, thread>>>" wywo³anie kernela
	AddIntsCUDA<<<1, 1>>>(d_a, d_b);

	// Kopiowaniez GPU do CPU
	cudaMemcpy(&a, d_a, sizeof(int), cudaMemcpyDeviceToHost);

	// Podanie wyniku
	cout << "Wynik dodawania wynosi " << a << endl;

	// Zwolnienie pamiêci
	cudaFree(d_a);
	cudaFree(d_b);

	// Zwrócenie wartoœci
	return 0;
}