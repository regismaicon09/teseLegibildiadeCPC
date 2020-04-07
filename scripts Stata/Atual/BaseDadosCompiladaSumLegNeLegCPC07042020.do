*****************************************************************************************************************************************************
*************************************************************** ABRIR O ARQUIVO *********************************************************************

*************************************************************** V 07_04_2020 *********************************************************************

clear
set more off
use "C:\Users\Regis\Documents\GitHub\teseLegibildiadeCPC\scripts Stata\Atual\BaseDadosCompiladaSumLegNeLegCPC06042020.dta"

keep if LegNE !=. | ADR !=. | LegCPC !=. | RevCPC !=. | CAPIT !=. | COMPLEX !=. //manter somente os anos com valores em pelo menos uma vari�vel (s�o excluidas as linhas que n�o apresenlnrl valores para as vari�veis)
encode NOME, generate (idempresa) label (NOME) //cria a vari�vel que ser� utilizada como o indiv�duo do painel, transformando-a de string para categ�rica.
xtset idempresa Ano //configura o painel mostrando para o Stata o que � para se considerar como indiv�duo e o que � para se considerar como tempo. Tanto a vari�vel de indiv�duo como a de tempo n�o podem ser do tipo texto (string)
*****************************************************************************************************************************************************
*************************************************************** CRIA��O E DEFINI��O DAS VARI�VEIS *********************************************************************
*****************************************************************************************************************************************************

**********************************************************************************************************
*********************************** AN�LISES DESCRITIVAS *************************************************
**********************************************************************************************************
codebook //mostra o dicion�rio das vari�veis da base de dados que est� sendo utilizada. � preciso ir no browse e alimentar cada vari�vel.



  ************************
**TRAlnrlENTO DAS VARI�VEIS**
  ************************

****Visualizar normalidade das vari�veis escalares


********LegNEsumpeso********
*histogram LegNEMedio, norm 
*kdensity LegNEMedio, norm 
*1)Tratando a normalidade da vari�vel LegNE

ladder LegNEMedio //traz as diversas alternativas para transforma��o da vari�vel --> pega a de menor qui2
*gladder LegNEMedio //demonstra em gr�ficos qual seria a melhor maneira de corrigir a normalidade dos dados --> manter a vari�vel
** a tecnica para tratar os outliers deixou o modelo pior por isso n�o sera utilizada

********TAM********
*histogram TAM, norm 
*kdensity TAM, norm 
*1)Tratando a normalidade da vari�vel end
ladder TAM //traz as diversas alternativas para transforma��o da vari�vel --> pega a de menor qui2
gladder TAM //demonstra em gr�ficos qual seria a melhor maneira de corrigir a normalidade dos dados -->transformar log
gen lTAM = log(TAM)
*histogram lTAM, norm 

*2)winsoriza��o (t�cnica para tratar os outliers).
*graph box lTAM //muitos outliers *Coment�rio te�rico: O boxplot mostra os outliers.
winsor lTAM, gen(wlTAM) p(0.05) //n�o tem mais outlier (inicia-se o teste com p(0,05), aumentando de 0,05 em 0,05 at� n�o ter mais outliers).
*graph box wlTAM
*histogram wlTAM, norm 
*kdensity wlTAM, norm
** Nesse caso vejo que utilizar winsoriza��o n�o foi t�o interessante


********COMPLEX********
*histogram COMPLEX, norm 
*kdensity COMPLEX, norm 
*1)Tratando a normalidade da vari�vel end
ladder COMPLEX //traz as diversas alternativas para transforma��o da vari�vel --> pega a de menor qui2
gladder COMPLEX //demonstra em gr�ficos qual seria a melhor maneira de corrigir a normalidade dos dados -->transformar COMPLEX^2  
gen sCOMPLEX = COMPLEX^2
*histogram sCOMPLEX, norm 


*2)winsoriza��o (t�cnica para tratar os outliers).
*graph box sCOMPLEX //muitos outliers *Coment�rio te�rico: O boxplot mostra os outliers.
winsor sCOMPLEX, gen(wsCOMPLEX) p(0.05) //n�o tem mais outlier (inicia-se o teste com p(0,05), aumentando de 0,05 em 0,05 at� n�o ter mais outliers).
*graph box wsCOMPLEX
*histogram wsCOMPLEX, norm 
*kdensity wsCOMPLEX, norm

**COMPLEX
** Chegou a conclus�o que � melhor utilizar sem fazer ajustes no modelo final


