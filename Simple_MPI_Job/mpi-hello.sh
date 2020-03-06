#!/bin/bash
#
#SBATCH --partition=kingspeak-guest
#SBATCH --account=owner-guest
#
#SBATCH --job-name=mpitest
#SBATCH --output=mpi.txt
#
#SBATCH --ntasks=32
#SBATCH --nodes=2
#SBATCH --time=10:00

cd $SLURM_SUBMIT_DIR

module load gcc mpich

mpicc -O2 mpi-hello.c -o mpi-hello

mpirun -np $SLURM_NTASKS ./mpi-hello

