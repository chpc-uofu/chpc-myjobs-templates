#!/bin/bash
#
#SBATCH --partition=kingspeak

#SBATCH --job-name=matlab
#SBATCH --output=matlab-%j.out-%N
#SBATCH --error=matlab-%j.err-%N
#
#SBATCH --nodes=1
#SBATCH --time=10:00

cd $SLURM_SUBMIT_DIR
module load matlab

matlab -nodisplay -nodesktop -r run_matlab
