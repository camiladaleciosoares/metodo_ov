# Testes plataforma - Comentários

[ ] excluir commit da V002_0 de 30/10

### PrCom x BuyPrice
BuyPrice --> usa média dos preços e zera quando a operação é finalizada

PrCom := Close --> usa o preço de fechamento da BE e não o preço de compra e não zera quando a operação é finalizada

### Coloração
Teste de coloração inclui:
    1) Barras elefantes
        - fatorBE = 2 (para determinar se é uma BE, a barra atual tem que ser maior que as últimas 5 barras multiplicado pelo fatorBE)
        - as barras tem tamanho mínimo de 8 ticks (4 pontos) e máximo de 40 ticks (20 pontos)
        - considera apenas o corpo da barra (abertura e fechamento)
        - identifica barras elefantes bear e bull
    2) BT e TT
        - Para colorir qualquer tamanho de BT e TT, alterar o parâmetro BEmin para 1
        - considera o tamanho total da barra (max e min)
        - as barras tem tamanho total mínimo de 8 ticks (4 pontos) e máximo de 40 ticks (20 pontos) --> mesmos parâmetros da BE
        - BT: está sendo considerado corpo+tt tem que ser 2x (fatorBT) menor ou igual a BT+mínimo incremento, proporção de 1/3 do total da barra
        - TT: está sendo considerado corpo+bt tem que ser 2x (fatorBT) menor ou igual a TT+mínimo incremento, proporção de 1/3 do total da barra
        - tails neutras: 'tail menor' tem que ser 2x (fatorBT) menor ou igual a 'tail maior'+mínimo incremento, proporção de 1/3 do total da barra
    3) Clearing bar
        - considera o tamanho total da barra (max e min)
        - as barras tem tamanho total mínimo de 8 ticks (4 pontos) e máximo de 40 ticks (20 pontos) --> mesmos parâmetros da BE
        - bull: colori a barra que tem o fechamento maior que máximas das últimas 5 barras
        - bear: colori a barra que tem o fechamento menor que a mínima das últimas 5 barras
    4) Bull180 e Bear180
        - a barra atual deve tamanho mínimo de 8 ticks (4 pontos) e máximo de 40 ticks (20 pontos)
        - considera apenas o corpo da barra (abertura e fechamento)
        - não considera tamanho da barra anterior
        - bull180: barra bear anterior e barra bull atual com fechamento maior ou igual que da barra anterior
        - bear180: barra bull anterior e barra bear atual com fechamento menor ou igual que da barra anterior
    5) RBI e GBI
        - BImax = 4 ticks (2 pontos) (determina tamanho máximo para barra ignoradas)
        - GBI: a antepenúltima barra bear e penúltima barra bull com tamanho menor ou igual a BImax e barra bear atual com fechamento menor ou igual a abertura da penúltima barra
        - RBI: a antepenúltima barra bull e penúltima barra bear com tamanho menor ou igual a BImax e barra bull atual com fechamento da maior ou igual a abertura da penúltima barra
        - não considera o tamanho das barras antepenúltima e última (atual)
- Inclusão de variáveis booleanas para substituir nos Ifs    


### Fazer análises
[ ] 

### Automação de estratégias
Existe uma configuração da estratégia na aba "Entrada" na seção "Modo de execução" que permite escolher envio de ordens no fechamento do candle ou quando a condição for satisfeita.
    --> Em uma observação preliminar, o programa deve ser pensado e adequado para cada tipo de envio de ordem, pois o comportamento deve divergir e o resultado também. Não é possível fazer backtesting, pois é uma configuração da automação da execução da estratégia. Apenas testes de replay.
        -->Executei a automação configurada para 'quando a condição for satisfeita' no replay do dia 24/10/2024. A entrada foi feita antes do fechamento do candle, quando configurou uma BE e foi stopada na mesma barra, quando passou pelo preço de entrada + 1 tick.
            Considerações:  - o stop foi bem menor, pois a entrada foi antecipada;
                            - não entrou no candle seguinte, mesmo tendo configurado um BE bull (não sei dizer o pq);
                            - possivelmente, em uma barra muito volátil, mas que dê continuação no movimento, pode ser que entrando antecipadamente (antes do fechamento do candle) ocorra um stop e depois barra volte e continue o movimento.

### Resumo análises 30/10/2024
1 - até meio dia com stop loss e gain diário apresentam os melhores resultados (o melhor ou segundo melhor)
2 - considerando o ano, até às 10h com stop diário apresentou o melhor resultado
3 - BE mín de 4 pontos é melhor na maioria das vezes
4 - o maior resultado foi considerando o ano e stop diário BE de 4 e até às 10h e o segundo melhor até meio dia nas mesmas condições
5 - em geral, não vale a pena operar até às 17h
6 - usar sempre stop diário
7 - em geral, não vale a pena usar pos1 max
