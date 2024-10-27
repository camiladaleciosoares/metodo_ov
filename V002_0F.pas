//Metodo_OV_002_0F --> entra em operações quando está no máx à 30 pontos da ma200 e com 1 contrato a menos se estiver entre 30 e 45 pontos
//ficou pior que a versão E
input
  fatorBE(2);
  //Fator para determinar se é uma BE
  horaSaida(1500);
  //Horário de saída de todas as operações
  qnt(3);
  //Quantidade inicial de contratos/lotes
  ticksLucro(12);
  //Ticks para pegar lucros parcial 1
  ticksLucro2(16);
  //Ticks para pegar lucros parcial 2
  ticksStop(1);
  //Ticks para stop além da abertura da BE
  BEmin(8);
  //tamanho mínimo BE
  BEmax(40);
  //tamanho máximo BE
  maxStop(40);
  //ticks para limite máximo da ordem de stop
  pos1max(60);
  //ticks para distância máxima da 200ma para determinar posição 1
  pos2max(90);
  //ticks para distância máxima da 200ma para determinar posição 1
var
  tamanhoBarra  : Float;
  //Tamanho do corpo de uma barra
  BEteste       : Boolean;
  //Teste para verificar se é uma BE
  ma200         : Float;
  //Média móvel 200 períodos
  ma20          : Float;
  //Média móvel 20 períodos
  PrCom         : Float;
  //Preço de compra
  PrVen         : Float;
  //Preço de venda
  inicioStop    : Float;
  //Pontos para stop inicial
  beIndex       : Integer;
  //Quantidade de barras para analisar se é uma barra elefante
  contaOperacao : Integer;
  //Contador de operações
  barraBull     : Boolean;
  //verificar se é uma barra verde
  barraBear     : Boolean;
  //verificar se é uma barra vermelha
  abaixo200     : Boolean;
  //verificar se está abaixo da 200MA
  abaixo20      : Boolean;
  //verificar se está abaixo da 20MA
  pegarLucros   : Float;
  //Pontos para pegar lucros
  pegarLucros2  : Float;
  //Pontos para pegar lucros
  pos1          : Boolean;
  //se o fechamento está dentro da posição 1
  pos2          : Boolean;
  //se o fechamento está dentro da posição 1
