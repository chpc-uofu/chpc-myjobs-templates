#!/bin/bash
#
#SBATCH --partition=granite-gpu
#SBATCH --qos=granite-gpu
#SBATCH --account=REPLACE-WITH-ACCOUNT-NAME

#SBATCH --job-name=gpu-test
#SBATCH --output=res.txt
#SBATCH --gres=gpu
#SBATCH --mem=10G
#SBATCH --ntasks=1
#SBATCH --time=10:00

cd $SLURM_SUBMIT_DIR
echo "Hello World" > output_file

echo "Created output file with 'Hello World'"


