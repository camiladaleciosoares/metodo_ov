//Metodo_OV_000_1

input
fatorBE(2);   		//Fator para determinar se é uma BE
horaSaida(1500);	//Horário de saída de todas as operações
qnt(2); 			//Quantidade inicial de contratos/lotes
pegarLucros(6); 	//Pontos para pegar lucros
BEmin(3);			//tamanho mínimo BE
BEmax(20);			//tamanho máximo BE

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
begin
  tamanhoBarra := Abs(Open - Close);
  ma200 := Media(200,Close);
  ma20 := Media(20,Close);
  BEteste := ((tamanhoBarra >= (fatorBE * tamanhoBarra[5])) and (tamanhoBarra >= (fatorBE * tamanhoBarra[4])) and (tamanhoBarra >= (fatorBE * tamanhoBarra[3])) and (tamanhoBarra >= (fatorBE * tamanhoBarra[2])) and (tamanhoBarra >= (fatorBE * tamanhoBarra[1])));
  barraBull := Close > Open;
  barraBear := Close < Open;
  abaixo200 := Close < ma200;
  abaixo20 := Close < ma20;
	if (ContadorDeCandle = 1) then
		begin
			Paintbar(clRed);
			contaOperacao := 0;
		end;
	if Time < horaSaida then
		begin
			//if (contaOperacao = 0) then
				//begin
					if barraBear and BEteste and (tamanhoBarra >= BEmin) and (tamanhoBarra <= BEmax) then
						begin
							Paintbar(clFuchsia);
								if abaixo200 and (contaOperacao = 0) then
									begin
										SellShortAtMarket(qnt);
										PrVen := Close;//SellPrice;
										inicioStop := Open;
										contaOperacao := contaOperacao + 1;
									end;
						end;
					if barraBull and BEteste and (tamanhoBarra >= BEmin) and (tamanhoBarra <= BEmax) then
						begin
							Paintbar(clGreen);
								if ( not abaixo200) and (contaOperacao = 0) then
									begin
										BuyAtMarket(qnt);
										PrCom := Close;//BuyPrice;
										inicioStop := Open;
										contaOperacao := contaOperacao + 1;
									end;
						end;
				//end
			//else
				//begin
					if IsSold then
						begin
							if (Close >= inicioStop) then
								begin
									BuyToCoverAtMarket(Abs(Position));
									contaOperacao := 0;
								end;
							if (Abs(Position) > 1) then
								begin
									BuyToCoverLimit((PrVen - pegarLucros),(Abs(Position) - 1));
								end
							else 
								begin
									if ((Close > ma20) and (Close[1] > ma20[1])) or (Close >= PrVen) then
										begin
											BuyToCoverAtMarket(Abs(Position));
											contaOperacao := 0;
										end;
								end;
						end;
					if IsBought then
						begin
							if (Close <= inicioStop) then
								begin
									SellToCoverAtMarket(Abs(Position));
									contaOperacao := 0;
								end;
							if (Abs(Position) > 1) then
								begin
									SellToCoverLimit((PrCom + pegarLucros),(Abs(Position) - 1));
								end
							else 
								begin
									if ((Close < ma20) and (Close[1] < ma20[1])) or (Close <= PrCom) then
										begin
											SellToCoverAtMarket(Abs(Position));
											contaOperacao := 0;
										end;
								end;
						end;
				//end;
		end
	else 
		begin
			ClosePosition;
			CancelPendingOrders;
			contaOperacao := 0;
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
//Plot (Abs(Position));
//Plot6 (ContadorDeCandle);
//Plot7 (contaOperacao);
end
