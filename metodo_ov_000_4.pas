//Metodo_OV_000_4

input
fatorBE(2);   		//Fator para determinar se é uma BE
horaSaida(1500);	//Horário de saída de todas as operações
qnt(2); 			//Quantidade inicial de contratos/lotes
ticksLucro(12); 	//Ticks para pegar lucros
ticksStop(1);		//Ticks para stop além da abertura da BE
BEmin(6);			//tamanho mínimo BE
BEmax(40);			//tamanho máximo BE
maxStop(40);		//ticks para limite máximo da ordem de stop

var
  tamanhoBarra : Float;
  //Tamanho do corpo de uma barra
  BEteste      : Boolean;
  //Teste para verificar se é uma BE
  ma200        : Float;
  //Média móvel 200 períodos
  ma20         : Float;
  //Média móvel 20 períodos
  PrCom        : Float;
  //Preço de compra
  PrVen        : Float;
  //Preço de venda
  inicioStop   : Float;
  //Pontos para stop inicial
  beIndex      : Integer;
  //Quantidade de barras para analisar se é uma barra elefante
  contaOperacao: Integer;
  //Contador de operações
  barraBull    : Boolean;
  //verificar se é uma barra verde
  barraBear    : Boolean;
  //verificar se é uma barra vermelha
  abaixo200    : Boolean;
  //verificar se está abaixo da 200MA
  abaixo20     : Boolean;
  //verificar se está abaixo da 20MA
  pegarLucros  : Float;
  //Pontos para pegar lucros
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
  
	if Time < horaSaida then
		begin
			if barraBear and BEteste and (tamanhoBarra >= (BEmin * MinPriceIncrement)) and (tamanhoBarra <= (BEmax * MinPriceIncrement)) then
				begin
					Paintbar(clFuchsia);
					if abaixo200 and (not HasPosition) then
						begin
							SellShortAtMarket(qnt);
							PrVen := Close;
							inicioStop := Open + (ticksStop * MinPriceIncrement);
						end;
				end;
			if barraBull and BEteste and (tamanhoBarra >= (BEmin * MinPriceIncrement)) and (tamanhoBarra <= (BEmax * MinPriceIncrement)) then
				begin
					Paintbar(clGreen);
					if ( not abaixo200) and (not HasPosition) then
						begin
							BuyAtMarket(qnt);
							PrCom := Close;
							inicioStop := Open - (ticksStop * MinPriceIncrement);
						end;
				end;
			if IsSold then
				begin
					if (Close > PrVen) then
						begin
							BuyToCoverStop(inicioStop,(inicioStop + (maxStop * MinPriceIncrement)),Abs(Position));
						end;
					if (Abs(Position) > 1) then
						begin
							BuyToCoverLimit((PrVen - pegarLucros),(Abs(Position) - 1));
						end
					else 
						begin
							if ((Close > ma20) and (Close[1] > ma20[1])) then
								begin
									BuyToCoverAtMarket(Abs(Position));
								end
							else if (qnt > 1) then//if (Close > (PrVen - pegarLucros)) then
								begin
									BuyToCoverStop(PrVen,(PrVen + ticksStop),Abs(Position));
								end;
						end;
				end;
			if IsBought then
				begin
					if (Close < PrCom) then
						begin
							SellToCoverStop(inicioStop,(inicioStop - (maxStop * MinPriceIncrement)),Abs(Position));
						end;
					if (Abs(Position) > 1) then
						begin
							SellToCoverLimit((PrCom + pegarLucros),(Abs(Position) - 1));
						end
					else 
						begin
							if ((Close < ma20) and (Close[1] < ma20[1])) then
								begin
									SellToCoverAtMarket(Abs(Position));
								end
							else if (qnt > 1) then //if (Close < (PrCom + pegarLucros)) then
								begin
									SellToCoverStop(PrCom,(PrCom - ticksStop),Abs(Position));
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
