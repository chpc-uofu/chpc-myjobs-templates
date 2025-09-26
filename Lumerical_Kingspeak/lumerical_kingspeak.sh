#!/bin/bash
#
#SBATCH --partition=kingspeak

#SBATCH --job-name=lumerical
#SBATCH --output=lumerical-%j.out-%N
#SBATCH --error=lumerical-%j.err-%N
#
#SBATCH --ntasks=32
#SBATCH --nodes=2
#SBATCH --time=10:00

cd $SLURM_SUBMIT_DIR
module load lumerical/2025R2

cp /uufs/chpc.utah.edu/sys/installdir/lumerical/fdtd/8.16.1022/examples/nanowire.fsp .

mpirun -n $SLURM_NTASKS fdtd-engine-ompi-lcl nanowire.fsp