********CAPIT********
*histogram CAPIT, norm 
*kdensity CAPIT, norm 
*1)Tratando a normalidade da vari�vel end
ladder CAPIT //traz as diversas alternativas para transforma��o da vari�vel --> pega a de menor qui2
*gladder CAPIT //demonstra em gr�ficos qual seria a melhor maneira de corrigir a normalidade dos dados -->transformar  sqrt(CAPIT)  
gen sqCAPIT = sqrt(CAPIT) 
*histogram sqCAPIT, norm 

*2)winsoriza��o (t�cnica para tratar os outliers).
*graph box sqCAPIT //muitos outliers *Coment�rio te�rico: O boxplot mostra os outliers.
winsor sqCAPIT, gen(wsqCAPIT) p(0.05) //n�o tem mais outlier (inicia-se o teste com p(0,05), aumentando de 0,05 em 0,05 at� n�o ter mais outliers).
*graph box wsqCAPIT
*histogram wsqCAPIT, norm 
*kdensity wsqCAPIT, norm


********EXT********
*histogram EXT, norm 
*kdensity EXT, norm 

*1)Tratando a normalidade da vari�vel end
ladder EXT //traz as diversas alternativas para transforma��o da vari�vel --> pega a de menor qui2
gladder EXT //demonstra em gr�ficos qual seria a melhor maneira de corrigir a normalidade dos dados -->transformar  sqrt(sqrt(EXT))  
gen sqEXT = sqrt(EXT) 
*histogram sqEXT, norm 

*2)winsoriza��o (t�cnica para tratar os outliers).
*graph box sqEXT //muitos outliers *Coment�rio te�rico: O boxplot mostra os outliers.
winsor sqEXT, gen(WsqEXT) p(0.05) //n�o tem mais outlier (inicia-se o teste com p(0,05), aumentando de 0,05 em 0,05 at� n�o ter mais outliers).
graph box WsqEXT
*histogram WsqEXT, norm 
*kdensity WsqEXT, norm

sum LegNEMedio LegCPCMedio RevCPC lTAM COMPLEX CAPIT GC AUDIT EXT ADR 

sum LegNEMedio LegCPCMedio wlTAM COMPLEX CAPIT WsqEXT
* Coment�rio te�rico: tabelas com descri��es estat�sticas 

****** Teste de Normalidade ***** 
** sem transformacao

sfrancia  LegNEMedio LegCPCMedio TAM COMPLEX CAPIT EXT
sfrancia  LegNEMedio LegCPCMedio wlTAM COMPLEX CAPIT WsqEXT
 
* Coment�rio te�rico: teste para a detec��o de normalidade Shapiro-wilk para grandes amostras
* Foi retirado as vari�veis bin�rias 
swilk LegNEMedio LegCPCMedio TAM COMPLEX CAPIT EXT
swilk LegNEMedio LegCPCMedio wlTAM COMPLEX CAPIT WsqEXT 

* Coment�rio te�rico: teste para a detec��o de normalidade Shapiro-wilk
* Foi retirado as vari�veis bin�rias 

** referencia interessante para o teste de curtose e assimetria que � menos sens�veis que os demais testes

*** https://www.researchgate.net/publication/314032599_TO_DETERMINE_SKEWNESS_MEAN_AND_DEVIATION_WITH_A_NEW_APPROACH_ON_CONTINUOUS_DATA


sktest LegNEMedio LegCPCMedio wlTAM COMPLEX CAPIT WsqEXT, noadjust
* Coment�rio te�rico: teste de assimetria e curtose
* Coment�rio te�rico: Pelos valores dos dois testes pode-se verificar que os termos de erro n�o apresenlnrl distribui��o normal ao n�vel de signific�ncia de 5%, podendo rejeitar a hip�tese nula de que os dados possuem distribui��o normal.

pwcorr  LegNEMedio LegCPCMedio RevCPC wlTAM COMPLEX CAPIT GC AUDIT EXT ADR, star(0.05) //verifica a correla��o (for�a da associa��o entre as vari�veis) e  ajuda a verificar se h� problemas de multicolinearidade (altas correla��es)

qui reg LegNEMedio LegCPCMedio RevCPC wlTAM COMPLEX CAPIT GC AUDIT EXT ADR
vif
*Coment�rio te�rico: Cada vari�vel n�o pode apresentar um valor de VIF individualmente maior que 10 e o VIF m�dio do modelo lnrlb�m n�o pode ser maior que 10 (HAIR JR. ET AL, 2009). A vari�vel que est� causando o problema deve ser retirada do modelo de regress�o.
*Coment�rio do resultado: Neste caso n�o h� problemas de multicolinearidade entre as vari�veis. Portanto nenhuma das vari�veis deve retirada do modelo.

