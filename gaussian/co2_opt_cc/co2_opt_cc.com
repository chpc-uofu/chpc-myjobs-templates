%chk=co2_opt_cc.chk
%mem=92GB
#p CCSD(T,FC,T1Diag,Conver=10, MaxCyc=200)/aug-cc-pVTZ 
   Opt=(Z-matrix,Tight)
   Symmetry=(Follow)
   SCF=(Conver=12,MaxCycle=200)
   Integral=(Acc2E=18,BasisTransform=18)

CO2: CCSD(T)/aug-cc-pVTZ linear opt. & freq. calc. using CCSD(T)

0 1
O
C 1 RCO
X 2 1.0 1 90.0
O 2 RCO 3 90.0 1 180.0

RCO=1.16

--Link1--
%chk=co2_ccsdt_opt.chk
%mem=92GB
#p CCSD(T,FC,T1Diag,Conver=10, MaxCyc=200)/aug-cc-pVTZ
   Freq 
   Geom=AllCheck Guess=Read 
   SCF=(Conver=12,MaxCycle=100)
   Integral=(Acc2E=18,BasisTransform=18)

CO2: CCSD(T) freq. at the optimized linear geometry

