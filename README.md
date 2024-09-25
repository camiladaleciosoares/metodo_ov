# Método OV
## Automação do Método OV

Método OV V000 - Básico - WDO

OBJETIVO: Encontrar Barras Elefantes (BE)

	- Acima 200MA: comprar
	- Abaixo 200MA: vender
	- Sair com lucro parcial e stop out (2 barras cruzar 20MA ou Break Even)
		OU
	- Sair na abertura da BE (Stop loss)

PARÂMETROS:

	- fator BE = 2.0
	- números de barras anteriores a BE = 5
	- hora saída = 1500
	- pegar lucros = 6 pontos
	- número máximo de contratos = 2
	- número máximo de operações em aberto = 1
	- sem limites de perdas/ganhos diários
		OU
	- limite de perdas = R$ 300 e limite de ganhos = R$ 500
	- Lucro parcial = fechamento BE + pegar lucros
	- Stop loss = abertura BE
	- Tamanho BE >= 3 pontos E Tamanho BE <= 20 pontos

TIRAR SPLITS E GRUPAMENTOS PARA BACKTESTING (Exibir --> Splits e Grupamento)
