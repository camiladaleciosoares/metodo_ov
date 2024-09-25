# Método OV
## Automação do Método OV

Método OV V001_0 - Básico - WDO

V000_1 --> V000 + implementando parâmetros (inputs)

V000_2 --> V000_1 + implementação de ticks no lugar de pontos

	- ticksLucro = 12 ticks (60 reais)
	- BEmin = 6 ticks (3 pontos --> 30 reais)
	- BEmax = 40 ticks (20 pontos --> 200 reais)

 V000_3 --> V000_2 + alterações 
 
 	- Troca de contaOperações por (not HasPosition)
	- Alteração de stop loss para tipo de ordem ToCoverStop no valor da abertura da BE +/- 1 tick
	- Correção ordem ToCoverStop

 V000_4 --> Alterar V000_3 
 
 	-Juntar V000_3 de 2Contratos E Vteste 1Contrato em um código, alterando o parâmetro qnt para 2 ou 1.

  V001_0 --> Alterar V000_4

  	- Incluir versão para 3 ou mais contratos no mesmo código
   	- Subir versão quando finalizar implementação

OBJETIVO: Encontrar Barras Elefantes (BE)

	- Acima 200MA: comprar
	- Abaixo 200MA: vender
	- Saída de acordo com o número de contratos: Sair com lucro(s) parcial(is) e/ou stop out (2 barras cruzar 20MA ou Break Even)
		OU
	- Sair na abertura da BE (Stop loss)

PARÂMETROS:

	- fator BE = 2.0
	- hora saída = 1500
	- número de contratos = 3 (pegar lucro 1 e 2), 2 (pegar lucros) OU 1 (com stop out)
 	- pegar lucros 1 = 12 ticks (6 pontos)
  	- pegar lucros 2 = 16 ticks (8 pontos)
  	- ticks de stop inicial = 1 tick (0,5 ponto)
   	- ticks máximo ordem stop = 40 ticks (20 pontos)
  	- Tamanho BE >= 6 ticks (3 pontos) E Tamanho BE <= 40 ticks (20 pontos)

 VARIÁVEIS/AUXILIARES:

 	- números de barras anteriores a BE = 5
  	- número máximo de operações em aberto = 1
	- sem limites de perdas/ganhos diários
		OU
	- limite de perdas:
 		-- Para 3 contratos: R$ 250,00 limite de perda diário (~ R$ 50,00 por contrato por operação)
	- Lucro parcial = fechamento BE + pegar lucros 1 e/ou fechamento BE + pegar lucros 2
	- Stop loss = abertura BE

TIRAR SPLITS E GRUPAMENTOS PARA BACKTESTING (Exibir --> Splits e Grupamento)
