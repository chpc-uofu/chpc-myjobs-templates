#!/bin/bash
#
#SBATCH --partition=kingspeak-gpu
#SBATCH --account=kingspeak-gpu
#SBATCH --qos=kingspeak-gpu

#SBATCH --job-name=gpu-test
#SBATCH --output=gpu-out.txt
#SBATCH --gres=gpu
#SBATCH --mem=10G
#SBATCH --ntasks=1
#SBATCH --time=00:10:00

cd $SLURM_SUBMIT_DIR
echo "Hello World" > output_file

echo "Created output file with 'Hello World'"