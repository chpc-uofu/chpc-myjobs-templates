#!/bin/bash
#SBATCH --time=1:00:00 # walltime, abbreviated by -t
#SBATCH --nodes=2      # number of cluster nodes, abbreviated by -N
#SBATCH -o slurm-%j.out-%N # name of the stdout, using the job number (%j) and the first node (%N)
#SBATCH --ntasks=32    # number of MPI tasks, abbreviated by -n
# additional information for allocated clusters
#SBATCH --account=owner-guest     # account - abbreviated by -A
#SBATCH --partition=kingspeak-guest  # partition, abbreviated by -p

module load ansys/18.1

# specify work directory and input file names
export WORKDIR=`pwd`
# name of the input file
export INPUTNAME=Benchmark.def
# our input source is one of the CFX examples
export INPUTDIR=$ANSYS181_ROOT/CFX/examples

# cd to the work directory
cp $INPUTDIR/$INPUTNAME $WORKDIR
cd $WORKDIR

export SLURM_NODEFILE=nodes.$$
srun hostname -s | sort > $SLURM_NODEFILE
NODELIST=`cat $SLURM_NODEFILE`
NODELIST=`echo $NODELIST | sed -e 's/ /,/g'`
echo "Ansys nodelist="$NODELIST

cfx5solve -def $INPUTNAME -parallel -par-dist $NODELIST -start-method "IBM MPI Distributed Parallel"
