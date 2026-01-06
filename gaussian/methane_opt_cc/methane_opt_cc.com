%chk=methane_opt_cc.chk
%mem=64GB
#p CCSD(T,FC,T1Diag,Conver=10, MaxCyc=200)/aug-cc-pVTZ 
   Opt=Z-matrix
   Symmetry=(Follow)
   SCF=(Conver=12,MaxCycle=100)
   Integral=(Acc2E=18,BasisTransform=18)

Methane CCSD(T)/aug-cc-pVTZ opt. & freq. calc. using CCSD(T)

0 1
C   
H 1 r_CH
H 1 r_CH 2 theta_HCH
H 1 r_CH 2 theta_HCH  3 120.0
H 1 r_CH 2 theta_HCH  4 120.0

r_CH = 1.090
theta_HCH = 109.4712

--Link1--
%chk=ch4_ccsdt.chk
%mem=64GB
#p CCSD(T,FC,T1Diag,Conver=10, MaxCyc=200)/aug-cc-pVTZ
   Freq
   Geom=AllCheck Guess=Read
   SCF=(Conver=12,MaxCycle=100)
   Integral=(Acc2E=18,BasisTransform=18)

CH4 frozen-core CCSD(T)/aug-cc-pVTZ freq at OPT geometry

