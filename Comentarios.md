# Testes plataforma - Comentários

### PrCom x BuyPrice
BuyPrice --> usa média dos preços e zera quando a operação é finalizada

PrCom := Close --> usa o preço de fechamento da BE e não o preço de compra e não zera quando a operação é finalizada

### Coloração
Teste de coloração inclui:
    1) Barras elefantes
    2) BT e TT
        Para colorir qualquer tamanho de BT e TT, alterar o parâmetro BEmin para 1
        BT: está sendo considerado corpo+tt tem que ser 2x maior ou igual a BT+mínimo incremento, proporção de 1/3 do total da barra
        TT: está sendo considerado corpo+bt tem que ser 2x maior ou igual a TT+mínimo incremento, proporção de 1/3 do total da barra

### Fazer análises
[ ] Analisar diferença stop inicial V001_1 e V002_0B

