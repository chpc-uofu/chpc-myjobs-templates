#include <omp.h>
#include <stdio.h>
#include <stdlib.h>

#include "mpi.h"

int main (int argc, char *argv[]) {
    int th_id, nthreads;
    int rank, nprocs;

    MPI_Init(&argc, &argv);

    MPI_Comm_size(MPI_COMM_WORLD, &nprocs);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    MPI_Barrier(MPI_COMM_WORLD);
    printf("This is rank %d of %d reporting for duty\n",
            rank, nprocs);
    MPI_Barrier(MPI_COMM_WORLD);
#pragma omp parallel private(th_id)
    {
        th_id = omp_get_thread_num();
        printf("Hello World from thread %d on rank %d\n", 
                th_id, rank);
#pragma omp barrier
        if ( th_id == 0 ) {
            nthreads = omp_get_num_threads();
            printf("There are %d threads on rank %d\n",
                    nthreads, rank);
        }
    }

    MPI_Finalize();
    return EXIT_SUCCESS;
}
