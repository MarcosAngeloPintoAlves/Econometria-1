use "G:\Trabalho Econometria 1\Trabalho Econometria 1.dta" 
set more off

*renomeando a variável sexo
replace v0302=1 if v0302==4
replace v0302=0 if v0302==2
rename v0302 sexo

*renomeando e gerando a variável idade ao quadrado
rename v8005 idade
gen idadeq=idade^2

*renomeação das variáveis 
rename v4719 renda
rename v0404 etnia 
rename v9032 setor
rename v9058 horas
rename v9054 estab
rename v9042 carteira
rename v4803 anose
rename v6007 nveduc
rename v4727 rm
rename v0402 cnaf
 
*limpeza dos dados indesejados contidos na base de dados 
drop if(idade<10)
drop if(renda==9) 
drop if(renda==999999999999) 
drop if(setor==.)
drop if(renda==.)
drop if(estab==8)
drop if(estab==.)
drop if(horas==.)
drop if(carteira==.)
drop if(nveduc==.)
drop if(anose==.)
drop if(anose==17)
drop if(etnia==9)

*manter apenas as observações referentes aos estados do Nordeste
keep if (uf==21 | uf==22 | uf==23 | uf==24 | uf==25 | uf==26 | uf==27 | uf==28 | uf==29)

gen logrenda=log(renda)

*substituição dos valores dos atributos das binárias

*condição na família
replace cnaf=1 if cnaf==1
replace cnaf=0 if(cnaf!=1) 

*região metropolitana ou não
replace rm=1 if rm==1
replace rm=0 if(rm==2 | rm==3)

*etnia:separado em brancos e não brancos
replace etnia=1 if (etnia==2)  
replace etnia=0 if (etnia==0 | etnia==4 | etnia==8 | etnia==6)

*setor:separado em público e privado
replace setor=1 if setor==4
replace setor=0 if setor==2

*tipo estabelecimento
replace estab=1 if estab==1
replace estab=0 if(estab==2 | estab==3 | estab==4 | estab==5 | estab==6 | estab==7 | estab==8)

*se possui carteira assinada ou não
replace carteira=1 if carteira==2
replace carteira=0 if carteira==4

*se possui possui ou não educação superior(graduação, mestrado ou doutorado)
replace nveduc=0 if(nveduc==8 | nveduc==9)
replace nveduc=1 if(nveduc==1 | nveduc==2 | nveduc==3 | nveduc==4 | nveduc==5 | nveduc==6 | nveduc==7 | nveduc==10 | nveduc==11 | nveduc==12 | nveduc==13)       

*regressão log-linear
regress logrenda sexo idade idadeq etnia horas setor anose carteira estab nveduc cnaf rm 

*regressão linear
regress renda sexo idade idadeq etnia horas setor anose carteira estab nveduc cnaf rm
*Anexo J

*geracao de residuos regressao
predict ul, res
gen ul2=ul^2

*teste informal de heterocedastivia
twoway(scatter ul2 idade)

*teste breuash-pagan
estat hettest

*teste de white
whitetst 

*teste de hetero pura
ivhettest

*correcao da heterocedasticia 
regress logrenda sexo idade idadeq etnia horas setor anose carteira estab nveduc cnaf rm, vce (robust)

* teste de normalidade
sktest ul
jb6 ul

*multicolinearidade
vif

*teste de ramsy 
ovtest
