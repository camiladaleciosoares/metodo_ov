///////////////////////////////////
//      Testes de coloração      //
///////////////////////////////////

//V001_3

input
TipoDeColoracao(5);  //Escolher tipo de coloração
 // 1 --> Barras elefantes
 // 2 --> Bottoming Tail + Topping Tail
 // 3 --> Clearing bar
 // 4 --> 180
 // 5 --> RBI + GBI


//inputs para Barras elefantes
fatorBE(2);                     //Fator para determinar se é uma BE
BEmin(8);                       //ticks tamanho mínimo BE
BEmax(40);                      //ticks tamanho máximo BE
fatorBEtotal(2);                //Fator para determinar se é uma BE utilizando tamanho total (max-min)

//inputs para BT
//tBTbTTmax(2);                   //ticks tamanho máximo do pavio do topo de uma BT e de baixo de uma TT
fatorBT(2);                     //Fator para determinar a proporção do corpo/pavio

//inputs para GBI e RBI
BImax(4);                     //ticks para determinar tamanho máximo da barra ignorada

var
tamanhoBarra        : Float;    //Tamanho do corpo de uma barra
specTamanho         : Boolean;  //Teste para verificar se a barra atende os requisitos de tamanho para ser considerada
tamanhoTotal        : Float;    //Tamanho total de uma barra
specTamanhoTotal    : Boolean;  //Teste para verificar se a barra atende os requisitos de tamanho para ser considerada

barraBull           : Boolean;  //Verificar se é uma barra verde
barraBear           : Boolean;  //Verificar se é uma barra vermelha

BEteste             : Boolean;  //Teste para verificar se é uma BE
barraBE             : Boolean;  //Verificar se é uma barra BE

BEtesteTotal        : Boolean;  //Teste para verificar se é uma BE utilizando o tamanho total (max-min)
barraBEtotal        : Boolean;  //Verificar se é uma barra BE utilizando o tamanho total (max-min)

btailBear           : Float;    //Tamanho bottom pavio bear
ttailBear           : Float;    //Tamanho top pavio bear
btailBull           : Float;    //Tamanho bottom pavio bull
ttailBull           : Float;    //Tamanho top pavio bull
barraBTbull         : Boolean;  //Verificar se é uma barra BT bull
barraBTbear         : Boolean;  //Verificar se é uma barra BT bear
barraBTneutra       : Boolean;  //Verificar se é uma barra BT neutra
barraTTbull         : Boolean;  //Verificar se é uma barra TT bull
barraTTbear         : Boolean;  //Verificar se é uma barra TT bear
barraTTneutra       : Boolean;  //Verificar se é uma barra TT neutra

clearBarBull        : Boolean;  //Verificar se é uma barra Clearing Close Bull
clearBarBear        : Boolean;  //Verificar se é uma barra Clearing Close Bear

bear180             : Boolean;  //Verficar se é um bear 180 (-180)
bull180             : Boolean;  //Verficar se é um bull 180 (+180)

GBI                 : Boolean;  //Verificar se ocorreu uma GBI
RBI                 : Boolean;  //Verificar se ocorreu uma RBI

