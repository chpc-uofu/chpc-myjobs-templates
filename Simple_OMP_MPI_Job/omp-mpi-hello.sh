#!/bin/bash
#
#SBATCH --partition=kingspeak-guest
#SBATCH --account=owner-guest
#
#SBATCH --job-name=ompmpitest
#SBATCH --output=ompmpi.txt
#
#SBATCH --ntasks=4
#SBATCH --nodes=2
#SBATCH --cpus-per-task=2
#SBATCH --time=10:00

cd $SLURM_SUBMIT_DIR

module load intel-oneapi-compilers/2021.4.0 openmpi/4.1.6

mpicc -qopenmp -O2 omp_mpi_hello.c -o omp_mpi_hello

# find number of MPI tasks per node
TPN=`echo $SLURM_TASKS_PER_NODE | cut -f 1 -d \(`
# find number of CPU cores per node
PPN=`echo $SLURM_JOB_CPUS_PER_NODE | cut -f 1 -d \(`
THREADS=$((PPN/TPN))
export OMP_NUM_THREADS=$THREADS

# generally we get better performance if we pin MPI tasks to sockets and OMP threads to cores
# this example uses OpenMPI's MPI task pinning and Intel's OpenMP thread pinning
# for a more general approach, see https://www.chpc.utah.edu/documentation/software/mpilibraries.php#d
mpirun -bind-to socket -map-by socket -x OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK -x KMP_AFFINITY="granularity=fine,compact,1,0" -np $SLURM_NTASKS ./omp_mpi_hello >& myresults

rm omp_mpi_hello
