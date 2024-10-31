//Metodo_OV_002_0  WDO - S/ BT e TT

input
	fatorBE(2);   		//Fator para determinar se é uma BE
	horaSaida(1200);	//Horário de saída de todas as operações
	qnt(3); 			//Quantidade inicial de contratos/lotes
	ticksLucro(12); 	//Ticks para pegar lucros parcial 1
	ticksLucro2(16); 	//Ticks para pegar lucros parcial 2
	ticksStop(1);		//Ticks para stop além da abertura da BE
	BEmin(8);			//Tamanho mínimo BE
	BEmax(40);			//Tamanho máximo BE
	maxStop(40);		//Ticks para limite máximo da ordem de stop

	fatorBT(2);         //Fator para determinar a proporção do corpo/pavio

	BImax(4);           //Ticks para determinar tamanho máximo da barra ignorada

var
	ma200        	: Float;	//Média móvel 200 períodos
	ma20         	: Float;	//Média móvel 20 períodos
	abaixo200    	: Boolean;	//Verificar se está abaixo da 200MA
	abaixo20     	: Boolean;	//Verificar se está abaixo da 20MA
	 
	PrCom        	: Float;	//Preço de compra
	PrVen        	: Float;	//Preço de venda
	inicioStop   	: Float;	//Pontos para stop inicial
	pegarLucros  	: Float;	//Pontos para pegar lucros
	pegarLucros2 	: Float;	//Pontos para pegar lucros
	 
	contaOperacao	: Integer;	//Contador de operações

	tamanhoBarra 	: Float;	//Tamanho do corpo de uma barra
	specTamanho  	: Boolean;	//Teste para verificar se a barra atende os requisitos de tamanho para ser considerada
	tamanhoTotal    : Float;    //Tamanho total de uma barra
	specTamanhoTotal: Boolean;  //Teste para verificar se a barra atende os requisitos de tamanho para ser considerada
	  
	barraBull    	: Boolean;	//Verificar se é uma barra verde
	barraBear    	: Boolean;	//Verificar se é uma barra vermelha
	  
	beIndex      	: Integer;	//Quantidade de barras para analisar se é uma barra elefante
	BEteste      	: Boolean;	//Teste para verificar se é uma BE
	barraBEbull    	: Boolean;	//Verificar se é uma barra BE bull
	barraBEbear    	: Boolean;	//Verificar se é uma barra BE bear
		
	btailBear    	: Float;    //Tamanho bottom pavio bear
	ttailBear    	: Float;    //Tamanho top pavio bear
	btailBull    	: Float;    //Tamanho bottom pavio bull
	ttailBull       : Float;    //Tamanho top pavio bull
	barraBTbull     : Boolean;  //Verificar se é uma barra BT bull
	barraBTbear     : Boolean;  //Verificar se é uma barra BT bear
	barraBTneutra	: Boolean;  //Verificar se é uma barra BT neutra
	barraTTbull     : Boolean;  //Verificar se é uma barra TT bull
	barraTTbear     : Boolean;  //Verificar se é uma barra TT bear
	barraTTneutra   : Boolean;  //Verificar se é uma barra TT neutra

	clearBarBull    : Boolean;  //Verificar se é uma barra Clearing Close Bull
	clearBarBear    : Boolean;  //Verificar se é uma barra Clearing Close Bear

	bear180         : Boolean;  //Verficar se é um bear 180 (-180)
	bull180         : Boolean;  //Verficar se é um bull 180 (+180)

	GBI             : Boolean;  //Verificar se ocorreu uma GBI
	RBI             : Boolean;  //Verificar se ocorreu uma RBI
  
