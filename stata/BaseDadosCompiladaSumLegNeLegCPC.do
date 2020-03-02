*****************************************************************************************************************************************************
*************************************************************** ABRIR O ARQUIVO *********************************************************************

clear
set more off
*use "C:\Users\FAGEN\Documents\GitHub\teseLegibildiadeCPC\stata\BaseDadosV1.dta"
use "C:\Users\Regis\Documents\GitHub\teseLegibildiadeCPC\stata\BaseDadosCompiladaSumLegNeLegCPC.dta"

keep if LegNE !=. | ADR !=. | LegCPC !=. | RevCPC !=. | CAPIT !=. | COMPLEX !=. //manter somente os anos com valores em pelo menos uma variável (são excluidas as linhas que não apresenlnrl valores para as variáveis)
encode NOME, generate (idempresa) label (NOME) //cria a variável que será utilizada como o indivíduo do painel, transformando-a de string para categórica.
xtset idempresa Ano //configura o painel mostrando para o Stata o que é para se considerar como indivíduo e o que é para se considerar como tempo. Tanto a variável de indivíduo como a de tempo não podem ser do tipo texto (string)
*****************************************************************************************************************************************************
*************************************************************** CRIAÇÃO E DEFINIÇÃO DAS VARIÁVEIS *********************************************************************
*****************************************************************************************************************************************************

**********************************************************************************************************
*********************************** ANÁLISES DESCRITIVAS *************************************************
**********************************************************************************************************
codebook //mostra o dicionário das variáveis da base de dados que está sendo utilizada. É preciso ir no browse e alimentar cada variável.
  ************************
**TRAlnrlENTO DAS VARIÁVEIS**
  ************************

****Visualizar normalidade das variáveis escalares
********LegNE********
histogram LegNEsumpeso, norm 
kdensity LegNEsumpeso, norm 
*1)Tratando a normalidade da variável LegNE
ladder LegNEsumpeso //traz as diversas alternativas para transformação da variável --> pega a de menor qui2
gladder LegNEsumpeso //demonstra em gráficos qual seria a melhor maneira de corrigir a normalidade dos dados --> manter a variável

*2)winsorização (técnica para tratar os outliers).
graph box LegNEsumpeso //muitos outliers *Comentário teórico: O boxplot mostra os outliers. Sem correção
winsor LegNEsumpeso, gen(wLegNEsumpeso) p(0.05) //não tem mais outlier (inicia-se o teste com p(0,05), aumentando de 0,05 em 0,05 até não ter mais outliers).
graph box wLegNEsumpeso
histogram wLegNEsumpeso, norm 
kdensity wLegNEsumpeso, norm
** a tecnica para tratar os outliers deixou o modelo pior por isso não sera utilizada

*search winsorize, all

********LegCPCSUMpeso********
// não faria sentido o cálculo de normalidade pois é valor fixo


histogram LegCPCSUMpeso, norm 
kdensity LegCPCSUMpeso, norm 
*1)Tratando a normalidade da variável LegNE
ladder LegCPCSUMpeso //traz as diversas alternativas para transformação da variável --> pega a de menor qui2
gladder LegCPCSUMpeso //demonstra em gráficos qual seria a melhor maneira de corrigir a normalidade dos dados --> manter a variável

gen srLegCPCSUMpeso = sqrt(LegCPCSUMpeso)
histogram srLegCPCSUMpeso, norm 
kdensity srLegCPCSUMpeso, norm 

*2)winsorização (técnica para tratar os outliers).
graph box srLegCPCSUMpeso //muitos outliers *Comentário teórico: O boxplot mostra os outliers.
winsor srLegCPCSUMpeso, gen(wsrLegCPCSUMpeso) p(0.05) //não tem mais outlier (inicia-se o teste com p(0,05), aumentando de 0,05 em 0,05 até não ter mais outliers).
graph box wsrLegCPCSUMpeso
histogram wsrLegCPCSUMpeso, norm 
kdensity wsrLegCPCSUMpeso, norm
** a tecnica de winsorização não apresentou melhoras significativa

********RevCPC********
// variável binária não faz sentido ( podemos chamar de variaveis de controle )

********TAM********
histogram TAM, norm 
kdensity TAM, norm 
*1)Tratando a normalidade da variável end
ladder TAM //traz as diversas alternativas para transformação da variável --> pega a de menor qui2
gladder TAM //demonstra em gráficos qual seria a melhor maneira de corrigir a normalidade dos dados -->transformar log
gen lTAM = log(TAM)
histogram lTAM, norm 

*2)winsorização (técnica para tratar os outliers).
graph box lTAM //muitos outliers *Comentário teórico: O boxplot mostra os outliers.
winsor lTAM, gen(wlTAM) p(0.05) //não tem mais outlier (inicia-se o teste com p(0,05), aumentando de 0,05 em 0,05 até não ter mais outliers).
graph box wlTAM
histogram wlTAM, norm 
kdensity wlTAM, norm

