#!/bin/bash
#
# owner nodes on Ember are the least utilized so try them first
#SBATCH --partition=ember-guest
#SBATCH --account=owner-guest
#
#SBATCH --job-name=mpitest
#SBATCH --output=mpi.txt
#
#SBATCH --ntasks=12
#SBATCH --nodes=1
#SBATCH --time=10:00

cd $SLURM_SUBMIT_DIR

ml intel

export OMP_NUM_THREADS=12
icc -O2 -qopenmp omp-hello.c -o omp-hello
./omp-hello > my_results
