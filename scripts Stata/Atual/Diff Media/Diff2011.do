*****************************************************************************************************************************************************
*************************************************************** ABRIR O ARQUIVO *********************************************************************

clear
use "C:\Users\Regis\Documents\GitHub\teseLegibildiadeCPC\scripts Stata\Atual\Diff Media\2011.dta"
ladder LegNEMedio //traz as diversas alternativas para transforma��o da vari�vel --> pega a de menor qui2
gladder LegNEMedio //demonstra em gr�ficos qual seria a melhor maneira de corrigir a normalidade dos dados --> manter a vari�vel
** a tecnica para tratar os outliers deixou o modelo pior por isso n�o sera utilizada

gen sLegNEMedio= LegNEMedio^2
histogram sLegNEMedio, norm 

****** Teste de Normalidade ***** 
sfrancia sLegNEMedio 
sktest sLegNEMedio 

** Visto que dos dados possuem um distribui��o normal podemos rodar os testes param�tricos de diferen�a de m�dia
*ranksum LegNEMedio, by(GC)

ttest LegNEMedio, by(GC)

ttest LegNEMedio, by(Reg_Nreg) 
***  Pr(|T| > |t|) = 0.3456   

ttest LegNEMedio, by(ADR) 
*** Pr(|T| > |t|) = 0.8069



****** TESTE ANOVA ***** 
*N�o h� diferen�a de m�dia significante entre os grupos

graph box LegNEMedio, over(COMPLEX)

oneway LegNEMedio COMPLEX

oneway LegNEMedio CAPIT

oneway LegNEMedio EXT



****** TESTE t ***** 
*N�o h� diferen�a de m�dia significante entre os grupos

ttest LegNEMedio, by(CAPIT2)

ttest LegNEMedio, by(EXT2)