********COMPLEX********
histogram COMPLEX, norm 
kdensity COMPLEX, norm 
*1)Tratando a normalidade da variável end
ladder COMPLEX //traz as diversas alternativas para transformação da variável --> pega a de menor qui2
gladder COMPLEX //demonstra em gráficos qual seria a melhor maneira de corrigir a normalidade dos dados -->transformar COMPLEX^2  
gen sCOMPLEX = COMPLEX^2
histogram sCOMPLEX, norm 




********CAPIT********
histogram CAPIT, norm 
kdensity CAPIT, norm 
*1)Tratando a normalidade da variável end
ladder CAPIT //traz as diversas alternativas para transformação da variável --> pega a de menor qui2
gladder CAPIT //demonstra em gráficos qual seria a melhor maneira de corrigir a normalidade dos dados -->transformar  sqrt(CAPIT)  
gen sqCAPIT = sqrt(CAPIT) 
histogram sqCAPIT, norm 

*2)winsorização (técnica para tratar os outliers).
graph box sqCAPIT //muitos outliers *Comentário teórico: O boxplot mostra os outliers.
winsor sqCAPIT, gen(wsqCAPIT) p(0.05) //não tem mais outlier (inicia-se o teste com p(0,05), aumentando de 0,05 em 0,05 até não ter mais outliers).
graph box wsqCAPIT
histogram wsqCAPIT, norm 
kdensity wsqCAPIT, norm

********EXT********
histogram EXT, norm 
kdensity EXT, norm 
*1)Tratando a normalidade da variável end
ladder EXT //traz as diversas alternativas para transformação da variável --> pega a de menor qui2
gladder EXT //demonstra em gráficos qual seria a melhor maneira de corrigir a normalidade dos dados -->transformar  sqrt(sqrt(EXT))  
gen sqEXT = sqrt(EXT) 
histogram sqEXT, norm 

*2)winsorização (técnica para tratar os outliers).
graph box sqEXT //muitos outliers *Comentário teórico: O boxplot mostra os outliers.
winsor sqEXT, gen(WsqEXT) p(0.05) //não tem mais outlier (inicia-se o teste com p(0,05), aumentando de 0,05 em 0,05 até não ter mais outliers).
graph box WsqEXT
histogram WsqEXT, norm 
kdensity WsqEXT, norm


tabstat LegNEsumpeso LegCPCSUMpeso srLegCPCSUMpeso RevCPC TAM wlTAM COMPLEX sCOMPLEX CAPIT wsqCAPIT GC AUDIT EXT ADR, s(count min max mean sd cv sk p1 p5 p10 p25 p50 p75 p90 p95 p99)
*Comentário: comando significativo para comparação de diversos resultados estatísticos. Percebe-se uma melhora em todas as variáveis para o coeficiente de assimetria (de Pearson).

summ LegNEsumpeso LegCPCSUMpeso srLegCPCSUMpeso RevCPC TAM wlTAM COMPLEX sCOMPLEX CAPIT wsqCAPIT GC AUDIT EXT ADR
* Comentário teórico: tabelas com descrições estatísticas para países e setores

****** Teste de Normalidade ***** 
** sem transformacao
*sfrancia  LegNEsumpeso LegCPCSUMpeso lTAM COMPLEX CAPIT EXT 

sfrancia  LegNEsumpeso srLegCPCSUMpeso wlTAM sCOMPLEX wsqCAPIT WsqEXT
 
* Comentário teórico: teste para a detecção de normalidade Shapiro-wilk para grandes amostras
* Foi retirado as variáveis binárias 

*swilk LegNEsumpeso LegCPCSUMpeso lTAM COMPLEX CAPIT EXT

swilk  LegNEsumpeso srLegCPCSUMpeso wlTAM sCOMPLEX wsqCAPIT WsqEXT 
* Comentário teórico: teste para a detecção de normalidade Shapiro-wilk
* Foi retirado as variáveis binárias 


*** https://www.researchgate.net/publication/314032599_TO_DETERMINE_SKEWNESS_MEAN_AND_DEVIATION_WITH_A_NEW_APPROACH_ON_CONTINUOUS_DATA

sktest LegNEsumpeso srLegCPCSUMpeso wlTAM sCOMPLEX wsqCAPIT WsqEXT, noadjust
* Comentário teórico: teste de assimetria e curtose
* Comentário teórico: Pelos valores dos dois testes pode-se verificar que os termos de erro não apresenlnrl distribuição normal ao nível de significância de 5%, podendo rejeitar a hipótese nula de que os dados possuem distribuição normal.

pwcorr  LegNEsumpeso srLegCPCSUMpeso RevCPC wlTAM sCOMPLEX wsqCAPIT GC AUDIT WsqEXT ADR, star(0.05) //verifica a correlação (força da associação entre as variáveis) e  ajuda a verificar se há problemas de multicolinearidade (altas correlações)

