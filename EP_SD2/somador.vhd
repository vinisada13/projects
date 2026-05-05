entity adder_n is
    generic (
        dataSize : natural := 64
    );
    port (
        in0  : in  bit_vector(dataSize-1 downto 0);  -- primeira parcela
        in1  : in  bit_vector(dataSize-1 downto 0);  -- segunda parcela
        sum  : out bit_vector(dataSize-1 downto 0);  -- soma
        cOut : out bit                                   -- carry de saída
    );
end entity adder_n;
architecture a_som of adder_n is

    signal c : bit_vector(dataSize downto 0);

begin

    c(0) <= '0';

    loop_somas: for i in 0 to dataSize-1 generate
        
        sum(i) <= in0(i) xor in1(i) xor c(i);
        
        c(i+1) <= (in0(i) and in1(i)) or (in0(i) and c(i)) or (in1(i) and c(i));
                  
    end generate loop_somas;

    cOut <= c(dataSize); 

end architecture a_som;
