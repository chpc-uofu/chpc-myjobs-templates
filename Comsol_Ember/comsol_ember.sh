#!/bin/bash
#
#SBATCH --partition=ember

#SBATCH --job-name=comsol
#SBATCH --output=comsol-%j.out-%N
#SBATCH --error=comsol-%j.err-%N
#
#SBATCH --ntasks=12
#SBATCH --nodes=1
#SBATCH --time=10:00

cd $SLURM_SUBMIT_DIR
module load comsol

comsol batch -inputfile /uufs/chpc.utah.edu/sys/pkg/comsol/4.4/models/COMSOL_Multiphysics/Equation-Based_Models/black_scholes_put.mph -outputfile my_test.mph



