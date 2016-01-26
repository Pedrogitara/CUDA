#include <iostream>
#include <cuda.h>

using namespace std;

// Wprowadzenie funkcji dodawaj�cej dwie zmienne i zapisuj�ce je jako wska�nik
// "__global__" wykonywanie funkcji na ho�cie i przekazywanie do karty graficznej w celu wykonania
__global__ void AddIntsCUDA(int* a, int *b)
{
	a[0] += b[0];
}

int main()
{
	//Podanie zmiennych oraz wska�nik�w kt�re b�d� u�ywane jako zmienne na GPU
	int a = 7, b = 9;
	int *d_a, *d_b;

	// Allokacja pami�ci w GPU
	cudaMalloc(&d_a, sizeof(int));
	cudaMalloc(&d_b, sizeof(int));

	// Kopiowanie z CPU do GPU
	cudaMemcpy(d_a, &a, sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(d_b, &b, sizeof(int), cudaMemcpyHostToDevice);

	// Wywo�anie funkcji dodawania ze zmiennymi b�d�cymi w GPU
	// "<<<1, 1>>>" odpowiada za ilo�� w siatce (gridzie) a druga odpowiada za ilo�� w�tk�w w gridzie.
	// "<<<grid, thread>>>" wywo�anie kernela
	AddIntsCUDA<<<1, 1>>>(d_a, d_b);

	// Kopiowaniez GPU do CPU
	cudaMemcpy(&a, d_a, sizeof(int), cudaMemcpyDeviceToHost);

	// Podanie wyniku
	cout << "Wynik dodawania wynosi " << a << endl;

	// Zwolnienie pami�ci
	cudaFree(d_a);
	cudaFree(d_b);

	// Zwr�cenie warto�ci
	return 0;
}