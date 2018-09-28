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

# optionally if the intermediate files are large, we need to write them to a different directory to avoid running out of home directory quota
# based on https://scicomp.ethz.ch/wiki/Comsol_files_in_the_home_directory
# export TMPDIR /scratch/general/lustre/$USER/$SLURM_JOBID
# comsol batch -tmpdir $TMPDIR -configuration $TMPDIR/configuration/comsol_@process.id -data $TMPDIR/data/comsol_@process.id -prefsdir $TMPDIR/preferences/comsol_@process.id -inputfile infile.mph -outputfile outfile.mph


