#!/bin/bash

#SBATCH --partition=notchpeak
#SBATCH --account=chpc
#SBATCH --nodes=1
#SBATCH -C "c64"
#SBATCH --mem=0
#SBATCH --ntasks=64
#SBATCH --time=12:00:00
#SBATCH --output=slurm-%j-%N.out
#SBATCH --error=slurm-%j-%N.err
#SBATCH --job-name=h20_sp_cc
##SBATCH --mail-type=ALL
##SBATCH --mail-user= <---- Here comes your email


module load openmpi/4.1.6-gpu
module load orca
export EXE=$(which orca)

export WORKDIR=$HOME/TestBench/Chem/orca/water_sp_cc
export INPUTFILE=water.inp
export OUTPUTFILE=water.out
export SCRATCHDIR=/scratch/general/vast/$USER/orca/$SLURM_JOBID
export SCR_TO_BE_RM=0
export ORCA_NPROCS=$SLURM_NTASKS

printf "Electronic structure calculation\n"
printf "  Started at  : %s\n"    "$(date +"%m/%d/%Y @ %H:%M:%S")"
printf "  Job. Id     : %s\n"    "$SLURM_JOBID"
printf "  Cluster     : %s\n"    "$SLURM_CLUSTER_NAME"
printf "  #Nodes      : %s\n"    "$SLURM_NNODES"
printf "  Nodes       : %s\n"    "$SLURM_JOB_NODELIST"
printf "  Executable  : %s\n"    "$EXE"
printf "  Working dir.: %s\n"    "$WORKDIR"
printf "  Input file  : %s\n"    "$INPUTFILE"
printf "  #ORCA procs : %s\n\n"  "$ORCA_NPROCS"


cd $WORKDIR
# Create the SCRATCH space
mkdir -p  $SCRATCHDIR

# Copy over files to 
cd $SCRATCHDIR 
cp -p $WORKDIR/$INPUTFILE . 


# Run the ORCA simulation
# Do not use mpirun (included in the executable)
$EXE $INPUTFILE >& $OUTPUTFILE


# Copy files over to WORKDIR
cd $WORKDIR
cp -pR $SCRATCHDIR/* .

# Remove the SCRATCHDIR
if [ "$SCR_TO_BE_RM" -eq 1 ]; then
   printf "  Scratch directory '%s' will be removed\n" "$SCRATCHDIR"
   rm -rf $SCRATCHDIR
fi  

printf "  Ended at    : %s\n"  "$(date +"%m/%d/%Y @ %H:%M:%S")"


