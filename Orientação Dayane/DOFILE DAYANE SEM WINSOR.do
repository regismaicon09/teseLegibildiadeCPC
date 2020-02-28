*****************************************************************************************************************************************************
*************************************************************** ABRIR O ARQUIVO *********************************************************************
*****************************************************************************************************************************************************
clear
set more off
use "C:\Users\vafis\OneDrive - ufu.br\Área de Trabalho\Orientação Dayane\modelograduação.dta"
keep if roe !=. | end !=. | lc !=. | tang !=. | lnrl !=. | lnat !=. //manter somente os anos com valores em pelo menos uma variável (são excluidas as linhas que não apresenlnrl valores para as variáveis)
encode nome, generate (idempresa) label (nome) //cria a variável que será utilizada como o indivíduo do painel, transformando-a de string para categórica.
xtset idempresa ano //configura o painel mostrando para o Stata o que é para se considerar como indivíduo e o que é para se considerar como tempo. Tanto a variável de indivíduo como a de tempo não podem ser do tipo texto (string)
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
********roe********
histogram roe, norm 
kdensity roe, norm 
*1)Tratando a normalidade da variável roe
ladder roe //traz as diversas alternativas para transformação da variável --> pega a de menor qui2
gladder roe //demonstra em gráficos qual seria a melhor maneira de corrigir a normalidade dos dados --> manter a variável

********end********
histogram end, norm 
kdensity end, norm 
*1)Tratando a normalidade da variável end
ladder wend //traz as diversas alternativas para transformação da variável --> pega a de menor qui2
gladder wend //demonstra em gráficos qual seria a melhor maneira de corrigir a normalidade dos dados --> manter a variável

********lc********
histogram lc, norm 
kdensity lc, norm 
*1)Tratando a normalidade da variável lc
ladder lc //traz as diversas alternativas para transformação da variável --> pega a de menor qui2
gladder lc //demonstra em gráficos qual seria a melhor maneira de corrigir a normalidade dos dados

********tang********
histogram tang, norm 
kdensity tang, norm 
*1)Tratando a normalidade da variável tang
ladder tang //traz as diversas alternativas para transformação da variável --> pega a de menor qui2
gladder tang //demonstra em gráficos qual seria a melhor maneira de corrigir a normalidade dos dados --> manter a variável

********lnrl********
histogram lnrl, norm 
kdensity lnrl, norm 
*1)Tratando a normalidade da variável lnrl
ladder lnrl //traz as diversas alternativas para transformação da variável 
gladder lnrl //demonstra em gráficos qual seria a melhor maneira de corrigir a normalidade dos dados 

********lnat********
histogram lnat, norm 
kdensity lnat, norm 

tabstat roe end lc tang lnrl lnat, s(count min max mean sd cv sk p1 p5 p10 p25 p50 p75 p90 p95 p99)
*Comentário: comando significativo para comparação de diversos resultados estatísticos. Percebe-se uma melhora em todas as variáveis para o coeficiente de assimetria (de Pearson).

summ roe end lc tang lnrl lnat
* Comentário teórico: tabelas com descrições estatísticas para países e setores

sfrancia roe end lc tang lnrl lnat
* Comentário teórico: teste para a detecção de normalidade Shapiro-wilk para grandes amostras
sktest roe end lc tang lnrl lnat, noadjust
* Comentário teórico: teste de assimetria e curtose
* Comentário teórico: Pelos valores dos dois testes pode-se verificar que os termos de erro não apresenlnrl distribuição normal ao nível de significância de 5%, podendo rejeitar a hipótese nula de que os dados possuem distribuição normal.

pwcorr roe end lc tang lnrl lnat, star(0.05) //verifica a correlação (força da associação entre as variáveis) e lnrlbém ajuda a verificar se há problemas de multicolinearidade (altas correlações)

qui reg roe end lc tang lnrl lnat
vif
*Comentário teórico: Cada variável não pode apresentar um valor de VIF individualmente maior que 10 e o VIF médio do modelo lnrlbém não pode ser maior que 10 (HAIR JR. ET AL, 2009). A variável que está causando o problema deve ser retirada do modelo de regressão.
*Comentário do resultado: Neste caso não há problemas de multicolinearidade entre as variáveis. Portanto nenhuma das variáveis deve retirada do modelo.

**********************************************************************************************************
**********************************************************************************************************
********************************* MODELOS DADOS EM PAINEL ************************************************
**********************************************************************************************************
**********************************************************************************************************

**********************************************************************************************************
********TESTES PARA ESCOLHA ENTRE MODELOS DE REGRESSÃO POOL, EFEITO FIXO OU EFEITO ALEATÓRIO *************
**********************************************************************************************************

********TESTE DE BREUSCH-PAGAN: POOL X EFEITO ALEATÓRIO; H0: POOL, H1: EFEITO ALEATÓRIO *******************
qui xtreg roe end lc tang lnrl lnat, re
xttest0
*Comentário: Rejeitou-se a menos de 1% a hipótese H0: Pooled. Portanto, o modelo estimado por efeitos aleatórios mostrou-se mais adequado que que o modelo pooled.

********TESTE DE CHOW: POOLED X EFEITO FIXO; H0: POOLED, H1: EFEITO FIXO ***********************************
xtreg roe end lc tang lnrl lnat, fe
*Comentário teórico: Olha-se o valor de Prob > F = 0.05 na regressão. Se 0 < Prob F < 0.05, rejeita-se H0, ou seja o modelo de Efeito Fixo é melhor. Caso contrário não rejeita-se H1, ou seja Pooled é melhor.
*Comentário do resultado: Neste caso o modelo de efeito fixo mostrou-se mais adequado que o modelo pooled. Após Teste de Breusch-Pagan e Chow, descarta-se o modelo pooled.

********TESTE DE HAUSMAN: POOLED X EFEITO FIXO X EFEITO ALEATÓRIO; H0: EFEITO ALEATÓRIO, H1: EFEITO FIXO ***********
qui xtreg roe end lc tang lnrl lnat, fe
estimates store fe
qui xtreg roe end lc tang lnrl lnat, re
estimates store re

hausman fe re, sigmamore
hausman fe re, sigmaless
*Comentário: com as opções acima descritas para o teste de hausman ocorre a correção para chi2<0 (hausman negativo). Assim, tem-se a escolha pelo Efeito ALEATÓRIO (H0: EFEITO ALEATÓRIO, H1: EFEITO FIXO)

**********TESTE PARA VERIFICAR SE EXISTE PROBLEMA DE AUTOCORRELAÇÃO: H0: não há autocorrelação; H1: há autocorrelação***********
***TESTE PARA VERIFICAR SE EXISTE PROBLEMA DE HETEROCEDASTICIDADE: H0: não há heterocedasticidade; H1: há heterocedasticidade***
findit xtserial //este comando irá instalar o teste de woodridge de autocorrelação. Em seguida clicar em "st0039" e depois "click here to install"
xtserial roe end lc tang lnrl lnat, output //roda o teste de woodridge de autocorrelação. 

findit xttest3
qui xtreg roe end lc tang lnrl lnat, fe
xttest3 //roda o teste de wald para detecção de heterocedasticidade.

*Comentários: As hipóteses H0 de ausência de autocorrelação e ausência de heterocedasticidade foram rejeitadas a um nível de significância de 5%. Portanto temos problema de autocorrelação e heterocedasticidade. Neste caso recomenda-se rodar o modelo utilizando o método robust ou bootstrap.

*************************************** MODELOS DE REGRESSÃO ************************************************

xtreg roe end lc tang lnrl lnat, fe vce(robust)
