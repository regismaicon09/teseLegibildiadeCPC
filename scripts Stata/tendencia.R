library(readxl)
library(tseries) 
require(randtests) # Teste de Cox-Stuart 


LegNE <- c(27.75,28.55,28.59,28.67,28.72,28.61,29.33,29.81)

View(LegNE)

# Teste de Cox-Stuart
cox.stuart.test(LegNE)

# Teste de Wald-Wolfowitz
runs.test(LegNE)

# Teste de Mann-Kendall
rank.test(LegNE)

#Para testar a tendência na série original, o teste de sinal de Cox-Stuart 
#foi realizado com sig. 5%  e apresentou p > 0,05, portanto pode-se
#afirmar que não tendência na série original



##ref
#https://www.monolitonimbus.com.br/tendencia-e-sazonalidade/
#http://www.portalaction.com.br/series-temporais/222-teste-de-cox-stuart
#https://cran.r-project.org/web/packages/randtests/randtests.pdf
#https://repositorio.ufu.br/bitstream/123456789/17827/1/EstudoS%C3%A9rieTemporal.pdf

