#!/bin/bash
#SBATCH --time=01:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=6
#SBATCH --mem=40G
#SBATCH --account=owner-gpu-guest
#SBATCH --partition=notchpeak-gpu-guest
#SBATCH --gres=gpu:rtx6000:1
#SBATCH --mail-type=ALL
#SBATCH --mail-user= <---- Here comes your email
#SBATCH --job=name=Pytorch-Example

module load deeplearning
export WORKDIR=$HOME/TestBench/Torch
NVIDIA_CHECK=$(nvidia-smi -L)

# Job Info
printf "Job %s started on %s\n" "$SLURM_JOBID" "$(date)"
printf "  #Nodes:%s\n"          "$SLURM_NNODES"
printf "  #Tasks:%s\n"          "$SLURM_NTASKS"
printf "  Hostname:%s\n"        "$(hostname)"

# Check whether a GPU has been detected
if [[ -z "$NVIDIA_CHECK" ]]; then
   printf "  ERROR:No GPU has been detected!\n"
   printf "        Goodbye!\n"
   exit
else
   printf "\n  %d GPUs were detected!\n"   "$(echo $NVIDIA_CHECK | wc -l )"
   printf "%s\n"                           "$(nvidia-smi -L)"
   printf "  CUDA_VISIBLE_DEVICES:%s\n\n"  "$(echo $CUDA_VISIBLE_DEVICES)"
fi

# Perform the work (and monitor it) 
cd $WORKDIR
printf "  pwd:%s\n"     "$(pwd)"
printf "  python:%s\n"  "$(which python)"
/uufs/chpc.utah.edu/sys/installdir/chpcscripts/gpu/gpu-monitor.sh &
python mycode.py > $SLURM_JOBID.out 2>&1

printf "Job %s ended on %s\n" "$SLURM_JOBID" "$(date)"