**********TESTE PARA VERIFICAR SE EXISTE PROBLEMA DE AUTOCORRELA��O: H0: n�o h� autocorrela��o; H1: h� autocorrela��o***********
***TESTE PARA VERIFICAR SE EXISTE PROBLEMA DE HETEROCEDASTICIDADE: H0: n�o h� heterocedasticidade; H1: h� heterocedasticidade***
findit xtserial //este comando ir� instalar o teste de woodridge de autocorrela��o. Em seguida clicar em "st0039" e depois "click here to install"
xtserial LegNEMedio cLegCPCMedio RevCPC wlTAM COMPLEX CAPIT GC AUDIT EXT ADR, output //roda o teste de woodridge de autocorrela��o. 

findit xttest3
qui xtreg LegNEMedio cLegCPCMedio RevCPC wlTAM COMPLEX CAPIT GC AUDIT EXT ADR,fe
xttest3 //roda o teste de wald para detec��o de heterocedasticidade.
*Coment�rios: As hip�teses H0 de aus�ncia de autocorrela��o e aus�ncia de heterocedasticidade
* foram rejeitadas a um n�vel de signific�ncia de 5%. Portanto temos problema de autocorrela��o e heterocedasticidade. 
*Neste caso recomenda-se rodar o modelo utilizando o m�todo robust ou bootstrap.



**********************************************************************************************************
**********************************************************************************************************
********************************* MODELOS DADOS EM PAINEL ************************************************
**********************************************************************************************************
**********************************************************************************************************

**********************************************************************************************************
********TESTES PARA ESCOLHA ENTRE MODELOS DE REGRESS�O POOL, EFEITO FIXO OU EFEITO ALEAT�RIO *************
**********************************************************************************************************

********TESTE DE BREUSCH-PAGAN: POOL X EFEITO ALEAT�RIO; H0: POOL, H1: EFEITO ALEAT�RIO *******************
qui xtreg LegNEMedio cLegCPCMedio RevCPC wlTAM COMPLEX CAPIT GC AUDIT WsqEXT ADR, re
xttest0
*Coment�rio: Rejeitou-se a menos de 1% a hip�tese H0: Pooled. Portanto, o modelo estimado por efeitos aleat�rios mostrou-se mais adequado que que o modelo pooled.

********TESTE DE CHOW: POOLED X EFEITO FIXO; H0: POOLED, H1: EFEITO FIXO ***********************************
xtreg LegNEMedio cLegCPCMedio RevCPC wlTAM COMPLEX CAPIT GC AUDIT WsqEXT ADR, fe
*Coment�rio te�rico: Verifica-se o valor de Prob > F = 0.05 na regress�o. Se 0 < Prob F < 0.05, rejeita-se H0, ou seja o modelo de Efeito Fixo � melhor. 
*Caso contr�rio n�o rejeita-se H1, ou seja Pooled � melhor.
*Coment�rio do resultado: Neste caso o modelo de efeito fixo mostrou-se mais adequado que o modelo pooled. 
* Ap�s Teste de Breusch-Pagan e Chow, descarta-se o modelo pooled.

********TESTE DE HAUSMAN: POOLED X EFEITO FIXO X EFEITO ALEAT�RIO; H0: EFEITO ALEAT�RIO, H1: EFEITO FIXO ***********
qui xtreg LegNEMedio cLegCPCMedio RevCPC wlTAM COMPLEX CAPIT GC AUDIT WsqEXT ADR, fe 
estimates store fe

qui xtreg LegNEMedio cLegCPCMedio RevCPC wlTAM COMPLEX CAPIT GC AUDIT WsqEXT ADR, re 
estimates store re

hausman fe re, sigmamore
hausman fe re, sigmaless
*Coment�rio: com as op��es acima descritas para o teste de hausman ocorre a corre��o para chi2<0 (hausman negativo). 
*Assim, tem-se a escolha pelo Efeito ALEAT�RIO (H0: EFEITO ALEAT�RIO, H1: EFEITO FIXO)

*************************************** MODELOS DE REGRESS�O ************************************************
xtreg LegNEMedio cLegCPCMedio RevCPC wlTAM COMPLEX CAPIT GC AUDIT WsqEXT ADR Reg_Nreg, fe vce(robust)
** modelo n�o apresente p value significante
** capit e adr escolher uma ou outra pois estas est�o correlacionados teoricamente e desse modo
** teremos problemas de multicolineariedade


************************************************************************************************

** Melhor composi��o de modelo para a analise
xtreg LegNEMedio LegCPCMedio CAPIT RevCPC COMPLEX Reg_Nreg ADR wlTAM , re vce(robust)

************************************************************************************************
