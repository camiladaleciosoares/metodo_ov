# Método OV
## Automação do Método OV

Método OV V002_0 - Parâmetros do código setados para WDO, parâmetros WIN nos comentários

V000_1 --> V000 + implementando parâmetros (inputs)
V000_2 --> V000_1 + implementação de ticks no lugar de pontos
V000_3 --> V000_2 + alterações (HasPosition, ordem stop loss) + Correção ordem ToCoverStop
V000_4 --> Alterar V000_3 para funcionar com 2 ou 1 contrato no parâmetro qnt
V000_5 --> Correção V000_4

V001_0 --> Alterar V000_4
V001_1 --> Correção V001_0 conforme alterações V000_5

V002_0 --> Inclusão de outros eventos de entrada -- versão de início de testes de automação na conta real com 1 contrato
	- Eventos de entrada: BE, Clearing bar, bull180/bear180, RBI/GBI

V002_1 --> Modificação de parâmetros e coloração de eventos de entrada + correção ClearBar + inlcusão BT e TT + escolha break-even
	- Eventos de entrada: BE, Clearing bar, bull180/bear180, RBI/GBI e BT/TT

OBJETIVO: Encontrar eventos de abertura que satisfaçam as condições de cada tipo de evento

	- Condições básicas:
		- Uma operação por vez (não é possível adicionar)
		- Acima 200MA: comprar
		- Abaixo 200MA: vender
		- Saída de acordo com o número de contratos: Sair com lucro(s) parcial(is) e/ou stop out (2 barras cruzar 20MA ou Break Even)
			OU
		- Sair na abertura da barra de entrada (Stop loss)

	- Barras elefantes (BE):
		- a barra atual tem que ser maior que as últimas 5 barras multiplicado pelo fatorBE
		- as barras tem tamanho mínimo de 8 ticks e máximo
        - considera apenas o corpo da barra (abertura e fechamento)
        - identifica barras elefantes bear e bull

	- Clearing bar (ClearBar):
		- considera o tamanho total da barra (max e min)
        - as barras tem tamanho total mínimo e máximo --> utiliza os parâmentros da BE
        - ClearBarBull: barra que tem o fechamento maior que máximas das últimas 5 barras
        - ClearBarBear: barra que tem o fechamento menor que a mínima das últimas 5 barras

	- Bull180 e Bear180:
        - a barra atual deve tamanho mínimo e máximo --> utiliza os parâmentros da BE
        - considera apenas o corpo da barra (abertura e fechamento) --> como na BE
        - não considera tamanho da barra anterior --> possível modificação posterior
        - bull180: barra bear anterior e barra bull atual com fechamento maior ou igual que da barra anterior
        - bear180: barra bull anterior e barra bear atual com fechamento menor ou igual que da barra anterior
	
	- RBI e GBI:
        - BImax determina tamanho máximo para barra ignoradas
        - GBI: a antepenúltima barra bear e penúltima barra bull com tamanho menor ou igual a BImax e barra bear atual com fechamento menor ou igual a abertura da penúltima barra
        - RBI: a antepenúltima barra bull e penúltima barra bear com tamanho menor ou igual a BImax e barra bull atual com fechamento da maior ou igual a abertura da penúltima barra
        - não considera o tamanho das barras antepenúltima e última (atual) --> possível modificação posterior

	- BT e TT:
		- considera o tamanho total da barra (max e min)
		- as barras tem tamanho total mínimo e máximo --> utiliza os parâmentros da BE
		- FatorBT determina o a proporção corpo/pavio
			- BT: está sendo considerado corpo+tt tem que ser 2x (fatorBT) menor ou igual a BT+mínimo incremento, proporção de 1/3 do total da barra 
			- TT: está sendo considerado corpo+bt tem que ser 2x (fatorBT) menor ou igual a TT+mínimo incremento, proporção de 1/3 do total da barra 
			- Tails neutras: 'tail menor' tem que ser 2x (fatorBT) menor ou igual a 'tail maior'+mínimo incremento, proporção de 1/3 do total da barra

PARÂMETROS:

	- hora saída = 1200
	- número de contratos = 3 (pegar lucro 1 e 2), 2 (pegar lucros) OU 1 (com stop out)

	- habilitar/desabilitar: Break-even, BE compra e venda, Clearing bar compra e venda, vira180 compra e venda, RBI compra e GBI venda, BT compra e TT venda

	- pegar lucros 1 = WDO: 12 ticks (6 pontos) -- WIN: 30 ticks (150 pontos)
  	- pegar lucros 2 = WDO: 16 ticks (8 pontos) -- WIN: 45 ticks (225 pontos)
	- ticks de stop inicial = WDO: 1 tick (0,5 ponto) -- WIN: 1 tick (5 pontos)
	
	- fator BE = WDO: 2.0 -- WIN: 1.75
	- tamanho BE min = WDO: >= 8 ticks (4 pontos) -- WIN: >= 35 ticks (175 pontos)
	- tamanho BE max = WDO: <= 40 ticks (20 pontos) -- WIN <= 80 ticks (400 pontos)
	- ticks máximo ordem stop = WDO: 40 ticks (20 pontos) -- WIN: 80 ticks (400 pontos)

	- tamanho máximo barra ignorada, BImax = WDO: 6 ticks (3 pontos) -- WIN: 20 ticks (100 pontos)

	- fator BT = 2 --> proporção entre corpo/pavio em BT e TT  	

 VARIÁVEIS/AUXILIARES:

 	- números de barras anteriores a BE e clearing bar= 5
  	- número máximo de operações em aberto = 1
	- sem limites de perdas/ganhos diários
		OU
	- limite de perdas:
 		-- Para 3 contratos: R$ 250,00 limite de perda diário (~ R$ 50,00 por contrato por operação)
	- Lucro parcial = fechamento BE + pegar lucros 1 e/ou fechamento BE + pegar lucros 2
	- Stop loss = abertura BE
 	- Break-even apenas para 2+ contratos com possibilidade de desabilitar:
  		-- 2Contratos: após lucro parcial
    		-- 3Contratos: após segundo lucro parcial

TIRAR SPLITS E GRUPAMENTOS PARA BACKTESTING (Exibir --> Splits e Grupamento)
