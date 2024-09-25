# Método OV
## Automação do Método OV

Método OV V000_1 - Básico - WDO

V000_1 --> V000 + implementando parâmetros (inputs)

OBJETIVO: Encontrar Barras Elefantes (BE)

	- Acima 200MA: comprar
	- Abaixo 200MA: vender
	- Sair com lucro parcial e stop out (2 barras cruzar 20MA ou Break Even)
		OU
	- Sair na abertura da BE (Stop loss)

PARÂMETROS:

	- fator BE = 2.0
	- hora saída = 1500
	- número máximo de contratos = 2
 	- pegar lucros = 6 pontos
  	- Tamanho BE >= 3 pontos E Tamanho BE <= 20 pontos

 VARIÁVEIS/AUXILIARES:

 	- números de barras anteriores a BE = 5
  	- número máximo de operações em aberto = 1
	- sem limites de perdas/ganhos diários
		OU
	- limite de perdas = R$ 300 e limite de ganhos = R$ 500
	- Lucro parcial = fechamento BE + pegar lucros
	- Stop loss = abertura BE

TIRAR SPLITS E GRUPAMENTOS PARA BACKTESTING (Exibir --> Splits e Grupamento)
