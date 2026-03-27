#!/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --mem=0
#SBATCH --partition=notchpeak-gpu
#SBATCH --account=notchpeak-gpu
#SBATCH --gres=gpu:3090:8
#SBATCH --time=1:00:00

#make scratch directory for I/O processing, copy input files to scratch directory
SCRDIR=/scratch/general/vast/$USER/$SLURM_JOB_ID
mkdir -p $SCRDIR
cp input.txt $SCRDIR
cd $SCRDIR


mpirun -np $SLURM_NTASKS myprogram.exe input.txt