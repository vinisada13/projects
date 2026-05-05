library IEEE;
use IEEE.numeric_bit.all;
entity sign_extend is
    generic (
        dataISize : natural := 32;
        dataOSize: natural := 64;
        dataMaxPosition : natural := 5 
    );
    port (
        inData : in bit_vector( dataISize-1 downto 0 ); -- dado de entrada
        inDataStart : in bit_vector(dataMaxPosition-1 downto 0);  -- posicao do bit mais significativo do valor util na entrada(bit de sinal)
        inDataEnd  : in bit_vector(dataMaxPosition-1 downto 0); -- posicao do bit menos significativo do valor util na entrada
        outData : out bit_vector(dataOSize-1 downto 0)   -- dado de saída com tamanho dataOsize e sinal estendido
    );
end entity sign_extend;

architecture a_ext of sign_extend is
begin 


    outData((to_integer(unsigned(inDataStart)))-(to_integer(unsigned(inDataEnd))) downto 0) <= 
    inData((to_integer(unsigned(inDataStart))) downto (to_integer(unsigned(inDataEnd)))); --primeiras casas recebem inData do start ao end

    outData(dataOSize-1 downto ((to_integer(unsigned(inDataStart)))-(to_integer(unsigned(inDataEnd)))+1)) 
    <= (others => inData(to_integer(unsigned(inDataStart)))); -- preenche o resto com o bit da última casa

end architecture a_ext;
