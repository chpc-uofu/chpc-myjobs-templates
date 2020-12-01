#!/bin/bash
#
# owner nodes on Ember are the least utilized so try them first
#SBATCH --partition=kingspeak-guest
#SBATCH --account=owner-guest
#
#SBATCH --job-name=omptest
#SBATCH --output=openmp.txt
#
#SBATCH --ntasks=16
#SBATCH --nodes=1
#SBATCH --time=10:00

cd $SLURM_SUBMIT_DIR

ml intel

# set the number of OpenMP threads equal to the CPU count on the node
export OMP_NUM_THREADS=$SLURM_NTASKS
icc -O2 -qopenmp omp-hello.c -o omp-hello
./omp-hello > my_results
