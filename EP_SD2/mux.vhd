entity mux_n is
    generic (
        dataSize : natural := 64
    );
    port (
        in0  : in  bit_vector(dataSize-1 downto 0);  -- entrada de dados 0
        in1  : in  bit_vector(dataSize-1 downto 0);  -- entrada de dados 1
        sel  : in  bit;                              -- sinal de seleção
        dOut : out bit_vector(dataSize-1 downto 0)   -- saída de dados
    );
end entity mux_n;

architecture a_mux of mux_n is
begin
    process(in0, in1, sel)
    begin
        if sel = '0' then
            dOut <= in0;
        else
            dOut <= in1;
        end if;
    end process;
end architecture a_mux;