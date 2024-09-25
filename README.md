# Método OV
## Automação do Método OV

Método OV V000_4 - Básico - WDO

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


OBJETIVO: Encontrar Barras Elefantes (BE)

	- Acima 200MA: comprar
	- Abaixo 200MA: vender
	- Sair com lucro parcial e stop out (2 barras cruzar 20MA ou Break Even)
		OU
	- Sair na abertura da BE (Stop loss)

PARÂMETROS:

	- fator BE = 2.0
	- hora saída = 1500
	- número de contratos = 2 (com pegar lucros) OU 1 (com stop out)
 	- pegar lucros = 12 ticks (6 pontos)
  	- ticks de stop inicial = 1 tick (0,5 ponto)
   	- ticks máximo ordem stop = 40 ticks (20 pontos)
  	- Tamanho BE >= 6 ticks (3 pontos) E Tamanho BE <= 40 ticks (20 pontos)

 VARIÁVEIS/AUXILIARES:

 	- números de barras anteriores a BE = 5
  	- número máximo de operações em aberto = 1
	- sem limites de perdas/ganhos diários
		OU
	- limite de perdas = R$ 300 e limite de ganhos = R$ 500
	- Lucro parcial = fechamento BE + pegar lucros
	- Stop loss = abertura BE

TIRAR SPLITS E GRUPAMENTOS PARA BACKTESTING (Exibir --> Splits e Grupamento)
