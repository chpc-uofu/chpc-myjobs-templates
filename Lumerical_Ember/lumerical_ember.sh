#!/bin/bash
#
#SBATCH --partition=ember

#SBATCH --job-name=lumerical
#SBATCH --output=lumerical-%j.out-%N.
#SBATCH --error=lumerical-%j.err-%N.
#
#SBATCH --ntasks=24
#SBATCH --nodes=2
#SBATCH --time=10:00

cd $SLURM_SUBMIT_DIR
module load intel impi lumerical

cp /uufs/chpc.utah.edu/sys/installdir/lumerical/fdtd/8.16.1022/examples/nanowire.fsp .

mpirun -n $SLURM_NTASKS fdtd-engine-impi-lcl nanowire.fsp



