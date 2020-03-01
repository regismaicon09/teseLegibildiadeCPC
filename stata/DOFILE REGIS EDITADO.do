*****************************************************************************************************************************************************
*************************************************************** ABRIR O ARQUIVO *********************************************************************

clear
set more off
*use "C:\Users\FAGEN\Documents\GitHub\teseLegibildiadeCPC\stata\BaseDadosV1.dta"
use "C:\Users\Regis\Documents\GitHub\teseLegibildiadeCPC\stata\BaseDadosV1.dta"

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
********LegNE********
histogram LegNE, norm 
kdensity LegNE, norm 
*1)Tratando a normalidade da vari�vel LegNE
ladder LegNE //traz as diversas alternativas para transforma��o da vari�vel --> pega a de menor qui2
gladder LegNE //demonstra em gr�ficos qual seria a melhor maneira de corrigir a normalidade dos dados --> manter a vari�vel

*2)winsoriza��o (t�cnica para tratar os outliers).
graph box LegNE //muitos outliers *Coment�rio te�rico: O boxplot mostra os outliers. Sem corre��o
winsor LegNE, gen(wLegNE) p(0.05) //n�o tem mais outlier (inicia-se o teste com p(0,05), aumentando de 0,05 em 0,05 at� n�o ter mais outliers).
graph box wLegNE
histogram wLegNE, norm 
kdensity wLegNE, norm

*search winsorize, all

********LegCPC********
// n�o faria sentido o c�lculo de normalidade pois � valor fixo


********RevCPC********
// vari�vel bin�ria n�o faz sentido ( podemos chamar de variaveis de controle )


********TAM********
histogram TAM, norm 
kdensity TAM, norm 
*1)Tratando a normalidade da vari�vel end
ladder TAM //traz as diversas alternativas para transforma��o da vari�vel --> pega a de menor qui2
gladder TAM //demonstra em gr�ficos qual seria a melhor maneira de corrigir a normalidade dos dados -->transformar log
gen lTAM = log(TAM)
histogram lTAM, norm 

*2)winsoriza��o (t�cnica para tratar os outliers).
graph box lTAM //muitos outliers *Coment�rio te�rico: O boxplot mostra os outliers.
winsor lTAM, gen(wlTAM) p(0.05) //n�o tem mais outlier (inicia-se o teste com p(0,05), aumentando de 0,05 em 0,05 at� n�o ter mais outliers).
graph box wlTAM
histogram wlTAM, norm 
kdensity wlTAM, norm

********COMPLEX********
histogram COMPLEX, norm 
kdensity COMPLEX, norm 
*1)Tratando a normalidade da vari�vel end
ladder COMPLEX //traz as diversas alternativas para transforma��o da vari�vel --> pega a de menor qui2
gladder COMPLEX //demonstra em gr�ficos qual seria a melhor maneira de corrigir a normalidade dos dados -->transformar COMPLEX^2  
gen sCOMPLEX = COMPLEX^2
histogram sCOMPLEX, norm 

*2)winsoriza��o (t�cnica para tratar os outliers).
graph box sCOMPLEX //muitos outliers *Coment�rio te�rico: O boxplot mostra os outliers.
winsor sCOMPLEX, gen(wsCOMPLEX) p(0.05) //n�o tem mais outlier (inicia-se o teste com p(0,05), aumentando de 0,05 em 0,05 at� n�o ter mais outliers).
graph box wsCOMPLEX
histogram wsCOMPLEX, norm 
kdensity wsCOMPLEX, norm


********CAPIT********
histogram CAPIT, norm 
kdensity CAPIT, norm 
*1)Tratando a normalidade da vari�vel end
ladder CAPIT //traz as diversas alternativas para transforma��o da vari�vel --> pega a de menor qui2
gladder CAPIT //demonstra em gr�ficos qual seria a melhor maneira de corrigir a normalidade dos dados -->transformar  sqrt(CAPIT)  
gen sqCAPIT = sqrt(CAPIT) 
histogram sqCAPIT, norm 

