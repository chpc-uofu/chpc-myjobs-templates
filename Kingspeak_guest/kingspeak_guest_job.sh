#!/bin/bash
#
#SBATCH --partition=kingspeak-guest
#SBATCH --account=owner-guest

#SBATCH --job-name=test
#SBATCH --output=res.txt
#
#SBATCH --ntasks=1
#SBATCH --time=10:00
# optionally constrain to nodes known to be used little by the owners
# to reduce the risk of preemption (leave only one # at #SBATCH to activate)
##SBATCH --constraint=soc

cd $SLURM_SUBMIT_DIR
echo "Hello World" > output_file

echo "Created output file with 'Hello World'"