begin
	ma200 := Media(200,Close);
	ma20 := Media(20,Close);
	abaixo200 := Close < ma200;
	abaixo20 := Close < ma20;
	  
	pegarLucros := ticksLucro * MinPriceIncrement;
	pegarLucros2 := ticksLucro2 * MinPriceIncrement;
	  
	tamanhoBarra := Abs(Open - Close);
	specTamanho := (tamanhoBarra >= (BEmin * MinPriceIncrement)) and (tamanhoBarra <= (BEmax * MinPriceIncrement));
	tamanhoTotal := Abs(High - Low);
    specTamanhoTotal := (tamanhoTotal >= (BEmin * MinPriceIncrement)) and (tamanhoTotal <= (BEmax * MinPriceIncrement));
	  
	barraBull := Close > Open;
	barraBear := Close < Open;
	  
	BEteste := ((tamanhoBarra >= (fatorBE * tamanhoBarra[5])) and (tamanhoBarra >= (fatorBE * tamanhoBarra[4])) and (tamanhoBarra >= (fatorBE * tamanhoBarra[3])) and (tamanhoBarra >= (fatorBE * tamanhoBarra[2])) and (tamanhoBarra >= (fatorBE * tamanhoBarra[1])));
	barraBEbull := specTamanho and barraBull and BEteste;
	barraBEbear := specTamanho and barraBear and BEteste;
  
	btailBear := Abs(Close - Low);
    ttailBear := Abs(High - Open);
    btailBull := Abs(Open - Low);
    ttailBull := Abs(High - Close);      
    barraBTbull := specTamanhoTotal and barraBull and ((fatorBT * (tamanhoBarra + ttailBull)) <= (btailBull + MinPriceIncrement));
    barraBTbear := specTamanhoTotal and barraBear and ((fatorBT * (tamanhoBarra + ttailBear)) <= (btailBear + MinPriceIncrement));
    barraBTneutra := specTamanhoTotal and (not barraBear) and (not barraBull) and ((fatorBT * (ttailBull)) <= (btailBull + MinPriceIncrement));
    barraTTbull := specTamanhoTotal and barraBull and ((fatorBT * (tamanhoBarra + btailBull)) <= (ttailBull + MinPriceIncrement));
    barraTTbear := specTamanhoTotal and barraBear and ((fatorBT * (tamanhoBarra + btailBear)) <= (ttailBear + MinPriceIncrement));
    barraTTneutra := specTamanhoTotal and (not barraBear) and (not barraBull) and ((fatorBT * (btailBull)) <= (ttailBull + MinPriceIncrement));

    clearBarBull := specTamanho and (Close >= (Highest(High,5)[1])); 
    clearBarBear := specTamanho and (Close <= (Lowest(Low,5)[1]));

    bear180 := specTamanho[1] and (barraBull[1]) and (barraBear) and (Close <= Open[1]);
    bull180 := specTamanho[1] and (barraBear[1]) and (barraBull) and (Close >= Open[1]);

    GBI := specTamanho[2] and barraBear[2] and barraBull[1] and (tamanhoBarra[1] <= (BImax * MinPriceIncrement)) and barraBear and (Close <= Open[1]);
    RBI := specTamanho[2] and barraBull[2] and barraBear[1] and (tamanhoBarra[1] <= (BImax * MinPriceIncrement)) and barraBull and (Close >= Open[1]);
  
	if Time < horaSaida then
		begin
			if (barraBEbear or clearBarBear or bear180 or GBI) then	//BEAR (barraBEbear or barraTTbear or barraTTbull or barraTTneutra or clearBarBear or bear180 or GBI)
				begin
					Paintbar(clFuchsia);
					if abaixo200 and (not HasPosition) then
						begin
							SellShortAtMarket(qnt);
							PrVen := Close;
							inicioStop := Open + (ticksStop * MinPriceIncrement);
						end;
				end;
			if (barraBEbull or clearBarBull or bull180 or RBI) then  //BULL (barraBEbull or barraBTbear or barraBTbull or barraBTneutra or clearBarBull or bull180 or RBI)
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
					if (Close > PrVen) then //Stop loss inicial
						begin
							BuyToCoverStop(inicioStop,(inicioStop + (maxStop * MinPriceIncrement)),Abs(Position));
						end;
					if ((Close > ma20) and (Close[1] > ma20[1])) then //stop-out 2 barras fechando acima da 20MA
						begin
							BuyToCoverAtMarket(Abs(Position));
						end;
					if (qnt = 2) then //pegar lucro parcial 2Contratos
						begin
							if (Abs(Position) > 1) then //pegar lucros 2Contratos
								begin
									BuyToCoverLimit((PrVen - pegarLucros),(Abs(Position) - 1));
								end
							else //mover para o break-even
								begin
									BuyToCoverStop(PrVen,(PrVen + (maxStop * MinPriceIncrement)),Abs(Position));
								end;
						end
					else if (qnt > 2) then //pegar lucros 3+Contratos
						begin
							if (Abs(Position) > 2) then //pegar lucros 1
								begin
									BuyToCoverLimit((PrVen - pegarLucros),(Abs(Position) - 2));
								end
							else 
								begin
									if (Abs(Position) = 2) then //pegar lucros 2
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
					if (Close < PrCom) then //Stop loss inicial
						begin
							SellToCoverStop(inicioStop,(inicioStop - (maxStop * MinPriceIncrement)),Abs(Position));
						end;
					if ((Close < ma20) and (Close[1] < ma20[1])) then //stop-out 2 barras fechando abaixo da 20MA
						begin
							SellToCoverAtMarket(Abs(Position));
						end;
					if (qnt = 2) then //pegar lucro parcial 2Contratos
						begin
							if (Abs(Position) > 1) then //pegar lucros 2Contratos
								begin
									SellToCoverLimit((PrCom + pegarLucros),(Abs(Position) - 1));
								end
							else //mover para o break-even 
								begin
									SellToCoverStop(PrCom,(PrCom - (maxStop * MinPriceIncrement)),Abs(Position));
								end;
						end
					else if (qnt > 2) then //pegar lucros 3+Contratos
						begin
							if (Abs(Position) > 2) then //pegar lucros 1
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
