# Método OV
## Automação do Método OV

Método OV V001_0 - Básico - WDO

V000_1 --> V000 + implementando parâmetros (inputs)

V000_2 --> V000_1 + implementação de ticks no lugar de pontos

V000_3 --> V000_2 + alterações (HasPosition, ordem stop loss) + Correção ordem ToCoverStop

V000_4 --> Alterar V000_3 para funcionar com 2 ou 1 contrato no parâmetro qnt

V000_5 --> Correção V000_4

	- Stop de fechamento acima/abaixo 20MA para 2 contratos
	- Alteração da ordem de break-even ToCoverStop (maxStop)

V001_0 --> Alterar V000_4

  	- Incluir versão para 3 ou mais contratos no mesmo código
   	- Subir versão quando finalizar implementação

V001_1 --> Correção V001_0 conforme alterações V000_5

	- Stop de fechamento acima/abaixo 20MA para 2/3 contratos
	- Alteração da ordem de break-even ToCoverStop (maxStop)
 	- Correção para funcionar igual V000_5 com 2 contratos
		-- 2C: Move stop loss para o break even depois do lucro parcial
		-- 3C: Move stop loss para o break even depois do segundo lucro parcial

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
 	- Break-even apenas para 2+ contratos:
  		-- 2Contratos: após lucro parcial
    		-- 3Contratos: após segundo lucro parcial

TIRAR SPLITS E GRUPAMENTOS PARA BACKTESTING (Exibir --> Splits e Grupamento)