*2)winsoriza��o (t�cnica para tratar os outliers).
graph box sqCAPIT //muitos outliers *Coment�rio te�rico: O boxplot mostra os outliers.
winsor sqCAPIT, gen(wsqCAPIT) p(0.05) //n�o tem mais outlier (inicia-se o teste com p(0,05), aumentando de 0,05 em 0,05 at� n�o ter mais outliers).
graph box wsqCAPIT
histogram wsqCAPIT, norm 
kdensity wsqCAPIT, norm

********EXT********
histogram EXT, norm 
kdensity EXT, norm 
*1)Tratando a normalidade da vari�vel end
ladder EXT //traz as diversas alternativas para transforma��o da vari�vel --> pega a de menor qui2
gladder EXT //demonstra em gr�ficos qual seria a melhor maneira de corrigir a normalidade dos dados -->transformar  sqrt(sqrt(EXT))  
gen sqEXT = sqrt(EXT) 
histogram sqEXT, norm 

*2)winsoriza��o (t�cnica para tratar os outliers).
graph box sqEXT //muitos outliers *Coment�rio te�rico: O boxplot mostra os outliers.
winsor sqEXT, gen(WsqEXT) p(0.05) //n�o tem mais outlier (inicia-se o teste com p(0,05), aumentando de 0,05 em 0,05 at� n�o ter mais outliers).
graph box WsqEXT
histogram WsqEXT, norm 
kdensity WsqEXT, norm



tabstat LegNE wLegNE LegCPC RevCPC TAM wlTAM COMPLEX sCOMPLEX CAPIT wsqCAPIT GC AUDIT EXT ADR, s(count min max mean sd cv sk p1 p5 p10 p25 p50 p75 p90 p95 p99)
*Coment�rio: comando significativo para compara��o de diversos resultados estat�sticos. Percebe-se uma melhora em todas as vari�veis para o coeficiente de assimetria (de Pearson).

summ wLegNE wLegNE LegCPC RevCPC TAM wlTAM COMPLEX sCOMPLEX CAPIT wsqCAPIT GC AUDIT EXT ADR
* Coment�rio te�rico: tabelas com descri��es estat�sticas para pa�ses e setores

sfrancia  wLegNE wlTAM sCOMPLEX wsqCAPIT WsqEXT 
* Coment�rio te�rico: teste para a detec��o de normalidade Shapiro-wilk para grandes amostras
* Foi retirado as vari�veis bin�rias 

swilk  wLegNE wlTAM sCOMPLEX wsqCAPIT WsqEXT 
* Coment�rio te�rico: teste para a detec��o de normalidade Shapiro-wilk
* Foi retirado as vari�veis bin�rias 


*** https://www.researchgate.net/publication/314032599_TO_DETERMINE_SKEWNESS_MEAN_AND_DEVIATION_WITH_A_NEW_APPROACH_ON_CONTINUOUS_DATA

sktest wLegNE wlTAM sCOMPLEX wsqCAPIT WsqEXT, noadjust
* Coment�rio te�rico: teste de assimetria e curtose
* Coment�rio te�rico: Pelos valores dos dois testes pode-se verificar que os termos de erro n�o apresenlnrl distribui��o normal ao n�vel de signific�ncia de 5%, podendo rejeitar a hip�tese nula de que os dados possuem distribui��o normal.

pwcorr  wLegNE  RevCPC TAM COMPLEX CAPIT GC AUDIT EXT ADR, star(0.05) //verifica a correla��o (for�a da associa��o entre as vari�veis) e  ajuda a verificar se h� problemas de multicolinearidade (altas correla��es)

qui reg wLegNE  RevCPC TAM COMPLEX CAPIT GC AUDIT EXT ADR
vif
*Coment�rio te�rico: Cada vari�vel n�o pode apresentar um valor de VIF individualmente maior que 10 e o VIF m�dio do modelo lnrlb�m n�o pode ser maior que 10 (HAIR JR. ET AL, 2009). A vari�vel que est� causando o problema deve ser retirada do modelo de regress�o.
*Coment�rio do resultado: Neste caso n�o h� problemas de multicolinearidade entre as vari�veis. Portanto nenhuma das vari�veis deve retirada do modelo.

