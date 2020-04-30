*****************************************************************************************************************************************************
*************************************************************** ABRIR O ARQUIVO *********************************************************************

clear
use "C:\Users\Regis\Documents\GitHub\teseLegibildiadeCPC\scripts Stata\Atual\Diff Media\2010.dta"


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

*oneway LegNEMedio CAPIT
*oneway LegNEMedio EXT


******** Oneway Variaveis Transformadas ********
** o Resultado não muda ** 

gen sCOMPLEX = COMPLEX^2
winsor sCOMPLEX, gen(wsCOMPLEX) p(0.05) 

gen sqCAPIT = sqrt(CAPIT) 
winsor sqCAPIT, gen(wsqCAPIT) p(0.05)

gen sqEXT = sqrt(EXT) 
winsor sqEXT, gen(WsqEXT) p(0.05) 



****** TESTE t ***** 
*Não há diferença de média significante entre os grupos

ttest LegNEMedio, by(CAPIT2)

ttest LegNEMedio, by(EXT2)







