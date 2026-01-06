#!/bin/csh
#SBATCH --partition=notchpeak
#SBATCH --account=chpc
#SBATCH --nodes=1
#SBATCH --time=24:00:00
#SBATCH --output=slurm-%j-%N.out
#SBATCH --error=slurm-%j-%N.err
#SBATCH --job-name=water_sp_cc
##SBATCH --mail-type=ALL
##SBATCH --mail-user=   # <--- Here comes the email address

#
# Insert proper account, partition,node count and walltime specifications above 
# Note that you do not set the ntasks at all
# 
#
# Other node specifications such as memory can also be added to above, as well
# as qos specifications.
# Add job name on PBS -N line above; this will become name for stderr and stdout,
# with extensions e#### and o#### respectively, where #### is the job number
#
# Put in proper WORKDIR, FILENAME in the first two lines below, respectively
#
# Set SCRFLAG to one of the following -- note LOCAL is usually the best choice
# unless you know your job needs more space than is available:
#       LOCAL for use of space local to nodes
#       VAST for /scratch/general/vast
#       NFS1 for /scratch/general/nfs1 
#
# Set  NODES in a manner consistent to the SBATCH -l line above
#
#
# Also make sure %nprocs and %mem are set properly in the com file!  # WRC <---
# Allow at least 64MB of the memory available per node for the OS
# I have not found any additional limitations of memory use
#
# -- env | grep SLURM 

setenv WORKDIR $HOME/TestBench/Chem/gaussian/water_sp_cc
setenv FILENAME water_sp_cc
setenv SCRFLAG VAST
setenv NODES 1


# --- Added by WRC ---
printf "Gaussian Job: %s\n"    "$SLURM_JOBID"
printf "  Started at: %s\n"    "`date`"
printf "  Scratch type: %s\n"  "$SCRFLAG"
printf "  Nodes: %s\n"         "$SLURM_NODELIST"
printf "  Work dir: %s\n"      "$WORKDIR"
#
# nothing should need changed below here to run unless you do not
# want to use the default version of Gaussian; in this case the
# g16root path will need to be changed
#
cd $WORKDIR
# Load appropriate version of Gaussian16 for the instruction set on the processor. 
# Choices are:
#    AVX2 (granite, notchpeak nodes, 24 and 28 core nodes on kingspeak)
#    AVX (16 and 20 core nodes on kingspeak, 20 core owner nodes on lonepeak)
#    E6L for none of the ones listed (legacy)
# Note that the newer processors have the older instructions sets such that the
# differen versions are backwards compatible -- therfore the E6L and the E64 will 
# run all all nodes, but the performance is impacted and the runs will be slower
# than if you used the ones listed

if ($UUFSCELL ==  "lonepeak.peaks") then
  if ($SLURM_CPUS_ON_NODE == 20 ) then
      module load gaussian16/AVX.C01
  else 
      module load gaussian16/SSE4.C01 
  endif
endif     
if ($UUFSCELL ==  "notchpeak.peaks") then
    module load gaussian16/AVX2.C01
   if ($SLURM_CPUS_ON_NODE == 64 ) then
       setenv PGI_FASTMATH_CPU sandybridge
   endif
endif
if ($UUFSCELL ==  "kingspeak.peaks") then
  if ($SLURM_CPUS_ON_NODE == 24 | $SLURM_CPUS_ON_NODE == 28 ) then
      module load gaussian16/AVX2.C01
  else 
      module load gaussian16/AVX.C01 
  endif
endif          
if ($UUFSCELL ==  "granite") then
    module load gaussian16/AVX2.C01
endif

env | grep gaussian
ml

setenv MP_NEWJOB yes
setenv LINDA_CLC network
setenv LINDA_FLC network


# CREATE SCRATCH DIRECTORY

if ("$SCRFLAG" == "LOCAL") then
  setenv GAUSS_SCRDIR  /scratch/local/$USER/$SLURM_JOB_ID/$UUFSCELL
  mkdir -p /scratch/local/$USER/$SLURM_JOB_ID/$UUFSCELL
  mkdir -p $WORKDIR/$SLURM_JOB_ID/$UUFSCELL
   cd $WORKDIR/$SLURM_JOB_ID/$UUFSCELL
   cp $WORKDIR/$FILENAME.{com,chk} .