*** Autocorrela��o *** 
quietly regress variables
estat bgodfrey variables


*** Teste de Arch - Heterocedasticidade *** 

**********************************************************************************************************
**********************************************************************************************************
********************************* MODELOS DADOS EM PAINEL ************************************************
**********************************************************************************************************
**********************************************************************************************************

**********************************************************************************************************
********TESTES PARA ESCOLHA ENTRE MODELOS DE REGRESS�O POOL, EFEITO FIXO OU EFEITO ALEAT�RIO *************
**********************************************************************************************************

********TESTE DE BREUSCH-PAGAN: POOL X EFEITO ALEAT�RIO; H0: POOL, H1: EFEITO ALEAT�RIO *******************
qui xtreg wLegNE  RevCPC TAM COMPLEX CAPIT GC AUDIT EXT ADR, re
xttest0
*Coment�rio: Rejeitou-se a menos de 1% a hip�tese H0: Pooled. Portanto, o modelo estimado por efeitos aleat�rios mostrou-se mais adequado que que o modelo pooled.

********TESTE DE CHOW: POOLED X EFEITO FIXO; H0: POOLED, H1: EFEITO FIXO ***********************************
xtreg wroe wlend wlcinv wtang wlnrl wlnat, fe
*Coment�rio te�rico: Olha-se o valor de Prob > F = 0.05 na regress�o. Se 0 < Prob F < 0.05, rejeita-se H0, ou seja o modelo de Efeito Fixo � melhor. Caso contr�rio n�o rejeita-se H1, ou seja Pooled � melhor.
*Coment�rio do resultado: Neste caso o modelo de efeito fixo mostrou-se mais adequado que o modelo pooled. Ap�s Teste de Breusch-Pagan e Chow, descarta-se o modelo pooled.

********TESTE DE HAUSMAN: POOLED X EFEITO FIXO X EFEITO ALEAT�RIO; H0: EFEITO ALEAT�RIO, H1: EFEITO FIXO ***********
qui xtreg wroe wlend wlcinv wtang wlnrl wlnat, fe
estimates store fe
qui xtreg wroe wlend wlcinv wtang wlnrl wlnat, re
estimates store re

hausman fe re, sigmamore
hausman fe re, sigmaless
*Coment�rio: com as op��es acima descritas para o teste de hausman ocorre a corre��o para chi2<0 (hausman negativo). Assim, tem-se a escolha pelo Efeito ALEAT�RIO (H0: EFEITO ALEAT�RIO, H1: EFEITO FIXO)

**********TESTE PARA VERIFICAR SE EXISTE PROBLEMA DE AUTOCORRELA��O: H0: n�o h� autocorrela��o; H1: h� autocorrela��o***********
***TESTE PARA VERIFICAR SE EXISTE PROBLEMA DE HETEROCEDASTICIDADE: H0: n�o h� heterocedasticidade; H1: h� heterocedasticidade***
findit xtserial //este comando ir� instalar o teste de woodridge de autocorrela��o. Em seguida clicar em "st0039" e depois "click here to install"
xtserial wroe wlend wlcinv wtang wlnrl wlnat, output //roda o teste de woodridge de autocorrela��o. 

findit xttest3
qui xtreg wroe wlend wlcinv wtang wlnrl wlnat,fe
xttest3 //roda o teste de wald para detec��o de heterocedasticidade.

*Coment�rios: As hip�teses H0 de aus�ncia de autocorrela��o e aus�ncia de heterocedasticidade foram rejeitadas a um n�vel de signific�ncia de 5%. Portanto temos problema de autocorrela��o e heterocedasticidade. Neste caso recomenda-se rodar o modelo utilizando o m�todo robust ou bootstrap.

*************************************** MODELOS DE REGRESS�O ************************************************

xtreg wroe wlend wlcinv wtang wlnrl wlnat, fe vce(robust)
