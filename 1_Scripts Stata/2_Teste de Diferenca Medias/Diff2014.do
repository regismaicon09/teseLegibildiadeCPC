*****************************************************************************************************************************************************
*************************************************************** ABRIR O ARQUIVO *********************************************************************

clear
use "C:\Users\Regis\Documents\GitHub\teseLegibildiadeCPC\scripts Stata\Atual\Diff Media\2014.dta"

****** TESTE t ***** 
ttest LegNEMedio, by(GC)

ttest LegNEMedio, by(Reg_Nreg) 

ttest LegNEMedio, by(ADR) 


ttest LegNEMedio, by(AUDIT) 


ttest LegNEMedio, by(TAM2) 


****** TESTE ANOVA ***** 
*Não há diferença de média significante entre os grupos

graph box LegNEMedio, over(COMPLEX)

oneway LegNEMedio COMPLEX

oneway LegNEMedio CAPIT

oneway LegNEMedio EXT



****** TESTE t ***** 
*Não há diferença de média significante entre os grupos

ttest LegNEMedio, by(CAPIT2)

ttest LegNEMedio, by(EXT2)
