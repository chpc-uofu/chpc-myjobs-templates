%Example M-file for Hello World

ncpus = str2num(getenv("SLURM_CPUS_ON_NODE"));
mypool = parpool('local',ncpus)

parfor idx=1:mypool.NumWorkers
  t = getCurrentTask(); 
  disp(['Hello World from worker ' num2str(t.ID)])
end
delete(mypool)
exit   
% end of example file