qui reg LegNEsumpeso srLegCPCSUMpeso RevCPC wlTAM sCOMPLEX wsqCAPIT GC AUDIT WsqEXT ADR
vif
*Comentário teórico: Cada variável não pode apresentar um valor de VIF individualmente maior que 10 e o VIF médio do modelo lnrlbém não pode ser maior que 10 (HAIR JR. ET AL, 2009). A variável que está causando o problema deve ser retirada do modelo de regressão.
*Comentário do resultado: Neste caso não há problemas de multicolinearidade entre as variáveis. Portanto nenhuma das variáveis deve retirada do modelo.

**********TESTE PARA VERIFICAR SE EXISTE PROBLEMA DE AUTOCORRELAÇÃO: H0: não há autocorrelação; H1: há autocorrelação***********
***TESTE PARA VERIFICAR SE EXISTE PROBLEMA DE HETEROCEDASTICIDADE: H0: não há heterocedasticidade; H1: há heterocedasticidade***
*findit xtserial //este comando irá instalar o teste de woodridge de autocorrelação. Em seguida clicar em "st0039" e depois "click here to install"
xtserial LegNEsumpeso srLegCPCSUMpeso RevCPC wlTAM sCOMPLEX wsqCAPIT GC AUDIT WsqEXT ADR, output //roda o teste de woodridge de autocorrelação. 

findit xttest3
qui xtreg LegNEsumpeso srLegCPCSUMpeso RevCPC wlTAM sCOMPLEX wsqCAPIT GC AUDIT WsqEXT ADR,fe
xttest3 //roda o teste de wald para detecção de heterocedasticidade.
*Comentários: As hipóteses H0 de ausência de autocorrelação e ausência de heterocedasticidade foram rejeitadas a um nível de significância de 5%. Portanto temos problema de autocorrelação e heterocedasticidade. Neste caso recomenda-se rodar o modelo utilizando o método robust ou bootstrap.

**********************************************************************************************************
**********************************************************************************************************
********************************* MODELOS DADOS EM PAINEL ************************************************
**********************************************************************************************************
**********************************************************************************************************

**********************************************************************************************************
********TESTES PARA ESCOLHA ENTRE MODELOS DE REGRESSÃO POOL, EFEITO FIXO OU EFEITO ALEATÓRIO *************
**********************************************************************************************************

********TESTE DE BREUSCH-PAGAN: POOL X EFEITO ALEATÓRIO; H0: POOL, H1: EFEITO ALEATÓRIO *******************
qui xtreg LegNEsumpeso srLegCPCSUMpeso RevCPC wlTAM sCOMPLEX wsqCAPIT GC AUDIT WsqEXT ADR, re
xttest0
*Comentário: Rejeitou-se a menos de 1% a hipótese H0: Pooled. Portanto, o modelo estimado por efeitos aleatórios mostrou-se mais adequado que que o modelo pooled.

********TESTE DE CHOW: POOLED X EFEITO FIXO; H0: POOLED, H1: EFEITO FIXO ***********************************
xtreg LegNEsumpeso srLegCPCSUMpeso RevCPC wlTAM sCOMPLEX wsqCAPIT GC AUDIT WsqEXT ADR, fe
*Comentário teórico: Olha-se o valor de Prob > F = 0.05 na regressão. Se 0 < Prob F < 0.05, rejeita-se H0, ou seja o modelo de Efeito Fixo é melhor. Caso contrário não rejeita-se H1, ou seja Pooled é melhor.
*Comentário do resultado: Neste caso o modelo de efeito fixo mostrou-se mais adequado que o modelo pooled. 
* Após Teste de Breusch-Pagan e Chow, descarta-se o modelo pooled.

********TESTE DE HAUSMAN: POOLED X EFEITO FIXO X EFEITO ALEATÓRIO; H0: EFEITO ALEATÓRIO, H1: EFEITO FIXO ***********
qui xtreg LegNEsumpeso srLegCPCSUMpeso RevCPC wlTAM sCOMPLEX wsqCAPIT GC AUDIT WsqEXT ADR, fe
estimates store fe
qui xtreg LegNEsumpeso srLegCPCSUMpeso RevCPC wlTAM sCOMPLEX wsqCAPIT GC AUDIT WsqEXT ADR, re
estimates store re

hausman fe re, sigmamore
hausman fe re, sigmaless
*Comentário: com as opções acima descritas para o teste de hausman ocorre a correção para chi2<0 (hausman negativo). 
*Assim, tem-se a escolha pelo Efeito ALEATÓRIO (H0: EFEITO ALEATÓRIO, H1: EFEITO FIXO)

*************************************** MODELOS DE REGRESSÃO ************************************************
xtreg LegNEsumpeso srLegCPCSUMpeso RevCPC wlTAM sCOMPLEX wsqCAPIT GC AUDIT WsqEXT ADR, fe vce(robust)

xtreg LegNEsumpeso srLegCPCSUMpeso RevCPC wlTAM sCOMPLEX wsqCAPIT GC AUDIT WsqEXT ADR, re vce(robust)