begin
  tamanhoBarra := Abs(Open - Close);
  ma200 := Media(200,Close);
  ma20 := Media(20,Close);
  BEteste := ((tamanhoBarra >= (fatorBE * tamanhoBarra[5])) and (tamanhoBarra >= (fatorBE * tamanhoBarra[4])) and (tamanhoBarra >= (fatorBE * tamanhoBarra[3])) and (tamanhoBarra >= (fatorBE * tamanhoBarra[2])) and (tamanhoBarra >= (fatorBE * tamanhoBarra[1])));
  barraBull := Close > Open;
  barraBear := Close < Open;
  abaixo200 := Close < ma200;
  abaixo20 := Close < ma20;
  pegarLucros := ticksLucro * MinPriceIncrement;
  pegarLucros2 := ticksLucro2 * MinPriceIncrement;
  pos1 := (Abs(Close - ma200)) <= (pos1max * MinPriceIncrement);
  pos2 := ((Abs(Close - ma200)) > (pos1max * MinPriceIncrement)) and ((Abs(Close - ma200)) <= (pos2max * MinPriceIncrement));
  if Time < horaSaida then
    begin
      if barraBear and BEteste and (tamanhoBarra >= (BEmin * MinPriceIncrement)) and (tamanhoBarra <= (BEmax * MinPriceIncrement)) then
        begin
          Paintbar(clFuchsia);
          if abaixo200 and ( not HasPosition) then
            begin
              if pos1 then
                begin
                  SellShortAtMarket(qnt);
                  PrVen := Close;
                  inicioStop := Open + (ticksStop * MinPriceIncrement);
                end
              else if pos2 and (qnt > 1) then
                begin
                  SellShortAtMarket(qnt - 1);
                  PrVen := Close;
                  inicioStop := Open + (ticksStop * MinPriceIncrement);
                end;
            end;
        end;
      if barraBull and BEteste and (tamanhoBarra >= (BEmin * MinPriceIncrement)) and (tamanhoBarra <= (BEmax * MinPriceIncrement)) then
        begin
          Paintbar(clGreen);
          if ( not abaixo200) and ( not HasPosition) then
            begin
              if pos1 then
                begin
                  BuyAtMarket(qnt);
                  PrCom := Close;
                  inicioStop := Open - (ticksStop * MinPriceIncrement);
                end
              else if pos2 and (qnt > 1) then
                begin
                  BuyAtMarket(qnt);
                  PrCom := Close;
                  inicioStop := Open - (ticksStop * MinPriceIncrement);
                end;
            end;
        end;
      if IsSold then
        begin
          if (Close > PrVen) then
            //Stop loss inicial
            begin
              BuyToCoverStop(inicioStop,(inicioStop + (maxStop * MinPriceIncrement)),Abs(Position));
            end;
          if ((Close > ma20) and (Close[1] > ma20[1])) then
            //stop-out 2 barras fechando acima da 20MA
            begin
              BuyToCoverAtMarket(Abs(Position));
            end;
          if (qnt = 2) then
            //pegar lucro parcial 2Contratos
            begin
              if (Abs(Position) > 1) then
                //pegar lucros 2Contratos
                begin
                  BuyToCoverLimit((PrVen - pegarLucros),(Abs(Position) - 1));
                end
              else 
                //mover para o break-even
                begin
                  BuyToCoverStop(PrVen,(PrVen + (maxStop * MinPriceIncrement)),Abs(Position));
                end;
            end
          else if (qnt > 2) then
            //pegar lucros 3+Contratos
            begin
              if (Abs(Position) > 2) then
                //pegar lucros 1
                begin
                  BuyToCoverLimit((PrVen - pegarLucros),(Abs(Position) - 2));
                end
              else 
                begin
                  if (Abs(Position) = 2) then
                    //pegar lucros 2
                    begin
                      BuyToCoverLimit((PrVen - pegarLucros2),(Abs(Position) - 1));
                    end
                  else 
                    begin
                      BuyToCoverStop(PrVen,(PrVen + (maxStop * MinPriceIncrement)),Abs(Position));
                    end;
                end;
            end;
        end;
      if IsBought then
        begin
          if (Close < PrCom) then
            //Stop loss inicial
            begin
              SellToCoverStop(inicioStop,(inicioStop - (maxStop * MinPriceIncrement)),Abs(Position));
            end;
          if ((Close < ma20) and (Close[1] < ma20[1])) then
            //stop-out 2 barras fechando abaixo da 20MA
            begin
              SellToCoverAtMarket(Abs(Position));
            end;
          if (qnt = 2) then
            //pegar lucro parcial 2Contratos
            begin
              if (Abs(Position) > 1) then
                //pegar lucros 2Contratos
                begin
                  SellToCoverLimit((PrCom + pegarLucros),(Abs(Position) - 1));
                end
              else 
                //mover para o break-even
                begin
                  SellToCoverStop(PrCom,(PrCom - (maxStop * MinPriceIncrement)),Abs(Position));
                end;
            end
          else if (qnt > 2) then
            //pegar lucros 3+Contratos
            begin
              if (Abs(Position) > 2) then
                //pegar lucros 1
                begin
                  SellToCoverLimit((PrCom + pegarLucros),(Abs(Position) - 2));
                end
              else 
                begin
                  if (Abs(Position) = 2) then
                    begin
                      SellToCoverLimit((PrCom + pegarLucros2),(Abs(Position) - 1));
                    end
                  else 
                    begin
                      SellToCoverStop(PrCom,(PrCom - (maxStop * MinPriceIncrement)),Abs(Position));
                    end;
                end;
            end;
        end;
    end
  else 
    begin
      ClosePosition;
      CancelPendingOrders;
    end;
  Plot(ma200);
  Plot2(ma20);
  SetPlotColor(2,clFuchsia);
  Plot3(inicioStop);
  SetPlotColor(3,clRed);
  Plot4(PrVen - pegarLucros);
  SetPlotColor(4,clWhite);
  Plot5(PrCom + pegarLucros);
  SetPlotColor(5,clYellow);
end;