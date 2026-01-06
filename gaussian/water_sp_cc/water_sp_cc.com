%chk=water_sp_cc.chk
%mem=90GB
#P CCSD(T,FC,T1Diag,Conver=10, MaxCyc=200)/aug-cc-pVQZ
   Freq
   SCF=(Conver=12,MaxCycle=200)
   Integral=(Acc2E=18,BasisTransform=18)

Water molecule H2O CCSD(T)/aug-cc-pVQZ SP & Freq.

0 1
O  0.000000   0.000000   0.000000
H  0.000000   0.757000   0.587000
H  0.000000  -0.757000   0.587000