endif

if ("$SCRFLAG" == "VAST") then
  setenv GAUSS_SCRDIR  /scratch/general/vast/$USER/$SLURM_JOB_ID/$UUFSCELL
  mkdir -p /scratch/general/vast/$USER/$SLURM_JOB_ID/$UUFSCELL
   cd /scratch/general/vast/$USER/$SLURM_JOB_ID/$UUFSCELL
   cp $WORKDIR/$FILENAME.{com,chk} .
endif

if ("$SCRFLAG" == "GENERAL") then
  setenv GAUSS_SCRDIR  /scratch/general/lustre/$USER/$SLURM_JOB_ID/$UUFSCELL
  mkdir -p /scratch/general/lustre/$USER/$SLURM_JOB_ID/$UUFSCELL
   cd /scratch/general/lustre/$USER/$SLURM_JOB_ID/$UUFSCELL
   cp $WORKDIR/$FILENAME.{com,chk} .
endif

if ("$SCRFLAG" == "NFS1") then
  setenv GAUSS_SCRDIR  /scratch/general/nfs1/$USER/$SLURM_JOB_ID/$UUFSCELL
  mkdir -p /scratch/general/nfs1/$USER/$SLURM_JOB_ID/$UUFSCELL
   cd /scratch/general/nfs1/$USER/$SLURM_JOB_ID/$UUFSCELL
   cp $WORKDIR/$FILENAME.{com,chk} .
endif

printenv




# RUN GAUSSIAN AS SUCH
if ("$NODES" == "1") then
#    srun g16 $FILENAME.com
    g16 $FILENAME.com
#removed srun for case where ntasks-per-node set (found when user submitting from another 
#job where this was set.  Either need to remove srun OR add --ntasks-per-cpu=1 to srun
else
    srun hostname -s | sort -u > tsnet.nodes.$SLURM_JOBID
    cat tsnet.nodes.$SLURM_JOBID | uniq > nodes.tmp
    setenv GAUSS_LFLAGS '-nodefile tsnet.nodes.$SLURM_JOBID -opt "Tsnet.Node.lindarsharg: ssh"'
#    cat $SLURM_NODELIST | uniq > nodes.tmp
    source /uufs/chpc.utah.edu/sys/installdir/gaussian16/etc/parascript.csh > Default.Route
    g16 $FILENAME.com
endif




# CLEAN UP scratch space

if ("$SCRFLAG" == "NFS1") then
    cp *.log $WORKDIR/.
    cp *.chk $WORKDIR/.
    cp Test.FChk $WORKDIR/$FILENAME.FChk
    cd ..
    rm -r /scratch/general/nfs1/$USER/$SLURM_JOB_ID/$UUFSCELL
endif
if ("$SCRFLAG" == "VAST") then
    cp *.log $WORKDIR/.
    cp *.chk $WORKDIR/.
    cp Test.FChk $WORKDIR/$FILENAME.FChk
    cd ..
    rm -r /scratch/general/vast/$USER/$SLURM_JOB_ID/$UUFSCELL
endif
if ("$SCRFLAG" == "GENERAL") then
    cp *.log $WORKDIR/.
    cp *.chk $WORKDIR/.
    cp Test.FChk $WORKDIR/$FILENAME.FChk
    cd ..
    rm -r /scratch/general/lustre/$USER/$SLURM_JOB_ID/$UUFSCELL
endif
if ("$SCRFLAG" == "LOCAL") then
    cp *.log $WORKDIR/.
    cp *.chk $WORKDIR/.
    #  cp Test.FChk $WORKDIR/$FILENAME.FChk
    cd ..
    rm -r $WORKDIR/$SLURM_JOB_ID/$UUFSCELL
endif

#----- End of g16job ---------

printf "\n\nGaussian Job: %s\n"    "$SLURM_JOBID"
printf "  Ended at: %s\n"    "`date`"