begin
    
    tamanhoBarra := Abs(Open - Close);
    specTamanho := (tamanhoBarra >= (BEmin * MinPriceIncrement)) and (tamanhoBarra <= (BEmax * MinPriceIncrement));
    tamanhoTotal := Abs(High - Low);
    specTamanhoTotal := (tamanhoTotal >= (BEmin * MinPriceIncrement)) and (tamanhoTotal <= (BEmax * MinPriceIncrement));
    
    barraBull := Close > Open;
    barraBear := Close < Open;
    
    BEteste := ((tamanhoBarra >= (fatorBE * tamanhoBarra[5])) and (tamanhoBarra >= (fatorBE * tamanhoBarra[4])) and 
    (tamanhoBarra >= (fatorBE * tamanhoBarra[3])) and (tamanhoBarra >= (fatorBE * tamanhoBarra[2])) and 
    (tamanhoBarra >= (fatorBE * tamanhoBarra[1])));
    barraBE := BEteste and specTamanho;

    BEtesteTotal := ((tamanhoTotal >= (fatorBEtotal * tamanhoTotal[5])) and (tamanhoTotal >= (fatorBEtotal * tamanhoTotal[4])) and 
    (tamanhoTotal >= (fatorBEtotal * tamanhoTotal[3])) and (tamanhoTotal >= (fatorBEtotal * tamanhoTotal[2])) and 
    (tamanhoTotal >= (fatorBEtotal * tamanhoTotal[1])));
    barraBEtotal := BEtesteTotal and specTamanhoTotal;
        
    btailBear := Abs(Close - Low);
    ttailBear := Abs(High - Open);
    btailBull := Abs(Open - Low);
    ttailBull := Abs(High - Close);      
    barraBTbull := ((fatorBT * (tamanhoBarra + ttailBull)) <= (btailBull + MinPriceIncrement));
    barraBTbear := ((fatorBT * (tamanhoBarra + ttailBear)) <= (btailBear + MinPriceIncrement));
    barraBTneutra := ((fatorBT * (ttailBull)) <= (btailBull + MinPriceIncrement));
    barraTTbull := ((fatorBT * (tamanhoBarra + btailBull)) <= (ttailBull + MinPriceIncrement));
    barraTTbear := ((fatorBT * (tamanhoBarra + btailBear)) <= (ttailBear + MinPriceIncrement));
    barraTTneutra := ((fatorBT * (btailBull)) <= (ttailBull + MinPriceIncrement));

    clearBarBull := Close >= (Highest(High,5)[1]); 
    clearBarBear := Close <= (Lowest(Low,5)[1]);

    bear180 := (barraBull[1]) and (barraBear) and (Close <= Open[1]);
    bull180 := (barraBear[1]) and (barraBull) and (Close >= Open[1]);

    GBI := barraBear[2] and barraBull[1] and (tamanhoBarra[1] <= (BImax * MinPriceIncrement)) and barraBear and (Close <= Open[1]);
    RBI := barraBull[2] and barraBear[1] and (tamanhoBarra[1] <= (BImax * MinPriceIncrement)) and barraBull and (Close >= Open[1]);

//  BARRA ELEFANTE  //
//  Barra elefante Bear --> Rosa
//  Barra elefante Bull --> Verde

if (TipoDeColoracao = 1) then
  begin
    if barraBear and barraBE then
        begin
          Paintbar(clFuchsia);
        end;
      if barraBull and barraBE then
        begin
          Paintbar(clGreen);
        end;
  end;


//  Teste Bottoming Tail  e Topping Tail //
//  BT Bear --> Marron
//  BT Bull --> Teal
//  BT neutra --> Amarelo 

if (TipoDeColoracao = 2) then
  begin
    if specTamanhoTotal then
        begin
            if barraBear then
                begin    
                    if barraBTbear then //((fatorBT*(tamanhoBarra)) <= btailBear) and (ttailBear <= (tBTbTTmax * MinPriceIncrement)) then
                        begin
                            Paintbar(clMaroon); //BT
                        end
                    else if barraTTbear then //((fatorBT*(tamanhoBarra)) <= ttailBear) and (btailBear <= (tBTbTTmax * MinPriceIncrement)) then
                        begin
                            Paintbar(clFuchsia); //TT
                        end;
                end
            else if barraBull then
                begin
                    if barraBTbull then //((fatorBT*(tamanhoBarra)) <= btailBull) and (ttailBull <= (tBTbTTmax * MinPriceIncrement)) then
                        begin
                            Paintbar(clBlue); //BT
                        end 
                    else if barraTTbull then //((fatorBT*(tamanhoBarra)) <= ttailBull) and (btailBull <= (tBTbTTmax * MinPriceIncrement)) then
                        begin
                            Paintbar(clGreen); //TT
                        end; 
                end
            else
                begin
                    if  barraBTneutra then //((fatorBT*(ttailBull)) <= btailBull) and (ttailBull <= (tBTbTTmax * MinPriceIncrement)) then
                        begin
                            Paintbar(clYellow); //BT
                        end
                    else if  barraTTneutra then //((fatorBT*(btailBull)) <= ttailBull) and (btailBull <= (tBTbTTmax * MinPriceIncrement)) then
                        begin
                            Paintbar(clAqua); //TT
                        end;
                end;
        end;
  end;

// Clearing Bar //

if (TipoDeColoracao = 3) then
    begin
        if specTamanhoTotal then
            begin         
                if clearBarBull then
                    begin
                        Paintbar(clGreen);
                    end
                else if clearBarBear then
                    begin
                        Paintbar(clFuchsia);
                    end;
            end;
    end;

// Bear180 Bull180 //

if (TipoDeColoracao = 4) then
    begin
        if specTamanho then
            begin
                if bear180 then //Bear180
                    begin
                        Paintbar(clFuchsia);
                    end
                else if bull180 then //Bull180
                    begin
                        Paintbar(clGreen);
                    end;
            end;
    end;

// RBI e GBI //

if (TipoDeColoracao = 5) then
    begin
        if GBI then   
            begin
                Paintbar(clFuchsia);
            end
        else if RBI then 
            begin
                Paintbar(clGreen);
            end;
        
    end;


end;