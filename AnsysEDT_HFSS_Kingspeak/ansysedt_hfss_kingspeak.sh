#!/bin/bash
#SBATCH --time=1:00:00 # walltime, abbreviated by -t
#SBATCH --nodes=2      # number of cluster nodes, abbreviated by -N
#SBATCH -o slurm-%j.out-%N # name of the stdout, using the job number (%j) and the first node (%N)
#SBATCH --ntasks=4    # number of MPI tasks, abbreviated by -n
# additional information for allocated clusters
#SBATCH --account=owner-guest     # account - abbreviated by -A
#SBATCH --partition=kingspeak-guest  # partition, abbreviated by -p

set echo
module load ansysedt/25.2

# specify work directory and input file names
export WORKDIR=`pwd`
export INPUTNAME="tune_coax_fed_patch.aedt"
export INPUTDIR="$ANSYSEDT_ROOT/AnsysEM/Examples/HFSS/Antennas"

# cd to the work directory
cp $INPUTDIR/$INPUTNAME $WORKDIR
cd $WORKDIR

# figure number of cores per task
# find number of tasks per node
TPN=`echo $SLURM_TASKS_PER_NODE | cut -f 1 -d \(`
# find number of CPU cores per node
PPN=`echo $SLURM_JOB_CPUS_PER_NODE | cut -f 1 -d \(`
#THREADS=$((PPN/TPN))
THREADS=$((PPN))


# figure out what nodes we run on
srun hostname | sort -u > nodefile

# create list of hosts:tasks:cores
export ABQHOSTS=""
a=1
for NODE in `cat nodefile`; do
  if (( $a == 1 )); then
    export ABQHOSTS="${ABQHOSTS}${NODE}:${TPN}:${THREADS}"
  else
    export ABQHOSTS="${ABQHOSTS},${NODE}:${TPN}:${THREADS}"
  fi
  let a=$a+1
done

echo $ABQHOSTS

# create batch options file
# this is necessary for correct license type
export OptFile="batch.cfg"
echo \$begin \'Config\' > ${OptFile}
echo \'HFSS/NumCoresPerDistributedTask\'=${THREADS} >> ${OptFile}
echo \'HFSS/HPCLicenseType\'=\'Pool\' >> ${OptFile}
echo \'HFSS/SolveAdaptiveOnly\'=0 >> ${OptFile}
echo \'HFSS/MPIVendor\'= \'Intel\' >> ${OptFile}
echo \$end \'Config\' >> ${OptFile}

ansysedt -ng -batchsolve -distributed -machinelist list="${ABQHOSTS}" -batchoptions $OptFile $INPUTNAME 

