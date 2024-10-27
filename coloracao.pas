///////////////////////////////////
//      Testes de coloração      //
///////////////////////////////////

//V001_2

input
TipoDeColoracao(3);  //Escolher tipo de coloração
 // 1 --> Barras elefantes
 // 2 --> Bottoming Tail + Topping Tail
 // 3 --> Clearing bar


//inputs para Barras elefantes
fatorBE(2);              //Fator para determinar se é uma BE
BEmin(8);                //ticks tamanho mínimo BE
BEmax(40);               //ticks tamanho máximo BE

//inputs para BT
tBTbTTmax(2);             //ticks tamanho máximo do pavio do topo de uma BT e de baixo de uma TT
fatorBT(2);             //Fator para determinar a proporção do corpo/pavio

var
tamanhoBarra  : Float;    //Tamanho do corpo de uma barra
barraBull     : Boolean;  //verificar se é uma barra verde
barraBear     : Boolean;  //verificar se é uma barra vermelha

BEteste       : Boolean;  //Teste para verificar se é uma BE
barraBE       : Boolean; //Verificar se é uma barra BE
specTamanhoTotal  : Boolean;  //Teste para verificar se a barra atende os requisitos de tamanho para ser considerada

tamanhoTotal  : Float;    //Tamanho total de uma barra
btailBear     : Float;    //Tamanho bottom pavio bear
ttailBear     : Float;    //Tamanho top pavio bear
btailBull     : Float;    //Tamanho bottom pavio bull
ttailBull     : Float;    //Tamanho top pavio bull
barraBTbull : Boolean;  //verificar se é uma barra BT bull
barraBTbear : Boolean;  //verificar se é uma barra BT bear
barraBTneutra : Boolean;  //verificar se é uma barra BT neutra
barraTTbull : Boolean;  //verificar se é uma barra TT bull
barraTTbear : Boolean;  //verificar se é uma barra TT bear
barraTTneutra : Boolean;  //verificar se é uma barra TT neutra

clearBarTesteHBull  : Boolean;    // Verificar se é uma barra Clearing Close Bull
clearBarTesteHBear  : Boolean;    // Verificar se é uma barra Clearing Close Bear

begin
    
    tamanhoBarra := Abs(Open - Close);
    barraBull := Close > Open;
    barraBear := Close < Open;
    BEteste := ((tamanhoBarra >= (fatorBE * tamanhoBarra[5])) and (tamanhoBarra >= (fatorBE * tamanhoBarra[4])) and 
    (tamanhoBarra >= (fatorBE * tamanhoBarra[3])) and (tamanhoBarra >= (fatorBE * tamanhoBarra[2])) and 
    (tamanhoBarra >= (fatorBE * tamanhoBarra[1])));
    barraBE := BEteste and (tamanhoBarra >= (BEmin * MinPriceIncrement)) and (tamanhoBarra <= (BEmax * MinPriceIncrement));
    
    tamanhoTotal := Abs(High - Low);
    btailBear := Abs(Close - Low);
    ttailBear := Abs(High - Open);
    btailBull := Abs(Open - Low);
    ttailBull := Abs(High - Close);   

    specTamanhoTotal := (tamanhoTotal >= (BEmin * MinPriceIncrement)) and (tamanhoTotal <= (BEmax * MinPriceIncrement));

    barraBTbull := ((fatorBT * (tamanhoBarra + ttailBull)) <= (btailBull + MinPriceIncrement));
    barraBTbear := ((fatorBT * (tamanhoBarra + ttailBear)) <= (btailBear + MinPriceIncrement));
    barraBTneutra := ((fatorBT * (ttailBull)) <= (btailBull + MinPriceIncrement));
    barraTTbull := ((fatorBT * (tamanhoBarra + btailBull)) <= (ttailBull + MinPriceIncrement));
    barraTTbear := ((fatorBT * (tamanhoBarra + btailBear)) <= (ttailBear + MinPriceIncrement));
    barraTTneutra := ((fatorBT * (btailBull)) <= (ttailBull + MinPriceIncrement));

    clearBarTesteHBull := Close >= (Highest(High,5)[1]); 
    clearBarTesteHBear := Close <= (Lowest(Low,5)[1]);

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
                if clearBarTesteHBull then
                    begin
                        Paintbar(clGreen);
                    end
                else if clearBarTesteHBear then
                    begin
                        Paintbar(clFuchsia);
                    end;
            end;
    end;


end;