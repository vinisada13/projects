entity two_left_shifts is
    generic (
        dataSize : natural := 64
    );
    port (
        input  : in  bit_vector (dataSize - 1 downto 0);
        output : out bit_vector (dataSize - 1 downto 0)
    );
end entity two_left_shifts;

architecture a_deslocador of two_left_shifts is 
begin
    output <= input(dataSize - 3 downto 0) & "00";

end architecture a_deslocador;