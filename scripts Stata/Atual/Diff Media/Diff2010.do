*****************************************************************************************************************************************************
*************************************************************** ABRIR O ARQUIVO *********************************************************************

clear
use "C:\Users\Regis\Documents\GitHub\teseLegibildiadeCPC\scripts Stata\Atual\Diff Media\2010.dta"
ladder LegNEMedio //traz as diversas alternativas para transformação da variável --> pega a de menor qui2
gladder LegNEMedio //demonstra em gráficos qual seria a melhor maneira de corrigir a normalidade dos dados --> manter a variável
** a tecnica para tratar os outliers deixou o modelo pior por isso não sera utilizada

gen sLegNEMedio= LegNEMedio^2
histogram sLegNEMedio, norm 

****** Teste de Normalidade ***** 
sfrancia sLegNEMedio 
sktest sLegNEMedio 

** Visto que dos dados possuem um distribuição normal podemos rodar os testes paramêtricos de diferença de média
*ranksum LegNEMedio, by(GC)

****** Resultados ***** 
*Não há diferença de média significante entre os grupos

ttest LegNEMedio, by(GC)

ttest LegNEMedio, by(Reg_Nreg) 
*** Pr(|T| > |t|) = 0.3265  

ttest LegNEMedio, by(ADR) 
*** Pr(|T| > |t|) = 0.3311 

