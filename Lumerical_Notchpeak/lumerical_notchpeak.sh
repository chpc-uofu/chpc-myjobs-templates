#!/bin/bash
#
#SBATCH --partition=notchpeak-shared-short
#SBATCH --account=notchpeak-shared-short

#SBATCH --job-name=lumerical
#SBATCH --output=lumerical-%j.out-%N
#SBATCH --error=lumerical-%j.err-%N
#
#SBATCH --ntasks=16
#SBATCH --nodes=2
#SBATCH --time=10:00

cd $SLURM_SUBMIT_DIR
module load lumerical/2022R1.2

cp /uufs/chpc.utah.edu/sys/installdir/lumerical/fdtd/8.16.1022/examples/nanowire.fsp .

mpirun -np $SLURM_NTASKS fdtd-engine-ompi-lcl nanowire.fsp



