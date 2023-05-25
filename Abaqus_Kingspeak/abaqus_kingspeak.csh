#!/bin/tcsh 
#SBATCH --time=0:10:00 # walltime, abbreviated by -t
#SBATCH --nodes=2      # number of cluster nodes, abbreviated by -N
#SBATCH -o slurm-%j.out-%N # name of the stdout, using the job number (%j) and the first node (%N)
#SBATCH --ntasks=32    # number of MPI tasks, abbreviated by -n
# additional information for allocated clusters
#SBATCH --account=owner-guest     # account - abbreviated by -A
#SBATCH --partition=kingspeak-guest  # partition, abbreviated by -p

# define the input file name (in this case it will be t5-std.inp). Change this to your own input file name
setenv JOBNAME t5-std
# fetch an example job, comment this line out if you use your own input file
abaqus fetch job=$JOBNAME

# --- no need to change anything below this ---
# create a scratch directory to run this job in
setenv SCRDIR /scratch/general/lustre/$USER/abaqus/$SLURM_JOBID
echo Running in $SCRDIR
mkdir -p $SCRDIR

# copy the input file to the scratch directory and change to it
cp $JOBNAME.inp $SCRDIR
cd $SCRDIR

# load the abaqus module
module load abaqus/2022

# unset a SLURM environment variable that breaks the parallel run
unsetenv SLURM_GTIDS
# abaqus/2022 needs a specific MPI setting
# for details: https://community.intel.com/t5/Intel-oneAPI-HPC-Toolkit/bug-mpiexec-segmentation-fault/m-p/1183364
setenv I_MPI_HYDRA_TOPOLIB ipl

# for multi-node job, we have to prepare a mp_host_list entry to the Abaqus environment file
/uufs/chpc.utah.edu/sys/installdir/abaqus/setup_ab_slurm.csh
# run Abaqus using an input file
abaqus job=$JOBNAME input=$JOBNAME cpus=$SLURM_NTASKS mp_mode=mpi interactive

# run Abaqus using Python script
# abaqus cae noGUI=myscript.py
# notice that compute resources are not possible to define on the command line, 
# instead, they are defined in the Python script as arguments to mdb.Job(). 
# Make sure they match what's defined in this SLURM job script, e.g. as
# mdb.Job(numCpus=os.getenv('SLURM_NTASKS'),multiprocessingMode='MPI')
