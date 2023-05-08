#!/bin/bash
#SBATCH --job-name=starccm+_test
#SBATCH --time=1:00:00
#SBATCH --ntasks=16
#SBATCH --nodes=2
#SBATCH --partition=notchpeak-shared-short
#SBATCH --account=notchpeak-shared-short

#### SET NAME OF SIMULATION FILE
SIM_FILE="/uufs/chpc.utah.edu/sys/installdir/star-ccm+/12.04.010/STAR-CCM+12.04.010/doc/startutorialsdata/foundationTutorials/data/foundationTutorial_1.sim"

echo
echo $SIM_FILE
echo

pwd
echo

#### LOAD PROPER VERSION OF STAR-CCM+
module load starccm+/14.02.012
which starccm+
echo

#### WRITE NODE LIST FOR ARCHIVAL/DEBUGGING PURPOSES
echo "Running on $SLURM_NNODES nodes and $SLURM_NTASKS cores"
echo "Machines:"
echo `srun hostname | sort`
echo

#### CREATE NODE FILE WITH A LIST OF NODES FOR STAR-CCM+ TO RUN ON
srun hostname | sort > node.file.$SLURM_JOBID

#### RUNNING STAR-CCM+ WITHOUT A JAVA MACRO, AND OUTPUT STORED IN SLURM OUTPUT FILE
starccm+ -env gnu7.1 -np $SLURM_NTASKS -machinefile node.file.$SLURM_JOBID -time -rsh ssh -fabric IBV -batch-report -batch $SIM_FILE &

wait

echo ENDING
echo
