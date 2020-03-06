#!/bin/bash
#SBATCH --job-name=starccm+_test
#SBATCH --time=1:00:00
#SBATCH --ntasks=32
#SBATCH --nodes=2
#SBATCH --partition=kingspeak

#### SET NAME OF SIMULATION FILE
SIM_FILE="/uufs/chpc.utah.edu/sys/installdir/star-ccm+/12.04.010/STAR-CCM+12.04.010/doc/startutorialsdata/electromagnetism/data/FEmagneticFlux_start.sim"

echo
echo $SIM_FILE
echo

pwd
echo


#### LOAD PROPER VERSION OF STAR-CCM+
module load starccm+/12.04.010
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
#### USING POWER LICENSE
starccm+ -env gnu4.8 -power -np $SLURM_NTASKS -machinefile node.file.$SLURM_JOBID -time -rsh ssh -fabric IBV -batch-report -batch $SIM_FILE &


#### RUNNING STAR-CCM+ WITH JAVA MACRO, AND STORING OUTPUT INTO A SEPARATE FILE CALLED TOOL_STAR_OUTPUT.MSG
#### USING POWER LICENSE
#### starccm+ -env gnu4.8 -power -np $SLURM_NTASKS -machinefile node.file.$SLURM_JOBID -time -rsh ssh -fabric IBV -batch-report -batch StarDriver.java $SIM_FILE > Tool_star_output.msg &


wait

echo ENDING
echo
